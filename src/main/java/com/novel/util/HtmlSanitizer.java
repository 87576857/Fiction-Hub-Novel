package com.novel.util;

import java.util.regex.Pattern;

/**
 * 신인작가 광장(rookie) 게시판은 CKEditor(툴바: heading, bold, italic, link,
 * bulletedList, numberedList, blockQuote)로 작성한 HTML을 그대로 저장/렌더링한다.
 * 즉 이 게시판의 content는 순수 텍스트가 아니라 "의도된 HTML"이므로
 * JSTL <c:out>으로 무조건 이스케이프하면 굵게/링크 같은 서식이 전부 깨진다.
 *
 * 대신 저장하기 "전에" 서버에서 허용 태그만 남기고 그 외(<script>, onerror= 같은
 * 이벤트 핸들러 속성, javascript: 스킴 링크 등)를 전부 제거하는 화이트리스트
 * 새니타이징을 적용한다. 외부 라이브러리(jsoup 등) 추가 없이 정규식 기반으로
 * 구현했다 - 프로젝트 마감 임박이라 빌드 의존성을 새로 늘리지 않기 위함.
 *
 * 허용 태그: h1~h6(에디터 heading), b, strong, i, em, a(href만), ul, ol, li,
 *            blockquote, p, br
 * 그 외 모든 태그(<script>, <img onerror=...>, <iframe> 등)는 통째로 제거한다.
 */
public final class HtmlSanitizer {

	private HtmlSanitizer() {
	}

	// CKEditor 툴바가 실제로 만들어내는 태그만 화이트리스트로 허용한다.
	private static final Pattern ALLOWED_TAG = Pattern.compile(
			"^/?(h[1-6]|b|strong|i|em|a|ul|ol|li|blockquote|p|br)(\\s|/|>|$)",
			Pattern.CASE_INSENSITIVE);

	// <script>...</script>, <style>...</style> 는 내용까지 통째로 제거 (여는/닫는 태그 사이 내용 포함)
	private static final Pattern SCRIPT_OR_STYLE_BLOCK = Pattern.compile(
			"(?is)<\\s*(script|style)[^>]*>.*?<\\s*/\\s*\\1\\s*>");

	// 태그 하나를 통째로 매칭하기 위한 패턴 (속성 포함, 자체닫힘 포함)
	private static final Pattern ANY_TAG = Pattern.compile("<\\s*/?\\s*([a-zA-Z][a-zA-Z0-9]*)[^>]*>");

	// href 속성값만 추출 (javascript: 스킴 차단 목적)
	private static final Pattern HREF_ATTR = Pattern.compile(
			"href\\s*=\\s*\"([^\"]*)\"|href\\s*=\\s*'([^']*)'", Pattern.CASE_INSENSITIVE);

	private static final Pattern JAVASCRIPT_SCHEME = Pattern.compile(
			"^\\s*javascript\\s*:", Pattern.CASE_INSENSITIVE);

	/**
	 * CKEditor 산출물(HTML)을 화이트리스트 기준으로 정제한다.
	 * - 허용 태그(a/b/strong/i/em/ul/ol/li/blockquote/p/br/h1~h6) 외 모든 태그 제거
	 * - <script>, <style> 은 내용까지 통째로 제거
	 * - a 태그는 href 속성만 남기고, javascript: 스킴은 무효화(href 제거)
     * - onXXX= 이벤트 핸들러 속성은 태그 자체를 허용 태그로 재구성하는 과정에서 자동으로 사라짐
	 */
	public static String sanitize(String html) {
		if (html == null) {
			return null;
		}

		String result = SCRIPT_OR_STYLE_BLOCK.matcher(html).replaceAll("");

		StringBuffer sb = new StringBuffer();
		java.util.regex.Matcher tagMatcher = ANY_TAG.matcher(result);
		while (tagMatcher.find()) {
			String wholeTag = tagMatcher.group(0);
			String tagName = tagMatcher.group(1).toLowerCase();
			String replacement;

			if (!isAllowedTagName(tagName)) {
				// 허용 목록에 없는 태그(script, img, iframe, svg, form 등)는 완전히 제거
				replacement = "";
			} else if ("a".equals(tagName) && !wholeTag.startsWith("</")) {
				// a 태그 여는 부분만 href 속성 값을 검사해서 재구성 (다른 속성/이벤트 핸들러는 버림)
				replacement = rebuildAnchorTag(wholeTag);
			} else if (wholeTag.startsWith("</")) {
				// 닫는 태그는 속성이 없으므로 그대로 유지
				replacement = "</" + tagName + ">";
			} else {
				// 여는 태그(a 제외)는 속성을 전부 제거하고 태그 이름만 남긴다 (이벤트 핸들러 무력화)
				replacement = "<" + tagName + ">";
			}
			tagMatcher.appendReplacement(sb, java.util.regex.Matcher.quoteReplacement(replacement));
		}
		tagMatcher.appendTail(sb);
		return sb.toString();
	}

	private static boolean isAllowedTagName(String tagName) {
		return ALLOWED_TAG.matcher(tagName + ">").matches();
	}

	private static String rebuildAnchorTag(String wholeTag) {
		java.util.regex.Matcher hrefMatcher = HREF_ATTR.matcher(wholeTag);
		if (!hrefMatcher.find()) {
			return "<a>"; // href 없는 a 태그는 링크 기능이 없으므로 속성 없이 유지
		}
		String href = hrefMatcher.group(1) != null ? hrefMatcher.group(1) : hrefMatcher.group(2);
		if (href == null || JAVASCRIPT_SCHEME.matcher(href).find()) {
			return "<a>"; // javascript: 스킴은 무효화
		}
		// 속성값 자체의 따옴표 이스케이프까지 고려해 큰따옴표만 사용
		String safeHref = href.replace("\"", "&quot;");
		return "<a href=\"" + safeHref + "\">";
	}
}

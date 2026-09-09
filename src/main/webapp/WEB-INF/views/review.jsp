<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:include page="common/header.jsp" />

<!-- 주소: review.jsp -->
<main class="container-xl py-5 px-3">
  <h1 class="mb-2 text-center" style="font-family:'Gowun Batang',serif;font-size:24px;font-weight:700;">소설 리뷰</h1>
  <p class="text-center mb-4" style="color:var(--muted);">표지를 클릭하면 줄거리를 볼 수 있어요.</p>

  <!-- 소설 이름 검색 : 필터/정렬 버튼보다 위에 위치 -->
  <form method="get" action="${pageContext.request.contextPath}/review"
        class="d-flex justify-content-center mb-4" style="gap:6px;">
    <c:if test="${not empty selectedPlatform}"><input type="hidden" name="platform" value="${selectedPlatform}" /></c:if>
    <c:if test="${not empty selectedSort}"><input type="hidden" name="sort" value="${selectedSort}" /></c:if>
    <input type="text" name="keyword" value="${selectedKeyword}" placeholder="소설 이름을 검색해보세요"
           style="max-width:280px;padding:6px 12px;font-size:13px;border:1px solid var(--border);border-radius:6px;" />
    <button type="submit" class="btn-primary-custom" style="padding:6px 16px;font-size:13px;">검색</button>
    <c:if test="${not empty selectedKeyword}">
      <c:url var="clearSearchUrl" value="/review">
        <c:if test="${not empty selectedPlatform}"><c:param name="platform" value="${selectedPlatform}" /></c:if>
        <c:if test="${not empty selectedSort}"><c:param name="sort" value="${selectedSort}" /></c:if>
      </c:url>
      <button type="button" class="btn-outline-custom" style="padding:6px 16px;font-size:13px;"
              onclick="location.href='${clearSearchUrl}'">검색 초기화</button>
    </c:if>
  </form>

  <div class="d-flex justify-content-center gap-2 mb-3" style="flex-wrap:wrap;">
    <c:forEach var="pf" items="${fn:split(',카카오페이지,네이버시리즈,문피아,노벨피아', ',')}">
      <c:url var="platformUrl" value="/review">
        <c:if test="${not empty pf}"><c:param name="platform" value="${pf}" /></c:if>
        <c:if test="${not empty selectedSort}"><c:param name="sort" value="${selectedSort}" /></c:if>
        <c:if test="${not empty selectedKeyword}"><c:param name="keyword" value="${selectedKeyword}" /></c:if>
      </c:url>
      <button type="button"
              class="${(empty selectedPlatform && empty pf) || selectedPlatform == pf ? 'btn-primary-custom' : 'btn-outline-custom'}"
              style="padding:6px 16px;font-size:13px;"
              onclick="location.href='${platformUrl}'">${empty pf ? '전체' : pf}</button>
    </c:forEach>
  </div>

  <div class="d-flex justify-content-center gap-2 mb-5" style="flex-wrap:wrap;">
    <c:forEach var="s" items="${fn:split(',view,reviews,rating', ',')}">
      <c:url var="sortUrl" value="/review">
        <c:if test="${not empty selectedPlatform}"><c:param name="platform" value="${selectedPlatform}" /></c:if>
        <c:if test="${not empty s}"><c:param name="sort" value="${s}" /></c:if>
        <c:if test="${not empty selectedKeyword}"><c:param name="keyword" value="${selectedKeyword}" /></c:if>
      </c:url>
      <button type="button"
              class="${(empty selectedSort && empty s) || selectedSort == s ? 'btn-primary-custom' : 'btn-outline-custom'}"
              style="padding:4px 14px;font-size:12px;"
              onclick="location.href='${sortUrl}'">
        <c:choose>
          <c:when test="${s == 'view'}">조회수순</c:when>
          <c:when test="${s == 'reviews'}">댓글순</c:when>
          <c:when test="${s == 'rating'}">별점순</c:when>
          <c:otherwise>최신순</c:otherwise>
        </c:choose>
      </button>
    </c:forEach>
  </div>

  <c:choose>
    <c:when test="${empty novels}">
      <p class="text-center text-muted py-5">아직 등록된 소설이 없습니다.</p>
    </c:when>
    <c:otherwise>
      <div class="row g-4">
        <c:forEach var="n" items="${novels}">
          <div class="col-6 col-md-3">
            <div class="novel-frame" style="cursor:pointer;" data-bs-toggle="modal" data-bs-target="#novelModal${n.novelId}">
              <c:if test="${not empty n.coverImageUrl}">
                <img src="<c:out value='${n.coverImageUrl}'/>" alt="<c:out value='${n.title}'/>"
                     style="width:100%;aspect-ratio:3/4;object-fit:cover;border-radius:8px;" />
              </c:if>
              <c:if test="${empty n.coverImageUrl}">
                <div style="width:100%;aspect-ratio:3/4;border-radius:8px;background:var(--surface-muted, #eee);
                            display:flex;align-items:center;justify-content:center;color:var(--muted);font-size:13px;">
                  표지 없음
                </div>
              </c:if>
              <div class="mt-2" style="font-size:14px;font-weight:700;line-height:1.3;"><c:out value="${n.title}"/></div>
              <div style="font-size:12px;color:var(--muted);">
                <c:out value="${n.authorName}"/> · <c:out value="${n.platform}"/>
                <c:if test="${not empty n.averageRating}"> · ⭐${n.averageRating}</c:if>
                <c:if test="${empty n.averageRating}"> · <span style="color:#bbb;">평점 없음</span></c:if>
              </div>
            </div>
          </div>

          <!-- 소설 상세 모달 -->
          <div class="modal fade" id="novelModal${n.novelId}" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
              <div class="modal-content">
                <div class="modal-header">
                  <h5 class="modal-title" style="font-family:'Gowun Batang',serif;"><c:out value="${n.title}"/></h5>
                  <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" style="display:grid;grid-template-columns:100px 1fr;gap:14px;align-items:start;">
                  <div>
                    <c:if test="${not empty n.coverImageUrl}">
                      <img src="<c:out value='${n.coverImageUrl}'/>" alt="<c:out value='${n.title}'/>"
                           style="width:100%;display:block;border-radius:6px;object-fit:cover;aspect-ratio:3/4;" />
                    </c:if>
                    <c:if test="${empty n.coverImageUrl}">
                      <div style="width:100%;aspect-ratio:3/4;border-radius:6px;background:var(--surface-muted, #eee);
                                  display:flex;align-items:center;justify-content:center;color:var(--muted);font-size:11px;">표지 없음</div>
                    </c:if>
                  </div>
                  <div style="min-width:0;">
                    <div style="font-size:13px;color:var(--muted);margin-bottom:6px;">
                      원작: <c:out value="${n.authorName}"/> · <c:out value="${n.platform}"/>
                    </div>
                    <p style="font-size:14px;white-space:pre-line;"><c:out value="${n.summary}"/></p>

                    <c:set var="topReviews" value="${topReviewsByNovel[n.novelId]}" />
                    <c:if test="${not empty topReviews}">
                      <div class="mt-3 pt-2" style="border-top:1px solid var(--border);">
                        <div style="font-size:12px;font-weight:700;color:var(--muted);margin-bottom:6px;">👍 좋아요 많은 리뷰</div>
                        <c:forEach var="tr" items="${topReviews}">
                          <div class="mb-2" style="font-size:13px;">
                            <span style="font-weight:700;"><c:out value="${tr.nickname}"/></span>
                            <span style="color:var(--muted);"> · ⭐${tr.rating} · 👍${tr.likes}</span>
                            <div style="color:#333;"><c:out value="${tr.reviewText}"/></div>
                          </div>
                        </c:forEach>
                      </div>
                    </c:if>

                    <div class="text-end mt-2">
                      <a href="${pageContext.request.contextPath}/review/${n.novelId}" class="btn-primary-custom d-inline-block" style="padding:6px 16px;font-size:13px;">리뷰 보러가기</a>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </c:forEach>
      </div>

      <c:if test="${totalPages > 1}">
        <div class="d-flex justify-content-center align-items-center gap-2 mt-5">
          <c:if test="${groupStart > 1}">
            <c:url var="prevGroupUrl" value="/review">
              <c:param name="page" value="${groupStart - 1}" />
              <c:if test="${not empty selectedPlatform}"><c:param name="platform" value="${selectedPlatform}" /></c:if>
              <c:if test="${not empty selectedSort}"><c:param name="sort" value="${selectedSort}" /></c:if>
              <c:if test="${not empty selectedKeyword}"><c:param name="keyword" value="${selectedKeyword}" /></c:if>
            </c:url>
            <button type="button" class="btn-outline-custom" style="padding:6px 12px;font-size:13px;"
                    onclick="location.href='${prevGroupUrl}'">&laquo;</button>
          </c:if>
          <c:forEach var="p" begin="${groupStart}" end="${groupEnd}">
            <c:url var="pageUrl" value="/review">
              <c:param name="page" value="${p}" />
              <c:if test="${not empty selectedPlatform}"><c:param name="platform" value="${selectedPlatform}" /></c:if>
              <c:if test="${not empty selectedSort}"><c:param name="sort" value="${selectedSort}" /></c:if>
              <c:if test="${not empty selectedKeyword}"><c:param name="keyword" value="${selectedKeyword}" /></c:if>
            </c:url>
            <button type="button"
                    class="${p == currentPage ? 'btn-primary-custom' : 'btn-outline-custom'}"
                    style="padding:6px 14px;font-size:13px;min-width:38px;"
                    onclick="location.href='${pageUrl}'">${p}</button>
          </c:forEach>
          <c:if test="${groupEnd < totalPages}">
            <c:url var="nextGroupUrl" value="/review">
              <c:param name="page" value="${groupEnd + 1}" />
              <c:if test="${not empty selectedPlatform}"><c:param name="platform" value="${selectedPlatform}" /></c:if>
              <c:if test="${not empty selectedSort}"><c:param name="sort" value="${selectedSort}" /></c:if>
              <c:if test="${not empty selectedKeyword}"><c:param name="keyword" value="${selectedKeyword}" /></c:if>
            </c:url>
            <button type="button" class="btn-outline-custom" style="padding:6px 12px;font-size:13px;"
                    onclick="location.href='${nextGroupUrl}'">&raquo;</button>
          </c:if>
        </div>
      </c:if>
    </c:otherwise>
  </c:choose>
</main>

<jsp:include page="common/footer.jsp" />

package com.novel.util;

import java.util.Collections;
import java.util.List;

/**
 * 목록 페이지네이션 공용 유틸.
 *
 * - 화면 번호는 5개 단위로 끊어서 보여주고(그룹), 그룹 밖으로 나가면 화살표(«, »)로 이동한다.
 *   예) 1.2.3.4.5 [»] 클릭 -> 6.7.8.9.10
 * - DB에서 이미 LIMIT/OFFSET으로 페이지네이션하는 목록(리뷰 게시판)은 slice()를 쓰지 않고
 *   totalPages/groupStart/groupEnd만 계산해서 쓴다.
 * - 관리자 콘텐츠 관리 / 마이페이지처럼 전체 목록을 한 번에 가져오는 곳은 slice()로
 *   현재 페이지에 해당하는 부분만 잘라서 화면에 넘긴다.
 */
public final class PageUtil {

	/** 한 번에 보여줄 페이지 번호 개수 (1.2.3.4.5 단위로 끊기) */
	public static final int GROUP_SIZE = 5;

	private PageUtil() {
	}

	/** 전체 개수와 페이지당 개수로 총 페이지 수 계산 (최소 1) */
	public static int totalPages(int totalCount, int pageSize) {
		return Math.max((int) Math.ceil(totalCount / (double) pageSize), 1);
	}

	/** 요청된 페이지 번호를 1 ~ totalPages 범위로 보정 */
	public static int safePage(int page, int totalPages) {
		return Math.min(Math.max(page, 1), totalPages);
	}

	/** 현재 페이지가 속한 그룹의 첫 페이지 번호 (예: 7페이지 -> 6) */
	public static int groupStart(int currentPage) {
		return ((currentPage - 1) / GROUP_SIZE) * GROUP_SIZE + 1;
	}

	/** 현재 페이지가 속한 그룹의 마지막 페이지 번호 (총 페이지 수를 넘지 않음) */
	public static int groupEnd(int currentPage, int totalPages) {
		return Math.min(groupStart(currentPage) + GROUP_SIZE - 1, totalPages);
	}

	/** 전체 리스트를 이미 메모리에 들고 있을 때, page/pageSize에 맞는 부분만 잘라서 반환 */
	public static <T> List<T> slice(List<T> list, int page, int pageSize) {
		if (list == null || list.isEmpty()) {
			return Collections.emptyList();
		}
		int totalPages = totalPages(list.size(), pageSize);
		int safePage = safePage(page, totalPages);
		int fromIndex = (safePage - 1) * pageSize;
		int toIndex = Math.min(fromIndex + pageSize, list.size());
		if (fromIndex >= toIndex) {
			return Collections.emptyList();
		}
		return list.subList(fromIndex, toIndex);
	}
}

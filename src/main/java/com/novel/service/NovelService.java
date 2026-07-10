package com.novel.service;

import java.util.List;

import com.novel.domain.Novel;

public interface NovelService {

	/** 리뷰 게시판 그리드용 전체 목록 (페이지네이션 없이 전체 - 관리자 목록 등에서 사용) */
	List<Novel> getNovelList();

	/** 관리자 목록 - 소설 제목 검색. keyword가 null/빈값이면 전체 */
	List<Novel> getNovelList(String keyword);

	/** 공개 리뷰게시판 페이지네이션 - page는 1부터 시작, 한 페이지 20개(4x5) */
	List<Novel> getNovelPage(int page, int pageSize);

	/** 플랫폼 필터가 적용된 페이지네이션. platform이 null/빈값이면 전체 */
	List<Novel> getNovelPage(int page, int pageSize, String platform);

	/** 플랫폼 필터 + 정렬(null/"latest"/"view"/"reviews") 적용 페이지네이션 */
	List<Novel> getNovelPage(int page, int pageSize, String platform, String sort);

	/** 플랫폼 필터 + 정렬 + 소설 제목 검색(keyword)까지 적용된 페이지네이션. 리뷰 게시판 검색창에서 사용 */
	List<Novel> getNovelPage(int page, int pageSize, String platform, String sort, String keyword);

	int countAllNovels();

	/** platform이 null/빈값이면 전체 개수 */
	int countAllNovels(String platform);

	/** platform/keyword가 null/빈값이면 해당 조건은 무시하고 개수 계산 */
	int countAllNovels(String platform, String keyword);

	/** 홈 화면 인기작 노출용 - 조회수 내림차순 상위 N개 */
	List<Novel> getTopNovels(int limit);

	/** 상세(모달) - 조회수 +1 처리 포함 (공개 화면에서 사용) */
	Novel getNovelDetail(int novelId);

	/** 조회수를 올리지 않는 단순 조회 (관리자 수정 화면 등 내부 용도) */
	Novel getNovelById(int novelId);

	/** 관리자 등록 - managedBy는 컨트롤러에서 세션 기준으로 채워서 넘긴다 */
	void registerNovel(Novel novel);

	void updateNovel(Novel novel);

	void deleteNovel(int novelId);
}

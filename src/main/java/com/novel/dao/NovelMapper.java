package com.novel.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.novel.domain.Novel;

public interface NovelMapper {

	/** 리뷰 게시판 목록 (등록순 최신 -> 그리드에 뿌리는 용도). keyword가 null/빈값이면 전체, 있으면 제목 부분검색 */
	List<Novel> selectAllNovels(@Param("keyword") String keyword);

	/** 페이지네이션 - 한 페이지에 20개(4열 x 5행). platform이 null/빈값이면 전체, sort는 null/"latest"(기본,최신순)/"view"(조회수순)/"reviews"(댓글순=리뷰개수순),
	 *  keyword가 null/빈값이면 전체, 있으면 제목 부분검색 */
	List<Novel> selectNovelsPaged(@Param("offset") int offset, @Param("limit") int limit,
			@Param("platform") String platform, @Param("sort") String sort, @Param("keyword") String keyword);

	/** platform/keyword가 null/빈값이면 해당 조건은 무시 */
	int countAllNovels(@Param("platform") String platform, @Param("keyword") String keyword);

	/** 홈 화면 인기작 노출용 - 조회수 내림차순 상위 N개 */
	List<Novel> selectTopNovelsByViewCount(@Param("limit") int limit);

	Novel selectNovelById(@Param("novelId") int novelId);

	void insertNovel(Novel novel);

	void updateNovel(Novel novel);

	void deleteNovel(@Param("novelId") int novelId);

	void increaseViewCount(@Param("novelId") int novelId);
}

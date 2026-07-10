package com.novel.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.novel.domain.Comment;
import com.novel.domain.Post;

/**
 * 관리자 대시보드 통계 + 콘텐츠(게시글/댓글) 일괄 관리 전용 매퍼
 * (회원/작가인증은 UserMapper, AuthorApplicationMapper에서 별도 처리)
 */
public interface AdminMapper {

	int countTodayNewNovels();

	int countTodayNewPosts();

	/**
	 * find/rookie/author 전체 게시판 게시글 (관리자 콘텐츠 관리 화면용, 최신순)
	 * @param keyword  제목/내용/작성자 닉네임 검색어 (null 또는 빈 문자열이면 전체)
	 * @param boardKey 게시판 필터 (find/rookie/author, null 또는 빈 문자열이면 전체)
	 */
	List<Post> selectAllPostsForAdmin(@Param("keyword") String keyword, @Param("boardKey") String boardKey);

	/** 체크박스로 선택한 게시글 일괄 삭제 */
	void deletePostsByIds(@Param("postIds") List<Integer> postIds);

	/**
	 * 전체 댓글 (관리자 콘텐츠 관리 화면용, 최신순)
	 * @param keyword  내용/작성자 닉네임 검색어 (null 또는 빈 문자열이면 전체)
	 * @param boardKey 게시판 필터 (find/rookie/author, null 또는 빈 문자열이면 전체)
	 */
	List<Comment> selectAllCommentsForAdmin(@Param("keyword") String keyword, @Param("boardKey") String boardKey);

	/** 체크박스로 선택한 댓글 일괄 삭제 */
	void deleteCommentsByIds(@Param("commentIds") List<Integer> commentIds);
}

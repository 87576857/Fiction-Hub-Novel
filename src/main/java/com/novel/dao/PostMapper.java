package com.novel.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.novel.domain.Post;

public interface PostMapper {

	/** 게시판 목록 (tag/keyword가 null 또는 빈값이면 해당 조건 없이 전체) */
	List<Post> selectPostsByBoard(@Param("boardId") int boardId, @Param("tag") String tag, @Param("keyword") String keyword);

	/** 3개 게시판(find/rookie/author) 전체를 통합해서 조회수 높은 순으로 N개 조회 (홈 화면 인기글용) */
	List<Post> selectTopPostsByView(@Param("limit") int limit);

	/** find/rookie/author 게시판 각각에서 조회수 상위 N건씩 조회 (홈 화면 게시판 블록용) */
	List<Post> selectTopPostsPerBoard(@Param("limit") int limit);

	Post selectPostById(@Param("postId") int postId);

	/** 마이페이지 "내가 쓴 글" 목록: find/rookie/author 통합, 본인 글만 최신순 */
	List<Post> selectPostsByUser(@Param("userId") int userId);

	void insertPost(Post post);

	void increaseViewCount(@Param("postId") int postId);

	void updateSolved(@Param("postId") int postId, @Param("isSolved") boolean isSolved);

	/**
	 * 본인 글 수정. WHERE 절에 user_id도 함께 걸어서, 다른 회원의 글을 수정하는 것을 DB 레벨에서 원천 차단한다.
	 * @return 수정된 행 수 (0이면 본인 글이 아니거나 존재하지 않는 글)
	 */
	int updatePostByIdAndUser(@Param("postId") int postId, @Param("userId") int userId,
			@Param("title") String title, @Param("content") String content, @Param("tag") String tag);
}

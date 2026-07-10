package com.novel.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.novel.domain.Comment;

public interface CommentMapper {

	List<Comment> selectCommentsByPost(@Param("postId") int postId);

	void insertComment(Comment comment);

	/** 마이페이지 "내가 쓴 댓글" 목록: 원글 제목/게시판 정보 포함, 최신순 */
	List<Comment> selectCommentsByUser(@Param("userId") int userId);

	/**
	 * 본인 댓글 삭제 (마이페이지 "내가 쓴 댓글"에서 사용).
	 * WHERE 절에 user_id도 함께 걸어서, 다른 회원의 댓글을 삭제하는 것을 DB 레벨에서 원천 차단한다.
	 * @return 삭제된 행 수 (0이면 본인 댓글이 아니거나 이미 삭제된 것)
	 */
	int deleteCommentByIdAndUser(@Param("commentId") int commentId, @Param("userId") int userId);
}

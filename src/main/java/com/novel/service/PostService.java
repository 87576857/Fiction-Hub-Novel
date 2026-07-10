package com.novel.service;

import java.util.List;
import java.util.Map;

import com.novel.domain.Comment;
import com.novel.domain.Post;

public interface PostService {

	/** find/rookie/author 게시판의 글 목록 (tag가 null이면 전체, keyword가 null/빈값이면 검색 없이 전체) */
	List<Post> getPostList(String boardName, String tag, String keyword);

	/** 3개 게시판 통합, 조회수 높은 순 N개 (홈 화면 인기글) */
	List<Post> getPopularPosts(int limit);

	/** find/rookie/author 게시판별 조회수 상위 N개 글 (홈 화면 게시판 블록용). key: boardKey(find/rookie/author) */
	Map<String, List<Post>> getTopPostsByBoard(int limit);

	/** 글 상세 (조회수 +1 처리 포함) */
	Post getPostDetail(int postId);

	/** 조회수를 올리지 않는 단순 조회 (권한 체크 등 내부 용도) */
	Post getPostById(int postId);

	List<Comment> getComments(int postId);

	void writePost(String boardName, Post post);

	void writeComment(Comment comment);

	void toggleSolved(int postId, boolean solved);

	/**
	 * 본인 글 수정 (제목/내용/태그). WHERE 절에 user_id도 함께 걸어서 본인 글만 수정 가능.
	 * @return 수정 성공 여부 (본인 글이 맞고 실제로 수정됐으면 true)
	 */
	boolean updateMyPost(int postId, int userId, String title, String content, String tag);

	/** 마이페이지 "내가 쓴 글" 목록: find/rookie/author 통합, 본인 글만 최신순 */
	List<Post> getMyPosts(int userId);

	/** 마이페이지 "내가 쓴 댓글" 목록: 게시판 댓글 + 소설 리뷰 통합, 원글 정보 포함, 최신순 */
	List<Comment> getMyComments(int userId);

	/**
	 * 본인 댓글(또는 리뷰) 삭제.
	 * @param type "review"면 소설 리뷰, 그 외(comment 등)면 게시판 댓글로 처리
	 * @return 삭제 성공 여부 (본인 것이 맞고 실제로 삭제됐으면 true)
	 */
	boolean deleteMyComment(int commentId, String type, int userId);
}

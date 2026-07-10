package com.novel.domain;

import java.sql.Timestamp;

/**
 * Comments 테이블 매핑 도메인
 */
public class Comment {

	private Integer commentId;
	private Integer postId;
	private Integer userId;
	private String content;
	private Integer likes;
	private Timestamp createdAt;

	// JOIN 결과로만 채워지는 부가 정보 (DB 컬럼 아님)
	private String nickname;
	private Boolean isAuthor;   // 작성자의 작가 인증 여부 (닉네임 옆 아이콘 표시용)
	private String postTitle;   // 마이페이지 "내가 쓴 댓글" 목록에서 원글 제목 표시용
	private String boardKey;    // 마이페이지 "내가 쓴 댓글" 목록에서 원글 링크 생성용 (find/rookie/author/review)
	private String type;        // "comment"(게시판 댓글) 또는 "review"(소설 리뷰) - 마이페이지/관리자 통합 목록 구분용

	public Integer getCommentId() { return commentId; }
	public void setCommentId(Integer commentId) { this.commentId = commentId; }

	public Integer getPostId() { return postId; }
	public void setPostId(Integer postId) { this.postId = postId; }

	public Integer getUserId() { return userId; }
	public void setUserId(Integer userId) { this.userId = userId; }

	public String getContent() { return content; }
	public void setContent(String content) { this.content = content; }

	public Integer getLikes() { return likes; }
	public void setLikes(Integer likes) { this.likes = likes; }

	public Timestamp getCreatedAt() { return createdAt; }
	public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

	public String getNickname() { return nickname; }
	public void setNickname(String nickname) { this.nickname = nickname; }

	public Boolean getIsAuthor() { return isAuthor; }
	public void setIsAuthor(Boolean isAuthor) { this.isAuthor = isAuthor; }

	public String getPostTitle() { return postTitle; }
	public void setPostTitle(String postTitle) { this.postTitle = postTitle; }

	public String getBoardKey() { return boardKey; }
	public void setBoardKey(String boardKey) { this.boardKey = boardKey; }

	public String getType() { return type; }
	public void setType(String type) { this.type = type; }
}

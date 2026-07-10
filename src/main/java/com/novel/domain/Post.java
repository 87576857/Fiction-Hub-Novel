package com.novel.domain;

import java.sql.Timestamp;

/**
 * Posts 테이블 매핑 도메인
 * find(이 소설 찾아요) / rookie(신인작가 광장) / author(작가 정보관) 3개 게시판이 공유
 */
public class Post {

	private Integer postId;
	private Integer boardId;
	private Integer userId;
	private String title;
	private String content;
	private String targetAuthor;   // author 게시판 전용(선택)
	private String platformTag;    // find:플랫폼 / rookie:장르 / author:연차
	private Integer viewCount;
	private Boolean isSolved;      // find 게시판 전용
	private Timestamp createdAt;

	// JOIN 결과로만 채워지는 부가 정보 (DB 컬럼 아님)
	private String nickname;
	private Boolean isAuthor;       // 작성자의 작가 인증 여부 (닉네임 옆 아이콘 표시용)
	private Integer commentCount;
	private String boardKey; // 홈 화면 인기글에서 링크 생성용 (find/rookie/author)

	public Integer getPostId() { return postId; }
	public void setPostId(Integer postId) { this.postId = postId; }

	public Integer getBoardId() { return boardId; }
	public void setBoardId(Integer boardId) { this.boardId = boardId; }

	public Integer getUserId() { return userId; }
	public void setUserId(Integer userId) { this.userId = userId; }

	public String getTitle() { return title; }
	public void setTitle(String title) { this.title = title; }

	public String getContent() { return content; }
	public void setContent(String content) { this.content = content; }

	public String getTargetAuthor() { return targetAuthor; }
	public void setTargetAuthor(String targetAuthor) { this.targetAuthor = targetAuthor; }

	public String getPlatformTag() { return platformTag; }
	public void setPlatformTag(String platformTag) { this.platformTag = platformTag; }

	public Integer getViewCount() { return viewCount; }
	public void setViewCount(Integer viewCount) { this.viewCount = viewCount; }

	public Boolean getIsSolved() { return isSolved; }
	public void setIsSolved(Boolean isSolved) { this.isSolved = isSolved; }

	public Timestamp getCreatedAt() { return createdAt; }
	public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

	public String getNickname() { return nickname; }
	public void setNickname(String nickname) { this.nickname = nickname; }

	public Boolean getIsAuthor() { return isAuthor; }
	public void setIsAuthor(Boolean isAuthor) { this.isAuthor = isAuthor; }

	public Integer getCommentCount() { return commentCount; }
	public void setCommentCount(Integer commentCount) { this.commentCount = commentCount; }

	public String getBoardKey() { return boardKey; }
	public void setBoardKey(String boardKey) { this.boardKey = boardKey; }
}

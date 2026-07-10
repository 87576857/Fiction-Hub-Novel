package com.novel.domain;

import java.sql.Timestamp;

/**
 * Novel_Reviews 테이블 매핑 도메인
 * 소설 상세(review-detail.jsp) 하단에 남기는 독자 한줄평 + 평점
 */
public class NovelReview {

	private Integer reviewId;
	private Integer novelId;
	private Integer userId;
	private String reviewText;
	private Integer rating;   // 1~5
	private Integer likes;
	private Timestamp createdAt;

	// JOIN 결과로만 채워지는 부가 정보 (DB 컬럼 아님)
	private String nickname;
	private Boolean isAuthor;   // 작성자의 작가 인증 여부 (닉네임 옆 아이콘 표시용)

	public Integer getReviewId() { return reviewId; }
	public void setReviewId(Integer reviewId) { this.reviewId = reviewId; }

	public Integer getNovelId() { return novelId; }
	public void setNovelId(Integer novelId) { this.novelId = novelId; }

	public Integer getUserId() { return userId; }
	public void setUserId(Integer userId) { this.userId = userId; }

	public String getReviewText() { return reviewText; }
	public void setReviewText(String reviewText) { this.reviewText = reviewText; }

	public Integer getRating() { return rating; }
	public void setRating(Integer rating) { this.rating = rating; }

	public Integer getLikes() { return likes; }
	public void setLikes(Integer likes) { this.likes = likes; }

	public Timestamp getCreatedAt() { return createdAt; }
	public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

	public String getNickname() { return nickname; }
	public void setNickname(String nickname) { this.nickname = nickname; }

	public Boolean getIsAuthor() { return isAuthor; }
	public void setIsAuthor(Boolean isAuthor) { this.isAuthor = isAuthor; }
}

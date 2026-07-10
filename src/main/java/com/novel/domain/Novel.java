package com.novel.domain;

import java.sql.Timestamp;

/**
 * Novels 테이블 매핑 도메인
 * 관리자 모드에서 등록/수정하는 "리뷰 게시판" 대상 소설 정보 (4x5 액자형 그리드의 소스)
 */
public class Novel {

	private Integer novelId;
	private String title;
	private String authorName;
	private String summary;
	private String coverImageUrl;
	private String platform;   // 카카오페이지 / 네이버시리즈 / 문피아 / 노벨피아 / 기타
	private Integer viewCount;
	private Integer managedBy;
	private Timestamp createdAt;
	private Timestamp updatedAt;

	// JOIN 결과로만 채워지는 부가 정보 (DB 컬럼 아님)
	private String managedByNickname;
	private Double averageRating; // 리뷰게시판 카드에 별점 표시용 - 리뷰 없으면 null
	private Integer reviewCount;  // 댓글순 정렬/카드 표시용

	public Integer getNovelId() { return novelId; }
	public void setNovelId(Integer novelId) { this.novelId = novelId; }

	public String getTitle() { return title; }
	public void setTitle(String title) { this.title = title; }

	public String getAuthorName() { return authorName; }
	public void setAuthorName(String authorName) { this.authorName = authorName; }

	public String getSummary() { return summary; }
	public void setSummary(String summary) { this.summary = summary; }

	public String getCoverImageUrl() { return coverImageUrl; }
	public void setCoverImageUrl(String coverImageUrl) { this.coverImageUrl = coverImageUrl; }

	public String getPlatform() { return platform; }
	public void setPlatform(String platform) { this.platform = platform; }

	public Integer getViewCount() { return viewCount; }
	public void setViewCount(Integer viewCount) { this.viewCount = viewCount; }

	public Integer getManagedBy() { return managedBy; }
	public void setManagedBy(Integer managedBy) { this.managedBy = managedBy; }

	public Timestamp getCreatedAt() { return createdAt; }
	public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

	public Timestamp getUpdatedAt() { return updatedAt; }
	public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

	public String getManagedByNickname() { return managedByNickname; }
	public void setManagedByNickname(String managedByNickname) { this.managedByNickname = managedByNickname; }

	public Double getAverageRating() { return averageRating; }
	public void setAverageRating(Double averageRating) { this.averageRating = averageRating; }

	public Integer getReviewCount() { return reviewCount; }
	public void setReviewCount(Integer reviewCount) { this.reviewCount = reviewCount; }
}

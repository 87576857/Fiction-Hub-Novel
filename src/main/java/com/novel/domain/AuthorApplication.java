package com.novel.domain;

import java.sql.Timestamp;

/**
 * Author_Applications 테이블 매핑 도메인 (작가 인증 신청)
 */
public class AuthorApplication {

	private Integer applicationId;
	private Integer userId;
	private String penName;
	private String workTitle;
	private String platform;
	private String description;
	private String status;          // PENDING / APPROVED / REJECTED
	private Integer reviewedBy;
	private Timestamp reviewedAt;
	private String rejectReason;
	private Timestamp createdAt;

	// JOIN 결과로만 채워지는 부가 정보 (DB 컬럼 아님) - 신청자 표시용
	private String username;
	private String nickname;

	public Integer getApplicationId() { return applicationId; }
	public void setApplicationId(Integer applicationId) { this.applicationId = applicationId; }

	public Integer getUserId() { return userId; }
	public void setUserId(Integer userId) { this.userId = userId; }

	public String getPenName() { return penName; }
	public void setPenName(String penName) { this.penName = penName; }

	public String getWorkTitle() { return workTitle; }
	public void setWorkTitle(String workTitle) { this.workTitle = workTitle; }

	public String getPlatform() { return platform; }
	public void setPlatform(String platform) { this.platform = platform; }

	public String getDescription() { return description; }
	public void setDescription(String description) { this.description = description; }

	public String getStatus() { return status; }
	public void setStatus(String status) { this.status = status; }

	public Integer getReviewedBy() { return reviewedBy; }
	public void setReviewedBy(Integer reviewedBy) { this.reviewedBy = reviewedBy; }

	public Timestamp getReviewedAt() { return reviewedAt; }
	public void setReviewedAt(Timestamp reviewedAt) { this.reviewedAt = reviewedAt; }

	public String getRejectReason() { return rejectReason; }
	public void setRejectReason(String rejectReason) { this.rejectReason = rejectReason; }

	public Timestamp getCreatedAt() { return createdAt; }
	public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

	public String getUsername() { return username; }
	public void setUsername(String username) { this.username = username; }

	public String getNickname() { return nickname; }
	public void setNickname(String nickname) { this.nickname = nickname; }
}

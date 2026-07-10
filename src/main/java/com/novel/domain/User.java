package com.novel.domain;

import java.sql.Timestamp;

/**
 * integrated_user 테이블 매핑 도메인
 * 통합 로그인에서 넘어오는 필드(username/password/nickname/email) + 이 프로젝트 전용 확장 필드
 */
public class User {

	private Integer userId;
	private String username;
	private String password;
	private String nickname;
	private String email;
	private Integer age;
	private String role;            // USER / ADMIN
	private Boolean isAuthor;
	private String penName;
	private Boolean isSuspended;
	private String suspendedReason;
	private Timestamp suspendedAt;
	private Timestamp createdAt;

	public Integer getUserId() { return userId; }
	public void setUserId(Integer userId) { this.userId = userId; }

	public String getUsername() { return username; }
	public void setUsername(String username) { this.username = username; }

	public String getPassword() { return password; }
	public void setPassword(String password) { this.password = password; }

	public String getNickname() { return nickname; }
	public void setNickname(String nickname) { this.nickname = nickname; }

	public String getEmail() { return email; }
	public void setEmail(String email) { this.email = email; }

	public Integer getAge() { return age; }
	public void setAge(Integer age) { this.age = age; }

	public String getRole() { return role; }
	public void setRole(String role) { this.role = role; }

	public Boolean getIsAuthor() { return isAuthor; }
	public void setIsAuthor(Boolean isAuthor) { this.isAuthor = isAuthor; }

	public String getPenName() { return penName; }
	public void setPenName(String penName) { this.penName = penName; }

	public Boolean getIsSuspended() { return isSuspended; }
	public void setIsSuspended(Boolean isSuspended) { this.isSuspended = isSuspended; }

	public String getSuspendedReason() { return suspendedReason; }
	public void setSuspendedReason(String suspendedReason) { this.suspendedReason = suspendedReason; }

	public Timestamp getSuspendedAt() { return suspendedAt; }
	public void setSuspendedAt(Timestamp suspendedAt) { this.suspendedAt = suspendedAt; }

	public Timestamp getCreatedAt() { return createdAt; }
	public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}

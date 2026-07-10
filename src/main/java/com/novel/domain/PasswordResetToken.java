package com.novel.domain;

import java.sql.Timestamp;
import java.util.Date;

/**
 * password_reset_token 테이블 매핑 도메인
 * '비밀번호 찾기' 요청 시 발급되는 1회용 토큰
 */
public class PasswordResetToken {

	private Integer tokenId;
	private Integer userId;
	private String token;
	private Date expiresAt;
	private Boolean used;
	private Timestamp createdAt;

	public Integer getTokenId() { return tokenId; }
	public void setTokenId(Integer tokenId) { this.tokenId = tokenId; }

	public Integer getUserId() { return userId; }
	public void setUserId(Integer userId) { this.userId = userId; }

	public String getToken() { return token; }
	public void setToken(String token) { this.token = token; }

	public Date getExpiresAt() { return expiresAt; }
	public void setExpiresAt(Date expiresAt) { this.expiresAt = expiresAt; }

	public Boolean getUsed() { return used; }
	public void setUsed(Boolean used) { this.used = used; }

	public Timestamp getCreatedAt() { return createdAt; }
	public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

	/** 만료되지 않았고 아직 사용되지 않은 유효한 토큰인지 체크 */
	public boolean isValid() {
		return Boolean.FALSE.equals(used) && expiresAt != null && expiresAt.after(new Date());
	}
}

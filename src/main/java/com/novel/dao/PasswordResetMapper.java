package com.novel.dao;

import org.apache.ibatis.annotations.Param;

import com.novel.domain.PasswordResetToken;

public interface PasswordResetMapper {

	/** 토큰 발급 - insert 후 tokenId가 채워짐 */
	void insertToken(PasswordResetToken resetToken);

	PasswordResetToken selectByToken(@Param("token") String token);

	void markTokenUsed(@Param("tokenId") int tokenId);

	/** 새 토큰 발급 전, 해당 유저의 기존 미사용 토큰들을 모두 무효화 (한 번에 하나만 유효하도록) */
	void invalidateTokensForUser(@Param("userId") int userId);
}

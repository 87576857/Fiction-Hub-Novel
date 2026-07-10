package com.novel.service;

import com.novel.domain.User;
import com.novel.exception.DuplicateFieldException;
import com.novel.exception.InvalidLoginException;
import com.novel.exception.InvalidTokenException;
import com.novel.exception.SuspendedUserException;

public interface AuthService {

	/**
	 * 회원가입. username/email 중복 시 DuplicateFieldException.
	 * 비밀번호는 서비스 내부에서 bcrypt로 해시하여 저장한다.
	 */
	void register(User user) throws DuplicateFieldException;

	/**
	 * 로그인. 성공 시 User(비밀번호 해시 포함) 반환 - 컨트롤러에서 세션에 담기 전 비밀번호는 null 처리 권장.
	 * 아이디/비밀번호 불일치 시 InvalidLoginException, 정지 계정이면 SuspendedUserException.
	 */
	User login(String username, String rawPassword) throws InvalidLoginException, SuspendedUserException;

	/**
	 * 비밀번호 찾기 요청. username+email이 모두 일치하는 회원이 있으면 토큰을 발급해 메일 발송.
	 * 계정 존재 여부가 외부에 노출되지 않도록, 일치하지 않아도 예외를 던지지 않고 조용히 무시한다.
	 */
	void requestPasswordReset(String username, String email, String resetLinkBaseUrl);

	/** 토큰 유효성 검증 (만료/사용여부) - 유효하지 않으면 InvalidTokenException */
	void validateResetToken(String token) throws InvalidTokenException;

	/** 새 비밀번호로 변경 + 토큰 사용 처리 */
	void resetPassword(String token, String newPassword) throws InvalidTokenException;

	/**
	 * 마이페이지 내정보 수정 진입 전 본인확인용 비밀번호 검증.
	 * 저장된 bcrypt 해시와 대조하며, 대상 유저가 없으면 false.
	 */
	boolean checkPassword(int userId, String rawPassword);

	/**
	 * 마이페이지 내정보 수정. 닉네임/이메일/나이만 변경 가능.
	 * 이메일을 다른 계정이 이미 쓰고 있으면 DuplicateFieldException.
	 * 반환값은 갱신 후의 User(세션 갱신용).
	 */
	User updateMyInfo(int userId, String nickname, String email, Integer age) throws DuplicateFieldException;
}

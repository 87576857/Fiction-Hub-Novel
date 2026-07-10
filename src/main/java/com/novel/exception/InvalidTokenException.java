package com.novel.exception;

/** 비밀번호 재설정 토큰이 존재하지 않거나, 만료되었거나, 이미 사용된 경우 발생 */
public class InvalidTokenException extends RuntimeException {

	private static final long serialVersionUID = 1L;

	public InvalidTokenException(String message) {
		super(message);
	}
}

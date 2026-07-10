package com.novel.exception;

/** 아이디 또는 비밀번호 불일치 시 발생 (계정 탈취 시도 방지를 위해 어느 쪽이 틀렸는지는 구분하지 않음) */
public class InvalidLoginException extends RuntimeException {

	private static final long serialVersionUID = 1L;

	public InvalidLoginException(String message) {
		super(message);
	}
}

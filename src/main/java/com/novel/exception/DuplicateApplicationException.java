package com.novel.exception;

/** 이미 작가 인증된 회원이거나, 심사 대기 중인 신청이 이미 있는 회원이 중복 신청할 때 발생 */
public class DuplicateApplicationException extends RuntimeException {

	private static final long serialVersionUID = 1L;

	public DuplicateApplicationException(String message) {
		super(message);
	}
}

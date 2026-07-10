package com.novel.exception;

/**
 * 회원가입 시 username/email이 이미 존재할 때 발생.
 * field: "username" 또는 "email" - 컨트롤러에서 어느 입력창에 에러를 표시할지 구분하는 용도
 */
public class DuplicateFieldException extends RuntimeException {

	private static final long serialVersionUID = 1L;

	private final String field;

	public DuplicateFieldException(String field, String message) {
		super(message);
		this.field = field;
	}

	public String getField() {
		return field;
	}
}

package com.novel.exception;

/**
 * 회원가입 시 입력값이 서버 검증 규칙(길이/형식)을 벗어났을 때 발생.
 * register.jsp의 클라이언트(HTML5) 검증은 브라우저에서만 걸리므로,
 * API를 직접 호출해 이를 우회하는 경우를 서버에서 한 번 더 막기 위한 용도.
 *
 * field: "username"/"password"/"nickname"/"email"/"age" - 컨트롤러에서
 *        어느 입력창에 에러를 표시할지 구분하는 용도 (DuplicateFieldException과 동일한 패턴)
 */
public class InvalidRegistrationException extends RuntimeException {

	private static final long serialVersionUID = 1L;

	private final String field;

	public InvalidRegistrationException(String field, String message) {
		super(message);
		this.field = field;
	}

	public String getField() {
		return field;
	}
}

package com.novel.exception;

/** is_suspended=TRUE인 회원이 로그인을 시도할 때 발생 */
public class SuspendedUserException extends RuntimeException {

	private static final long serialVersionUID = 1L;

	private final String reason;

	public SuspendedUserException(String reason) {
		super("정지된 계정입니다.");
		this.reason = reason;
	}

	public String getReason() {
		return reason;
	}
}

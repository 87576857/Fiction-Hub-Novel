package com.novel.exception;

/** 같은 회원이 같은 소설에 이미 리뷰를 남긴 상태에서 다시 리뷰를 작성하려 할 때 발생 */
public class DuplicateReviewException extends RuntimeException {

	private static final long serialVersionUID = 1L;

	public DuplicateReviewException(String message) {
		super(message);
	}
}

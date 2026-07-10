package com.novel.service;

import com.novel.domain.AuthorApplication;
import com.novel.domain.User;
import com.novel.exception.DuplicateApplicationException;

public interface AuthorApplicationService {

	/** 마이페이지에 표시할, 로그인한 유저의 가장 최근 신청 내역 (없으면 null) */
	AuthorApplication getMyLatestApplication(int userId);

	/**
	 * 작가 인증 신청 제출.
	 * - 이미 is_author=TRUE인 회원이거나
	 * - 이전 신청이 아직 PENDING(심사중)인 경우
	 * DuplicateApplicationException을 던진다.
	 */
	void submitApplication(User loginUser, AuthorApplication application) throws DuplicateApplicationException;
}

package com.novel.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.novel.dao.AuthorApplicationMapper;
import com.novel.domain.AuthorApplication;
import com.novel.domain.User;
import com.novel.exception.DuplicateApplicationException;

@Service
public class AuthorApplicationServiceImpl implements AuthorApplicationService {

	@Autowired
	private AuthorApplicationMapper authorApplicationMapper;

	@Override
	public AuthorApplication getMyLatestApplication(int userId) {
		return authorApplicationMapper.selectLatestApplicationByUserId(userId);
	}

	@Override
	public void submitApplication(User loginUser, AuthorApplication application) {
		if (Boolean.TRUE.equals(loginUser.getIsAuthor())) {
			throw new DuplicateApplicationException("이미 작가 인증이 완료된 계정입니다.");
		}

		AuthorApplication latest = authorApplicationMapper.selectLatestApplicationByUserId(loginUser.getUserId());
		if (latest != null && "PENDING".equals(latest.getStatus())) {
			throw new DuplicateApplicationException("이미 심사 중인 신청이 있습니다. 심사 완료 후 다시 시도해주세요.");
		}

		// userId는 폼 입력이 아니라 세션의 로그인 유저 기준으로 서버에서 강제 지정 (다른 사람 명의로 신청 방지)
		application.setUserId(loginUser.getUserId());
		authorApplicationMapper.insertApplication(application);
	}
}

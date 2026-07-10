package com.novel.service;

public interface MailService {

	/** 비밀번호 재설정 링크를 이메일로 발송 */
	void sendPasswordResetMail(String toEmail, String resetLink);
}

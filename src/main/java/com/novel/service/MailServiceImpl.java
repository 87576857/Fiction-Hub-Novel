package com.novel.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class MailServiceImpl implements MailService {

	private static final Logger logger = LoggerFactory.getLogger(MailServiceImpl.class);

	@Autowired
	private JavaMailSender mailSender;

	@Override
	public void sendPasswordResetMail(String toEmail, String resetLink) {
		SimpleMailMessage message = new SimpleMailMessage();
		message.setTo(toEmail);
		message.setSubject("[마쉬업 커뮤니티] 비밀번호 재설정 안내");
		message.setText(
			"비밀번호 재설정을 요청하셨습니다.\n\n" +
			"아래 링크를 클릭해 새 비밀번호를 설정해주세요. (유효시간 30분)\n" +
			resetLink + "\n\n" +
			"본인이 요청하지 않았다면 이 메일을 무시하셔도 됩니다."
		);
		// 개발 단계에서 SMTP 미설정 시 메일함 대신 로그로 링크를 확인할 수 있도록 남겨둠
		logger.info("[비밀번호 재설정 링크] to={}, link={}", toEmail, resetLink);
		try {
			mailSender.send(message);
		} catch (Exception e) {
			// 개발 환경에서 SMTP 미설정 시에도 흐름 확인이 가능하도록 예외를 흡수하고 로그로 대체
			// (운영 배포 전, root-context.xml의 mailSender 계정 정보를 반드시 실제 값으로 채워야 함)
			logger.error("비밀번호 재설정 메일 발송 실패: to={}, link={}", toEmail, resetLink, e);
		}
	}
}

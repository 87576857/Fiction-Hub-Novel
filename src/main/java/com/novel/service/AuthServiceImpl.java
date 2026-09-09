package com.novel.service;

import java.util.Date;
import java.util.UUID;

import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.novel.dao.PasswordResetMapper;
import com.novel.dao.UserMapper;
import com.novel.domain.PasswordResetToken;
import com.novel.domain.User;
import com.novel.exception.DuplicateFieldException;
import com.novel.exception.InvalidLoginException;
import com.novel.exception.InvalidRegistrationException;
import com.novel.exception.InvalidTokenException;
import com.novel.exception.SuspendedUserException;

@Service
public class AuthServiceImpl implements AuthService {

	/** 재설정 토큰 유효 시간 (분) */
	private static final long TOKEN_EXPIRY_MINUTES = 30;

	@Autowired
	private UserMapper userMapper;

	@Autowired
	private PasswordResetMapper passwordResetMapper;

	@Autowired
	private MailService mailService;

	@Override
	public void register(User user) {
		validateForRegister(user);

		if (userMapper.countByUsername(user.getUsername()) > 0) {
			throw new DuplicateFieldException("username", "이미 사용 중인 아이디입니다.");
		}
		if (userMapper.countByEmail(user.getEmail()) > 0) {
			throw new DuplicateFieldException("email", "이미 사용 중인 이메일입니다.");
		}
		// 평문 비밀번호를 절대 저장하지 않고 bcrypt 해시로 변환
		user.setPassword(BCrypt.hashpw(user.getPassword(), BCrypt.gensalt()));
		userMapper.insertUser(user);
	}

	@Override
	public User login(String username, String rawPassword) {
		User user = userMapper.selectUserByUsername(username);

		// 아이디가 없거나 비밀번호가 틀려도 동일한 메시지 - 계정 존재 여부 노출 방지
		if (user == null || !BCrypt.checkpw(rawPassword, user.getPassword())) {
			throw new InvalidLoginException("아이디 또는 비밀번호가 일치하지 않습니다.");
		}
		if (Boolean.TRUE.equals(user.getIsSuspended())) {
			throw new SuspendedUserException(user.getSuspendedReason());
		}
		return user;
	}

	@Override
	@Transactional
	public void requestPasswordReset(String username, String email, String resetLinkBaseUrl) {
		User user = userMapper.selectUserByUsername(username);

		// username+email이 모두 일치할 때만 토큰 발급. 불일치해도 예외 없이 조용히 리턴(계정 존재 여부 비노출)
		if (user == null || !user.getEmail().equalsIgnoreCase(email)) {
			return;
		}

		// 기존에 발급된 미사용 토큰이 있다면 무효화 (한 시점에 유효 토큰 1개만 유지)
		passwordResetMapper.invalidateTokensForUser(user.getUserId());

		String token = UUID.randomUUID().toString().replace("-", "");
		PasswordResetToken resetToken = new PasswordResetToken();
		resetToken.setUserId(user.getUserId());
		resetToken.setToken(token);
		resetToken.setExpiresAt(new Date(System.currentTimeMillis() + TOKEN_EXPIRY_MINUTES * 60 * 1000));
		passwordResetMapper.insertToken(resetToken);

		String resetLink = resetLinkBaseUrl + "?token=" + token;
		mailService.sendPasswordResetMail(user.getEmail(), resetLink);
	}

	@Override
	public void validateResetToken(String token) {
		findValidToken(token);
	}

	@Override
	@Transactional
	public void resetPassword(String token, String newPassword) {
		PasswordResetToken resetToken = findValidToken(token);
		String hashed = BCrypt.hashpw(newPassword, BCrypt.gensalt());
		userMapper.updatePassword(resetToken.getUserId(), hashed);
		passwordResetMapper.markTokenUsed(resetToken.getTokenId());
	}

	@Override
	public boolean checkPassword(int userId, String rawPassword) {
		User user = userMapper.selectUserById(userId);
		if (user == null) {
			return false;
		}
		return BCrypt.checkpw(rawPassword, user.getPassword());
	}

	@Override
	@Transactional
	public User updateMyInfo(int userId, String nickname, String email, Integer age) {
		if (userMapper.countByEmailExcludingUser(email, userId) > 0) {
			throw new DuplicateFieldException("email", "이미 사용 중인 이메일입니다.");
		}
		userMapper.updateUserInfo(userId, nickname, email, age);
		return userMapper.selectUserById(userId);
	}

	private PasswordResetToken findValidToken(String token) {
		PasswordResetToken resetToken = passwordResetMapper.selectByToken(token);
		if (resetToken == null || !resetToken.isValid()) {
			throw new InvalidTokenException("유효하지 않거나 만료된 링크입니다. 비밀번호 찾기를 다시 시도해주세요.");
		}
		return resetToken;
	}

	/**
	 * register.jsp의 클라이언트(HTML5) 검증 규칙을 서버에서도 동일하게 강제한다.
	 * 클라이언트 검증은 브라우저에서만 걸리므로, API를 직접 호출하면 우회되어
	 * DB 컬럼 길이(username/nickname VARCHAR(50), email VARCHAR(100))를 넘는 값이
	 * 그대로 INSERT 시도되어 500 에러(데이터 잘림 예외)가 발생하던 문제를 방지한다.
	 */
	private void validateForRegister(User user) {
		String username = user.getUsername();
		if (username == null || !username.matches("[a-zA-Z0-9]{4,50}")) {
			throw new InvalidRegistrationException("username", "아이디는 영문/숫자 4~50자여야 합니다.");
		}
		String password = user.getPassword();
		if (password == null || password.length() < 8) {
			throw new InvalidRegistrationException("password", "비밀번호는 8자 이상이어야 합니다.");
		}
		String nickname = user.getNickname();
		if (nickname == null || nickname.trim().isEmpty() || nickname.length() > 50) {
			throw new InvalidRegistrationException("nickname", "닉네임은 1~50자여야 합니다.");
		}
		String email = user.getEmail();
		if (email == null || email.length() > 100 || !email.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$")) {
			throw new InvalidRegistrationException("email", "올바른 이메일 형식이 아닙니다.");
		}
		Integer age = user.getAge();
		if (age != null && (age < 1 || age > 120)) {
			throw new InvalidRegistrationException("age", "나이는 1~120 사이여야 합니다.");
		}
	}
}

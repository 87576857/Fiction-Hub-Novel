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
}

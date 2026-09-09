package com.novel.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomNumberEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.novel.domain.User;
import com.novel.exception.DuplicateFieldException;
import com.novel.exception.InvalidLoginException;
import com.novel.exception.InvalidRegistrationException;
import com.novel.exception.InvalidTokenException;
import com.novel.exception.SuspendedUserException;
import com.novel.service.AuthService;

@Controller
public class AuthController {

	@Autowired
	private AuthService authService;

	// age(선택 입력)를 비워둔 채 제출해도 "" -> Integer 바인딩 에러 없이 null로 처리되도록 등록
	@InitBinder
	public void initBinder(WebDataBinder binder) {
		binder.registerCustomEditor(Integer.class, new CustomNumberEditor(Integer.class, true));
	}

	// ================= 회원가입 =================

	@GetMapping("/register")
	public String registerForm(@ModelAttribute("user") User user) {
		return "register";
	}

	@PostMapping("/register")
	public String register(@ModelAttribute("user") User user, Model model) {
		try {
			authService.register(user);
			return "redirect:/login?registered";
		} catch (DuplicateFieldException e) {
			// 실패 시 입력값 유지 + 어느 필드가 중복인지 표시
			model.addAttribute("errorField", e.getField());
			model.addAttribute("errorMessage", e.getMessage());
			return "register";
		} catch (InvalidRegistrationException e) {
			// 클라이언트(HTML5) 검증을 우회해 서버에 직접 요청한 경우 - 길이/형식 위반
			model.addAttribute("errorField", e.getField());
			model.addAttribute("errorMessage", e.getMessage());
			return "register";
		}
	}

	// ================= 로그인 / 로그아웃 =================

	@GetMapping("/login")
	public String loginForm() {
		return "login";
	}

	@PostMapping("/login")
	public String login(@RequestParam String username, @RequestParam String password,
			HttpSession session, Model model) {
		try {
			User user = authService.login(username, password);
			user.setPassword(null); // 세션에는 비밀번호 해시를 남기지 않음
			session.setAttribute("loginUser", user);
			return "redirect:/home";
		} catch (InvalidLoginException e) {
			model.addAttribute("errorMessage", e.getMessage());
			return "login";
		} catch (SuspendedUserException e) {
			model.addAttribute("errorMessage", "정지된 계정입니다. 사유: "
					+ (e.getReason() != null ? e.getReason() : "관리자에게 문의해주세요."));
			return "login";
		}
	}

	@GetMapping("/logout")
	public String logout(HttpSession session) {
		session.invalidate();
		return "redirect:/home";
	}

	// ================= 비밀번호 찾기 =================

	@GetMapping("/find-password")
	public String findPasswordForm() {
		return "find-password";
	}

	@PostMapping("/find-password")
	public String findPassword(@RequestParam String username, @RequestParam String email,
			HttpServletRequest request, Model model) {
		String baseUrl = request.getRequestURL().toString()
				.replace(request.getRequestURI(), request.getContextPath()) + "/reset-password";
		authService.requestPasswordReset(username, email, baseUrl);
		// 실제 존재 여부와 무관하게 항상 동일한 안내 메시지 (계정 존재 여부 노출 방지)
		model.addAttribute("submitted", true);
		return "find-password";
	}

	// ================= 비밀번호 재설정 =================

	@GetMapping("/reset-password")
	public String resetPasswordForm(@RequestParam String token, Model model) {
		try {
			authService.validateResetToken(token);
			model.addAttribute("token", token);
			return "reset-password";
		} catch (InvalidTokenException e) {
			model.addAttribute("errorMessage", e.getMessage());
			return "reset-password";
		}
	}

	@PostMapping("/reset-password")
	public String resetPassword(@RequestParam String token, @RequestParam String newPassword,
			@RequestParam String newPasswordConfirm, Model model) {
		if (!newPassword.equals(newPasswordConfirm)) {
			model.addAttribute("token", token);
			model.addAttribute("errorMessage", "새 비밀번호가 일치하지 않습니다.");
			return "reset-password";
		}
		try {
			authService.resetPassword(token, newPassword);
			return "redirect:/login?reset";
		} catch (InvalidTokenException e) {
			model.addAttribute("errorMessage", e.getMessage());
			return "reset-password";
		}
	}
}

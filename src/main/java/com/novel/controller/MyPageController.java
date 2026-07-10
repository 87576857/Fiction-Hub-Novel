package com.novel.controller;

import java.util.List;

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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.novel.domain.AuthorApplication;
import com.novel.domain.Comment;
import com.novel.domain.Post;
import com.novel.domain.User;
import com.novel.exception.DuplicateApplicationException;
import com.novel.exception.DuplicateFieldException;
import com.novel.service.AuthService;
import com.novel.service.AuthorApplicationService;
import com.novel.service.PostService;
import com.novel.util.PageUtil;

/**
 * 마이페이지 (/mypage/**) - 로그인한 회원 전용.
 * 로그인 여부 체크는 AdminInterceptor처럼 별도 인터셉터로 빼지 않고,
 * 메서드마다 세션을 직접 확인한다 (이 프로젝트에 로그인 필수 페이지가 아직 이 화면뿐이라 간단하게 처리).
 */
@Controller
@RequestMapping("/mypage")
public class MyPageController {

	/** 내정보 수정 진입 전 비밀번호 확인을 거쳤는지 세션에 남겨두는 키 */
	private static final String EDIT_VERIFIED_KEY = "mypageEditVerified";

	@Autowired
	private AuthorApplicationService authorApplicationService;

	@Autowired
	private AuthService authService;

	@Autowired
	private PostService postService;

	// age(선택 입력)를 비워둔 채 제출해도 "" -> Integer 바인딩 에러 없이 null로 처리되도록 등록
	@InitBinder
	public void initBinder(WebDataBinder binder) {
		binder.registerCustomEditor(Integer.class, new CustomNumberEditor(Integer.class, true));
	}

	@GetMapping("")
	public String myPage(HttpSession session, Model model) {
		User loginUser = requireLogin(session);
		if (loginUser == null) {
			return "redirect:/login";
		}
		model.addAttribute("loginUser", loginUser);
		model.addAttribute("latestApplication", authorApplicationService.getMyLatestApplication(loginUser.getUserId()));
		return "mypage";
	}

	@GetMapping("/author-apply")
	public String applyForm(HttpSession session, Model model) {
		User loginUser = requireLogin(session);
		if (loginUser == null) {
			return "redirect:/login";
		}
		model.addAttribute("application", new AuthorApplication());
		return "author-apply";
	}

	@PostMapping("/author-apply")
	public String apply(@ModelAttribute("application") AuthorApplication application,
			HttpSession session, Model model) {
		User loginUser = requireLogin(session);
		if (loginUser == null) {
			return "redirect:/login";
		}
		try {
			authorApplicationService.submitApplication(loginUser, application);
			return "redirect:/mypage?applied";
		} catch (DuplicateApplicationException e) {
			model.addAttribute("errorMessage", e.getMessage());
			return "author-apply";
		}
	}

	// ================= 내가 쓴 글 / 댓글 모아보기 =================

	// 내가 쓴 글 / 댓글 목록 페이지당 개수 (5단위로 끊어서 번호 노출)
	private static final int MYPAGE_LIST_PAGE_SIZE = 5;

	@GetMapping("/posts")
	public String myPosts(@RequestParam(value = "page", required = false, defaultValue = "1") int page,
			HttpSession session, Model model) {
		User loginUser = requireLogin(session);
		if (loginUser == null) {
			return "redirect:/login";
		}
		List<Post> allPosts = postService.getMyPosts(loginUser.getUserId());
		int totalPages = PageUtil.totalPages(allPosts.size(), MYPAGE_LIST_PAGE_SIZE);
		int currentPage = PageUtil.safePage(page, totalPages);

		model.addAttribute("posts", PageUtil.slice(allPosts, currentPage, MYPAGE_LIST_PAGE_SIZE));
		model.addAttribute("currentPage", currentPage);
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("groupStart", PageUtil.groupStart(currentPage));
		model.addAttribute("groupEnd", PageUtil.groupEnd(currentPage, totalPages));
		return "mypage-posts";
	}

	@GetMapping("/comments")
	public String myComments(@RequestParam(value = "page", required = false, defaultValue = "1") int page,
			HttpSession session, Model model) {
		User loginUser = requireLogin(session);
		if (loginUser == null) {
			return "redirect:/login";
		}
		List<Comment> allComments = postService.getMyComments(loginUser.getUserId());
		int totalPages = PageUtil.totalPages(allComments.size(), MYPAGE_LIST_PAGE_SIZE);
		int currentPage = PageUtil.safePage(page, totalPages);

		model.addAttribute("comments", PageUtil.slice(allComments, currentPage, MYPAGE_LIST_PAGE_SIZE));
		model.addAttribute("currentPage", currentPage);
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("groupStart", PageUtil.groupStart(currentPage));
		model.addAttribute("groupEnd", PageUtil.groupEnd(currentPage, totalPages));
		return "mypage-comments";
	}

	/**
	 * 내가 쓴 댓글(또는 리뷰) 삭제: userId를 세션에서 꺼내 서비스에 함께 넘기므로,
	 * 다른 회원의 commentId를 넘겨도 삭제되지 않는다.
	 * type이 "review"면 소설 리뷰, 그 외에는 게시판 댓글로 처리한다 (목록이 두 종류를 함께 노출하기 때문).
	 */
	@PostMapping("/comments/delete")
	public String deleteMyComment(@RequestParam int commentId,
			@RequestParam(value = "type", required = false, defaultValue = "comment") String type,
			@RequestParam(value = "page", required = false, defaultValue = "1") int page,
			HttpSession session) {
		User loginUser = requireLogin(session);
		if (loginUser == null) {
			return "redirect:/login";
		}
		postService.deleteMyComment(commentId, type, loginUser.getUserId());
		return "redirect:/mypage/comments?page=" + page;
	}

	// ================= 내정보 수정 (비밀번호 확인 -> 수정 폼) =================

	/** 1단계: 본인확인용 비밀번호 입력 폼 */
	@GetMapping("/edit")
	public String editVerifyForm(HttpSession session) {
		if (requireLogin(session) == null) {
			return "redirect:/login";
		}
		session.removeAttribute(EDIT_VERIFIED_KEY);
		return "mypage-edit-verify";
	}

	/** 1단계 처리: 비밀번호가 맞으면 세션에 인증 플래그를 남기고 수정 폼으로 이동 */
	@PostMapping("/edit")
	public String editVerify(@RequestParam String password, HttpSession session, Model model) {
		User loginUser = requireLogin(session);
		if (loginUser == null) {
			return "redirect:/login";
		}
		if (!authService.checkPassword(loginUser.getUserId(), password)) {
			model.addAttribute("errorMessage", "비밀번호가 일치하지 않습니다.");
			return "mypage-edit-verify";
		}
		session.setAttribute(EDIT_VERIFIED_KEY, Boolean.TRUE);
		return "redirect:/mypage/edit-form";
	}

	/** 2단계: 실제 정보 수정 폼. 1단계를 거치지 않았으면 다시 비밀번호 확인으로 되돌린다 */
	@GetMapping("/edit-form")
	public String editForm(HttpSession session, Model model) {
		User loginUser = requireLogin(session);
		if (loginUser == null) {
			return "redirect:/login";
		}
		if (!Boolean.TRUE.equals(session.getAttribute(EDIT_VERIFIED_KEY))) {
			return "redirect:/mypage/edit";
		}
		model.addAttribute("loginUser", loginUser);
		return "mypage-edit-form";
	}

	/** 2단계 처리: 닉네임/이메일/나이 저장 후 세션의 loginUser도 갱신 */
	@PostMapping("/edit-form")
	public String editSubmit(@RequestParam String nickname,
			@RequestParam String email,
			@RequestParam(required = false) Integer age,
			HttpSession session, Model model) {
		User loginUser = requireLogin(session);
		if (loginUser == null) {
			return "redirect:/login";
		}
		if (!Boolean.TRUE.equals(session.getAttribute(EDIT_VERIFIED_KEY))) {
			return "redirect:/mypage/edit";
		}
		try {
			User updated = authService.updateMyInfo(loginUser.getUserId(), nickname, email, age);
			updated.setPassword(null);
			session.setAttribute("loginUser", updated);
			session.removeAttribute(EDIT_VERIFIED_KEY);
			return "redirect:/mypage?updated";
		} catch (DuplicateFieldException e) {
			loginUser.setNickname(nickname);
			loginUser.setEmail(email);
			loginUser.setAge(age);
			model.addAttribute("loginUser", loginUser);
			model.addAttribute("errorMessage", e.getMessage());
			return "mypage-edit-form";
		}
	}

	private User requireLogin(HttpSession session) {
		Object loginUser = session.getAttribute("loginUser");
		return (loginUser instanceof User) ? (User) loginUser : null;
	}
}
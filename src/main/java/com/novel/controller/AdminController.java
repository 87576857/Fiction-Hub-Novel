package com.novel.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.novel.domain.AuthorApplication;
import com.novel.domain.Comment;
import com.novel.domain.Novel;
import com.novel.domain.Post;
import com.novel.domain.User;
import com.novel.service.AdminService;
import com.novel.service.NovelService;
import com.novel.util.PageUtil;
import com.novel.util.RolePolicy;

/**
 * 관리자 모드 (/admin/**)
 * 접근 권한 체크는 AdminInterceptor에서 처리 (servlet-context.xml에 등록됨)
 */
@Controller
@RequestMapping("/admin")
public class AdminController {

	@Autowired
	private AdminService adminService;

	@Autowired
	private NovelService novelService;

	// 1. 대시보드 메인 홈
	@GetMapping("")
	public String dashboard(Model model) {
		model.addAttribute("stats", adminService.getDashboardStats());
		return "admin/dashboard";
	}

	// 2. 회원 관리 - 관리자(ADMIN/SUPER_ADMIN)와 일반 회원(USER)을 구분해서 노출
	//    일반 회원은 10명씩, 페이지 번호는 5단위로 끊어서 노출 («/» 화살표로 다음 그룹 이동)
	private static final int USER_PAGE_SIZE = 10;

	@GetMapping("/users")
	public String users(@RequestParam(value = "keyword", required = false) String keyword,
			@RequestParam(value = "userPage", required = false, defaultValue = "1") int userPage,
			Model model) {
		List<User> allUsers = adminService.searchUsers(keyword);

		List<User> adminUsers = new ArrayList<>();
		List<User> regularUsers = new ArrayList<>();
		for (User u : allUsers) {
			if (RolePolicy.ROLE_USER.equals(u.getRole())) {
				regularUsers.add(u);
			} else {
				adminUsers.add(u);
			}
		}

		int userTotalPages = PageUtil.totalPages(regularUsers.size(), USER_PAGE_SIZE);
		int userCurrentPage = PageUtil.safePage(userPage, userTotalPages);

		model.addAttribute("adminUsers", adminUsers);
		model.addAttribute("users", PageUtil.slice(regularUsers, userCurrentPage, USER_PAGE_SIZE));
		model.addAttribute("userCurrentPage", userCurrentPage);
		model.addAttribute("userTotalPages", userTotalPages);
		model.addAttribute("userGroupStart", PageUtil.groupStart(userCurrentPage));
		model.addAttribute("userGroupEnd", PageUtil.groupEnd(userCurrentPage, userTotalPages));
		model.addAttribute("keyword", keyword);
		return "admin/users";
	}

	@PostMapping("/users/{userId}/suspend")
	public String suspendUser(@PathVariable int userId, @RequestParam String reason,
			@RequestParam(value = "keyword", required = false) String keyword,
			@RequestParam(value = "userPage", required = false, defaultValue = "1") int userPage) {
		adminService.suspendUser(userId, reason);
		return "redirect:/admin/users" + buildUserQueryString(keyword, userPage);
	}

	@PostMapping("/users/{userId}/unsuspend")
	public String unsuspendUser(@PathVariable int userId,
			@RequestParam(value = "keyword", required = false) String keyword,
			@RequestParam(value = "userPage", required = false, defaultValue = "1") int userPage) {
		adminService.unsuspendUser(userId);
		return "redirect:/admin/users" + buildUserQueryString(keyword, userPage);
	}

	/** 회원 관리 액션(정지/해제/임명 등) 후 리다이렉트 시 검색어·페이지를 유지하기 위한 쿼리스트링 조립 */
	private String buildUserQueryString(String keyword, int userPage) {
		StringBuilder sb = new StringBuilder("?userPage=").append(userPage);
		if (keyword != null && !keyword.isEmpty()) {
			sb.append("&keyword=").append(java.net.URLEncoder.encode(keyword, java.nio.charset.StandardCharsets.UTF_8));
		}
		return sb.toString();
	}

	// 관리자 임명/해제 - SUPER_ADMIN만 가능. AdminInterceptor는 ADMIN도 통과시키므로 여기서 한 번 더 체크한다.
	@PostMapping("/users/{userId}/grant-admin")
	public String grantAdmin(@PathVariable int userId, HttpSession session,
			@RequestParam(value = "keyword", required = false) String keyword,
			@RequestParam(value = "userPage", required = false, defaultValue = "1") int userPage) {
		if (!isSuperAdmin(session)) {
			return "redirect:/admin/users" + buildUserQueryString(keyword, userPage);
		}
		adminService.grantAdmin(userId);
		return "redirect:/admin/users" + buildUserQueryString(keyword, userPage);
	}

	@PostMapping("/users/{userId}/revoke-admin")
	public String revokeAdmin(@PathVariable int userId, HttpSession session,
			@RequestParam(value = "keyword", required = false) String keyword,
			@RequestParam(value = "userPage", required = false, defaultValue = "1") int userPage) {
		if (!isSuperAdmin(session)) {
			return "redirect:/admin/users" + buildUserQueryString(keyword, userPage);
		}
		adminService.revokeAdmin(userId);
		return "redirect:/admin/users" + buildUserQueryString(keyword, userPage);
	}

	private boolean isSuperAdmin(HttpSession session) {
		Object loginUser = session.getAttribute("loginUser");
		return loginUser instanceof User && RolePolicy.ROLE_SUPER_ADMIN.equals(((User) loginUser).getRole());
	}

	// 3. 작가 인증 신청 관리 - 5개씩, 페이지 번호 5단위로 끊어서 노출
	private static final int AUTHOR_PAGE_SIZE = 5;

	@GetMapping("/authors")
	public String authors(@RequestParam(value = "authorPage", required = false, defaultValue = "1") int authorPage,
			Model model) {
		List<AuthorApplication> allApplications = adminService.getPendingApplications();

		int authorTotalPages = PageUtil.totalPages(allApplications.size(), AUTHOR_PAGE_SIZE);
		int authorCurrentPage = PageUtil.safePage(authorPage, authorTotalPages);

		model.addAttribute("applications", PageUtil.slice(allApplications, authorCurrentPage, AUTHOR_PAGE_SIZE));
		model.addAttribute("authorCurrentPage", authorCurrentPage);
		model.addAttribute("authorTotalPages", authorTotalPages);
		model.addAttribute("authorGroupStart", PageUtil.groupStart(authorCurrentPage));
		model.addAttribute("authorGroupEnd", PageUtil.groupEnd(authorCurrentPage, authorTotalPages));
		return "admin/authors";
	}

	@PostMapping("/authors/{applicationId}/approve")
	public String approveAuthor(@PathVariable int applicationId, HttpSession session,
			@RequestParam(value = "authorPage", required = false, defaultValue = "1") int authorPage) {
		User admin = (User) session.getAttribute("loginUser");
		adminService.approveApplication(applicationId, admin.getUserId());
		return "redirect:/admin/authors?authorPage=" + authorPage;
	}

	@PostMapping("/authors/{applicationId}/reject")
	public String rejectAuthor(@PathVariable int applicationId, @RequestParam String reason, HttpSession session,
			@RequestParam(value = "authorPage", required = false, defaultValue = "1") int authorPage) {
		User admin = (User) session.getAttribute("loginUser");
		adminService.rejectApplication(applicationId, admin.getUserId(), reason);
		return "redirect:/admin/authors?authorPage=" + authorPage;
	}

	// 4. 콘텐츠 관리 (게시글/댓글 모아보기 + 일괄삭제) - 게시글/댓글 각각 5개씩, 페이지 번호 5단위로 끊어서 노출
	private static final int CONTENT_PAGE_SIZE = 5;

	@GetMapping("/content")
	public String content(@RequestParam(value = "postPage", required = false, defaultValue = "1") int postPage,
			@RequestParam(value = "commentPage", required = false, defaultValue = "1") int commentPage,
			@RequestParam(value = "postKeyword", required = false) String postKeyword,
			@RequestParam(value = "postBoard", required = false) String postBoard,
			@RequestParam(value = "commentKeyword", required = false) String commentKeyword,
			@RequestParam(value = "commentBoard", required = false) String commentBoard,
			Model model) {
		List<Post> allPosts = adminService.getAllPosts(postKeyword, postBoard);
		List<Comment> allComments = adminService.getAllComments(commentKeyword, commentBoard);

		int postTotalPages = PageUtil.totalPages(allPosts.size(), CONTENT_PAGE_SIZE);
		int postCurrentPage = PageUtil.safePage(postPage, postTotalPages);
		int commentTotalPages = PageUtil.totalPages(allComments.size(), CONTENT_PAGE_SIZE);
		int commentCurrentPage = PageUtil.safePage(commentPage, commentTotalPages);

		model.addAttribute("posts", PageUtil.slice(allPosts, postCurrentPage, CONTENT_PAGE_SIZE));
		model.addAttribute("postCurrentPage", postCurrentPage);
		model.addAttribute("postTotalPages", postTotalPages);
		model.addAttribute("postGroupStart", PageUtil.groupStart(postCurrentPage));
		model.addAttribute("postGroupEnd", PageUtil.groupEnd(postCurrentPage, postTotalPages));
		model.addAttribute("postKeyword", postKeyword);
		model.addAttribute("postBoard", postBoard);

		model.addAttribute("comments", PageUtil.slice(allComments, commentCurrentPage, CONTENT_PAGE_SIZE));
		model.addAttribute("commentCurrentPage", commentCurrentPage);
		model.addAttribute("commentTotalPages", commentTotalPages);
		model.addAttribute("commentGroupStart", PageUtil.groupStart(commentCurrentPage));
		model.addAttribute("commentGroupEnd", PageUtil.groupEnd(commentCurrentPage, commentTotalPages));
		model.addAttribute("commentKeyword", commentKeyword);
		model.addAttribute("commentBoard", commentBoard);
		return "admin/content";
	}

	@PostMapping("/content/posts/delete")
	public String deletePosts(@RequestParam(value = "postIds", required = false) List<Integer> postIds,
			@RequestParam(value = "postPage", required = false, defaultValue = "1") int postPage,
			@RequestParam(value = "commentPage", required = false, defaultValue = "1") int commentPage,
			@RequestParam(value = "postKeyword", required = false) String postKeyword,
			@RequestParam(value = "postBoard", required = false) String postBoard,
			@RequestParam(value = "commentKeyword", required = false) String commentKeyword,
			@RequestParam(value = "commentBoard", required = false) String commentBoard) {
		if (postIds != null && !postIds.isEmpty()) {
			adminService.deletePosts(postIds);
		}
		return "redirect:/admin/content" + buildContentQueryString(postPage, commentPage, postKeyword, postBoard,
				commentKeyword, commentBoard);
	}

	@PostMapping("/content/comments/delete")
	public String deleteComments(@RequestParam(value = "commentKeys", required = false) List<String> commentKeys,
			@RequestParam(value = "postPage", required = false, defaultValue = "1") int postPage,
			@RequestParam(value = "commentPage", required = false, defaultValue = "1") int commentPage,
			@RequestParam(value = "postKeyword", required = false) String postKeyword,
			@RequestParam(value = "postBoard", required = false) String postBoard,
			@RequestParam(value = "commentKeyword", required = false) String commentKeyword,
			@RequestParam(value = "commentBoard", required = false) String commentBoard) {
		// 댓글/리뷰 통합 목록에서 체크박스 값은 "comment:12", "review:7" 형태라서
		// 타입별로 나눠서 각자의 테이블에서 삭제해야 한다.
		if (commentKeys != null && !commentKeys.isEmpty()) {
			List<Integer> commentIds = new java.util.ArrayList<>();
			List<Integer> reviewIds = new java.util.ArrayList<>();
			for (String key : commentKeys) {
				String[] parts = key.split(":", 2);
				if (parts.length != 2) {
					continue;
				}
				try {
					int id = Integer.parseInt(parts[1]);
					if ("review".equals(parts[0])) {
						reviewIds.add(id);
					} else {
						commentIds.add(id);
					}
				} catch (NumberFormatException ignored) {
					// 잘못된 값은 무시
				}
			}
			if (!commentIds.isEmpty()) {
				adminService.deleteComments(commentIds);
			}
			if (!reviewIds.isEmpty()) {
				adminService.deleteReviews(reviewIds);
			}
		}
		return "redirect:/admin/content" + buildContentQueryString(postPage, commentPage, postKeyword, postBoard,
				commentKeyword, commentBoard);
	}

	/** 삭제 후 리다이렉트 시 페이지/검색어/게시판 필터를 그대로 유지하기 위한 쿼리스트링 조립 */
	private String buildContentQueryString(int postPage, int commentPage, String postKeyword, String postBoard,
			String commentKeyword, String commentBoard) {
		StringBuilder sb = new StringBuilder("?postPage=").append(postPage).append("&commentPage=").append(commentPage);
		if (postKeyword != null && !postKeyword.isEmpty()) {
			sb.append("&postKeyword=").append(java.net.URLEncoder.encode(postKeyword, java.nio.charset.StandardCharsets.UTF_8));
		}
		if (postBoard != null && !postBoard.isEmpty()) {
			sb.append("&postBoard=").append(postBoard);
		}
		if (commentKeyword != null && !commentKeyword.isEmpty()) {
			sb.append("&commentKeyword=").append(java.net.URLEncoder.encode(commentKeyword, java.nio.charset.StandardCharsets.UTF_8));
		}
		if (commentBoard != null && !commentBoard.isEmpty()) {
			sb.append("&commentBoard=").append(commentBoard);
		}
		return sb.toString();
	}

	// 5. 리뷰 게시판(소설) 관리 - 10개씩, 페이지 번호 5단위로 끊어서 노출
	private static final int NOVEL_PAGE_SIZE = 10;

	@GetMapping("/novels")
	public String novels(@RequestParam(value = "keyword", required = false) String keyword,
			@RequestParam(value = "novelPage", required = false, defaultValue = "1") int novelPage, Model model) {
		List<Novel> allNovels = novelService.getNovelList(keyword);

		int novelTotalPages = PageUtil.totalPages(allNovels.size(), NOVEL_PAGE_SIZE);
		int novelCurrentPage = PageUtil.safePage(novelPage, novelTotalPages);

		model.addAttribute("novels", PageUtil.slice(allNovels, novelCurrentPage, NOVEL_PAGE_SIZE));
		model.addAttribute("novelCurrentPage", novelCurrentPage);
		model.addAttribute("novelTotalPages", novelTotalPages);
		model.addAttribute("novelGroupStart", PageUtil.groupStart(novelCurrentPage));
		model.addAttribute("novelGroupEnd", PageUtil.groupEnd(novelCurrentPage, novelTotalPages));
		model.addAttribute("keyword", keyword);
		return "admin/novels";
	}

	@GetMapping("/novels/write")
	public String novelWriteForm(Model model) {
		model.addAttribute("novel", new Novel());
		return "admin/novel-write";
	}

	@PostMapping("/novels/write")
	public String novelWrite(@ModelAttribute("novel") Novel novel, HttpSession session) {
		User admin = (User) session.getAttribute("loginUser");
		// managedBy는 폼 입력이 아니라 세션의 로그인 관리자 기준으로 서버에서 강제 지정
		novel.setManagedBy(admin.getUserId());
		novelService.registerNovel(novel);
		return "redirect:/admin/novels";
	}

	@GetMapping("/novels/{novelId}/edit")
	public String novelEditForm(@PathVariable int novelId, Model model) {
		model.addAttribute("novel", novelService.getNovelById(novelId));
		return "admin/novel-write";
	}

	@PostMapping("/novels/{novelId}/edit")
	public String novelEdit(@PathVariable int novelId, @ModelAttribute("novel") Novel novel, HttpSession session) {
		User admin = (User) session.getAttribute("loginUser");
		novel.setNovelId(novelId);
		novel.setManagedBy(admin.getUserId());
		novelService.updateNovel(novel);
		return "redirect:/admin/novels";
	}

	@PostMapping("/novels/{novelId}/delete")
	public String novelDelete(@PathVariable int novelId) {
		novelService.deleteNovel(novelId);
		return "redirect:/admin/novels";
	}
}

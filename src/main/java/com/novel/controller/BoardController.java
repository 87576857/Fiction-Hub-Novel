package com.novel.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.novel.domain.Comment;
import com.novel.domain.Post;
import com.novel.domain.User;
import com.novel.service.PostService;
import com.novel.util.PageUtil;

/**
 * find(이 소설 찾아요) / rookie(신인작가 광장) / author(작가 정보관)
 * 3개 게시판이 URL의 {boardKey}로 구분되어 같은 로직을 공유한다.
 *
 * 뷰 이름은 boardKey 그대로 사용하므로 기존 파일명 규칙(author-detail.jsp 등)과 일치한다.
 *   목록:  find.jsp / rookie.jsp / author.jsp
 *   상세:  find-detail.jsp / rookie-detail.jsp / author-detail.jsp
 *   작성:  find-write.jsp / rookie-write.jsp / author-write.jsp
 */
@Controller
public class BoardController {

	@Autowired
	private PostService postService;

	private String boardName(String boardKey) {
		switch (boardKey) {
			case "find":   return "이 소설 찾아요";
			case "rookie": return "신인작가 광장";
			case "author": return "작가 정보관";
			default:       return null;
		}
	}

	/** 세션에서 로그인 유저를 꺼낸다. 없으면 null (호출부에서 로그인 페이지로 리다이렉트 처리) */
	private User currentUser(HttpSession session) {
		Object loginUser = session.getAttribute("loginUser");
		return (loginUser instanceof User) ? (User) loginUser : null;
	}

	private static final int BOARD_PAGE_SIZE = 10;

	@GetMapping("/{boardKey:find|rookie|author}")
	public String list(@PathVariable String boardKey,
						@RequestParam(value = "tag", required = false) String tag,
						@RequestParam(value = "keyword", required = false) String keyword,
						@RequestParam(value = "page", required = false, defaultValue = "1") int page,
						Model model) {
		List<Post> allPosts = postService.getPostList(boardName(boardKey), tag, keyword);

		int totalPages = PageUtil.totalPages(allPosts.size(), BOARD_PAGE_SIZE);
		int currentPage = PageUtil.safePage(page, totalPages);

		model.addAttribute("posts", PageUtil.slice(allPosts, currentPage, BOARD_PAGE_SIZE));
		model.addAttribute("selectedTag", (tag == null || tag.isEmpty()) ? "전체" : tag);
		model.addAttribute("keyword", keyword);
		model.addAttribute("currentPage", currentPage);
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("groupStart", PageUtil.groupStart(currentPage));
		model.addAttribute("groupEnd", PageUtil.groupEnd(currentPage, totalPages));
		return boardKey;
	}

	@GetMapping("/{boardKey:find|rookie|author}/write")
	public String writeForm(@PathVariable String boardKey, HttpSession session) {
		// 비로그인 상태로 글쓰기 폼에 진입하는 것 자체를 막아서, 다 쓰고 나서 튕기는 상황을 방지
		if (currentUser(session) == null) {
			return "redirect:/login";
		}
		return boardKey + "-write";
	}

	@PostMapping("/{boardKey:find|rookie|author}/write")
	public String write(@PathVariable String boardKey,
						 @RequestParam String title,
						 @RequestParam String content,
						 @RequestParam(required = false, defaultValue = "전체") String tag,
						 HttpSession session) {
		User loginUser = currentUser(session);
		if (loginUser == null) {
			return "redirect:/login";
		}
		Post post = new Post();
		post.setUserId(loginUser.getUserId());
		post.setTitle(title);
		post.setContent(content);
		post.setPlatformTag(tag);
		postService.writePost(boardName(boardKey), post);
		return "redirect:/" + boardKey;
	}

	@GetMapping("/{boardKey:find|rookie|author}/{postId:\\d+}")
	public String detail(@PathVariable String boardKey,
						  @PathVariable int postId,
						  Model model) {
		Post post = postService.getPostDetail(postId);
		model.addAttribute("post", post);
		model.addAttribute("comments", postService.getComments(postId));
		return boardKey + "-detail";
	}

	// 본인 글 수정: 글쓴이 본인만 폼에 진입할 수 있고, 저장도 본인 글만 가능 (Service의 WHERE user_id 조건으로 이중 체크)
	@GetMapping("/{boardKey:find|rookie|author}/{postId:\\d+}/edit")
	public String editForm(@PathVariable String boardKey,
							@PathVariable int postId,
							HttpSession session,
							Model model,
							RedirectAttributes redirectAttributes) {
		User loginUser = currentUser(session);
		if (loginUser == null) {
			return "redirect:/login";
		}
		Post post = postService.getPostById(postId);
		if (post == null || !post.getUserId().equals(loginUser.getUserId())) {
			redirectAttributes.addFlashAttribute("errorMessage", "본인이 작성한 글만 수정할 수 있습니다.");
			return "redirect:/" + boardKey + "/" + postId;
		}
		model.addAttribute("post", post);
		return boardKey + "-edit";
	}

	@PostMapping("/{boardKey:find|rookie|author}/{postId:\\d+}/edit")
	public String editSubmit(@PathVariable String boardKey,
							  @PathVariable int postId,
							  @RequestParam String title,
							  @RequestParam String content,
							  @RequestParam(required = false, defaultValue = "전체") String tag,
							  HttpSession session,
							  RedirectAttributes redirectAttributes) {
		User loginUser = currentUser(session);
		if (loginUser == null) {
			return "redirect:/login";
		}
		boolean updated = postService.updateMyPost(postId, loginUser.getUserId(), title, content, tag);
		if (!updated) {
			redirectAttributes.addFlashAttribute("errorMessage", "본인이 작성한 글만 수정할 수 있습니다.");
		}
		return "redirect:/" + boardKey + "/" + postId;
	}

	@PostMapping("/{boardKey:find|rookie|author}/{postId:\\d+}/comment")
	public String addComment(@PathVariable String boardKey,
							  @PathVariable int postId,
							  @RequestParam String content,
							  HttpSession session) {
		User loginUser = currentUser(session);
		if (loginUser == null) {
			return "redirect:/login";
		}
		Comment comment = new Comment();
		comment.setPostId(postId);
		comment.setUserId(loginUser.getUserId());
		comment.setContent(content);
		postService.writeComment(comment);
		return "redirect:/" + boardKey + "/" + postId;
	}

	// find 게시판 전용: 해결/미해결 토글 - 글쓴이 본인만 가능
	@PostMapping("/find/{postId:\\d+}/solve")
	public String toggleSolved(@PathVariable int postId,
								@RequestParam boolean solved,
								HttpSession session,
								RedirectAttributes redirectAttributes) {
		User loginUser = currentUser(session);
		if (loginUser == null) {
			return "redirect:/login";
		}
		Post post = postService.getPostById(postId);
		if (post == null || !post.getUserId().equals(loginUser.getUserId())) {
			redirectAttributes.addFlashAttribute("errorMessage", "글쓴이만 해결 상태를 변경할 수 있습니다.");
			return "redirect:/find/" + postId;
		}
		postService.toggleSolved(postId, solved);
		return "redirect:/find/" + postId;
	}
}

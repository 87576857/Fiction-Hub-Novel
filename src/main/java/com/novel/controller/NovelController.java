package com.novel.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.novel.domain.NovelReview;
import com.novel.domain.User;
import com.novel.exception.DuplicateReviewException;
import com.novel.service.NovelReviewService;
import com.novel.service.NovelService;

/**
 * 소설 상세(리뷰) 페이지 - /review/{novelId}
 * 그리드(review.jsp)의 모달에서 "리뷰 전체보기"로 진입하는 상세 화면.
 */
@Controller
public class NovelController {

	@Autowired
	private NovelService novelService;

	@Autowired
	private NovelReviewService novelReviewService;

	@GetMapping("/review/{novelId}")
	public String detail(@PathVariable int novelId, HttpSession session, Model model) {
		model.addAttribute("novel", novelService.getNovelDetail(novelId));
		model.addAttribute("reviews", novelReviewService.getReviews(novelId));
		model.addAttribute("averageRating", novelReviewService.getAverageRating(novelId));
		model.addAttribute("reviewCount", novelReviewService.countReviews(novelId));

		User loginUser = currentUser(session);
		model.addAttribute("loginUser", loginUser);
		if (loginUser != null) {
			model.addAttribute("alreadyReviewed", novelReviewService.hasReviewed(novelId, loginUser.getUserId()));
			model.addAttribute("likedReviewIds", novelReviewService.getLikedReviewIds(novelId, loginUser.getUserId()));
		}
		return "review-detail";
	}

	@PostMapping("/review/{novelId}/reviews")
	public String submitReview(@PathVariable int novelId,
			@ModelAttribute("review") NovelReview review,
			HttpSession session, RedirectAttributes redirectAttributes) {
		User loginUser = currentUser(session);
		if (loginUser == null) {
			return "redirect:/login";
		}
		// novelId/userId는 폼 입력이 아니라 URL 경로/세션 기준으로 서버에서 강제 지정
		review.setNovelId(novelId);
		review.setUserId(loginUser.getUserId());
		try {
			novelReviewService.submitReview(review);
		} catch (DuplicateReviewException | IllegalArgumentException e) {
			redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
		}
		return "redirect:/review/" + novelId;
	}

	@PostMapping("/review/{novelId}/reviews/{reviewId}/like")
	public String likeReview(@PathVariable int novelId, @PathVariable int reviewId, HttpSession session,
			RedirectAttributes redirectAttributes) {
		User loginUser = currentUser(session);
		if (loginUser == null) {
			return "redirect:/login";
		}
		boolean liked = novelReviewService.likeReview(reviewId, loginUser.getUserId());
		if (!liked) {
			redirectAttributes.addFlashAttribute("errorMessage", "이미 이 리뷰에 좋아요를 누르셨습니다.");
		}
		return "redirect:/review/" + novelId;
	}

	private User currentUser(HttpSession session) {
		Object loginUser = session.getAttribute("loginUser");
		return (loginUser instanceof User) ? (User) loginUser : null;
	}
}

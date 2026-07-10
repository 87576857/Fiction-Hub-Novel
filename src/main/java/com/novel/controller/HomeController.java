package com.novel.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.novel.domain.Novel;
import com.novel.domain.NovelReview;
import com.novel.service.NovelReviewService;
import com.novel.service.NovelService;
import com.novel.service.PostService;
import com.novel.util.PageUtil;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);

	@Autowired
	private PostService postService;

	@Autowired
	private NovelService novelService;

	@Autowired
	private NovelReviewService novelReviewService;

	/**
	 * 홈 화면: find/rookie/author 게시판 블록마다 해당 게시판의 조회수 1위 글을 함께 보여준다.
	 */
	@RequestMapping(value = {"/", "/home"}, method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		model.addAttribute("topPostsByBoard", postService.getTopPostsByBoard(3));
		model.addAttribute("topNovels", novelService.getTopNovels(4));
		return "home";
	}

	// 리뷰 게시판: 관리자가 등록한 소설을 4x5(20개) 액자형 그리드로 노출, 하단 번호로 페이지 이동
	private static final int NOVELS_PER_PAGE = 20;
	// 팝업에 보여줄 "좋아요 많은 리뷰" 개수
	private static final int TOP_LIKED_REVIEWS_PER_NOVEL = 2;

	@RequestMapping(value = "/review", method = RequestMethod.GET)
	public String review(@RequestParam(value = "page", required = false, defaultValue = "1") int page,
			@RequestParam(value = "platform", required = false) String platform,
			@RequestParam(value = "sort", required = false) String sort,
			@RequestParam(value = "keyword", required = false) String keyword, Model model) {
		int totalCount = novelService.countAllNovels(platform, keyword);
		int totalPages = PageUtil.totalPages(totalCount, NOVELS_PER_PAGE);
		int currentPage = PageUtil.safePage(page, totalPages);
		int groupStart = PageUtil.groupStart(currentPage);
		int groupEnd = PageUtil.groupEnd(currentPage, totalPages);

		List<Novel> novels = novelService.getNovelPage(currentPage, NOVELS_PER_PAGE, platform, sort, keyword);

		// 팝업에서 "좋아요 많은 리뷰 2개"를 보여주기 위해, 현재 페이지에 노출되는 소설들만 조회 (최대 20건 - 부담 없음)
		Map<Integer, List<NovelReview>> topReviewsByNovel = new HashMap<>();
		for (Novel n : novels) {
			topReviewsByNovel.put(n.getNovelId(),
					novelReviewService.getTopLikedReviews(n.getNovelId(), TOP_LIKED_REVIEWS_PER_NOVEL));
		}

		model.addAttribute("novels", novels);
		model.addAttribute("topReviewsByNovel", topReviewsByNovel);
		model.addAttribute("currentPage", currentPage);
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("groupStart", groupStart);
		model.addAttribute("groupEnd", groupEnd);
		model.addAttribute("selectedPlatform", platform);
		model.addAttribute("selectedSort", sort);
		model.addAttribute("selectedKeyword", keyword);
		return "review";
	}

	@RequestMapping(value = "/terms", method = RequestMethod.GET)
	public String terms() {
		return "terms";
	}

	@RequestMapping(value = "/privacy", method = RequestMethod.GET)
	public String privacy() {
		return "privacy";
	}

}
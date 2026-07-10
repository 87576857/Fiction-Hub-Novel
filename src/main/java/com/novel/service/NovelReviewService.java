package com.novel.service;

import java.util.List;

import com.novel.domain.NovelReview;
import com.novel.exception.DuplicateReviewException;

public interface NovelReviewService {

	List<NovelReview> getReviews(int novelId);

	/** 평균 평점 - 리뷰가 없으면 null */
	Double getAverageRating(int novelId);

	int countReviews(int novelId);

	/** 특정 유저가 이 소설에 이미 리뷰를 남겼는지 (상세 화면에서 폼 노출 여부 판단용) */
	boolean hasReviewed(int novelId, int userId);

	/**
	 * 리뷰 작성. userId는 세션 기준으로 컨트롤러에서 채워서 넘긴다.
	 * 같은 유저가 같은 소설에 이미 리뷰를 남겼으면 DuplicateReviewException.
	 */
	void submitReview(NovelReview review) throws DuplicateReviewException;

	/**
	 * 리뷰 좋아요. 이미 해당 유저가 좋아요를 누른 리뷰면 아무 것도 하지 않고 false를 반환한다.
	 * (같은 유저가 여러 번 눌러도 likes가 계속 올라가지 않도록 Review_Likes로 중복 차단)
	 */
	boolean likeReview(int reviewId, int userId);

	/** 상세 화면에서 "이미 좋아요 누른 리뷰"를 표시하기 위한 review_id 목록 */
	java.util.List<Integer> getLikedReviewIds(int novelId, int userId);

	/** 리뷰게시판 팝업용 - 좋아요 많은 순 상위 N개 리뷰 */
	List<NovelReview> getTopLikedReviews(int novelId, int limit);
}

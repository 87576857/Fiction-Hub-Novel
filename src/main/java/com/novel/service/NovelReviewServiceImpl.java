package com.novel.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.novel.dao.NovelReviewMapper;
import com.novel.domain.NovelReview;
import com.novel.exception.DuplicateReviewException;

@Service
public class NovelReviewServiceImpl implements NovelReviewService {

	@Autowired
	private NovelReviewMapper novelReviewMapper;

	@Override
	public List<NovelReview> getReviews(int novelId) {
		return novelReviewMapper.selectReviewsByNovel(novelId);
	}

	@Override
	public Double getAverageRating(int novelId) {
		return novelReviewMapper.selectAverageRating(novelId);
	}

	@Override
	public int countReviews(int novelId) {
		return novelReviewMapper.countReviews(novelId);
	}

	@Override
	public boolean hasReviewed(int novelId, int userId) {
		return novelReviewMapper.countByNovelAndUser(novelId, userId) > 0;
	}

	@Override
	public void submitReview(NovelReview review) {
		if (review.getRating() == null || review.getRating() < 1 || review.getRating() > 5) {
			throw new IllegalArgumentException("평점은 1~5 사이여야 합니다.");
		}
		if (novelReviewMapper.countByNovelAndUser(review.getNovelId(), review.getUserId()) > 0) {
			throw new DuplicateReviewException("이미 이 작품에 리뷰를 남기셨습니다.");
		}
		novelReviewMapper.insertReview(review);
	}

	@Override
	@org.springframework.transaction.annotation.Transactional
	public boolean likeReview(int reviewId, int userId) {
		if (novelReviewMapper.countLikeByReviewAndUser(reviewId, userId) > 0) {
			return false; // 이미 좋아요 누름 - 중복 방지
		}
		novelReviewMapper.insertLike(reviewId, userId);
		novelReviewMapper.increaseLikes(reviewId);
		return true;
	}

	@Override
	public java.util.List<Integer> getLikedReviewIds(int novelId, int userId) {
		return novelReviewMapper.selectLikedReviewIds(novelId, userId);
	}

	@Override
	public List<NovelReview> getTopLikedReviews(int novelId, int limit) {
		return novelReviewMapper.selectTopLikedReviews(novelId, limit);
	}
}

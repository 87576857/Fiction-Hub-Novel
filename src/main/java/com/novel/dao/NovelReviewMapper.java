package com.novel.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.novel.domain.Comment;
import com.novel.domain.NovelReview;

public interface NovelReviewMapper {

	/** 특정 소설의 리뷰 목록 (최신순) */
	List<NovelReview> selectReviewsByNovel(@Param("novelId") int novelId);

	/** 평균 평점 (리뷰 없으면 null) */
	Double selectAverageRating(@Param("novelId") int novelId);

	int countReviews(@Param("novelId") int novelId);

	/** 같은 유저가 같은 소설에 이미 리뷰를 남겼는지 체크 (중복 방지) */
	int countByNovelAndUser(@Param("novelId") int novelId, @Param("userId") int userId);

	void insertReview(NovelReview review);

	void increaseLikes(@Param("reviewId") int reviewId);

	/** 이 유저가 이 리뷰에 이미 좋아요를 눌렀는지 (중복 방지) */
	int countLikeByReviewAndUser(@Param("reviewId") int reviewId, @Param("userId") int userId);

	/** 좋아요 기록 저장 (Review_Likes) - 실패(중복) 시 서비스에서 걸러짐 */
	void insertLike(@Param("reviewId") int reviewId, @Param("userId") int userId);

	/** 상세 화면 진입 시, 이 소설의 리뷰들 중 로그인 유저가 이미 좋아요 누른 review_id 목록 */
	List<Integer> selectLikedReviewIds(@Param("novelId") int novelId, @Param("userId") int userId);

	/** 리뷰게시판 팝업용 - 좋아요 많은 순 상위 N개 리뷰 */
	List<NovelReview> selectTopLikedReviews(@Param("novelId") int novelId, @Param("limit") int limit);

	/**
	 * 마이페이지 "내가 쓴 댓글" 목록에 리뷰도 함께 노출하기 위해,
	 * 리뷰를 Comment 형태(소설 제목=postTitle, boardKey="review")로 변환해서 조회.
	 */
	List<Comment> selectReviewsAsCommentsByUser(@Param("userId") int userId);

	/**
	 * 관리자 콘텐츠 관리 화면(댓글 목록)에 리뷰도 함께 노출하기 위한 전체 리뷰 조회 (Comment 형태)
	 * @param keyword 리뷰 내용/작성자 닉네임/소설 제목 검색어 (null 또는 빈 문자열이면 전체)
	 */
	List<Comment> selectAllReviewsForAdminAsComments(@Param("keyword") String keyword);

	/**
	 * 본인 리뷰 삭제 (마이페이지 "내가 쓴 댓글"에서 사용).
	 * WHERE 절에 user_id도 함께 걸어서 다른 회원의 리뷰를 삭제하는 것을 DB 레벨에서 원천 차단한다.
	 * @return 삭제된 행 수 (0이면 본인 리뷰가 아니거나 이미 삭제된 것)
	 */
	int deleteReviewByIdAndUser(@Param("reviewId") int reviewId, @Param("userId") int userId);

	/** 관리자 - 체크박스로 선택한 리뷰 일괄 삭제 */
	void deleteReviewsByIds(@Param("reviewIds") List<Integer> reviewIds);
}

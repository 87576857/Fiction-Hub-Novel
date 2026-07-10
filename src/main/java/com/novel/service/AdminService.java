package com.novel.service;

import java.util.List;

import com.novel.domain.AdminDashboardStats;
import com.novel.domain.AuthorApplication;
import com.novel.domain.Comment;
import com.novel.domain.Post;
import com.novel.domain.User;

public interface AdminService {

	/** 대시보드 메인 홈(Overview) 통계 묶음 */
	AdminDashboardStats getDashboardStats();

	/** 회원 검색 (keyword가 null이면 전체) */
	List<User> searchUsers(String keyword);

	void suspendUser(int userId, String reason);

	void unsuspendUser(int userId);

	/**
	 * 회원을 ADMIN으로 임명. SUPER_ADMIN 권한 체크는 컨트롤러에서 세션 기준으로 선행되어야 한다.
	 * 대상이 이미 SUPER_ADMIN이면 아무 동작도 하지 않는다(강등 방지).
	 */
	void grantAdmin(int userId);

	/**
	 * ADMIN 회원의 권한을 USER로 해제. 대상이 SUPER_ADMIN이면 아무 동작도 하지 않는다(강등 방지).
	 */
	void revokeAdmin(int userId);

	/** 심사 대기 중인 작가 인증 신청 목록 */
	List<AuthorApplication> getPendingApplications();

	/** 승인 - Author_Applications.status 변경 + integrated_user.is_author/pen_name 반영 (트랜잭션) */
	void approveApplication(int applicationId, int adminId);

	void rejectApplication(int applicationId, int adminId, String reason);

	/**
	 * @param keyword  제목/내용/작성자 닉네임 검색어 (null 또는 빈 문자열이면 전체)
	 * @param boardKey 게시판 필터 (find/rookie/author, null 또는 빈 문자열이면 전체)
	 */
	List<Post> getAllPosts(String keyword, String boardKey);

	/**
	 * @param keyword  내용/작성자 닉네임/원글(소설) 제목 검색어 (null 또는 빈 문자열이면 전체)
	 * @param boardKey 게시판 필터 (find/rookie/author/review, null 또는 빈 문자열이면 전체)
	 */
	List<Comment> getAllComments(String keyword, String boardKey);

	void deletePosts(List<Integer> postIds);

	void deleteComments(List<Integer> commentIds);

	/** 체크박스로 선택한 소설 리뷰 일괄 삭제 (콘텐츠 관리 "댓글" 목록에 리뷰도 함께 노출되므로) */
	void deleteReviews(List<Integer> reviewIds);
}

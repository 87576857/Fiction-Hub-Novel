package com.novel.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Comparator;

import com.novel.dao.AdminMapper;
import com.novel.dao.AuthorApplicationMapper;
import com.novel.dao.NovelReviewMapper;
import com.novel.dao.UserMapper;
import com.novel.domain.AdminDashboardStats;
import com.novel.domain.AuthorApplication;
import com.novel.domain.Comment;
import com.novel.domain.Post;
import com.novel.domain.User;
import com.novel.util.RolePolicy;

@Service
public class AdminServiceImpl implements AdminService {

	@Autowired
	private UserMapper userMapper;

	@Autowired
	private AuthorApplicationMapper authorApplicationMapper;

	@Autowired
	private AdminMapper adminMapper;

	@Autowired
	private NovelReviewMapper novelReviewMapper;

	@Override
	public AdminDashboardStats getDashboardStats() {
		AdminDashboardStats stats = new AdminDashboardStats();
		stats.setTotalUsers(userMapper.countTotalUsers());
		stats.setTodayNewUsers(userMapper.countTodayNewUsers());
		stats.setTodayNewNovels(adminMapper.countTodayNewNovels());
		stats.setTodayNewPosts(adminMapper.countTodayNewPosts());
		stats.setPendingApplications(authorApplicationMapper.countPendingApplications());
		stats.setRecentUsers(userMapper.selectRecentUsers(5));
		return stats;
	}

	@Override
	public List<User> searchUsers(String keyword) {
		return userMapper.selectUserList(keyword);
	}

	@Override
	public void suspendUser(int userId, String reason) {
		User target = userMapper.selectUserById(userId);
		// 관리자(ADMIN, SUPER_ADMIN)는 정지 대상에서 제외 - 관리자끼리 서로 정지시키는 것을 방지
		if (RolePolicy.isSuspendable(target)) {
			userMapper.suspendUser(userId, reason);
		}
	}

	@Override
	public void unsuspendUser(int userId) {
		userMapper.unsuspendUser(userId);
	}

	@Override
	public void grantAdmin(int userId) {
		User target = userMapper.selectUserById(userId);
		// SUPER_ADMIN은 임명 대상에서 제외 (이미 최고 권한이므로 의미 없는 동작 방지)
		if (RolePolicy.isAppointable(target)) {
			userMapper.updateRole(userId, RolePolicy.ROLE_ADMIN);
		}
	}

	@Override
	public void revokeAdmin(int userId) {
		User target = userMapper.selectUserById(userId);
		if (RolePolicy.isAppointable(target)) {
			userMapper.updateRole(userId, RolePolicy.ROLE_USER);
		}
	}

	@Override
	public List<AuthorApplication> getPendingApplications() {
		return authorApplicationMapper.selectPendingApplications();
	}

	@Override
	@Transactional
	public void approveApplication(int applicationId, int adminId) {
		AuthorApplication application = authorApplicationMapper.selectApplicationById(applicationId);
		authorApplicationMapper.approveApplication(applicationId, adminId);
		// 신청 시 입력한 필명을 그대로 회원의 인증 필명으로 반영
		userMapper.verifyAuthor(application.getUserId(), application.getPenName());
	}

	@Override
	public void rejectApplication(int applicationId, int adminId, String reason) {
		authorApplicationMapper.rejectApplication(applicationId, adminId, reason);
	}

	@Override
	public List<Post> getAllPosts(String keyword, String boardKey) {
		return adminMapper.selectAllPostsForAdmin(keyword, boardKey);
	}

	@Override
	public List<Comment> getAllComments(String keyword, String boardKey) {
		// 콘텐츠 관리 화면 "댓글" 목록에 게시판 댓글 + 소설 리뷰를 함께 노출
		// boardKey가 "review"면 리뷰만, find/rookie/author면 게시판 댓글만, 비어있으면 둘 다 조회
		boolean includeComments = boardKey == null || boardKey.isEmpty() || !"review".equals(boardKey);
		boolean includeReviews = boardKey == null || boardKey.isEmpty() || "review".equals(boardKey);

		List<Comment> comments = includeComments
				? adminMapper.selectAllCommentsForAdmin(keyword, "review".equals(boardKey) ? null : boardKey)
				: new ArrayList<>();
		List<Comment> reviews = includeReviews
				? novelReviewMapper.selectAllReviewsForAdminAsComments(keyword)
				: new ArrayList<>();

		List<Comment> merged = new ArrayList<>(comments.size() + reviews.size());
		merged.addAll(comments);
		merged.addAll(reviews);
		merged.sort(Comparator.comparing(Comment::getCreatedAt).reversed());
		return merged;
	}

	@Override
	public void deletePosts(List<Integer> postIds) {
		adminMapper.deletePostsByIds(postIds);
	}

	@Override
	public void deleteComments(List<Integer> commentIds) {
		adminMapper.deleteCommentsByIds(commentIds);
	}

	@Override
	public void deleteReviews(List<Integer> reviewIds) {
		novelReviewMapper.deleteReviewsByIds(reviewIds);
	}
}

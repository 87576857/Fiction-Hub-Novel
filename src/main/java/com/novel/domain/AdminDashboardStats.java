package com.novel.domain;

import java.util.List;

/**
 * 관리자 대시보드 메인 홈(Overview)에 표시할 통계 묶음
 * (DB 테이블과 매핑되지 않는, 여러 COUNT 쿼리 결과를 담는 화면 전용 객체)
 */
public class AdminDashboardStats {

	private int totalUsers;
	private int todayNewUsers;
	private int todayNewNovels;
	private int todayNewPosts;
	private int pendingApplications;
	private List<User> recentUsers;

	public int getTotalUsers() { return totalUsers; }
	public void setTotalUsers(int totalUsers) { this.totalUsers = totalUsers; }

	public int getTodayNewUsers() { return todayNewUsers; }
	public void setTodayNewUsers(int todayNewUsers) { this.todayNewUsers = todayNewUsers; }

	public int getTodayNewNovels() { return todayNewNovels; }
	public void setTodayNewNovels(int todayNewNovels) { this.todayNewNovels = todayNewNovels; }

	public int getTodayNewPosts() { return todayNewPosts; }
	public void setTodayNewPosts(int todayNewPosts) { this.todayNewPosts = todayNewPosts; }

	public int getPendingApplications() { return pendingApplications; }
	public void setPendingApplications(int pendingApplications) { this.pendingApplications = pendingApplications; }

	public List<User> getRecentUsers() { return recentUsers; }
	public void setRecentUsers(List<User> recentUsers) { this.recentUsers = recentUsers; }
}

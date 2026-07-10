package com.novel.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.novel.domain.AuthorApplication;

public interface AuthorApplicationMapper {

	/** 심사 대기(PENDING) 목록 - 신청자 정보 JOIN */
	List<AuthorApplication> selectPendingApplications();

	int countPendingApplications();

	AuthorApplication selectApplicationById(@Param("applicationId") int applicationId);

	/** 해당 유저가 가장 최근에 낸 신청 1건 (없으면 null) - 마이페이지에서 신청 가능 여부/상태 표시용 */
	AuthorApplication selectLatestApplicationByUserId(@Param("userId") int userId);

	/** 신청서 제출 - status는 기본 PENDING */
	void insertApplication(AuthorApplication application);

	void approveApplication(@Param("applicationId") int applicationId, @Param("adminId") int adminId);

	void rejectApplication(@Param("applicationId") int applicationId, @Param("adminId") int adminId,
			@Param("reason") String reason);
}

package com.novel.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.novel.domain.User;

public interface UserMapper {

	/** 아이디/닉네임/이메일 검색 (keyword가 null/빈값이면 전체 조회) */
	List<User> selectUserList(@Param("keyword") String keyword);

	int countTotalUsers();

	int countTodayNewUsers();

	List<User> selectRecentUsers(@Param("limit") int limit);

	User selectUserById(@Param("userId") int userId);

	User selectUserByUsername(@Param("username") String username);

	/** 비밀번호 찾기 본인확인(username+email 일치) 및 이메일 중복 체크용 */
	User selectUserByEmail(@Param("email") String email);

	int countByUsername(@Param("username") String username);

	int countByEmail(@Param("email") String email);

	void suspendUser(@Param("userId") int userId, @Param("reason") String reason);

	void unsuspendUser(@Param("userId") int userId);

	/** 작가 인증 승인 처리 - is_author=TRUE, pen_name 반영 */
	void verifyAuthor(@Param("userId") int userId, @Param("penName") String penName);

	/** 회원가입 - insert 후 생성된 user_id가 user.userId에 채워짐 (useGeneratedKeys) */
	void insertUser(User user);

	/** 비밀번호 재설정/변경 - password는 이미 해시된 값이어야 함 */
	void updatePassword(@Param("userId") int userId, @Param("password") String hashedPassword);

	/** 관리자 임명/해제 - SUPER_ADMIN만 호출 가능하도록 서비스/컨트롤러 단에서 제한 */
	void updateRole(@Param("userId") int userId, @Param("role") String role);

	/** 마이페이지 내정보 수정 - 닉네임/이메일/나이만 변경 */
	void updateUserInfo(@Param("userId") int userId, @Param("nickname") String nickname,
			@Param("email") String email, @Param("age") Integer age);

	/** 이메일 중복 체크(본인 제외) - 내정보 수정 시 이메일 변경용 */
	int countByEmailExcludingUser(@Param("email") String email, @Param("userId") int userId);
}

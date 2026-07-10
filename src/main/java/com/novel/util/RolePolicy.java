package com.novel.util;

import com.novel.domain.User;

/**
 * 관리자 모드에서 "이 회원을 대상으로 이 동작을 해도 되는가"를 판단하는 역할 기반 정책 모음.
 *
 * AdminServiceImpl의 suspendUser/grantAdmin/revokeAdmin 각각에 흩어져 있던
 * "role 문자열 비교" 로직을 한 곳으로 모아서, 규칙이 바뀔 때 이 클래스만 고치면 되도록 했다.
 * (예: "USER" / "ADMIN" / "SUPER_ADMIN" 상수도 여기서만 관리)
 */
public final class RolePolicy {

	public static final String ROLE_USER = "USER";
	public static final String ROLE_ADMIN = "ADMIN";
	public static final String ROLE_SUPER_ADMIN = "SUPER_ADMIN";

	private RolePolicy() {
		// 정적 유틸리티 클래스 - 인스턴스화 방지
	}

	/**
	 * 정지 가능한 대상인지 여부.
	 * 관리자(ADMIN, SUPER_ADMIN)는 서로 정지시킬 수 없고, 일반 회원(USER)만 정지 대상이 된다.
	 */
	public static boolean isSuspendable(User target) {
		return target != null && ROLE_USER.equals(target.getRole());
	}

	/**
	 * 관리자 임명/해제 대상이 될 수 있는지 여부.
	 * SUPER_ADMIN은 이미 최고 권한이므로 임명/해제 대상에서 제외한다.
	 */
	public static boolean isAppointable(User target) {
		return target != null && !ROLE_SUPER_ADMIN.equals(target.getRole());
	}
}

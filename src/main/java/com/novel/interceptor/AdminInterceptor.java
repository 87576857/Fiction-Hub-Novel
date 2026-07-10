package com.novel.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;

import com.novel.domain.User;
import com.novel.util.RolePolicy;

/**
 * /admin/** 경로는 세션에 로그인된 회원이 있고, 그 회원의 role이 ADMIN 또는 SUPER_ADMIN인 경우에만 통과시킨다.
 * (관리자 임명/해제 같은 SUPER_ADMIN 전용 기능은 AdminController에서 별도로 한 번 더 체크한다)
 */
public class AdminInterceptor implements HandlerInterceptor {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		HttpSession session = request.getSession(false);
		Object loginUser = (session != null) ? session.getAttribute("loginUser") : null;

		if (!(loginUser instanceof User)) {
			response.sendRedirect(request.getContextPath() + "/login");
			return false;
		}
		String role = ((User) loginUser).getRole();
		if (!RolePolicy.ROLE_ADMIN.equals(role) && !RolePolicy.ROLE_SUPER_ADMIN.equals(role)) {
			response.sendRedirect(request.getContextPath() + "/home");
			return false;
		}
		return true;
	}
}

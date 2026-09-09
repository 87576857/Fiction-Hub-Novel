<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:include page="../common/header.jsp" />

<!-- 주소: admin/users.jsp -->
<main class="container-xl py-4">
  <div class="row g-4">
    <div class="col-md-3">
      <jsp:include page="common/sidebar.jsp"><jsp:param name="active" value="users" /></jsp:include>
    </div>

    <div class="col-md-9">
      <h1 class="mb-4" style="font-family:'Gowun Batang',serif;font-size:22px;font-weight:700;">회원 관리</h1>

      <form method="get" action="${pageContext.request.contextPath}/admin/users" class="d-flex gap-2 mb-4">
        <input type="text" name="keyword" class="form-control" placeholder="아이디, 닉네임, 이메일 검색" value="${keyword}" />
        <button type="submit" class="btn-primary-custom" style="white-space:nowrap;">검색</button>
      </form>

      <!-- ===================== 관리자 관리 ===================== -->
      <h2 class="mb-2" style="font-size:16px;font-weight:700;">관리자 관리</h2>
      <c:choose>
        <c:when test="${empty adminUsers}">
          <p class="text-muted mb-5">조회된 관리자가 없습니다.</p>
        </c:when>
        <c:otherwise>
          <div class="table-responsive mb-5">
            <table class="table align-middle" style="table-layout:fixed;width:100%;">
              <colgroup>
                <col style="width:140px;">
                <col style="width:140px;">
                <col>
                <col style="width:110px;">
                <col style="width:80px;">
                <col style="width:100px;">
                <col style="width:120px;">
              </colgroup>
              <thead>
                <tr>
                  <th>아이디</th><th>닉네임</th><th>이메일</th><th>권한</th><th>상태</th><th>가입일</th><th></th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="u" items="${adminUsers}">
                  <tr>
                    <td style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;" title="${fn:escapeXml(u.username)}"><c:out value="${u.username}"/></td>
                    <td style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;" title="${fn:escapeXml(u.nickname)}"><c:out value="${u.nickname}"/><c:if test="${u.isAuthor}"> ✒️</c:if></td>
                    <td style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;" title="${fn:escapeXml(u.email)}"><c:out value="${u.email}"/></td>
                    <td><span class="chip chip-default">${u.role}</span></td>
                    <td>
                      <c:choose>
                        <c:when test="${u.isSuspended}"><span class="badge-unsolved">정지됨</span></c:when>
                        <c:otherwise><span class="badge-solved">정상</span></c:otherwise>
                      </c:choose>
                    </td>
                    <td style="font-size:12px;color:var(--muted);"><fmt:formatDate value="${u.createdAt}" pattern="yyyy-MM-dd" /></td>
                    <td>
                      <!-- 관리자(ADMIN, SUPER_ADMIN)는 정지 대상이 아니므로 항상 "-" -->
                      <span style="font-size:12px;color:var(--muted);">-</span>

                      <!-- 관리자 임명/해제 - SUPER_ADMIN으로 로그인한 경우에만 노출. SUPER_ADMIN 대상 회원에게는 표시하지 않음 -->
                      <c:if test="${sessionScope.loginUser.role == 'SUPER_ADMIN' and u.role != 'SUPER_ADMIN'}">
                        <form method="post" action="${pageContext.request.contextPath}/admin/users/${u.userId}/revoke-admin" style="display:inline;margin-left:4px;">
                          <input type="hidden" name="keyword" value="${keyword}" />
                          <input type="hidden" name="userPage" value="${userCurrentPage}" />
                          <button type="submit" class="btn-outline-custom" style="padding:4px 12px;font-size:12px;">관리자 해제</button>
                        </form>
                      </c:if>
                    </td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </div>
        </c:otherwise>
      </c:choose>

      <!-- ===================== 일반 회원 관리 ===================== -->
      <h2 class="mb-2" style="font-size:16px;font-weight:700;">일반 회원 관리</h2>
      <c:choose>
        <c:when test="${empty users}">
          <p class="text-muted">조회된 회원이 없습니다.</p>
        </c:when>
        <c:otherwise>
          <div class="table-responsive">
            <table class="table align-middle" style="table-layout:fixed;width:100%;">
              <colgroup>
                <col style="width:140px;">
                <col style="width:140px;">
                <col>
                <col style="width:110px;">
                <col style="width:80px;">
                <col style="width:100px;">
                <col style="width:120px;">
              </colgroup>
              <thead>
                <tr>
                  <th>아이디</th><th>닉네임</th><th>이메일</th><th>권한</th><th>상태</th><th>가입일</th><th></th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="u" items="${users}">
                  <tr>
                    <td style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;" title="${fn:escapeXml(u.username)}"><c:out value="${u.username}"/></td>
                    <td style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;" title="${fn:escapeXml(u.nickname)}"><c:out value="${u.nickname}"/><c:if test="${u.isAuthor}"> ✒️</c:if></td>
                    <td style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;" title="${fn:escapeXml(u.email)}"><c:out value="${u.email}"/></td>
                    <td><span class="chip chip-default">${u.role}</span></td>
                    <td>
                      <c:choose>
                        <c:when test="${u.isSuspended}"><span class="badge-unsolved">정지됨</span></c:when>
                        <c:otherwise><span class="badge-solved">정상</span></c:otherwise>
                      </c:choose>
                    </td>
                    <td style="font-size:12px;color:var(--muted);"><fmt:formatDate value="${u.createdAt}" pattern="yyyy-MM-dd" /></td>
                    <td>
                      <c:choose>
                        <c:when test="${u.isSuspended}">
                          <form method="post" action="${pageContext.request.contextPath}/admin/users/${u.userId}/unsuspend" style="display:inline;">
                            <input type="hidden" name="keyword" value="${keyword}" />
                            <input type="hidden" name="userPage" value="${userCurrentPage}" />
                            <button type="submit" class="btn-outline-custom" style="padding:4px 12px;font-size:12px;">정지 해제</button>
                          </form>
                        </c:when>
                        <c:otherwise>
                          <button type="button" class="btn-outline-custom" style="padding:4px 12px;font-size:12px;"
                                  onclick="document.getElementById('suspendForm${u.userId}').style.display='flex'">정지</button>
                          <form id="suspendForm${u.userId}" method="post"
                                action="${pageContext.request.contextPath}/admin/users/${u.userId}/suspend"
                                style="display:none;gap:4px;margin-top:6px;">
                            <input type="hidden" name="keyword" value="${keyword}" />
                            <input type="hidden" name="userPage" value="${userCurrentPage}" />
                            <input type="text" name="reason" placeholder="정지 사유" required class="form-control form-control-sm" />
                            <button type="submit" class="btn-primary-custom" style="padding:4px 12px;font-size:12px;">확인</button>
                          </form>
                        </c:otherwise>
                      </c:choose>

                      <!-- 관리자 임명 - SUPER_ADMIN으로 로그인한 경우에만 노출 -->
                      <c:if test="${sessionScope.loginUser.role == 'SUPER_ADMIN'}">
                        <form method="post" action="${pageContext.request.contextPath}/admin/users/${u.userId}/grant-admin" style="display:inline;margin-left:4px;">
                          <input type="hidden" name="keyword" value="${keyword}" />
                          <input type="hidden" name="userPage" value="${userCurrentPage}" />
                          <button type="submit" class="btn-outline-custom" style="padding:4px 12px;font-size:12px;">관리자 임명</button>
                        </form>
                      </c:if>
                    </td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </div>

          <c:if test="${userTotalPages > 1}">
            <div class="d-flex justify-content-center align-items-center gap-2 mt-3">
              <c:if test="${userGroupStart > 1}">
                <button type="button" class="btn-outline-custom" style="padding:5px 10px;font-size:12px;"
                        onclick="location.href='${pageContext.request.contextPath}/admin/users?userPage=${userGroupStart - 1}&keyword=${keyword}'">&laquo;</button>
              </c:if>
              <c:forEach var="p" begin="${userGroupStart}" end="${userGroupEnd}">
                <button type="button"
                        class="${p == userCurrentPage ? 'btn-primary-custom' : 'btn-outline-custom'}"
                        style="padding:5px 12px;font-size:12px;min-width:32px;"
                        onclick="location.href='${pageContext.request.contextPath}/admin/users?userPage=${p}&keyword=${keyword}'">${p}</button>
              </c:forEach>
              <c:if test="${userGroupEnd < userTotalPages}">
                <button type="button" class="btn-outline-custom" style="padding:5px 10px;font-size:12px;"
                        onclick="location.href='${pageContext.request.contextPath}/admin/users?userPage=${userGroupEnd + 1}&keyword=${keyword}'">&raquo;</button>
              </c:if>
            </div>
          </c:if>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</main>

<jsp:include page="../common/footer.jsp" />

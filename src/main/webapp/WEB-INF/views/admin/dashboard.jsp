<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../common/header.jsp" />

<!-- 주소: admin/dashboard.jsp -->
<main class="container-xl py-4">
  <div class="row g-4">
    <div class="col-md-3">
      <jsp:include page="common/sidebar.jsp"><jsp:param name="active" value="dashboard" /></jsp:include>
    </div>

    <div class="col-md-9">
      <h1 class="mb-4" style="font-family:'Gowun Batang',serif;font-size:22px;font-weight:700;">대시보드</h1>

      <div class="row g-3 mb-5">
        <div class="col-6 col-lg-3">
          <div class="muted-panel text-center">
            <div style="font-size:12px;color:var(--muted);">전체 회원 수</div>
            <div style="font-size:24px;font-weight:800;">${stats.totalUsers}</div>
          </div>
        </div>
        <div class="col-6 col-lg-3">
          <div class="muted-panel text-center">
            <div style="font-size:12px;color:var(--muted);">오늘 신규 가입</div>
            <div style="font-size:24px;font-weight:800;">${stats.todayNewUsers}</div>
          </div>
        </div>
        <div class="col-6 col-lg-3">
          <div class="muted-panel text-center">
            <div style="font-size:12px;color:var(--muted);">오늘 신규 게시글</div>
            <div style="font-size:24px;font-weight:800;">${stats.todayNewPosts}</div>
          </div>
        </div>
        <div class="col-6 col-lg-3">
          <div class="muted-panel text-center" style="background:#fef2f2;">
            <div style="font-size:12px;color:#ef4444;">작가 인증 대기</div>
            <div style="font-size:24px;font-weight:800;color:#ef4444;">${stats.pendingApplications}</div>
          </div>
        </div>
      </div>

      <h2 class="mb-3" style="font-family:'Gowun Batang',serif;font-size:18px;font-weight:700;">최근 가입한 회원</h2>
      <c:choose>
        <c:when test="${empty stats.recentUsers}">
          <p class="text-muted">최근 가입한 회원이 없습니다.</p>
        </c:when>
        <c:otherwise>
          <c:forEach var="u" items="${stats.recentUsers}">
            <div class="board-list-row">
              <span class="chip chip-default">${u.role}</span>
              <div class="flex-grow-1">
                <div class="fw-bold" style="font-size:14px;">${u.nickname}
                  <span style="color:var(--muted);font-weight:400;">(${u.username})</span></div>
                <div style="font-size:12px;color:var(--muted);">${u.email}</div>
              </div>
            </div>
          </c:forEach>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</main>

<jsp:include page="../common/footer.jsp" />

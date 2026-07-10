<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>픽션허브 - 웹소설 플랫폼</title>
  <!-- Bootstrap 5 -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
  <!-- Bootstrap Icons -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet" />
  <!-- Google Fonts -->
  <link href="https://fonts.googleapis.com/css2?family=Gowun+Batang:wght@400;700&family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
  <!-- CSS 스타일 시트 -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css" />
</head>
<body>

<header class="site-header" style="position:relative;">
  <!-- 사내 인트라넷/포털 브랜드 배지: 헤더 맨 왼쪽 끝에 고정 -->
  <a class="fw-bold text-uppercase text-decoration-none d-inline-flex align-items-center justify-content-center"
     href="http://192.168.0.35:8080/portalMain/" 
     style="position:absolute; left:clamp(12px, 5vw, 80px); top:50%; transform:translateY(-50%); background:#1c1e26; border-radius:8px 8px 8px 8px; padding:clamp(4px, 1vw, 6px) clamp(8px, 2vw, 14px); letter-spacing:1.5px; font-size:clamp(0.7rem, 1.8vw, 1rem); line-height:1; white-space:nowrap;">
    <span style="color:#ffffff;">InFo</span>&nbsp;<span style="color:#82c419;">FiVe</span>
  </a>

  <div class="container-xl d-flex align-items-center justify-content-between py-3">
    <!-- 로고 클릭 시 home.jsp로 이동 -->
    <button class="d-flex align-items-center gap-2 bg-transparent border-0 p-0 cursor-pointer" onclick="location.href='${pageContext.request.contextPath}/home'">
      <div class="logo-icon">📖</div>
      <div>
        <div class="logo-title">픽션 허브</div>
        <div class="logo-sub">Fiction Hub (Novel Community)</div>
      </div>
    </button>

    <!-- PC 네비게이션 -->
    <nav class="d-none d-md-flex gap-4">
      <button class="nav-link-custom" onclick="location.href='${pageContext.request.contextPath}/home'">홈</button>
      <button class="nav-link-custom" onclick="location.href='${pageContext.request.contextPath}/review'">리뷰</button>
      <button class="nav-link-custom" onclick="location.href='${pageContext.request.contextPath}/find'">이 소설 찾아요</button>
      <button class="nav-link-custom" onclick="location.href='${pageContext.request.contextPath}/rookie'">신인작가</button>
      <button class="nav-link-custom" onclick="location.href='${pageContext.request.contextPath}/author'">작가정보</button>
    </nav>

    <c:choose>
      <c:when test="${not empty sessionScope.loginUser}">
        <div class="d-flex align-items-center gap-2">
          <span style="font-size:14px;">
            <a href="${pageContext.request.contextPath}/mypage" class="me-1" style="color:inherit;">
              <c:out value="${sessionScope.loginUser.nickname}" /><c:if test="${sessionScope.loginUser.isAuthor}"> ✒️</c:if>님</a>
            <c:if test="${sessionScope.loginUser.role == 'ADMIN' or sessionScope.loginUser.role == 'SUPER_ADMIN'}">
              <a href="${pageContext.request.contextPath}/admin" class="ms-1" style="font-size:12px;">관리자모드</a>
            </c:if>
          </span>
          <button class="btn-outline-custom" style="padding:6px 14px;font-size:13px;"
                  onclick="location.href='${pageContext.request.contextPath}/logout'">로그아웃</button>
        </div>
      </c:when>
      <c:otherwise>
        <button class="btn-login" onclick="location.href='${pageContext.request.contextPath}/login'">로그인 · 회원가입</button>
      </c:otherwise>
    </c:choose>
  </div>
  
  <!-- 모바일 네비게이션 -->
  <div class="d-flex d-md-none gap-2 px-3 pb-2 overflow-auto">
    <button class="filter-btn" onclick="location.href='${pageContext.request.contextPath}/home'">홈</button>
    <button class="filter-btn" onclick="location.href='${pageContext.request.contextPath}/review'">리뷰</button>
    <button class="filter-btn" onclick="location.href='${pageContext.request.contextPath}/find'">이 소설 찾아요</button>
    <button class="filter-btn" onclick="location.href='${pageContext.request.contextPath}/rookie'">신인작가</button>
    <button class="filter-btn" onclick="location.href='${pageContext.request.contextPath}/author'">작가정보</button>
  </div>
</header>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="common/header.jsp" />

<!-- 주소: mypage.jsp -->
<main class="container-xl py-4" style="max-width:640px;">
  <h1 class="mb-4" style="font-family:'Gowun Batang',serif;font-size:22px;font-weight:700;">마이페이지</h1>

  <c:if test="${param.applied != null}">
    <div class="alert alert-success">작가 인증 신청이 접수되었습니다. 관리자 심사 후 결과가 반영됩니다.</div>
  </c:if>
  <c:if test="${param.updated != null}">
    <div class="alert alert-success">내 정보가 수정되었습니다.</div>
  </c:if>

  <div class="board-card mb-4">
    <div class="d-flex justify-content-between align-items-start">
      <div style="flex:1;">
        <div class="mb-2"><span style="color:var(--muted);font-size:13px;">아이디</span><br />${loginUser.username}</div>
        <div class="mb-2"><span style="color:var(--muted);font-size:13px;">닉네임</span><br />${loginUser.nickname}<c:if test="${loginUser.isAuthor}"> ✒️</c:if></div>
        <div class="mb-2"><span style="color:var(--muted);font-size:13px;">이메일</span><br />${loginUser.email}</div>
        <div><span style="color:var(--muted);font-size:13px;">가입일</span><br />
          <fmt:formatDate value="${loginUser.createdAt}" pattern="yyyy-MM-dd" /></div>
      </div>
      <a href="${pageContext.request.contextPath}/mypage/edit" class="btn-outline-custom" style="white-space:nowrap;">내 정보 수정</a>
    </div>
  </div>

  <div class="board-card mb-4">
    <h2 style="font-size:16px;font-weight:700;margin-bottom:12px;">내 활동</h2>
    <div class="d-flex gap-2">
      <a href="${pageContext.request.contextPath}/mypage/posts" class="btn-outline-custom">내가 쓴 글</a>
      <a href="${pageContext.request.contextPath}/mypage/comments" class="btn-outline-custom">내가 쓴 댓글</a>
    </div>
  </div>

  <div class="board-card">
    <h2 style="font-size:16px;font-weight:700;margin-bottom:12px;">작가 인증</h2>

    <c:choose>
      <c:when test="${loginUser.isAuthor}">
        <p style="font-size:14px;">
          <span class="chip chip-default">인증 완료 ✒️</span>
          필명: <strong>${loginUser.penName}</strong>
        </p>
      </c:when>
      <c:when test="${not empty latestApplication and latestApplication.status == 'PENDING'}">
        <p style="font-size:14px;">
          <span class="chip chip-genre">심사중</span>
          "${latestApplication.workTitle}" (필명: ${latestApplication.penName}) 신청이 접수되어 있습니다.
        </p>
      </c:when>
      <c:when test="${not empty latestApplication and latestApplication.status == 'REJECTED'}">
        <p style="font-size:14px;" class="text-muted">
          지난 신청이 반려되었습니다.
          <c:if test="${not empty latestApplication.rejectReason}"> (사유: ${latestApplication.rejectReason})</c:if>
        </p>
        <a href="${pageContext.request.contextPath}/mypage/author-apply" class="btn-primary-custom d-inline-block">다시 신청하기</a>
      </c:when>
      <c:otherwise>
        <p style="font-size:14px;color:var(--muted);">아직 작가 인증을 받지 않은 계정입니다.</p>
        <a href="${pageContext.request.contextPath}/mypage/author-apply" class="btn-primary-custom d-inline-block">작가 인증 신청하기</a>
      </c:otherwise>
    </c:choose>
  </div>
</main>

<jsp:include page="common/footer.jsp" />

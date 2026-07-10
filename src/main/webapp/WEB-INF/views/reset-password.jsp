<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="common/header.jsp" />

<!-- 주소: reset-password.jsp -->
<main class="container-xl py-5" style="max-width:420px;">
  <h1 class="mb-4 text-center" style="font-family:'Gowun Batang',serif;font-size:24px;font-weight:700;">새 비밀번호 설정</h1>

  <c:choose>
    <c:when test="${empty token}">
      <div class="alert alert-danger">${not empty errorMessage ? errorMessage : '유효하지 않은 접근입니다.'}</div>
      <a href="${pageContext.request.contextPath}/find-password" class="btn-outline-custom w-100 d-block text-center">비밀번호 찾기 다시 시도</a>
    </c:when>
    <c:otherwise>
      <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger">${errorMessage}</div>
      </c:if>
      <form method="post" action="${pageContext.request.contextPath}/reset-password">
        <input type="hidden" name="token" value="${token}" />
        <div class="mb-3">
          <label class="form-label">새 비밀번호</label>
          <input type="password" name="newPassword" class="form-control" required minlength="8" autofocus />
        </div>
        <div class="mb-3">
          <label class="form-label">새 비밀번호 확인</label>
          <input type="password" name="newPasswordConfirm" class="form-control" required minlength="8" />
        </div>
        <button type="submit" class="btn-primary-custom w-100">비밀번호 변경</button>
      </form>
    </c:otherwise>
  </c:choose>
</main>

<jsp:include page="common/footer.jsp" />

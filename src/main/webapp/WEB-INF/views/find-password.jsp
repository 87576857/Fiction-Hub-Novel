<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="common/header.jsp" />

<!-- 주소: find-password.jsp -->
<main class="container-xl py-5" style="max-width:420px;">
  <h1 class="mb-3 text-center" style="font-family:'Gowun Batang',serif;font-size:24px;font-weight:700;">비밀번호 찾기</h1>

  <c:choose>
    <c:when test="${submitted}">
      <div class="alert alert-success">
        입력하신 정보와 일치하는 계정이 있다면, 해당 이메일로 비밀번호 재설정 링크를 보내드렸습니다.<br />
        (유효시간 30분) 메일함을 확인해주세요.
      </div>
      <a href="${pageContext.request.contextPath}/login" class="btn-outline-custom w-100 d-block text-center">로그인으로 돌아가기</a>
    </c:when>
    <c:otherwise>
      <p class="text-muted mb-4" style="font-size:14px;">가입 시 등록한 아이디와 이메일을 입력해주세요.</p>
      <form method="post" action="${pageContext.request.contextPath}/find-password">
        <div class="mb-3">
          <label class="form-label">아이디</label>
          <input type="text" name="username" class="form-control" required autofocus />
        </div>
        <div class="mb-3">
          <label class="form-label">이메일</label>
          <input type="email" name="email" class="form-control" required />
        </div>
        <button type="submit" class="btn-primary-custom w-100">재설정 링크 받기</button>
      </form>
    </c:otherwise>
  </c:choose>
</main>

<jsp:include page="common/footer.jsp" />

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="common/header.jsp" />

<!-- 주소: login.jsp -->
<main class="container-xl py-5" style="max-width:420px;">
  <h1 class="mb-4 text-center" style="font-family:'Gowun Batang',serif;font-size:24px;font-weight:700;">로그인</h1>

  <c:if test="${param.registered != null}">
    <div class="alert alert-success">회원가입이 완료되었습니다. 로그인해주세요.</div>
  </c:if>
  <c:if test="${param.reset != null}">
    <div class="alert alert-success">비밀번호가 변경되었습니다. 새 비밀번호로 로그인해주세요.</div>
  </c:if>
  <c:if test="${not empty errorMessage}">
    <div class="alert alert-danger">${errorMessage}</div>
  </c:if>

  <form method="post" action="${pageContext.request.contextPath}/login">
    <div class="mb-3">
      <label class="form-label">아이디</label>
      <input type="text" name="username" class="form-control" required autofocus />
    </div>
    <div class="mb-3">
      <label class="form-label">비밀번호</label>
      <input type="password" name="password" class="form-control" required />
    </div>
    <button type="submit" class="btn-primary-custom w-100 mb-3">로그인</button>
  </form>

  <div class="d-flex justify-content-between" style="font-size:14px;">
    <a href="${pageContext.request.contextPath}/find-password">비밀번호를 잊으셨나요?</a>
    <a href="${pageContext.request.contextPath}/register">회원가입</a>
  </div>
</main>

<jsp:include page="common/footer.jsp" />

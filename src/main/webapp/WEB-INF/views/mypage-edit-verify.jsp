<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="common/header.jsp" />

<!-- 주소: mypage-edit-verify.jsp -->
<main class="container-xl py-5" style="max-width:420px;">
  <h1 class="mb-2 text-center" style="font-family:'Gowun Batang',serif;font-size:22px;font-weight:700;">본인 확인</h1>
  <p class="text-center text-muted mb-4" style="font-size:13px;">내 정보를 수정하려면 비밀번호를 다시 입력해주세요.</p>

  <c:if test="${not empty errorMessage}">
    <div class="alert alert-danger">${errorMessage}</div>
  </c:if>

  <form method="post" action="${pageContext.request.contextPath}/mypage/edit">
    <div class="mb-3">
      <label class="form-label">비밀번호</label>
      <input type="password" name="password" class="form-control" required autofocus />
    </div>
    <button type="submit" class="btn-primary-custom w-100">확인</button>
  </form>
  <div class="text-center mt-3">
    <a href="${pageContext.request.contextPath}/mypage" style="font-size:13px;color:var(--muted);">마이페이지로 돌아가기</a>
  </div>
</main>

<jsp:include page="common/footer.jsp" />

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="common/header.jsp" />

<!-- 주소: mypage-edit-form.jsp -->
<main class="container-xl py-5" style="max-width:420px;">
  <h1 class="mb-4 text-center" style="font-family:'Gowun Batang',serif;font-size:22px;font-weight:700;">내 정보 수정</h1>

  <c:if test="${not empty errorMessage}">
    <div class="alert alert-danger">${errorMessage}</div>
  </c:if>

  <form method="post" action="${pageContext.request.contextPath}/mypage/edit-form">
    <div class="mb-3">
      <label class="form-label">아이디</label>
      <input type="text" class="form-control" value="${loginUser.username}" disabled />
      <div class="form-text" style="font-size:12px;">아이디는 변경할 수 없습니다.</div>
    </div>
    <div class="mb-3">
      <label class="form-label">닉네임</label>
      <input type="text" name="nickname" class="form-control" value="${loginUser.nickname}" required maxlength="50" />
    </div>
    <div class="mb-3">
      <label class="form-label">이메일</label>
      <input type="email" name="email" class="form-control" value="${loginUser.email}" required maxlength="100" />
    </div>
    <div class="mb-4">
      <label class="form-label">나이 <span class="text-muted" style="font-size:12px;">(선택)</span></label>
      <input type="number" name="age" class="form-control" min="1" max="120" value="${loginUser.age}" />
    </div>
    <button type="submit" class="btn-primary-custom w-100">저장</button>
  </form>
  <div class="text-center mt-3">
    <a href="${pageContext.request.contextPath}/mypage" style="font-size:13px;color:var(--muted);">취소하고 마이페이지로</a>
  </div>
</main>

<jsp:include page="common/footer.jsp" />

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="common/header.jsp" />

<!-- 주소: author-apply.jsp -->
<main class="container-xl py-4" style="max-width:520px;">
  <h1 class="mb-2" style="font-family:'Gowun Batang',serif;font-size:22px;font-weight:700;">작가 인증 신청</h1>
  <p class="text-muted mb-4" style="font-size:13px;">신청 내용은 관리자 검토 후 승인/반려됩니다.</p>

  <c:if test="${not empty errorMessage}">
    <div class="alert alert-danger">${errorMessage}</div>
  </c:if>

  <form method="post" action="${pageContext.request.contextPath}/mypage/author-apply">
    <div class="mb-3">
      <label class="form-label">작가 필명 <span class="text-danger">*</span></label>
      <input type="text" name="penName" class="form-control" value="${application.penName}" required maxlength="100" />
    </div>
    <div class="mb-3">
      <label class="form-label">대표 작품명 <span class="text-danger">*</span></label>
      <input type="text" name="workTitle" class="form-control" value="${application.workTitle}" required maxlength="255" />
    </div>
    <div class="mb-3">
      <label class="form-label">연재 플랫폼 <span class="text-muted" style="font-size:12px;">(선택)</span></label>
      <input type="text" name="platform" class="form-control" value="${application.platform}"
             placeholder="예: 카카오페이지" maxlength="50" />
    </div>
    <div class="mb-3">
      <label class="form-label">추가 설명 <span class="text-muted" style="font-size:12px;">(연재 링크, 경력 등 증빙)</span></label>
      <textarea name="description" class="form-control" rows="5">${application.description}</textarea>
    </div>
    <button type="submit" class="btn-primary-custom w-100">신청하기</button>
  </form>
</main>

<jsp:include page="common/footer.jsp" />

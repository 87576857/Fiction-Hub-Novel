<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../common/header.jsp" />

<!-- 주소: admin/novel-write.jsp -->
<main class="container-xl py-4">
  <div class="row g-4">
    <div class="col-md-3">
      <jsp:include page="common/sidebar.jsp"><jsp:param name="active" value="novels" /></jsp:include>
    </div>

    <div class="col-md-9" style="max-width:560px;">
      <h1 class="mb-4" style="font-family:'Gowun Batang',serif;font-size:22px;font-weight:700;">
        ${empty novel.novelId ? '소설 등록' : '소설 정보 수정'}
      </h1>

      <c:set var="formAction" value="${pageContext.request.contextPath}/admin/novels/write" />
      <c:if test="${not empty novel.novelId}">
        <c:set var="formAction" value="${pageContext.request.contextPath}/admin/novels/${novel.novelId}/edit" />
      </c:if>

      <form method="post" action="${formAction}">
        <div class="mb-3">
          <label class="form-label">제목 <span class="text-danger">*</span></label>
          <input type="text" name="title" class="form-control" value="${novel.title}" required maxlength="255" />
        </div>
        <div class="mb-3">
          <label class="form-label">원작 작가 <span class="text-danger">*</span></label>
          <input type="text" name="authorName" class="form-control" value="${novel.authorName}" required maxlength="100" />
        </div>
        <div class="mb-3">
          <label class="form-label">연재 플랫폼 <span class="text-danger">*</span></label>
          <select name="platform" class="form-select" required>
            <option value="카카오페이지" ${novel.platform == '카카오페이지' ? 'selected' : ''}>카카오페이지</option>
            <option value="네이버시리즈" ${novel.platform == '네이버시리즈' ? 'selected' : ''}>네이버시리즈</option>
            <option value="문피아" ${novel.platform == '문피아' ? 'selected' : ''}>문피아</option>
            <option value="노벨피아" ${novel.platform == '노벨피아' ? 'selected' : ''}>노벨피아</option>
            <option value="기타" ${novel.platform == '기타' ? 'selected' : ''}>기타</option>
          </select>
        </div>
        <div class="mb-3">
          <label class="form-label">표지 이미지 URL <span class="text-muted" style="font-size:12px;">(그리드/모달에 노출)</span></label>
          <input type="url" name="coverImageUrl" class="form-control" value="${novel.coverImageUrl}"
                 placeholder="https://..." maxlength="255" />
        </div>
        <div class="mb-3">
          <label class="form-label">줄거리 요약 <span class="text-muted" style="font-size:12px;">(모달 팝업에 노출)</span></label>
          <textarea name="summary" class="form-control" rows="5">${novel.summary}</textarea>
        </div>
        <div class="d-flex gap-2">
          <button type="submit" class="btn-primary-custom">${empty novel.novelId ? '등록하기' : '수정하기'}</button>
          <button type="button" class="btn-outline-custom" onclick="location.href='${pageContext.request.contextPath}/admin/novels'">취소</button>
        </div>
      </form>
    </div>
  </div>
</main>

<jsp:include page="../common/footer.jsp" />

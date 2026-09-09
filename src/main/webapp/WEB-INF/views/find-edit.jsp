<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="common/header.jsp" />

<!-- 주소: find-edit.jsp -->
<main class="container-xl py-4 px-3" style="display:block; max-width:720px;">
  <h1 class="mb-1" style="font-family:'Gowun Batang',serif;font-size:24px;font-weight:700;">이 소설 찾아요 - 글 수정</h1>
  <p class="mb-4" style="color:var(--muted);font-size:14px;">내용을 수정한 뒤 저장해주세요.</p>

  <form method="post" action="${pageContext.request.contextPath}/find/${post.postId}/edit">
    <div class="muted-panel">
      <div class="mb-3">
        <label class="form-label fw-semibold" style="font-size:14px;">제목</label>
        <input type="text" name="title" class="form-control" value="<c:out value='${post.title}'/>" required>
      </div>
      <div class="mb-3">
        <label class="form-label fw-semibold" style="font-size:14px;">짐작되는 플랫폼</label>
        <select name="tag" class="form-select" style="max-width:220px;">
          <option value="전체" ${post.platformTag == '전체' ? 'selected' : ''}>모름 / 기타</option>
          <option value="카카오페이지" ${post.platformTag == '카카오페이지' ? 'selected' : ''}>카카오페이지</option>
          <option value="네이버시리즈" ${post.platformTag == '네이버시리즈' ? 'selected' : ''}>네이버시리즈</option>
          <option value="문피아" ${post.platformTag == '문피아' ? 'selected' : ''}>문피아</option>
          <option value="노벨피아" ${post.platformTag == '노벨피아' ? 'selected' : ''}>노벨피아</option>
        </select>
      </div>
      <div class="mb-3">
        <label class="form-label fw-semibold" style="font-size:14px;">내용</label>
        <textarea name="content" class="form-control" rows="10" required><c:out value="${post.content}"/></textarea>
      </div>
      <div class="text-end d-flex justify-content-end gap-2">
        <button type="button" class="btn-outline-custom" onclick="location.href='${pageContext.request.contextPath}/find/${post.postId}'">취소</button>
        <button type="submit" class="btn-primary-custom">저장하기</button>
      </div>
    </div>
  </form>
</main>

<jsp:include page="common/footer.jsp" />

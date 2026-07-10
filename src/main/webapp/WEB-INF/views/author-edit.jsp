<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="common/header.jsp" />

<!-- 주소: author-edit.jsp -->
<main class="container-xl py-4 px-3" style="display:block; max-width:720px;">
  <h1 class="mb-1" style="font-family:'Gowun Batang',serif;font-size:24px;font-weight:700;">작가 정보관 - 글 수정</h1>
  <p class="mb-4" style="color:var(--muted);font-size:14px;">내용을 수정한 뒤 저장해주세요.</p>

  <form method="post" action="${pageContext.request.contextPath}/author/${post.postId}/edit">
    <div class="muted-panel">
      <div class="mb-3">
        <label class="form-label fw-semibold" style="font-size:14px;">제목</label>
        <input type="text" name="title" class="form-control" value="${post.title}" required>
      </div>
      <div class="mb-3">
        <label class="form-label fw-semibold" style="font-size:14px;">연차</label>
        <select name="tag" class="form-select" style="max-width:220px;">
          <option value="1년차" ${post.platformTag == '1년차' ? 'selected' : ''}>1년차</option>
          <option value="2년차" ${post.platformTag == '2년차' ? 'selected' : ''}>2년차</option>
          <option value="3년차" ${post.platformTag == '3년차' ? 'selected' : ''}>3년차</option>
          <option value="5년차" ${post.platformTag == '5년차' ? 'selected' : ''}>5년차</option>
          <option value="10년차 이상" ${post.platformTag == '10년차 이상' ? 'selected' : ''}>10년차 이상</option>
        </select>
      </div>
      <div class="mb-3">
        <label class="form-label fw-semibold" style="font-size:14px;">내용</label>
        <textarea name="content" class="form-control" rows="10" required>${post.content}</textarea>
      </div>
      <div class="text-end d-flex justify-content-end gap-2">
        <button type="button" class="btn-outline-custom" onclick="location.href='${pageContext.request.contextPath}/author/${post.postId}'">취소</button>
        <button type="submit" class="btn-primary-custom">저장하기</button>
      </div>
    </div>
  </form>
</main>

<jsp:include page="common/footer.jsp" />

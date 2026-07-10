<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="common/header.jsp" />

<!-- 주소: author-write.jsp -->
<main class="container-xl py-4 px-3" style="display:block; max-width:720px;">
  <h1 class="mb-1" style="font-family:'Gowun Batang',serif;font-size:24px;font-weight:700;">작가 정보관 - 글쓰기</h1>
  <p class="mb-4" style="color:var(--muted);font-size:14px;">연재 노하우, 업계 정보를 다른 작가님들과 나눠보세요.</p>

  <form method="post" action="${pageContext.request.contextPath}/author/write">
    <div class="muted-panel">
      <div class="mb-3">
        <label class="form-label fw-semibold" style="font-size:14px;">제목</label>
        <input type="text" name="title" class="form-control" placeholder="예: 편집자와 소통할 때 알아두면 좋은 것들" required>
      </div>
      <div class="mb-3">
        <label class="form-label fw-semibold" style="font-size:14px;">연차</label>
        <select name="tag" class="form-select" style="max-width:220px;">
          <option value="1년차">1년차</option>
          <option value="2년차">2년차</option>
          <option value="3년차">3년차</option>
          <option value="5년차">5년차</option>
          <option value="10년차 이상">10년차 이상</option>
        </select>
      </div>
      <div class="mb-3">
        <label class="form-label fw-semibold" style="font-size:14px;">내용</label>
        <textarea name="content" class="form-control" rows="10" placeholder="작가 활동, 정산, 슬럼프 극복 등 자유롭게 작성해주세요." required></textarea>
      </div>
      <div class="text-end d-flex justify-content-end gap-2">
        <button type="button" class="btn-outline-custom" onclick="location.href='${pageContext.request.contextPath}/author'">취소</button>
        <button type="submit" class="btn-primary-custom">등록하기</button>
      </div>
    </div>
  </form>
</main>

<jsp:include page="common/footer.jsp" />

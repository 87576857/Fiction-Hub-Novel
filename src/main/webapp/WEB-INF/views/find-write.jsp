<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="common/header.jsp" />

<!-- 주소: find-write.jsp -->
<main class="container-xl py-4 px-3" style="display:block; max-width:720px;">
  <h1 class="mb-1" style="font-family:'Gowun Batang',serif;font-size:24px;font-weight:700;">이 소설 찾아요 - 글쓰기</h1>
  <p class="mb-4" style="color:var(--muted);font-size:14px;">줄거리, 키워드, 기억나는 장면 등을 최대한 자세히 적어주시면 찾을 확률이 올라가요.</p>

  <form method="post" action="${pageContext.request.contextPath}/find/write">
    <div class="muted-panel">
      <div class="mb-3">
        <label class="form-label fw-semibold" style="font-size:14px;">제목</label>
        <input type="text" name="title" class="form-control" placeholder="예: 회귀한 주인공이 재벌집 막내로 태어나는 소설 찾아요" required>
      </div>
      <div class="mb-3">
        <label class="form-label fw-semibold" style="font-size:14px;">짐작되는 플랫폼</label>
        <select name="tag" class="form-select" style="max-width:220px;">
          <option value="전체">모름 / 기타</option>
          <option value="카카오페이지">카카오페이지</option>
          <option value="네이버시리즈">네이버시리즈</option>
          <option value="문피아">문피아</option>
          <option value="노벨피아">노벨피아</option>
        </select>
      </div>
      <div class="mb-3">
        <label class="form-label fw-semibold" style="font-size:14px;">내용</label>
        <textarea name="content" class="form-control" rows="10" placeholder="기억나는 줄거리, 키워드, 등장인물 등을 자유롭게 적어주세요." required></textarea>
      </div>
      <div class="text-end d-flex justify-content-end gap-2">
        <button type="button" class="btn-outline-custom" onclick="location.href='${pageContext.request.contextPath}/find'">취소</button>
        <button type="submit" class="btn-primary-custom">등록하기</button>
      </div>
    </div>
  </form>
</main>

<jsp:include page="common/footer.jsp" />

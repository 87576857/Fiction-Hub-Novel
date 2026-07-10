<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:include page="common/header.jsp" />

<!-- 주소: find-detail.jsp -->
<main class="container-xl py-4 px-3" style="display:block; max-width:760px;">
  <button class="btn-back" onclick="location.href='${pageContext.request.contextPath}/find'"><i class="bi bi-arrow-left"></i> 목록으로</button>

  <c:choose>
    <c:when test="${empty post}">
      <p class="py-5 text-center text-muted">해당 글을 찾을 수 없습니다.</p>
    </c:when>
    <c:otherwise>
      <c:if test="${not empty errorMessage}">
        <div class="board-card mb-3" style="border:1px solid #e57373;color:#c62828;">${errorMessage}</div>
      </c:if>
      <div class="board-card mb-3" style="background:var(--accent-find);">
        <span class="${post.isSolved ? 'badge-solved' : 'badge-unsolved'}">${post.isSolved ? '해결' : '미해결'}</span>
        <h1 class="mt-2 mb-1" style="font-family:'Gowun Batang',serif;font-size:22px;font-weight:700;">${post.title}</h1>
        <p class="mb-0" style="font-size:13px;color:var(--muted);">${post.nickname}<c:if test="${post.isAuthor}"> ✒️</c:if> &middot; <fmt:formatDate value="${post.createdAt}" pattern="yyyy.MM.dd"/> &middot; &#128065; ${post.viewCount}</p>
      </div>
      <p class="mb-3" style="font-size:14px;line-height:1.8;background:var(--muted-bg);border-radius:1rem;padding:16px 18px; white-space:pre-line;">${post.content}</p>

      <c:if test="${not empty sessionScope.loginUser and sessionScope.loginUser.userId == post.userId}">
        <div class="d-flex justify-content-end gap-2 mb-4">
          <button type="button" class="btn-outline-custom" onclick="location.href='${pageContext.request.contextPath}/find/${post.postId}/edit'">수정</button>
          <form method="post" action="${pageContext.request.contextPath}/find/${post.postId}/solve">
            <input type="hidden" name="solved" value="${post.isSolved ? 'false' : 'true'}">
            <button type="submit" class="btn-outline-custom">${post.isSolved ? '미해결로 변경' : '해결됨으로 표시'}</button>
          </form>
        </div>
      </c:if>

      <h2 style="font-family:'Gowun Batang',serif;font-size:19px;font-weight:700;" class="mb-3">댓글 (${fn:length(comments)})</h2>

      <c:choose>
        <c:when test="${empty comments}">
          <p class="text-muted" style="font-size:14px;">아직 댓글이 없습니다. 첫 댓글을 남겨보세요!</p>
        </c:when>
        <c:otherwise>
          <c:forEach var="cmt" items="${comments}">
            <div class="review-item">
              <div class="d-flex justify-content-between align-items-start mb-2">
                <div class="fw-bold" style="font-size:14px;">${cmt.nickname}<c:if test="${cmt.isAuthor}"> ✒️</c:if></div>
                <span style="font-size:12px;color:var(--muted);"><fmt:formatDate value="${cmt.createdAt}" pattern="yyyy.MM.dd"/></span>
              </div>
              <p class="mb-0" style="font-size:14px;line-height:1.7;">${cmt.content}</p>
            </div>
          </c:forEach>
        </c:otherwise>
      </c:choose>

      <form method="post" action="${pageContext.request.contextPath}/find/${post.postId}/comment" class="muted-panel mt-4">
        <h3 class="fw-bold mb-3" style="font-size:15px;">&#128172; 댓글 남기기</h3>
        <textarea name="content" class="form-control mb-3" rows="3" placeholder="댓글을 남겨주세요..." required></textarea>
        <div class="text-end">
          <button type="submit" class="btn-primary-custom">등록</button>
        </div>
      </form>
    </c:otherwise>
  </c:choose>
</main>

<jsp:include page="common/footer.jsp" />

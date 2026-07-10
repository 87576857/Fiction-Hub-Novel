<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="common/header.jsp" />

<!-- 주소: mypage-comments.jsp -->
<main class="container-xl py-4" style="max-width:800px;">
  <div class="d-flex justify-content-between align-items-center mb-4">
    <h1 style="font-family:'Gowun Batang',serif;font-size:22px;font-weight:700;">내가 쓴 댓글</h1>
    <a href="${pageContext.request.contextPath}/mypage" class="btn-outline-custom" style="padding:6px 14px;font-size:13px;">마이페이지로</a>
  </div>

  <div class="d-flex gap-2 mb-3">
    <a href="${pageContext.request.contextPath}/mypage/posts" class="btn-outline-custom" style="padding:6px 16px;font-size:13px;">게시글</a>
    <a href="${pageContext.request.contextPath}/mypage/comments" class="btn-primary-custom" style="padding:6px 16px;font-size:13px;">댓글</a>
  </div>

  <c:choose>
    <c:when test="${empty comments}">
      <div class="board-card text-center text-muted" style="font-size:14px;padding:40px 0;">아직 작성한 댓글이 없습니다.</div>
    </c:when>
    <c:otherwise>
      <div class="table-responsive">
        <table class="table align-middle">
          <thead>
            <tr><th>게시판</th><th>원글 제목</th><th>내 댓글</th><th>작성일</th><th></th></tr>
          </thead>
          <tbody>
            <c:forEach var="cm" items="${comments}">
              <tr style="cursor:pointer;" onclick="location.href='${pageContext.request.contextPath}/${cm.boardKey}/${cm.postId}'">
                <td><span class="chip chip-default">${cm.boardKey == 'review' ? '리뷰' : cm.boardKey}</span></td>
                <td>${cm.postTitle}</td>
                <td>${cm.content}</td>
                <td style="font-size:12px;color:var(--muted);"><fmt:formatDate value="${cm.createdAt}" pattern="yyyy-MM-dd" /></td>
                <td>
                  <form method="post" action="${pageContext.request.contextPath}/mypage/comments/delete"
                        onclick="event.stopPropagation();"
                        onsubmit="return confirm('이 ${cm.type == 'review' ? '리뷰' : '댓글'}을(를) 삭제하시겠습니까?');">
                    <input type="hidden" name="commentId" value="${cm.commentId}" />
                    <input type="hidden" name="type" value="${cm.type}" />
                    <input type="hidden" name="page" value="${currentPage}" />
                    <button type="submit" class="btn-outline-custom" style="padding:4px 10px;font-size:12px;">삭제</button>
                  </form>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>

      <c:if test="${totalPages > 1}">
        <div class="d-flex justify-content-center align-items-center gap-2 mt-3">
          <c:if test="${groupStart > 1}">
            <button type="button" class="btn-outline-custom" style="padding:5px 10px;font-size:12px;"
                    onclick="location.href='${pageContext.request.contextPath}/mypage/comments?page=${groupStart - 1}'">&laquo;</button>
          </c:if>
          <c:forEach var="p" begin="${groupStart}" end="${groupEnd}">
            <button type="button"
                    class="${p == currentPage ? 'btn-primary-custom' : 'btn-outline-custom'}"
                    style="padding:5px 12px;font-size:12px;min-width:32px;"
                    onclick="location.href='${pageContext.request.contextPath}/mypage/comments?page=${p}'">${p}</button>
          </c:forEach>
          <c:if test="${groupEnd < totalPages}">
            <button type="button" class="btn-outline-custom" style="padding:5px 10px;font-size:12px;"
                    onclick="location.href='${pageContext.request.contextPath}/mypage/comments?page=${groupEnd + 1}'">&raquo;</button>
          </c:if>
        </div>
      </c:if>
    </c:otherwise>
  </c:choose>
</main>

<jsp:include page="common/footer.jsp" />

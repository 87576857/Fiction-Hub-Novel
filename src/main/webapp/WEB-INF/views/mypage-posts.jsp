<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:include page="common/header.jsp" />

<!-- 주소: mypage-posts.jsp -->
<main class="container-xl py-4" style="max-width:800px;">
  <div class="d-flex justify-content-between align-items-center mb-4">
    <h1 style="font-family:'Gowun Batang',serif;font-size:22px;font-weight:700;">내가 쓴 글</h1>
    <a href="${pageContext.request.contextPath}/mypage" class="btn-outline-custom" style="padding:6px 14px;font-size:13px;">마이페이지로</a>
  </div>

  <div class="d-flex gap-2 mb-3">
    <a href="${pageContext.request.contextPath}/mypage/posts" class="btn-primary-custom" style="padding:6px 16px;font-size:13px;">게시글</a>
    <a href="${pageContext.request.contextPath}/mypage/comments" class="btn-outline-custom" style="padding:6px 16px;font-size:13px;">댓글</a>
  </div>

  <c:choose>
    <c:when test="${empty posts}">
      <div class="board-card text-center text-muted" style="font-size:14px;padding:40px 0;">아직 작성한 글이 없습니다.</div>
    </c:when>
    <c:otherwise>
      <div class="table-responsive">
        <table class="table align-middle" style="table-layout:fixed;width:100%;">
          <colgroup>
            <col style="width:120px;">
            <col>
            <col style="width:80px;">
            <col style="width:80px;">
            <col style="width:100px;">
          </colgroup>
          <thead>
            <tr><th>게시판</th><th>제목</th><th>댓글</th><th>조회수</th><th>작성일</th></tr>
          </thead>
          <tbody>
            <c:forEach var="p" items="${posts}">
              <tr style="cursor:pointer;" onclick="location.href='${pageContext.request.contextPath}/${p.boardKey}/${p.postId}'">
                <td><span class="chip chip-default"><c:out value="${p.boardKey}"/></span></td>
                <td style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;" title="${fn:escapeXml(p.title)}"><c:out value="${p.title}"/>
                  <c:if test="${p.boardKey == 'find' and p.isSolved}"> <span class="chip chip-genre">해결</span></c:if>
                </td>
                <td>${p.commentCount}</td>
                <td>${p.viewCount}</td>
                <td style="font-size:12px;color:var(--muted);white-space:nowrap;"><fmt:formatDate value="${p.createdAt}" pattern="yyyy-MM-dd" /></td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>

      <c:if test="${totalPages > 1}">
        <div class="d-flex justify-content-center align-items-center gap-2 mt-3">
          <c:if test="${groupStart > 1}">
            <button type="button" class="btn-outline-custom" style="padding:5px 10px;font-size:12px;"
                    onclick="location.href='${pageContext.request.contextPath}/mypage/posts?page=${groupStart - 1}'">&laquo;</button>
          </c:if>
          <c:forEach var="p" begin="${groupStart}" end="${groupEnd}">
            <button type="button"
                    class="${p == currentPage ? 'btn-primary-custom' : 'btn-outline-custom'}"
                    style="padding:5px 12px;font-size:12px;min-width:32px;"
                    onclick="location.href='${pageContext.request.contextPath}/mypage/posts?page=${p}'">${p}</button>
          </c:forEach>
          <c:if test="${groupEnd < totalPages}">
            <button type="button" class="btn-outline-custom" style="padding:5px 10px;font-size:12px;"
                    onclick="location.href='${pageContext.request.contextPath}/mypage/posts?page=${groupEnd + 1}'">&raquo;</button>
          </c:if>
        </div>
      </c:if>
    </c:otherwise>
  </c:choose>
</main>

<jsp:include page="common/footer.jsp" />

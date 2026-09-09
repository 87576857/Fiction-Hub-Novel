<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="common/header.jsp" />

<!-- 주소: rookie.jsp -->
<main class="container-xl py-4 px-3" style="display:block; max-width:820px;">
  <h1 class="mb-1" style="font-family:'Gowun Batang',serif;font-size:24px;font-weight:700;">신인작가 광장</h1>
  <p class="mb-4" style="color:var(--muted);font-size:14px;">써주신 습작에 다른 작가님들이 피드백을 남겨드려요.</p>

  <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap gap-2">
    <div>
      <a class="filter-btn ${selectedTag == '전체' ? 'active' : ''}" href="${pageContext.request.contextPath}/rookie?keyword=${keyword}">전체</a>
      <a class="filter-btn ${selectedTag == '판타지' ? 'active' : ''}" href="${pageContext.request.contextPath}/rookie?tag=판타지&keyword=${keyword}">판타지</a>
      <a class="filter-btn ${selectedTag == '로맨스판타지' ? 'active' : ''}" href="${pageContext.request.contextPath}/rookie?tag=로맨스판타지&keyword=${keyword}">로맨스판타지</a>
      <a class="filter-btn ${selectedTag == '현대판타지' ? 'active' : ''}" href="${pageContext.request.contextPath}/rookie?tag=현대판타지&keyword=${keyword}">현대판타지</a>
      <a class="filter-btn ${selectedTag == '팁공유' ? 'active' : ''}" href="${pageContext.request.contextPath}/rookie?tag=팁공유&keyword=${keyword}">팁공유</a>
    </div>
    <button class="btn-primary-custom" onclick="location.href='${pageContext.request.contextPath}/rookie/write'">글쓰기</button>
  </div>

  <form method="get" action="${pageContext.request.contextPath}/rookie" class="d-flex gap-2 mb-3">
    <input type="hidden" name="tag" value="${selectedTag == '전체' ? '' : selectedTag}" />
    <input type="text" name="keyword" value="${keyword}" placeholder="제목·내용·작성자 검색"
           class="form-control" style="max-width:280px;font-size:13px;" />
    <button type="submit" class="btn-outline-custom" style="padding:6px 16px;font-size:13px;">검색</button>
    <c:if test="${not empty keyword}">
      <button type="button" class="btn-outline-custom" style="padding:6px 16px;font-size:13px;"
              onclick="location.href='${pageContext.request.contextPath}/rookie?tag=${selectedTag == '전체' ? '' : selectedTag}'">초기화</button>
    </c:if>
  </form>

  <c:choose>
    <c:when test="${empty posts}">
      <p class="text-center text-muted py-5">
        <c:choose>
          <c:when test="${not empty keyword}">"${keyword}"에 대한 검색 결과가 없습니다.</c:when>
          <c:otherwise>아직 등록된 글이 없습니다. 첫 습작을 올려보세요!</c:otherwise>
        </c:choose>
      </p>
    </c:when>
    <c:otherwise>
      <c:forEach var="p" items="${posts}">
        <a class="board-list-row" href="${pageContext.request.contextPath}/rookie/${p.postId}">
          <span class="chip chip-genre"><c:out value="${p.platformTag}"/></span>
          <div class="flex-grow-1">
            <div class="fw-bold" style="font-size:15px;"><c:out value="${p.title}"/></div>
            <div style="font-size:12px;color:var(--muted);"><c:out value="${p.nickname}"/><c:if test="${p.isAuthor}"> ✒️</c:if> &middot; <fmt:formatDate value="${p.createdAt}" pattern="yyyy.MM.dd"/> &middot; &#128065; ${p.viewCount}</div>
          </div>
          <span class="comment-badge">&#128172; ${p.commentCount}</span>
        </a>
      </c:forEach>

      <c:if test="${totalPages > 1}">
        <div class="d-flex justify-content-center align-items-center gap-2 mt-3">
          <c:if test="${groupStart > 1}">
            <button type="button" class="btn-outline-custom" style="padding:5px 10px;font-size:12px;"
                    onclick="location.href='${pageContext.request.contextPath}/rookie?page=${groupStart - 1}&tag=${selectedTag == '전체' ? '' : selectedTag}&keyword=${keyword}'">&laquo;</button>
          </c:if>
          <c:forEach var="p" begin="${groupStart}" end="${groupEnd}">
            <button type="button"
                    class="${p == currentPage ? 'btn-primary-custom' : 'btn-outline-custom'}"
                    style="padding:5px 12px;font-size:12px;min-width:32px;"
                    onclick="location.href='${pageContext.request.contextPath}/rookie?page=${p}&tag=${selectedTag == '전체' ? '' : selectedTag}&keyword=${keyword}'">${p}</button>
          </c:forEach>
          <c:if test="${groupEnd < totalPages}">
            <button type="button" class="btn-outline-custom" style="padding:5px 10px;font-size:12px;"
                    onclick="location.href='${pageContext.request.contextPath}/rookie?page=${groupEnd + 1}&tag=${selectedTag == '전체' ? '' : selectedTag}&keyword=${keyword}'">&raquo;</button>
          </c:if>
        </div>
      </c:if>
    </c:otherwise>
  </c:choose>
</main>

<jsp:include page="common/footer.jsp" />

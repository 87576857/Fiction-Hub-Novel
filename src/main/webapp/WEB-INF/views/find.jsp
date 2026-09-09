<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="common/header.jsp" />

<!-- 주소: find.jsp -->
<main class="container-xl py-4 px-3" style="display:block; max-width:820px;">
  <h1 class="mb-1" style="font-family:'Gowun Batang',serif;font-size:24px;font-weight:700;">이 소설 찾아요</h1>
  <p class="mb-4" style="color:var(--muted);font-size:14px;">제목이 기억 안 나는 소설, 줄거리나 키워드만으로도 함께 찾아드려요.</p>

  <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap gap-2">
    <div>
      <a class="filter-btn ${selectedTag == '전체' ? 'active' : ''}" href="${pageContext.request.contextPath}/find?keyword=${keyword}">전체</a>
      <a class="filter-btn ${selectedTag == '카카오페이지' ? 'active' : ''}" href="${pageContext.request.contextPath}/find?tag=카카오페이지&keyword=${keyword}">카카오페이지</a>
      <a class="filter-btn ${selectedTag == '네이버시리즈' ? 'active' : ''}" href="${pageContext.request.contextPath}/find?tag=네이버시리즈&keyword=${keyword}">네이버시리즈</a>
      <a class="filter-btn ${selectedTag == '문피아' ? 'active' : ''}" href="${pageContext.request.contextPath}/find?tag=문피아&keyword=${keyword}">문피아</a>
      <a class="filter-btn ${selectedTag == '노벨피아' ? 'active' : ''}" href="${pageContext.request.contextPath}/find?tag=노벨피아&keyword=${keyword}">노벨피아</a>
    </div>
    <button class="btn-primary-custom" onclick="location.href='${pageContext.request.contextPath}/find/write'">글쓰기</button>
  </div>

  <form method="get" action="${pageContext.request.contextPath}/find" class="d-flex gap-2 mb-3">
    <input type="hidden" name="tag" value="${selectedTag == '전체' ? '' : selectedTag}" />
    <input type="text" name="keyword" value="${keyword}" placeholder="제목·내용·작성자 검색"
           class="form-control" style="max-width:280px;font-size:13px;" />
    <button type="submit" class="btn-outline-custom" style="padding:6px 16px;font-size:13px;">검색</button>
    <c:if test="${not empty keyword}">
      <button type="button" class="btn-outline-custom" style="padding:6px 16px;font-size:13px;"
              onclick="location.href='${pageContext.request.contextPath}/find?tag=${selectedTag == '전체' ? '' : selectedTag}'">초기화</button>
    </c:if>
  </form>

  <c:choose>
    <c:when test="${empty posts}">
      <p class="text-center text-muted py-5">
        <c:choose>
          <c:when test="${not empty keyword}">"${keyword}"에 대한 검색 결과가 없습니다.</c:when>
          <c:otherwise>아직 등록된 글이 없습니다. 첫 글을 남겨보세요!</c:otherwise>
        </c:choose>
      </p>
    </c:when>
    <c:otherwise>
      <c:forEach var="p" items="${posts}">
        <a class="board-list-row" href="${pageContext.request.contextPath}/find/${p.postId}">
          <span class="${p.isSolved ? 'badge-solved' : 'badge-unsolved'}">${p.isSolved ? '해결' : '미해결'}</span>
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
                    onclick="location.href='${pageContext.request.contextPath}/find?page=${groupStart - 1}&tag=${selectedTag == '전체' ? '' : selectedTag}&keyword=${keyword}'">&laquo;</button>
          </c:if>
          <c:forEach var="p" begin="${groupStart}" end="${groupEnd}">
            <button type="button"
                    class="${p == currentPage ? 'btn-primary-custom' : 'btn-outline-custom'}"
                    style="padding:5px 12px;font-size:12px;min-width:32px;"
                    onclick="location.href='${pageContext.request.contextPath}/find?page=${p}&tag=${selectedTag == '전체' ? '' : selectedTag}&keyword=${keyword}'">${p}</button>
          </c:forEach>
          <c:if test="${groupEnd < totalPages}">
            <button type="button" class="btn-outline-custom" style="padding:5px 10px;font-size:12px;"
                    onclick="location.href='${pageContext.request.contextPath}/find?page=${groupEnd + 1}&tag=${selectedTag == '전체' ? '' : selectedTag}&keyword=${keyword}'">&raquo;</button>
          </c:if>
        </div>
      </c:if>
    </c:otherwise>
  </c:choose>
</main>

<jsp:include page="common/footer.jsp" />

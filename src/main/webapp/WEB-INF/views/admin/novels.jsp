<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../common/header.jsp" />

<!-- 주소: admin/novels.jsp -->
<main class="container-xl py-4">
  <div class="row g-4">
    <div class="col-md-3">
      <jsp:include page="common/sidebar.jsp"><jsp:param name="active" value="novels" /></jsp:include>
    </div>

    <div class="col-md-9">
      <form method="get" action="${pageContext.request.contextPath}/admin/novels" class="d-flex gap-2 mb-3">
        <input type="text" name="keyword" value="${keyword}" placeholder="소설 이름 검색"
               class="form-control" style="max-width:280px;font-size:13px;" />
        <button type="submit" class="btn-outline-custom" style="padding:6px 16px;font-size:13px;">검색</button>
        <c:if test="${not empty keyword}">
          <button type="button" class="btn-outline-custom" style="padding:6px 16px;font-size:13px;"
                  onclick="location.href='${pageContext.request.contextPath}/admin/novels'">초기화</button>
        </c:if>
      </form>

      <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 style="font-family:'Gowun Batang',serif;font-size:22px;font-weight:700;">리뷰게시판 관리</h1>
        <button class="btn-primary-custom" style="padding:8px 18px;font-size:13px;"
                onclick="location.href='${pageContext.request.contextPath}/admin/novels/write'">+ 소설 등록</button>
      </div>

      <c:choose>
        <c:when test="${empty novels}">
          <p class="text-muted">
            <c:choose>
              <c:when test="${not empty keyword}">"${keyword}"에 대한 검색 결과가 없습니다.</c:when>
              <c:otherwise>등록된 소설이 없습니다. "소설 등록" 버튼으로 리뷰게시판에 첫 작품을 올려보세요.</c:otherwise>
            </c:choose>
          </p>
        </c:when>
        <c:otherwise>
          <c:forEach var="n" items="${novels}">
            <div class="board-card mb-3 d-flex gap-3">
              <c:if test="${not empty n.coverImageUrl}">
                <img src="${n.coverImageUrl}" alt="${n.title}" style="width:56px;height:80px;object-fit:cover;border-radius:6px;flex-shrink:0;" />
              </c:if>
              <div class="flex-grow-1" style="min-width:0;">
                <div class="d-flex justify-content-between align-items-start">
                  <div>
                    <div class="fw-bold" style="font-size:15px;">${n.title}
                      <span style="color:var(--muted);font-weight:400;font-size:13px;">(원작: ${n.authorName})</span></div>
                    <div style="font-size:13px;color:var(--muted);">${n.platform} · 조회 ${n.viewCount} · 등록자 ${n.managedByNickname}</div>
                  </div>
                  <span class="chip chip-default">${n.platform}</span>
                </div>
                <p style="font-size:13px;margin:8px 0;" class="text-truncate">${n.summary}</p>
                <div class="d-flex gap-2">
                  <button class="btn-outline-custom" style="padding:4px 12px;font-size:12px;"
                          onclick="location.href='${pageContext.request.contextPath}/admin/novels/${n.novelId}/edit'">수정</button>
                  <form method="post" action="${pageContext.request.contextPath}/admin/novels/${n.novelId}/delete"
                        onsubmit="return confirm('삭제하시겠습니까? 관련 리뷰도 함께 삭제됩니다.');" style="display:inline;">
                    <button type="submit" class="btn-outline-custom" style="padding:4px 12px;font-size:12px;">삭제</button>
                  </form>
                </div>
              </div>
            </div>
          </c:forEach>
        </c:otherwise>
      </c:choose>

      <c:if test="${novelTotalPages > 1}">
        <div class="d-flex justify-content-center align-items-center gap-2 mt-3">
          <c:if test="${novelGroupStart > 1}">
            <button type="button" class="btn-outline-custom" style="padding:5px 10px;font-size:12px;"
                    onclick="location.href='${pageContext.request.contextPath}/admin/novels?novelPage=${novelGroupStart - 1}&keyword=${keyword}'">&laquo;</button>
          </c:if>
          <c:forEach var="p" begin="${novelGroupStart}" end="${novelGroupEnd}">
            <button type="button"
                    class="${p == novelCurrentPage ? 'btn-primary-custom' : 'btn-outline-custom'}"
                    style="padding:5px 12px;font-size:12px;min-width:32px;"
                    onclick="location.href='${pageContext.request.contextPath}/admin/novels?novelPage=${p}&keyword=${keyword}'">${p}</button>
          </c:forEach>
          <c:if test="${novelGroupEnd < novelTotalPages}">
            <button type="button" class="btn-outline-custom" style="padding:5px 10px;font-size:12px;"
                    onclick="location.href='${pageContext.request.contextPath}/admin/novels?novelPage=${novelGroupEnd + 1}&keyword=${keyword}'">&raquo;</button>
          </c:if>
        </div>
      </c:if>
    </div>
  </div>
</main>

<jsp:include page="../common/footer.jsp" />

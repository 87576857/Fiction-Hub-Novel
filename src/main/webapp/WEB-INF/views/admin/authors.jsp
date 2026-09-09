<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../common/header.jsp" />

<!-- 주소: admin/authors.jsp -->
<main class="container-xl py-4">
  <div class="row g-4">
    <div class="col-md-3">
      <jsp:include page="common/sidebar.jsp"><jsp:param name="active" value="authors" /></jsp:include>
    </div>

    <div class="col-md-9">
      <h1 class="mb-4" style="font-family:'Gowun Batang',serif;font-size:22px;font-weight:700;">작가 인증 신청 관리</h1>

      <c:choose>
        <c:when test="${empty applications}">
          <p class="text-muted">대기 중인 작가 인증 신청이 없습니다.</p>
        </c:when>
        <c:otherwise>
          <c:forEach var="a" items="${applications}">
            <div class="board-card mb-3">
              <div class="d-flex justify-content-between align-items-start mb-2">
                <div>
                  <div class="fw-bold" style="font-size:15px;"><c:out value="${a.penName}"/>
                    <span style="color:var(--muted);font-weight:400;font-size:13px;">(신청자: <c:out value="${a.nickname}"/> / <c:out value="${a.username}"/>)</span></div>
                  <div style="font-size:13px;color:var(--muted);">대표작: <c:out value="${a.workTitle}"/><c:if test="${not empty a.platform}"> · <c:out value="${a.platform}"/></c:if></div>
                </div>
                <span class="chip chip-genre">PENDING</span>
              </div>
              <c:if test="${not empty a.description}">
                <p style="font-size:13px;"><c:out value="${a.description}"/></p>
              </c:if>

              <div class="d-flex gap-2">
                <form method="post" action="${pageContext.request.contextPath}/admin/authors/${a.applicationId}/approve">
                  <input type="hidden" name="authorPage" value="${authorCurrentPage}" />
                  <button type="submit" class="btn-primary-custom" style="padding:6px 16px;font-size:13px;">승인</button>
                </form>
                <button type="button" class="btn-outline-custom" style="padding:6px 16px;font-size:13px;"
                        onclick="document.getElementById('rejectForm${a.applicationId}').style.display='flex'">반려</button>
              </div>
              <form id="rejectForm${a.applicationId}" method="post"
                    action="${pageContext.request.contextPath}/admin/authors/${a.applicationId}/reject"
                    style="display:none;gap:6px;margin-top:8px;">
                <input type="hidden" name="authorPage" value="${authorCurrentPage}" />
                <input type="text" name="reason" placeholder="반려 사유" required class="form-control form-control-sm" />
                <button type="submit" class="btn-outline-custom" style="padding:4px 12px;font-size:12px;">반려 확정</button>
              </form>
            </div>
          </c:forEach>

          <c:if test="${authorTotalPages > 1}">
            <div class="d-flex justify-content-center align-items-center gap-2 mt-3">
              <c:if test="${authorGroupStart > 1}">
                <button type="button" class="btn-outline-custom" style="padding:5px 10px;font-size:12px;"
                        onclick="location.href='${pageContext.request.contextPath}/admin/authors?authorPage=${authorGroupStart - 1}'">&laquo;</button>
              </c:if>
              <c:forEach var="p" begin="${authorGroupStart}" end="${authorGroupEnd}">
                <button type="button"
                        class="${p == authorCurrentPage ? 'btn-primary-custom' : 'btn-outline-custom'}"
                        style="padding:5px 12px;font-size:12px;min-width:32px;"
                        onclick="location.href='${pageContext.request.contextPath}/admin/authors?authorPage=${p}'">${p}</button>
              </c:forEach>
              <c:if test="${authorGroupEnd < authorTotalPages}">
                <button type="button" class="btn-outline-custom" style="padding:5px 10px;font-size:12px;"
                        onclick="location.href='${pageContext.request.contextPath}/admin/authors?authorPage=${authorGroupEnd + 1}'">&raquo;</button>
              </c:if>
            </div>
          </c:if>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</main>

<jsp:include page="../common/footer.jsp" />

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:include page="common/header.jsp" />

<!-- 주소: review-detail.jsp -->
<main class="container-xl py-4 px-3" style="display:block; max-width:760px;">
  <button class="btn-back" onclick="location.href='${pageContext.request.contextPath}/review'"><i class="bi bi-arrow-left"></i> 목록으로</button>

  <c:choose>
    <c:when test="${empty novel}">
      <p class="py-5 text-center text-muted">해당 작품을 찾을 수 없습니다.</p>
    </c:when>
    <c:otherwise>
      <div class="board-card mb-4" style="display:grid;grid-template-columns:100px 1fr;gap:14px;align-items:start;">
        <div>
          <c:if test="${not empty novel.coverImageUrl}">
            <img src="<c:out value='${novel.coverImageUrl}'/>" alt="<c:out value='${novel.title}'/>"
                 style="width:100%;display:block;border-radius:8px;object-fit:cover;aspect-ratio:3/4;" />
          </c:if>
          <c:if test="${empty novel.coverImageUrl}">
            <div style="width:100%;aspect-ratio:3/4;border-radius:8px;background:var(--surface-muted, #eee);
                        display:flex;align-items:center;justify-content:center;color:var(--muted);font-size:12px;">표지 없음</div>
          </c:if>
        </div>
        <div style="min-width:0;">
          <h1 class="mb-1" style="font-family:'Gowun Batang',serif;font-size:22px;font-weight:700;"><c:out value="${novel.title}"/></h1>
          <p class="mb-1" style="font-size:13px;color:var(--muted);">원작: <c:out value="${novel.authorName}"/> &middot; <c:out value="${novel.platform}"/></p>
          <p class="mb-2" style="font-size:14px;">
            <c:choose>
              <c:when test="${not empty averageRating}">⭐ ${averageRating} <span style="color:var(--muted);font-size:12px;">(${reviewCount}개 리뷰)</span></c:when>
              <c:otherwise><span style="color:var(--muted);font-size:13px;">아직 등록된 리뷰가 없습니다.</span></c:otherwise>
            </c:choose>
          </p>
          <p style="font-size:14px;line-height:1.7;white-space:pre-line;"><c:out value="${novel.summary}"/></p>
        </div>
      </div>

      <h2 style="font-family:'Gowun Batang',serif;font-size:19px;font-weight:700;" class="mb-3">독자 리뷰 (${fn:length(reviews)})</h2>

      <c:choose>
        <c:when test="${empty reviews}">
          <p class="text-muted" style="font-size:14px;">아직 리뷰가 없습니다. 첫 리뷰를 남겨보세요!</p>
        </c:when>
        <c:otherwise>
          <c:forEach var="r" items="${reviews}">
            <div class="review-item mb-2">
              <div class="d-flex justify-content-between align-items-start mb-2">
                <div>
                  <span class="fw-bold" style="font-size:14px;"><c:out value="${r.nickname}"/><c:if test="${r.isAuthor}"> ✒️</c:if></span>
                  <span style="font-size:13px;color:#f5a623;"> ${'★'} ${r.rating}</span>
                </div>
                <span style="font-size:12px;color:var(--muted);"><fmt:formatDate value="${r.createdAt}" pattern="yyyy.MM.dd"/></span>
              </div>
              <p class="mb-2" style="font-size:14px;line-height:1.7;"><c:out value="${r.reviewText}"/></p>
              <c:choose>
                <c:when test="${not empty likedReviewIds and likedReviewIds.contains(r.reviewId)}">
                  <button type="button" class="btn-outline-custom" style="padding:2px 10px;font-size:12px;opacity:0.5;" disabled>👍 ${r.likes} (완료)</button>
                </c:when>
                <c:otherwise>
                  <form method="post" action="${pageContext.request.contextPath}/review/${novel.novelId}/reviews/${r.reviewId}/like" style="display:inline;">
                    <button type="submit" class="btn-outline-custom" style="padding:2px 10px;font-size:12px;">👍 ${r.likes}</button>
                  </form>
                </c:otherwise>
              </c:choose>
            </div>
          </c:forEach>
        </c:otherwise>
      </c:choose>

      <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger mt-3">${errorMessage}</div>
      </c:if>

      <c:if test="${empty loginUser}">
        <div class="muted-panel mt-4 text-center" style="font-size:14px;">
          <a href="${pageContext.request.contextPath}/login">로그인</a> 후 리뷰를 남길 수 있어요.
        </div>
      </c:if>

      <c:if test="${not empty loginUser and alreadyReviewed}">
        <div class="muted-panel mt-4 text-center" style="font-size:14px;color:var(--muted);">
          이미 이 작품에 리뷰를 남기셨습니다.
        </div>
      </c:if>

      <c:if test="${not empty loginUser and not alreadyReviewed}">
        <form method="post" action="${pageContext.request.contextPath}/review/${novel.novelId}/reviews" class="muted-panel mt-4">
          <h3 class="fw-bold mb-3" style="font-size:15px;">✍️ 리뷰 남기기</h3>
          <div class="mb-3">
            <label class="form-label" style="font-size:13px;">평점</label>
            <select name="rating" class="form-select" style="max-width:140px;" required>
              <option value="5">⭐⭐⭐⭐⭐ (5)</option>
              <option value="4">⭐⭐⭐⭐ (4)</option>
              <option value="3" selected>⭐⭐⭐ (3)</option>
              <option value="2">⭐⭐ (2)</option>
              <option value="1">⭐ (1)</option>
            </select>
          </div>
          <textarea name="reviewText" class="form-control mb-3" rows="3" placeholder="이 작품에 대한 생각을 남겨주세요..." required></textarea>
          <div class="text-end">
            <button type="submit" class="btn-primary-custom">등록</button>
          </div>
        </form>
      </c:if>
    </c:otherwise>
  </c:choose>
</main>

<jsp:include page="common/footer.jsp" />

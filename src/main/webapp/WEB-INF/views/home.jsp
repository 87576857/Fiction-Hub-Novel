<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="common/header.jsp" />

<!-- 주소: home.jsp -->
<main class="container-xl py-5 px-3">
  <div class="hero-section mb-4">
    <div class="hero-badge">&#128214; 픽션 허브</div>
    <h1 class="hero-title mb-2">웹소설 독자와 작가가 만나는 곳</h1>
    <p style="color:var(--muted);">궁금한 소설을 찾고, 습작을 나누고, 작가들의 이야기를 들어보세요.</p>

    <div class="mt-4">
      <div class="d-flex justify-content-between align-items-center mb-3">
        <h2 style="font-family:'Gowun Batang',serif;font-size:18px;font-weight:700;">리뷰게시판 인기 작품</h2>
        <a href="${pageContext.request.contextPath}/review" style="font-size:13px;color:var(--muted);">더보기 &gt;</a>
      </div>
      <c:choose>
        <c:when test="${empty topNovels}">
          <p class="text-muted" style="font-size:13px;">아직 등록된 소설이 없어요.</p>
        </c:when>
        <c:otherwise>
          <div class="row g-4">
            <c:forEach var="n" items="${topNovels}">
              <div class="col-6 col-md-3">
                <div class="novel-frame" style="cursor:pointer;" onclick="location.href='${pageContext.request.contextPath}/review/${n.novelId}'">
                  <c:if test="${not empty n.coverImageUrl}">
                    <img src="${n.coverImageUrl}" alt="${n.title}"
                         style="width:100%;aspect-ratio:3/4;object-fit:cover;border-radius:8px;" />
                  </c:if>
                  <c:if test="${empty n.coverImageUrl}">
                    <div style="width:100%;aspect-ratio:3/4;border-radius:8px;background:var(--surface-muted, #eee);
                                display:flex;align-items:center;justify-content:center;color:var(--muted);font-size:13px;">
                      표지 없음
                    </div>
                  </c:if>
                  <div class="mt-2" style="font-size:14px;font-weight:700;line-height:1.3;">${n.title}</div>
                  <div style="font-size:12px;color:var(--muted);">${n.platform} &#183; &#128065; ${n.viewCount}</div>
                </div>
              </div>
            </c:forEach>
          </div>
        </c:otherwise>
      </c:choose>
    </div>
  </div>

  <div class="row g-3 mb-5">
    <div class="col-md-4">
      <div class="intro-card" onclick="location.href='${pageContext.request.contextPath}/find'">
        <h2 style="font-family:'Gowun Batang',serif;font-size:18px;font-weight:700;">이 소설 찾아요</h2>
        <p style="font-size:13px;color:var(--muted);margin-bottom:12px;">제목이 기억 안 나는 소설, 함께 찾아드려요.</p>
        <c:choose>
          <c:when test="${not empty topPostsByBoard.find}">
            <div class="d-flex flex-column gap-2">
              <c:forEach var="p" items="${topPostsByBoard.find}">
                <a class="board-list-row" href="${pageContext.request.contextPath}/find/${p.postId}" onclick="event.stopPropagation();">
                  <span class="chip chip-genre">&#128293; 인기</span>
                  <div class="flex-grow-1 min-w-0">
                    <div class="fw-bold text-ellipsis" style="font-size:14px;">${p.title}</div>
                    <div style="font-size:12px;color:var(--muted);">${p.nickname}<c:if test="${p.isAuthor}"> ✒️</c:if></div>
                  </div>
                  <span class="comment-badge">&#128065; ${p.viewCount}</span>
                </a>
              </c:forEach>
            </div>
          </c:when>
          <c:otherwise>
            <p class="text-muted" style="font-size:12px;margin-bottom:0;">아직 등록된 글이 없어요.</p>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
    <div class="col-md-4">
      <div class="intro-card" onclick="location.href='${pageContext.request.contextPath}/rookie'">
        <h2 style="font-family:'Gowun Batang',serif;font-size:18px;font-weight:700;">신인작가 광장</h2>
        <p style="font-size:13px;color:var(--muted);margin-bottom:12px;">습작을 올리고 피드백을 받아보세요.</p>
        <c:choose>
          <c:when test="${not empty topPostsByBoard.rookie}">
            <div class="d-flex flex-column gap-2">
              <c:forEach var="p" items="${topPostsByBoard.rookie}">
                <a class="board-list-row" href="${pageContext.request.contextPath}/rookie/${p.postId}" onclick="event.stopPropagation();">
                  <span class="chip chip-genre">&#128293; 인기</span>
                  <div class="flex-grow-1 min-w-0">
                    <div class="fw-bold text-ellipsis" style="font-size:14px;">${p.title}</div>
                    <div style="font-size:12px;color:var(--muted);">${p.nickname}<c:if test="${p.isAuthor}"> ✒️</c:if></div>
                  </div>
                  <span class="comment-badge">&#128065; ${p.viewCount}</span>
                </a>
              </c:forEach>
            </div>
          </c:when>
          <c:otherwise>
            <p class="text-muted" style="font-size:12px;margin-bottom:0;">아직 등록된 글이 없어요.</p>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
    <div class="col-md-4">
      <div class="intro-card" onclick="location.href='${pageContext.request.contextPath}/author'">
        <h2 style="font-family:'Gowun Batang',serif;font-size:18px;font-weight:700;">작가 정보관</h2>
        <p style="font-size:13px;color:var(--muted);margin-bottom:12px;">연재 노하우와 작가들의 이야기.</p>
        <c:choose>
          <c:when test="${not empty topPostsByBoard.author}">
            <div class="d-flex flex-column gap-2">
              <c:forEach var="p" items="${topPostsByBoard.author}">
                <a class="board-list-row" href="${pageContext.request.contextPath}/author/${p.postId}" onclick="event.stopPropagation();">
                  <span class="chip chip-genre">&#128293; 인기</span>
                  <div class="flex-grow-1 min-w-0">
                    <div class="fw-bold text-ellipsis" style="font-size:14px;">${p.title}</div>
                    <div style="font-size:12px;color:var(--muted);">${p.nickname}<c:if test="${p.isAuthor}"> ✒️</c:if></div>
                  </div>
                  <span class="comment-badge">&#128065; ${p.viewCount}</span>
                </a>
              </c:forEach>
            </div>
          </c:when>
          <c:otherwise>
            <p class="text-muted" style="font-size:12px;margin-bottom:0;">아직 등록된 글이 없어요.</p>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
  </div>
</main>

<jsp:include page="common/footer.jsp" />

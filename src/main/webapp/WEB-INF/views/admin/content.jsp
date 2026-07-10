<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../common/header.jsp" />

<!-- 주소: admin/content.jsp -->
<main class="container-xl py-4">
  <div class="row g-4">
    <div class="col-md-3">
      <jsp:include page="common/sidebar.jsp"><jsp:param name="active" value="content" /></jsp:include>
    </div>

    <div class="col-md-9">
      <h1 class="mb-4" style="font-family:'Gowun Batang',serif;font-size:22px;font-weight:700;">콘텐츠 관리</h1>

      <h2 class="mb-2" style="font-size:16px;font-weight:700;">게시글</h2>

      <!-- 게시글 검색 -->
      <form method="get" action="${pageContext.request.contextPath}/admin/content" class="d-flex gap-2 mb-2">
        <input type="hidden" name="commentPage" value="${commentCurrentPage}" />
        <input type="hidden" name="commentKeyword" value="${commentKeyword}" />
        <input type="hidden" name="commentBoard" value="${commentBoard}" />
        <input type="hidden" name="postBoard" value="${postBoard}" />
        <input type="text" name="postKeyword" value="${postKeyword}" placeholder="제목·내용·작성자 검색"
               class="form-control" style="max-width:280px;font-size:13px;" />
        <button type="submit" class="btn-outline-custom" style="padding:6px 16px;font-size:13px;">검색</button>
        <c:if test="${not empty postKeyword}">
          <button type="button" class="btn-outline-custom" style="padding:6px 16px;font-size:13px;"
                  onclick="location.href='${pageContext.request.contextPath}/admin/content?commentPage=${commentCurrentPage}&commentKeyword=${commentKeyword}&commentBoard=${commentBoard}&postBoard=${postBoard}'">초기화</button>
        </c:if>
      </form>

      <!-- 게시판 필터 -->
      <div class="d-flex gap-2 mb-3">
        <button type="button" class="${empty postBoard ? 'btn-primary-custom' : 'btn-outline-custom'}" style="padding:5px 14px;font-size:12px;"
                onclick="location.href='${pageContext.request.contextPath}/admin/content?commentPage=${commentCurrentPage}&commentKeyword=${commentKeyword}&commentBoard=${commentBoard}&postKeyword=${postKeyword}'">전체</button>
        <button type="button" class="${postBoard == 'find' ? 'btn-primary-custom' : 'btn-outline-custom'}" style="padding:5px 14px;font-size:12px;"
                onclick="location.href='${pageContext.request.contextPath}/admin/content?commentPage=${commentCurrentPage}&commentKeyword=${commentKeyword}&commentBoard=${commentBoard}&postKeyword=${postKeyword}&postBoard=find'">이 소설 찾아요</button>
        <button type="button" class="${postBoard == 'rookie' ? 'btn-primary-custom' : 'btn-outline-custom'}" style="padding:5px 14px;font-size:12px;"
                onclick="location.href='${pageContext.request.contextPath}/admin/content?commentPage=${commentCurrentPage}&commentKeyword=${commentKeyword}&commentBoard=${commentBoard}&postKeyword=${postKeyword}&postBoard=rookie'">신인작가 광장</button>
        <button type="button" class="${postBoard == 'author' ? 'btn-primary-custom' : 'btn-outline-custom'}" style="padding:5px 14px;font-size:12px;"
                onclick="location.href='${pageContext.request.contextPath}/admin/content?commentPage=${commentCurrentPage}&commentKeyword=${commentKeyword}&commentBoard=${commentBoard}&postKeyword=${postKeyword}&postBoard=author'">작가 정보관</button>
      </div>

      <form method="post" action="${pageContext.request.contextPath}/admin/content/posts/delete">
        <input type="hidden" name="postPage" value="${postCurrentPage}" />
        <input type="hidden" name="commentPage" value="${commentCurrentPage}" />
        <input type="hidden" name="postKeyword" value="${postKeyword}" />
        <input type="hidden" name="postBoard" value="${postBoard}" />
        <input type="hidden" name="commentKeyword" value="${commentKeyword}" />
        <input type="hidden" name="commentBoard" value="${commentBoard}" />
        <c:choose>
          <c:when test="${empty posts}">
            <p class="text-muted">
              <c:choose>
                <c:when test="${not empty postKeyword or not empty postBoard}">검색 결과가 없습니다.</c:when>
                <c:otherwise>게시글이 없습니다.</c:otherwise>
              </c:choose>
            </p>
          </c:when>
          <c:otherwise>
            <div class="table-responsive mb-2">
              <table class="table align-middle">
                <thead>
                  <tr><th></th><th>게시판</th><th>제목</th><th>작성자</th><th>조회수</th><th>작성일</th></tr>
                </thead>
                <tbody>
                  <c:forEach var="p" items="${posts}">
                    <tr>
                      <td><input type="checkbox" name="postIds" value="${p.postId}" /></td>
                      <td><span class="chip chip-default">${p.boardKey == 'find' ? '이 소설 찾아요' : (p.boardKey == 'rookie' ? '신인작가 광장' : '작가 정보관')}</span></td>
                      <td>${p.title}</td>
                      <td>${p.nickname}</td>
                      <td>${p.viewCount}</td>
                      <td style="font-size:12px;color:var(--muted);"><fmt:formatDate value="${p.createdAt}" pattern="yyyy-MM-dd" /></td>
                    </tr>
                  </c:forEach>
                </tbody>
              </table>
            </div>
            <button type="submit" class="btn-outline-custom" onclick="return confirm('선택한 게시글을 삭제할까요?')">선택 삭제</button>
          </c:otherwise>
        </c:choose>
      </form>

      <c:if test="${postTotalPages > 1}">
        <div class="d-flex justify-content-center align-items-center gap-2 mt-3">
          <c:if test="${postGroupStart > 1}">
            <button type="button" class="btn-outline-custom" style="padding:5px 10px;font-size:12px;"
                    onclick="location.href='${pageContext.request.contextPath}/admin/content?postPage=${postGroupStart - 1}&commentPage=${commentCurrentPage}&postKeyword=${postKeyword}&postBoard=${postBoard}&commentKeyword=${commentKeyword}&commentBoard=${commentBoard}'">&laquo;</button>
          </c:if>
          <c:forEach var="p" begin="${postGroupStart}" end="${postGroupEnd}">
            <button type="button"
                    class="${p == postCurrentPage ? 'btn-primary-custom' : 'btn-outline-custom'}"
                    style="padding:5px 12px;font-size:12px;min-width:32px;"
                    onclick="location.href='${pageContext.request.contextPath}/admin/content?postPage=${p}&commentPage=${commentCurrentPage}&postKeyword=${postKeyword}&postBoard=${postBoard}&commentKeyword=${commentKeyword}&commentBoard=${commentBoard}'">${p}</button>
          </c:forEach>
          <c:if test="${postGroupEnd < postTotalPages}">
            <button type="button" class="btn-outline-custom" style="padding:5px 10px;font-size:12px;"
                    onclick="location.href='${pageContext.request.contextPath}/admin/content?postPage=${postGroupEnd + 1}&commentPage=${commentCurrentPage}&postKeyword=${postKeyword}&postBoard=${postBoard}&commentKeyword=${commentKeyword}&commentBoard=${commentBoard}'">&raquo;</button>
          </c:if>
        </div>
      </c:if>

      <h2 class="mt-5 mb-2" style="font-size:16px;font-weight:700;">댓글</h2>

      <!-- 댓글 검색 -->
      <form method="get" action="${pageContext.request.contextPath}/admin/content" class="d-flex gap-2 mb-2">
        <input type="hidden" name="postPage" value="${postCurrentPage}" />
        <input type="hidden" name="postKeyword" value="${postKeyword}" />
        <input type="hidden" name="postBoard" value="${postBoard}" />
        <input type="hidden" name="commentBoard" value="${commentBoard}" />
        <input type="text" name="commentKeyword" value="${commentKeyword}" placeholder="내용·작성자 검색"
               class="form-control" style="max-width:280px;font-size:13px;" />
        <button type="submit" class="btn-outline-custom" style="padding:6px 16px;font-size:13px;">검색</button>
        <c:if test="${not empty commentKeyword}">
          <button type="button" class="btn-outline-custom" style="padding:6px 16px;font-size:13px;"
                  onclick="location.href='${pageContext.request.contextPath}/admin/content?postPage=${postCurrentPage}&postKeyword=${postKeyword}&postBoard=${postBoard}&commentBoard=${commentBoard}'">초기화</button>
        </c:if>
      </form>

      <!-- 게시판 필터 (리뷰게시판 포함) -->
      <div class="d-flex gap-2 mb-3">
        <button type="button" class="${empty commentBoard ? 'btn-primary-custom' : 'btn-outline-custom'}" style="padding:5px 14px;font-size:12px;"
                onclick="location.href='${pageContext.request.contextPath}/admin/content?postPage=${postCurrentPage}&postKeyword=${postKeyword}&postBoard=${postBoard}&commentKeyword=${commentKeyword}'">전체</button>
        <button type="button" class="${commentBoard == 'review' ? 'btn-primary-custom' : 'btn-outline-custom'}" style="padding:5px 14px;font-size:12px;"
                onclick="location.href='${pageContext.request.contextPath}/admin/content?postPage=${postCurrentPage}&postKeyword=${postKeyword}&postBoard=${postBoard}&commentKeyword=${commentKeyword}&commentBoard=review'">리뷰</button>
        <button type="button" class="${commentBoard == 'find' ? 'btn-primary-custom' : 'btn-outline-custom'}" style="padding:5px 14px;font-size:12px;"
                onclick="location.href='${pageContext.request.contextPath}/admin/content?postPage=${postCurrentPage}&postKeyword=${postKeyword}&postBoard=${postBoard}&commentKeyword=${commentKeyword}&commentBoard=find'">이 소설 찾아요</button>
        <button type="button" class="${commentBoard == 'rookie' ? 'btn-primary-custom' : 'btn-outline-custom'}" style="padding:5px 14px;font-size:12px;"
                onclick="location.href='${pageContext.request.contextPath}/admin/content?postPage=${postCurrentPage}&postKeyword=${postKeyword}&postBoard=${postBoard}&commentKeyword=${commentKeyword}&commentBoard=rookie'">신인작가 광장</button>
        <button type="button" class="${commentBoard == 'author' ? 'btn-primary-custom' : 'btn-outline-custom'}" style="padding:5px 14px;font-size:12px;"
                onclick="location.href='${pageContext.request.contextPath}/admin/content?postPage=${postCurrentPage}&postKeyword=${postKeyword}&postBoard=${postBoard}&commentKeyword=${commentKeyword}&commentBoard=author'">작가 정보관</button>
      </div>

      <form method="post" action="${pageContext.request.contextPath}/admin/content/comments/delete">
        <input type="hidden" name="postPage" value="${postCurrentPage}" />
        <input type="hidden" name="commentPage" value="${commentCurrentPage}" />
        <input type="hidden" name="postKeyword" value="${postKeyword}" />
        <input type="hidden" name="postBoard" value="${postBoard}" />
        <input type="hidden" name="commentKeyword" value="${commentKeyword}" />
        <input type="hidden" name="commentBoard" value="${commentBoard}" />
        <c:choose>
          <c:when test="${empty comments}">
            <p class="text-muted">
              <c:choose>
                <c:when test="${not empty commentKeyword or not empty commentBoard}">검색 결과가 없습니다.</c:when>
                <c:otherwise>댓글이 없습니다.</c:otherwise>
              </c:choose>
            </p>
          </c:when>
          <c:otherwise>
            <div class="table-responsive mb-2">
              <table class="table align-middle">
                <thead>
                  <tr><th></th><th>구분</th><th>내용</th><th>작성자</th><th>작성일</th></tr>
                </thead>
                <tbody>
                  <c:forEach var="cm" items="${comments}">
                    <tr>
                      <td><input type="checkbox" name="commentKeys" value="${cm.type}:${cm.commentId}" /></td>
                      <td><span class="chip chip-default">${cm.type == 'review' ? '리뷰' : (cm.boardKey == 'find' ? '이 소설 찾아요' : (cm.boardKey == 'rookie' ? '신인작가 광장' : '작가 정보관'))}</span></td>
                      <td>${cm.content}</td>
                      <td>${cm.nickname}</td>
                      <td style="font-size:12px;color:var(--muted);"><fmt:formatDate value="${cm.createdAt}" pattern="yyyy-MM-dd" /></td>
                    </tr>
                  </c:forEach>
                </tbody>
              </table>
            </div>
            <button type="submit" class="btn-outline-custom" onclick="return confirm('선택한 댓글을 삭제할까요?')">선택 삭제</button>
          </c:otherwise>
        </c:choose>
      </form>

      <c:if test="${commentTotalPages > 1}">
        <div class="d-flex justify-content-center align-items-center gap-2 mt-3">
          <c:if test="${commentGroupStart > 1}">
            <button type="button" class="btn-outline-custom" style="padding:5px 10px;font-size:12px;"
                    onclick="location.href='${pageContext.request.contextPath}/admin/content?postPage=${postCurrentPage}&commentPage=${commentGroupStart - 1}&postKeyword=${postKeyword}&postBoard=${postBoard}&commentKeyword=${commentKeyword}&commentBoard=${commentBoard}'">&laquo;</button>
          </c:if>
          <c:forEach var="p" begin="${commentGroupStart}" end="${commentGroupEnd}">
            <button type="button"
                    class="${p == commentCurrentPage ? 'btn-primary-custom' : 'btn-outline-custom'}"
                    style="padding:5px 12px;font-size:12px;min-width:32px;"
                    onclick="location.href='${pageContext.request.contextPath}/admin/content?postPage=${postCurrentPage}&commentPage=${p}&postKeyword=${postKeyword}&postBoard=${postBoard}&commentKeyword=${commentKeyword}&commentBoard=${commentBoard}'">${p}</button>
          </c:forEach>
          <c:if test="${commentGroupEnd < commentTotalPages}">
            <button type="button" class="btn-outline-custom" style="padding:5px 10px;font-size:12px;"
                    onclick="location.href='${pageContext.request.contextPath}/admin/content?postPage=${postCurrentPage}&commentPage=${commentGroupEnd + 1}&postKeyword=${postKeyword}&postBoard=${postBoard}&commentKeyword=${commentKeyword}&commentBoard=${commentBoard}'">&raquo;</button>
          </c:if>
        </div>
      </c:if>
    </div>
  </div>
</main>

<jsp:include page="../common/footer.jsp" />

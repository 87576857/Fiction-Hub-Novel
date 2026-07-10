<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<footer class="site-footer">
  <div class="container-xl py-4">
    <div class="footer-top">
      <!-- 사이트 정보 -->
      <div class="footer-brand">
        <div class="d-flex align-items-center gap-2 mb-2">
          <div class="logo-icon">📖</div>
          <div>
            <div class="logo-title">픽션 허브</div>
            <div class="logo-sub">Fiction Hub (Novel Community)</div>
          </div>
        </div>
        <p class="footer-desc">웹소설 정보 큐레이션 &amp; 독자 커뮤니티</p>
      </div>

      <!-- 바로가기 -->
      <div class="footer-links">
        <div class="footer-col-title">바로가기</div>
        <nav class="d-flex flex-column">
          <a href="${pageContext.request.contextPath}/home">홈</a>
          <a href="${pageContext.request.contextPath}/review">리뷰</a>
          <a href="${pageContext.request.contextPath}/find">이 소설 찾아요</a>
          <a href="${pageContext.request.contextPath}/rookie">신인작가</a>
          <a href="${pageContext.request.contextPath}/author">작가정보</a>
        </nav>
      </div>

      <!-- 약관/정책 -->
      <div class="footer-links">
        <div class="footer-col-title">정책</div>
        <nav class="d-flex flex-column">
          <a href="${pageContext.request.contextPath}/terms">이용약관</a>
          <a href="${pageContext.request.contextPath}/privacy">개인정보처리방침</a>
        </nav>
      </div>
    </div>

    <!-- 저작권 표시 -->
    <div class="footer-bottom">
      <span>&copy; <%= java.time.Year.now() %> 픽션 허브. All rights reserved.</span>
    </div>
  </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

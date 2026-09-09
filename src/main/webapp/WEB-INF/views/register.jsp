<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="common/header.jsp" />

<!-- 주소: register.jsp -->
<main class="container-xl py-5" style="max-width:420px;">
  <h1 class="mb-4 text-center" style="font-family:'Gowun Batang',serif;font-size:24px;font-weight:700;">회원가입</h1>

  <c:if test="${not empty errorMessage}">
    <div class="alert alert-danger">${errorMessage}</div>
  </c:if>

  <form method="post" action="${pageContext.request.contextPath}/register">
    <div class="mb-3">
      <label class="form-label">아이디</label>
      <input type="text" name="username" class="form-control ${errorField == 'username' ? 'is-invalid' : ''}"
             value="<c:out value='${user.username}'/>" required minlength="4" maxlength="50" pattern="[a-zA-Z0-9]+"
             title="영문/숫자 4자 이상" />
    </div>
    <div class="mb-3">
      <label class="form-label">비밀번호</label>
      <input type="password" name="password" class="form-control ${errorField == 'password' ? 'is-invalid' : ''}" required minlength="8"
             title="8자 이상 입력해주세요" />
    </div>
    <div class="mb-3">
      <label class="form-label">비밀번호 확인</label>
      <input type="password" id="passwordConfirm" class="form-control" required minlength="8" />
      <div id="pwMismatch" class="text-danger" style="font-size:12px;display:none;margin-top:4px;">비밀번호가 일치하지 않습니다.</div>
    </div>
    <div class="mb-3">
      <label class="form-label">닉네임</label>
      <input type="text" name="nickname" class="form-control ${errorField == 'nickname' ? 'is-invalid' : ''}" value="<c:out value='${user.nickname}'/>" required maxlength="50" />
    </div>
    <div class="mb-3">
      <label class="form-label">이메일</label>
      <input type="email" name="email" class="form-control ${errorField == 'email' ? 'is-invalid' : ''}"
             value="<c:out value='${user.email}'/>" required maxlength="100" />
    </div>
    <div class="mb-3">
      <label class="form-label">나이 <span class="text-muted" style="font-size:12px;">(선택)</span></label>
      <input type="number" name="age" class="form-control ${errorField == 'age' ? 'is-invalid' : ''}" min="1" max="120" value="${user.age}" />
    </div>
    <div class="form-check mb-3">
      <input type="checkbox" class="form-check-input" id="agree" required />
      <label class="form-check-label" for="agree" style="font-size:13px;">이용약관 및 개인정보처리방침에 동의합니다.</label>
    </div>
    <button type="submit" id="submitBtn" class="btn-primary-custom w-100">가입하기</button>
  </form>
</main>

<script>
  // 비밀번호/확인 일치 여부는 UX 편의를 위한 프론트 체크일 뿐, 서버는 password만 받아 저장한다
  const form = document.querySelector('form');
  const pw = document.querySelector('input[name="password"]');
  const pwConfirm = document.getElementById('passwordConfirm');
  const mismatch = document.getElementById('pwMismatch');
  form.addEventListener('submit', function (e) {
    if (pw.value !== pwConfirm.value) {
      e.preventDefault();
      mismatch.style.display = 'block';
    }
  });
</script>

<jsp:include page="common/footer.jsp" />

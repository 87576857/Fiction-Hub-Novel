<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="muted-panel mb-3">
  <div class="fw-bold mb-3" style="font-family:'Gowun Batang',serif;font-size:16px;">🛡️ 관리자 모드</div>
  <div class="d-flex flex-column gap-2">
    <button class="filter-btn ${param.active == 'dashboard' ? 'active' : ''}" style="width:100%;text-align:left;"
            onclick="location.href='${pageContext.request.contextPath}/admin'">대시보드</button>
    <button class="filter-btn ${param.active == 'users' ? 'active' : ''}" style="width:100%;text-align:left;"
            onclick="location.href='${pageContext.request.contextPath}/admin/users'">회원 관리</button>
    <button class="filter-btn ${param.active == 'authors' ? 'active' : ''}" style="width:100%;text-align:left;"
            onclick="location.href='${pageContext.request.contextPath}/admin/authors'">작가 인증 관리</button>
    <button class="filter-btn ${param.active == 'content' ? 'active' : ''}" style="width:100%;text-align:left;"
            onclick="location.href='${pageContext.request.contextPath}/admin/content'">콘텐츠 관리</button>
    <button class="filter-btn ${param.active == 'novels' ? 'active' : ''}" style="width:100%;text-align:left;"
            onclick="location.href='${pageContext.request.contextPath}/admin/novels'">리뷰게시판 관리</button>
  </div>
</div>

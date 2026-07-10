<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="common/header.jsp" />

<head>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/editor-style.css">
    
    <script src="https://cdn.ckeditor.com/ckeditor5/41.0.0/classic/ckeditor.js"></script>
</head>

<main class="container-xl py-4 px-3" style="display:block; max-width:720px;">
    <h1 class="mb-1" style="font-family:'Gowun Batang',serif;font-size:24px;font-weight:700;">신인작가 광장 - 습작 올리기</h1>
    <p class="mb-4" style="color:var(--muted);font-size:14px;">써주신 습작에 다른 작가님들이 피드백을 남겨드려요.</p>

    <form method="post" action="${pageContext.request.contextPath}/rookie/write">
        <div class="muted-panel">
            <div class="mb-3">
                <label class="form-label fw-semibold" style="font-size:14px;">제목</label>
                <input type="text" name="title" class="form-control" placeholder="예: 처음 쓴 단편 올려봅니다" required>
            </div>
            
            <div class="mb-3">
                <label class="form-label fw-semibold" style="font-size:14px;">장르 태그</label>
                <select name="tag" class="form-select" style="max-width:220px;">
                    <option value="판타지">판타지</option>
                    <option value="로맨스판타지">로맨스판타지</option>
                    <option value="현대판타지">현대판타지</option>
                    <option value="팁공유">팁공유</option>
                </select>
            </div>

            <div class="mb-3">
                <label class="form-label fw-semibold" style="font-size:14px;">내용</label>
                <textarea name="content" id="editor" class="form-control" rows="10"></textarea>
            </div>
        
            <div class="text-end d-flex justify-content-end gap-2">
                <button type="button" class="btn-outline-custom" onclick="location.href='${pageContext.request.contextPath}/rookie'">취소</button>
                <button type="submit" class="btn-primary-custom">등록하기</button>
            </div>
        </div>
    </form>
</main>

<script>
    // 페이지 로드 완료 후 에디터 초기화
    ClassicEditor
        .create(document.querySelector('#editor'), {
            toolbar: [ 'heading', '|', 'bold', 'italic', 'link', 'bulletedList', 'numberedList', 'blockQuote', '|', 'undo', 'redo' ]
        })
        .catch(error => { console.error(error); });
</script>

<jsp:include page="common/footer.jsp" />
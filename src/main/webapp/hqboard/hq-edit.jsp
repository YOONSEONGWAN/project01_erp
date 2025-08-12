<%@page import="java.util.List"%>
<%@page import="dto.HqBoardFileDto"%>
<%@page import="dao.HqBoardDao"%>
<%@page import="dto.HqBoardDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%


    // 수정 할 글의 정보를 얻어와서 
    int num = Integer.parseInt(request.getParameter("num"));
    HqBoardDto dto = HqBoardDao.getInstance().getByNum(num);
    List<HqBoardFileDto> fileList = dto.getFileList(); // 첨부파일 목록
    
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/hqboard/hq-edit.jsp</title>
<jsp:include page="/WEB-INF/include/resource.jsp"></jsp:include>
<!-- Toast UI Editor CSS/JS 필요시 include 추가 -->
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
<script src="https://uicdn.toast.com/editor/latest/i18n/ko-kr.js"></script>

<style>
/* HQ 공통 폰트/굵기 */
body, .container, .form-label, .form-control, .drop-zone, .preview, .btn {
    font-family: 'Segoe UI', '맑은 고딕', 'Malgun Gothic', Arial, sans-serif;
    font-weight: 500;
    color: #222;
    letter-spacing: 0.01em;
}
.form-control, .form-label {
    font-size: 1.05rem;
}

/* 제목(h1/h3) HQ 스타일 */
.h3.mb-4, h1.h3 {
    font-size: 2rem;
    font-weight: 600;
    color: #000000 !important;
    margin-bottom: 1.5rem !important;
}

/* HQ색 버튼 (수정) */
.btn-hq, .btn-hq:focus {
    background-color: #003366;
    border-color: #003366;
    color: #fff; !important;
    font-weight: 500;
}
.btn-hq:hover {
    background-color: #002855;
    border-color: #002855;
    color: #fff;
}

/* 소프트 레드(취소) */
.btn-soft-danger, .btn-soft-danger:focus {
    background-color: #ffe5e5;
    border-color: #ffa3a3;
    color: #e05252;
    font-weight: 500;
}
.btn-soft-danger:hover {
    background-color: #ffb3b3;
    border-color: #e05252;
    color: #a51212;
}

/* 드롭존 HQ 테두리 */
.drop-zone {
    border: 2.5px dashed #003366;
    cursor: pointer;
    border-radius: 12px;
    background-color: #f8f9fa;
    display: flex;
    align-items: center;
    justify-content: center;
    height: 200px;
    color: #003366;
    font-size: 1.04rem;
    font-weight: 500;
    margin-bottom: 0.7rem;
    box-shadow: 0 2px 12px 0 #00336615;
    transition: background 0.2s, border-color 0.16s;
}
.drop-zone.dragover {
    background-color: #eaf3fb;
    border-color: #003366;
}

/* 파일 썸네일 HQ 테두리 */
.preview img {
    max-width: 120px;
    margin: 10px;
    border: 1.5px solid #003366;
    border-radius: 7px;
    box-shadow: 0 2px 6px #00336611;
    background: #fff;
}
.preview-item {
    position: relative;
    display: inline-block;
}
.remove-btn {
    position: absolute;
    top: 11px;
    right: 11px;
    background-color: #ffffffcc;
    color: #333;
    border: none;
    border-radius: 4px;
    width: 20px;
    height: 20px;
    font-size: 16px;
    cursor: pointer;
    text-align: center;
    transition: background-color 0.2s, color 0.2s;
    box-shadow: 0 1px 4px rgba(0,0,0,0.09);
    display: flex;
    align-items: center;
    justify-content: center;
}
.remove-btn:hover {
    background-color: #003366;
    color: #fff;
}

/* 첨부파일/삭제 체크 */
.list-unstyled li {
    font-size: 1.01rem;
    margin-bottom: 6px;
}

/* 버튼 우측정렬 */
.d-flex.gap-2.justify-content-end {
    margin-top: 1.1rem;
}
</style>
</head>
<body>
	<div class="container my-5">
	    <h1 class="h3 mb-4">글 수정</h1>
	    <form action="<%=request.getContextPath()%>/hqboard/update" method="post" id="editForm" enctype="multipart/form-data">
	        <div class="mb-3">
	            <label for="num" class="form-label">글 번호</label>
	            <input type="text" class="form-control" name="num" id="num" value="<%=dto.getNum() %>" readonly/>
	        </div>
	        <div class="mb-3">
	            <label for="writer" class="form-label">작성자</label>
	            <input type="text" class="form-control" name="writer" id="writer" value="<%=dto.getWriter() %>" readonly/>
	        </div>
	        <div class="mb-3">
	            <label for="title" class="form-label">제목</label>
	            <input type="text" class="form-control" name="title" id="title" value="<%=dto.getTitle() %>" />
	        </div>
	        <div class="mb-3">
	            <label for="editor" class="form-label">내용</label>
	            <div id="editor"></div>
	            <textarea class="form-control" name="content" id="hiddencontent" style="display:none;"><%=dto.getContent() %></textarea>
	        </div>
			<div class="mb-3">
			    <label class="form-label">기존 첨부파일</label>
			    <ul class="list-unstyled">
			        <% if(dto.getFileList() != null && !dto.getFileList().isEmpty()) { 
			            for (HqBoardFileDto file : dto.getFileList()) { %>
			            <li>
			                <%=file.getOrgFileName()%>
			                <!-- 삭제 체크박스 -->
			                <label>
			                  <input type="checkbox" name="deleteFile" value="<%=file.getNum()%>"> 삭제
			                </label>
			            </li>
			        <% } 
			        } else { %>
			            <li>첨부파일 없음</li>
			        <% } %>
			    </ul>
			</div>
			<div class="mb-3">
			    <label class="form-label">새 파일 추가</label>
			    <input type="file" name="myFile" multiple>
			</div>	        
			<div class="d-flex gap-2 justify-content-end">
				<button class="btn btn-hq" type="submit">수정하기</button>
			    <a class="btn btn-soft-danger" href="<%=request.getContextPath()%>/headquater.jsp?page=hqboard/hq-list.jsp">취소</a>
			</div>
	    </form>
	</div>
	<script>
		// 위에 toast ui javascript 가 로딩 되어 있으면, toastui.Editor 클래스를 생성할 수 있다.
		// 해당 클래스를 이용해서 객체 생성하면서 {} object 로 ui 에 관련된 옵션을 잘 전달하면 
		// 우리가 원하는 모양의 텍스트 편집기를 만들 수 있다. 
		const editor = new toastui.Editor({
			el: document.querySelector('#editor'),
			height: '500px',
			initialEditType: 'wysiwyg',
			previewStyle: 'vertical',
			language: 'ko',
			initialValue:`<%=dto.getContent() %>`
		});
		
		document.querySelector("#editForm").addEventListener("submit", (e)=>{
			// Editor 로 작성된 문자열 읽어오기
			const content = editor.getHTML();
			// 테스트로 콘솔에 출력하기
			console.log(content);
			// editor 로 작성된 문자열을 폼 전송이 될 수 있는 textarea 의 value 로 넣어준다.
			document.querySelector("#hiddencontent").value=content;
			// 테스트 하기 위해 폼 전송 막기
			//e.preventDefault();
		})
	</script>
</body>
</html>

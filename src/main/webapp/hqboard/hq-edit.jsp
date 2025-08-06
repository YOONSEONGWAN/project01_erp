<%@page import="java.util.List"%>
<%@page import="dto.HqBoardFileDto"%>
<%@page import="dao.HqBoardDao"%>
<%@page import="dto.HqBoardDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%


    out.println("num param: " + request.getParameter("num"));
    out.println("title param: " + request.getParameter("title"));
    out.println("content param: " + request.getParameter("content"));
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
<!-- Toast UI Editor CSS/JS 필요시 include 추가 -->
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
<script src="https://uicdn.toast.com/editor/latest/i18n/ko-kr.js"></script>
</head>
<body>
	<div class="container my-5">
	    <h1 class="h3 mb-4">글 수정</h1>
	    <form action="${pageContext.request.contextPath}/hqboard/update" method="post" id="editForm" enctype="multipart/form-data">
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
	        <div class="d-flex gap-2">
	            <button class="btn btn-primary" type="submit">수정 확인</button>
	            <button type="reset" class="btn btn-outline-secondary">리셋</button>
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

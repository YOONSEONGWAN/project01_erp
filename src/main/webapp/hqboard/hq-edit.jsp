<%@page import="dao.HqBoardDao"%>
<%@page import="dto.HqBoardDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// 수정 할 글의 정보를 얻어와서 
	int num = Integer.parseInt(request.getParameter("num"));
	HqBoardDto dto=HqBoardDao.getInstance().getByNum(num);
	// 글 수정 폼을 응답한다.
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/hqboard/hq-edit.jsp</title>
</head>
<body>
	<div class="container">
		<nav>
		 <ol class="breadcrumb"><!-- 게시판 경로 -->
		   <li class="breadcrumb-item">
		   	<a href="${pageContext.request.contextPath }/">Home</a>
		  	</li>
		   <li class="breadcrumb-item">
		   	<a href="${pageContext.request.contextPath }/hqboard/hq-list.jsp">Board</a>
		  	</li>
		   <li class="breadcrumb-item active" >Edit</li>
		 </ol><!-- 게시판 경로 -->
		</nav>
		<h1>글 수정 페이지</h1>
		<form action="hq-update.jsp" method="post" id="editForm" >
			<div>
				<label for="num" class="">글 번호</label>
				<input type="text" class="" name="num" id="num"
				 value="<%=dto.getNum() %>" readonly/>
			</div>
			<div>
				<label for="writer" class="">작성자</label>
				<input type="text" class="" name="writer" id="witer"
				 value="<%=dto.getWriter() %>" readonly/>
			</div>
			<div>
				<label for="title" class="">제목</label>
				<input type="text" class="" name="title" id="witer"
					value="<%=dto.getTitle() %>" />
			</div>
			<div>
				<label for="editor" class="">내용</label>
				<div id="editor"></div>
				<textarea type="text" class="" name="content" 
					id="hiddencontent"><%=dto.getContent() %> </textarea>
			</div>
			<button class="">수정 확인</button>
			<button class="">리셋</button>
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
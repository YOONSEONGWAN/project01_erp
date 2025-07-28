<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div class="container">
		<h1>게시글 작성 양식</h1>
		<form action="hq-save.jsp" method="post" id="saveForm">
			<div class="">
				<label class="" for="title">제목</label>
				<input class="" type="text" name="title" id="title" />
			</div>
			<div class="">
				<label class="" for="editor">내용</label>
				<!-- Editor UI 가 출력될 div 
				<div id="editor"></div>
				-->
				<textarea class="" name="content" id="hiddencontent" ></textarea>
			</div>
			<button class="" type="submit">저장</button>
			<a class="" href="${pageContext.request.contextPath }/hqboard/hq-list.jsp">취소</a>
		</form>
	</div>
	<script>
		// 텍스트 편집기 에디터 생성 메소드 
		const editor = new toastui.Editor({
			el: document.querySelector('#editor'),
			height: '500px',
			initialEditType: 'wysiwyg',
			previewStyle: 'vertical',
			language: 'ko'
		});
		
		document.querySelector("#saveForm").addEventListener("submit", (e)=>{
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
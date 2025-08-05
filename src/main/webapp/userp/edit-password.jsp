
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>edit-password.jsp</title>
</head>
<body>
	<div class="container">
		<h1>비밀번호 수정 양식</h1>
		<form action="update-password.jsp" method="post" id="editForm">
			<div>
				<label for="password">기존 비밀번호</label>
				<input type="password" name="password" id="password"/>
			</div>
			<div>
				<label for="newPassword">새 비밀번호</label>
				<input type="password" name="newPassword" id="newPassword"/>
			</div>
			<div>
				<label for="newPassword2">새 비밀번호 확인</label>
				<input type="password" name="newPassword2" id="newPassword2"/>
			</div>
			<button type="submit">수정하기</button>
		</form>
	</div>
	<script>
		// id 가 editForm 인 요소에 "submit" 이벤트가 일어 났을때 실행할 함수 등록 
		// form 안에 있는 submit 버튼을 누르면 해당 form 에는 "submit" 이벤트가 발생한다 
		document.querySelector("#editForm").addEventListener("submit", (e)=>{
			/*
				여기서 해야할일
				- 폼에 입력한 내용의 유효성을 검증한다
				- 검증해서 유효하다면(잘 입력했다면) 관여하지 않는다(자동으로 폼이 제출된다)
				- 유효하지 않다면 e.preventDefault(); 를 실행해서 폼 제출을 막아준다.
			*/
			//기존 비밀번호
			const pwd = document.querySelector("#password").value;
			//새 비밀번호
			const newPwd = document.querySelector("#newPassword").value;
			//새 비밀번호 확인
			const newPwd2 = document.querySelector("#newPassword2").value;
			
			if(pwd.trim() == ""){ // 문자열에서 공백제거(좌우 공백)해서 비교 
				alert("기존 비밀번호를 입력하세요!");
				e.preventDefault();
			}else if(newPwd.trim() == ""){
				alert("새 비밀번호를 입력하세요!");
				e.preventDefault();
			}else if(newPwd.trim() != newPwd2.trim()){
				alert("새 비밀번호를 확인란과 동일하게 입력하세요!");
				e.preventDefault();
			}
			
		});
	</script>
</body>
</html>

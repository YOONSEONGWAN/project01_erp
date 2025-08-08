<%@page import="dto.BranchInfoDto"%>
<%@page import="dao.BranchInfoDao"%>
<%@page import="org.mindrot.jbcrypt.BCrypt"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//1. 폼 전송되는 기존 비밀번호와 새 비밀번호를 읽어온다.
	String password=request.getParameter("password");
	String newPassword=request.getParameter("newPassword");
	//2. 세션에 저장된 userName 을 이용해서 가입정보를 DB 에서 불러온다.
	String userId=(String)session.getAttribute("userId");
	BranchInfoDto dto=BranchInfoDao.getInstance().getByUserId(userId);
	//3. 기존 비밀번호와 DB 에 저장된 비밀번호가 일치하는지 확인해서
	boolean isValid=BCrypt.checkpw(password, dto.getUser_password());
	//4. 일치한다면 새 비밀번호를 DB 에 수정 반영하고 로그 아웃한다.
	if(isValid){
		//새 비밀번호를 암호화 한다.
		String encodedPwd=BCrypt.hashpw(newPassword, BCrypt.gensalt());
		//dto 에 담고
		dto.setUser_password(encodedPwd);
		//DB 에 수정반영
		BranchInfoDao.getInstance().updatePassword(dto.getUser_id(), dto.getUser_password());
		//로그아웃
		session.removeAttribute("userId");
	}
	//5. 일치하지 않는다면 에러정보를 응답하고 다시 입력할수 있도록 한다.
	
	System.out.println("입력된 기존 비밀번호: " + password);
	System.out.println("DB 저장된 해시 비밀번호: " + dto.getUser_password());
	System.out.println("BCrypt.checkpw 결과: " + isValid);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>비밀번호 수정</title>
<!-- 부트스트랩 CSS CDN -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
	<div class="container mt-5" style="max-width: 600px;">
		<div class="card shadow">
			<div class="card-header text-white" style="background-color: #003366;">
				<h5 class="mb-0">비밀번호 수정 결과</h5>
			</div>
			<div class="card-body">
				<% if(isValid){ %>
					<div class="alert alert-success" role="alert">
						<strong><%=dto.getUser_name() %></strong> 님의 비밀번호가 성공적으로 수정되었으며, 로그아웃 되었습니다.
					</div>
					<a href="${pageContext.request.contextPath}/userp/loginform.jsp?url=${pageContext.request.contextPath}/branchinfo/info2.jsp" class="btn btn-outline-secondary btn-sm ms-auto">다시 로그인</a>
				<% } else { %>
					<div class="alert alert-danger" role="alert">
						기존 비밀번호가 일치하지 않습니다. 다시 입력해 주세요.
					</div>
					<a href="edit-password2.jsp" class="btn btn-outline-secondary btn-sm">확인</a>
				<% } %>
			</div>
		</div>
	</div>

	<!-- 부트스트랩 JS (선택사항, 모달 등 필요시) -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
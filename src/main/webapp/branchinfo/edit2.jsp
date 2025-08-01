<%@page import="dao.BranchInfoDao"%>
<%@page import="dto.BranchInfoDto"%>
<%@page import="dao.UserDao"%>
<%@page import="dto.UserDto"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    //세션에 저장된 userName 을 읽어온다. (이미 로그인된 상태이기 때문에)
	 String userId=(String)session.getAttribute("userId");
	
	//DB 에서 사용자 정보를 읽어온다.
	BranchInfoDto dto=BranchInfoDao.getInstance().getByUserId(userId);
%> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/user/edit.jsp</title>
<jsp:include page="/WEB-INF/include/resource.jsp"></jsp:include>
</head>
<body>
	<div class="container">
		<h1>가입정보 수정 양식</h1>
		<%-- 
			input type="file" 이 있는 form 의 전송 방식은 다르다
			따라서 enctype="multipart/form-data" 속성을 form 에 추가해준다.
			서버에서 해당 요청을 처리하는 방법도 다르기 때문에 jsp 가 아닌 서블릿에서 처리를 하자 
		--%>
			<form action="${pageContext.request.contextPath }/branchinfo/update" method="post" 
					enctype="multipart/form-data">
	
			<input type="hidden" name="userId" value="<%=userId %>" />
			<div>
				<label for="branchName">지점 이름</label>
				<input type="text" name="branchName" value="<%=dto.getBranch_name() %>" readonly/>
			</div>
			
			<div>
				<label for="userName">지점장 이름</label>
				<input type="text" name="userName" value="<%=dto.getUser_name() %>" readonly/>
			</div>
			
			<div>
				<label for="branchAddress">지점 주소</label>
				<input type="text" name="branchAddress" value="<%=dto.getBranch_address() %>" />
			</div>
			
			<div>
				<label for="branchPhone">지점 연락처</label>
				<input type="text" name="branchPhone" value="<%=dto.getBranch_phone() %>" />
			</div>
			
			<div>
				<label for="userRole">직급</label>
				<input type="text" name="userRole" value="<%=dto.getUser_role() %>" />
			</div>
			
			
			
			<button type="submit">수정확인</button>
			<button type="reset">취소</button>
		</form>
	</div>
	
</body>
</html>








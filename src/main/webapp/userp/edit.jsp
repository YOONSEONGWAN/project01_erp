
<%@page import="dao.UserDao"%>
<%@page import="dto.UserDto"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    //세션에 저장된 userName 을 읽어온다. (이미 로그인된 상태이기 때문에)
	 String userId=(String)session.getAttribute("userId");
	
	//DB 에서 사용자 정보를 읽어온다.
	UserDto dto=UserDao.getInstance().getByUserId(userId);
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
			<form action="${pageContext.request.contextPath }/userp/update" method="post" 
					enctype="multipart/form-data">
	
			<input type="hidden" name="userId" value="<%=userId %>" />
			<label>프로필 이미지</label>
				<div>
					<a href="javascript:" href="javascript:" id="profileLink">
						<%if(dto.getProfile_image() == null){ %>
							<i style="font-size:100px;" class="bi bi-person-circle"></i>
						<%}else{ %>
							<img src="${pageContext.request.contextPath }/upload/<%=dto.getProfile_image() %>" 
							style="width:100px;height:100px;border-radius:50%;"/>
						<%} %>
					</a>
				</div>
				<!-- type="file" 말고 multiple 속성을 추가 하면 여러개의 파일을 하나의 name 으로 전송 할 수 있다-->
				<input type="file" name="profileImage" accept="image/*" style="display:none;"/>
			
			<div>
				<label for="userName">지점장 이름</label>
				<input type="text" name="userName" value="<%=dto.getUser_id() %>" readonly/>
			</div>
			
			<div>
				<label for="userPassword">비밀번호</label>
				<input type="text" name="userPassword" value="<%=dto.getPassword() %>" />
			</div>
			
			<div>
				<label for="userLocation">회원 주소</label>
				<input type="text" name="userLocation" value="<%=dto.getLocation() %>" />
			</div>
			
			<div>
				<label for="userPhone">전화번호</label>
				<input type="text" name="userPhone" value="<%=dto.getPhone() %>" />
			</div>
			<div>
				<label for="userCreated">가입날짜</label>
				<input type="text" name="userCreated" value="<%=dto.getCreated_at() %>" readonly/>
			</div>
			
			
			<button type="submit">수정확인</button>
			<button type="reset">취소</button>
		</form>
	</div>
	
</body>
</html>








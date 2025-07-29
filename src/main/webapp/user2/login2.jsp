<%@page import="org.mindrot.jbcrypt.BCrypt"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="branch.dao.UserDao"%>
<%@page import="branch.dto.UserDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	//아이디 비밀번호가 유효한 정보인지 여부
	boolean isValid = false;
	//폼을 전송되는 아이디과 비밀번호 추출하기
	String userName = request.getParameter("userName");
	String password = request.getParameter("password");
	//로그인 후에 가야할 목적지 정보
	String url=request.getParameter("url");
	//로그인 실패를 대비해서 목적지 정보를 인코딩한 결과도 준비한다.
	String encodedUrl=URLEncoder.encode(url,"UTF-8");
	
	//DB에서 userName 을 이용해서 select 되는 정보가 있는지 select 해 본다
	UserDto dto=UserDao.getInstance().getByName(userName);
	//만일 select 된 정보가 있다면(최소한 userName 은 존재한다는 것)
	if(dto != null){
		//raw 비밀번호와 DB 에 저장된 암호화된 비밀 번호를 비교해서 일치 하는지 확인한다.
		//BCrypt.checkpw(입력한 비밀 번호, 암호화된 비밀 번호);
		
	 isValid =BCrypt.checkpw(password, dto.getPassword());
	}
	/* 만일 입력한 아이디와 비밀번호가 유효한 정보라면 로그인 처리를 한다.
		jsp 에서 기본 제공해주는 HttpSession 객체에 userName 을 저장한다.
		HttpSession 객체에 저장하면 응답을 한 이후에 다음번 요청에서 HttpSession 객체에 저장된 정보를 읽어 올 수 있다.
		세션 객체에 담긴 정보는 어떤 요청도 하지 않고 일정 시간이 흐르면 자동 삭제 된다.
		필요하다면(로그아웃이 요청되면) 강제로 세션 객체에 담긴 정보를 삭제 할수도 있다.
		세션객체에 담긴 로그인 정보를 삭제하는것이 "로그아웃" 이고
		세션객체에 로그인 정보(userName)을 저장하는 것이 "로그인" 이다.
		
	
	*/
	if(isValid){
		//HttpSession 객체에 "userName" 이라는 키값으로 userName 을 저장한다.
		session.setAttribute("userName", userName);
		//세션 유지시간 설정(초단위)
		session.setMaxInactiveInterval(60*60);//설정하지 않으면 기본30분
	}
	

%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>login2</title>
</head>
<body>
	<div class="container">
		<%if(isValid){ %>
			<p>
				<strong><%=userName %></strong> 회원님 로그인
				
				<a href="${pageContext.request.contextPath }/index/branchindex.jsp">확인</a>
				
			</p>
			
		
		<%}else{ %>
			<p>
				아이디 혹은 비밀번호가 틀려요!
				<a href="loginform2.jsp?url=<%=encodedUrl%>">다시 로그인</a>
			</p>
		
		<%} %>
	</div>
</body>
</html>
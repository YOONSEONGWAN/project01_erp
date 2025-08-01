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
<title>info2</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-LN+7fdVzj6u52u30Kp6M/trliBMCMKTyK833zpbD+pXdCLuTusPj697FH4R/5mcr" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/js/bootstrap.bundle.min.js" integrity="sha384-ndDqU0Gzau9qJ1lfW4pNLlhNTkCfHzAVBReH9diLvGRem5+R9g2FzA8ZGN954O5Q" crossorigin="anonymous"></script>

</head>
<body>
		<div class="container">
		<h1>지점 정보</h1>
		<table class="table table-bordered table-striped">
		

			
			<tr>
				<th>지점 이름</th>
				<td><%=dto.getBranch_name() %></td>
			</tr>
			
			<tr>
				<th>지점장 이름</th>
				<td><%=dto.getUser_name() %></td>
			</tr>
			<tr>
				<th>비밀번호</th>
				<td>
					<a href="edit-password2.jsp">수정하기</a>
				</td>
			</tr>
			<tr>
				<th>지점 주소</th>
				<td><%=dto.getBranch_address() %></td>
			</tr> 
				
			<tr>
				<th>지점 연락처</th>
				<td><%=dto.getBranch_phone() %></td>
				
			</tr>
			<tr>
				<th>직급</th>
				<td><%=(dto.getUser_role() != null && !dto.getUser_role().isEmpty()) ? dto.getUser_role() : "직급 정보 없음" %></td>
				
			</tr>
			
			
		</table>
		
	</div>
	
	<div class="grid text-center" style="--bs-columns: 18; --bs-gap: .5rem;">
 		 <div style="grid-column: span 14;">
 		 	<a class="g-col-6 g-col-md-4" href="edit2.jsp">개인 정보 수정</a>
 		 </div>
  		 <div class="g-col-4">
  		 	<a class="mt-2" href="${pageContext.request.contextPath }/branchinfo/logout2.jsp">로그아웃</a>
  		 </div>
	</div>
	
	             
	                    
	                     
	                   
	                
	
</body>
</html>
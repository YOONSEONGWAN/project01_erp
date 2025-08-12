<%@page import="dao.BranchDao"%>
<%@page import="dto.BranchDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//폼 전송되는 정보를 추출한다
	String branchId=request.getParameter("branchId");
	String name=request.getParameter("name");
	String address=request.getParameter("address");
	String phone=request.getParameter("phone");
	
	//dto 에 담아서
	BranchDto dto=new BranchDto();
	dto.setBranch_id(branchId);
	dto.setName(name);
	dto.setAddress(address);
	dto.setPhone(phone);
	//dao 객체를 이용해서 DB 에 저장하고
	boolean isSuccess=BranchDao.getInstance().insert(dto);
	//응답한다
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/branch-admin/insert.jsp</title>
</head>
<body>
	<div class="container">
		<%if(isSuccess){%>
			<p>
				<strong><%=name %></strong> 등록 완료되었습니다.
				<a href="<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/list.jsp">지점 목록 가기</a>
			</p>
		<%}else{ %>
			<p>
				등록 실패!
				<a href="<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/insert-form.jsp">다시 등록하기</a>
			</p>
		<%} %>
	</div>
</body>
</html>
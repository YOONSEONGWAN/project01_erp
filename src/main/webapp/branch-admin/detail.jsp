<%@page import="dto.UserDtoAdmin"%>
<%@page import="java.util.List"%>
<%@page import="dao.BranchDao"%>
<%@page import="dto.BranchDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//get 방식 파라미터로 전달되는 지점번호 얻어내기
	int num=Integer.parseInt(request.getParameter("num"));
	//DB 에서 해당 지점의 자세한 정보를 얻어낸다.
	BranchDto dto=BranchDao.getInstance().getByNum(num);
	
	List<UserDtoAdmin> clerkList=BranchDao.getInstance().getListWithRole(dto.getBranch_id());
	List<UserDtoAdmin> managerList=BranchDao.getInstance().getManagerListByBranchId(dto.getBranch_id());

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/branch-admin/detail.jsp</title>
<jsp:include page="/WEB-INF/include/resource.jsp"></jsp:include>
</head>
<body>
	<div class="container position-relative">
		<nav aria-label="breadcrumb">
		  <ol class="breadcrumb">
		    <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/headquater.jsp">Home</a></li>
		    <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/main.jsp">지점 관리</a></li>
			<li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/list.jsp">지점 목록</a></li>
		    <li class="breadcrumb-item active" aria-current="page">지점 상세보기</li>
		  </ol>
		</nav>
	
		<h1 class="text-center">지점 상세 보기</h1>
		<table class="table table-bordered w-75 mx-auto">
			<tr>
				<th>지점 고유 번호</th>
				<td><%=dto.getBranch_id() %></td>
			</tr>
			<tr>
				<th>지점 이름</th>
				<td><%=dto.getName() %></td>
			</tr>
			<tr>
				<th>주소</th>
				<td><%=dto.getAddress() %></td>
			</tr>
			<tr>
				<th>지점 연락처</th>
				<td><%=dto.getPhone() %></td>
			</tr>
			<tr>
				<th>지점장 목록</th>
				<td>
					<%for(UserDtoAdmin manager : managerList){%>
						<a href="<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/roleupdate-form.jsp?num=<%=manager.getNum()%>"><%=manager.getUser_name() %></a> <br/>
					<%} %>
				</td>
			</tr>
			<tr>
				<th>직원 목록</th>
				<td>
					<%for(UserDtoAdmin clerk : clerkList){%>
						<a href="<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/roleupdate-form.jsp?num=<%=clerk.getNum()%>"><%=clerk.getUser_name() %></a>
						<%=clerk.getRole().equals("clerk")?"(직원)":"(미등록)" %>
						 <br/>
					<%} %>
				</td>
			</tr>
			<tr>
				<th>등록일</th>
				<td><%=dto.getCreatedAt() %></td>
			</tr>
			<tr>
				<th>수정일</th>
				<td><%=dto.getUpdatedAt()==null?"":dto.getUpdatedAt() %></td>
			</tr>
			<tr>
				<th>운영 상태</th>
				<td><%=dto.getStatus() %></td>
			</tr>
		</table>
		<a class="btn btn-sm btn-warning position-absolute" style="right:12.5%;" href="#" id="delete-btn" data-num="<%=dto.getNum()%>">삭제</a>
	</div>	
	<script>
		document.querySelector("#delete-btn").addEventListener("click", (e) => {
			e.preventDefault(); // 링크의 기본 동작 막기
			const num = e.currentTarget.getAttribute("data-num"); 
			const isDelete = confirm(num + " 번 지점을 삭제 하시겠습니까?");
			if (isDelete) {
				location.href = `<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/delete.jsp?num=\${num}`; 
			}
		});
	</script>
	<%
		String alertMsg = (String) session.getAttribute("alertMsg");
			if (alertMsg != null) {
				session.removeAttribute("alertMsg"); // 한 번 쓰고 지워줌
	%>
		<script>
			alert("<%= alertMsg %>");
		</script>
	<%
			}
	%>
	
</body>
</html>
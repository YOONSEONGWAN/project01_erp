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
	<div>
		<h1>지점 상세 보기</h1>
		<a href="list.jsp">지점 목록으로 돌아가기</a>
		<table>
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
				<th>지점장 이름</th>
				<td>
					<%for(UserDtoAdmin manager : managerList){%>
						<a href="roleupdate-form.jsp?num=<%=manager.getNum()%>"><%=manager.getUser_name() %></a> <br/>
					<%} %>
				</td>
				<th>직원 목록</th>
				<td>
					<%for(UserDtoAdmin clerk : clerkList){%>
						<a href="roleupdate-form.jsp?num=<%=clerk.getNum()%>"><%=clerk.getUser_name() %></a>
						<%=clerk.getRole() %>
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
				<td><%=dto.getUpdatedAt() %></td>
			</tr>
			<tr>
				<th>운영 상태</th>
				<td><%=dto.getStatus() %></td>
			</tr>
		</table>
	</div>
	<div>
	<a href="#" id="delete-btn" data-num="<%=dto.getNum()%>">삭제</a>
	</div>
	<script>
		document.querySelector("#delete-btn").addEventListener("click", (e) => {
			e.preventDefault(); // 링크의 기본 동작 막기
			const num = e.currentTarget.getAttribute("data-num"); 
			const isDelete = confirm(num + " 번 지점을 삭제 하시겠습니까?");
			if (isDelete) {
				location.href = `delete.jsp?num=\${num}`; 
			}
		});
	</script>
</body>
</html>
<%@page import="dao.BranchDao"%>
<%@page import="dto.BranchDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//get 방식 파라미터로 전달되는 지점번호 얻어내기
	int num=Integer.parseInt(request.getParameter("num"));
	//DB 에서 해당 지점의 자세한 정보를 얻어낸다.
	BranchDto dto=BranchDao.getInstance().getByNum(num);

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/branch-admin/detail.jsp</title>
</head>
<body>
	<div>
		<h1>지점 상세 보기</h1>
		<table>
			<tr>
				<th>지점 고유 번호</th>
				<td><%=dto.getBranchId() %></td>
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
				<td><%=dto.getUserName() %></td>
			</tr>
			<tr>
				<th>등록일</th>
				<td><%=dto.getCreatedAt() %></td>
			</tr>
			<tr>
				<th>수정일</th>
				<td><%=dto.getUpdatedAt() %></td>
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
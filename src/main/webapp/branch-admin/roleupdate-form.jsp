<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/branch-admin/roleupdate-form</title>
</head>
<body>
	<div class="container">
		<h1>등급 업데이트</h1>
		<table>
			<tr>
				<th>지점명</th>
				<th>이름</th>
				<th>등급</th>
			</tr>
			<tr>
				<%for(UserDto tmp:list){ %>
				<tr>
					<td>
						<a href="detail.jsp?num=<%=tmp.getNum() %>"><%=tmp.getName() %></a>
					</td> 
					<td><%=tmp.getAddress() %></td>
					<td><%=tmp.getPhone() %></td>
					<td><%=tmp.getUserName() %></td>
					<td><%=tmp.getStatus() %></td>
				</tr>
			<%} %>
			</tr>
		</table>
	</div>
</body>
</html>
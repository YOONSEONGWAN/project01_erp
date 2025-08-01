<%@page import="test.dao.SalesDao"%>
<%@page import="test.dto.SalesDto"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String branchId = (String)session.getAttribute("branchId");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>/branch-sales/list.jsp</title>
    <jsp:include page="/WEB-INF/include/resource.jsp"></jsp:include>
</head>
<body>
	<jsp:include page="/WEB-INF/include/branchnavbar.jsp">
		<jsp:param value="branch-sales" name="thisPage"/>
	</jsp:include>
    <h2>매출 목록</h2>

    <form action="${pageContext.request.contextPath}/branch-sales/insert-form.jsp" method="get">
        <button type="submit">매출 등록</button>
    </form>

    <form action="${pageContext.request.contextPath}/branch-sales/summary.jsp" method="get">
        <button type="submit">매출 요약 보기</button>
    </form>

    <table border="1" cellpadding="8" cellspacing="0">
        <tr>
            <th>매출ID</th>
            <th>지점ID</th>
            <th>날짜</th>
            <th>매출금액</th>
            <th>수정</th>
            <th>삭제</th>
            <th>상세보기</th>
        </tr>
        <%
            List<SalesDto> list = SalesDao.getInstance().getList(branchId);
            for (SalesDto dto : list) {
        %>
        <tr>
            <td><%= dto.getSalesId() %></td>
            <td><%= dto.getBranchId() %></td>
            <td><%= dto.getCreatedAt() %></td>
            <td><%= dto.getTotalAmount() %></td>
            <td>
                <a href="${pageContext.request.contextPath}/branch-sales/update-form.jsp?salesId=<%=dto.getSalesId()%>">수정</a>
            </td>
            <td>
                <a href="${pageContext.request.contextPath}/branch-sales/delete.jsp?salesId=<%=dto.getSalesId()%>&branchId=<%=dto.getBranchId()%>">삭제</a>
            </td>
            <td>
                <a href="${pageContext.request.contextPath}/branch-sales/detail.jsp?salesId=<%=dto.getSalesId()%>">상세보기</a>
            </td>
        </tr>
        <%
            }
        %>
    </table>
</body>
</html>
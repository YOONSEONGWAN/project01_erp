<%@page import="test.dao.BranchSalesDao"%>
<%@page import="test.dto.BranchSalesDto"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");

    String branchId = (String) session.getAttribute("branchId");
    if(branchId == null){
        response.sendRedirect(request.getContextPath()+"/userp/branchlogin-form.jsp");
        return;
    }

    int salesId = Integer.parseInt(request.getParameter("salesId"));
    BranchSalesDto dto = BranchSalesDao.getInstance().getData(salesId);

    // 데이터가 없거나 내 지점 데이터가 아니면 접근 차단
    if(dto == null || !branchId.equals(dto.getBranchId())){
        out.println("<script>alert('권한이 없습니다.'); location.href='list.jsp';</script>");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/branch-sales/detail.jsp</title>
</head>
<body>
    <h2>매출 상세 보기 (내 지점: <%=branchId%>)</h2>
    <table border="1">
        <tr><th>번호</th><td><%= dto.getSalesId() %></td></tr>
        <tr><th>날짜</th><td><%= dto.getCreated_at() %></td></tr>
        <tr><th>금액</th><td><%= dto.getTotalAmount() %> 원</td></tr>
    </table>
    <br>
    <button onclick="location.href='list.jsp'">← 목록으로</button>
    <button onclick="location.href='update-form.jsp?salesId=<%=dto.getSalesId()%>'">수정</button>
    <button onclick="if(confirm('삭제할까요?')) location.href='delete.jsp?salesId=<%=dto.getSalesId()%>'">삭제</button>
</body>
</html>
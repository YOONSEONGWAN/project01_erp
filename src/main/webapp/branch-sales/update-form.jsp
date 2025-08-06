<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="test.dao.BranchSalesDao" %>
<%@ page import="test.dto.BranchSalesDto" %>
<%
request.setCharacterEncoding("UTF-8");

    // 로그인 세션 확인
    String branchId = (String)session.getAttribute("branchId");
    if(branchId == null){
        response.sendRedirect(request.getContextPath() + "/userp/branchlogin-form.jsp");
        return;
    }

    // 매출 정보 조회
    int salesId = Integer.parseInt(request.getParameter("salesId"));
    BranchSalesDto dto = BranchSalesDao.getInstance().getById(salesId, branchId);

    String cpath = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/branch-sales/update-form.jsp</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-3">

<%
    if(dto == null){
%>
    <script>
        alert("권한이 없거나 존재하지 않는 매출입니다.");
        history.back();
    </script>
<%
    } else {
%>

    <h2>매출 수정</h2>

    <form action="<%=cpath%>/branch-sales/update.jsp" method="post" class="mt-3" style="max-width:400px;">
        <input type="hidden" name="salesId" value="<%= dto.getSalesId() %>">

        <table class="table table-bordered">
            <tr>
                <th class="table-light" style="width:150px;">총 매출 금액</th>
                <td><input type="number" name="totalAmount" class="form-control" value="<%= dto.getTotalAmount() %>" required></td>
            </tr>
        </table>

        <div class="mt-3">
            <button type="submit" class="btn btn-warning">수정</button>
            <a href="<%=cpath%>/branch-sales/list.jsp" class="btn btn-secondary">취소</a>
        </div>
    </form>

<%
    }
%>

</div>
</body>
</html>
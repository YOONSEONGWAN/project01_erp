<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");

    // 로그인 세션 확인
    String branchId = (String)session.getAttribute("branchId");
    if(branchId == null){
        response.sendRedirect(request.getContextPath() + "/userp/branchlogin-form.jsp");
        return;
    }

    String cpath = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/branch-sales/insert-form.jsp</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-3">

    <h2>매출 등록</h2>

    <form action="<%=cpath%>/branch-sales/save.jsp" method="post" class="mt-3">
        <table class="table table-bordered" style="max-width: 400px;">
            <tr>
                <th class="table-light" style="width:150px;">총 매출 금액</th>
                <td><input type="number" name="totalAmount" class="form-control" required></td>
            </tr>
        </table>

        <div class="mt-3">
            <button type="submit" class="btn btn-primary">등록</button>
            <a href="<%=cpath%>/branch-sales/list.jsp" class="btn btn-secondary">취소</a>
        </div>
    </form>

</div>
</body>
</html>
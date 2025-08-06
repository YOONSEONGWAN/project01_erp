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

// 매출 ID 파라미터
int salesId = Integer.parseInt(request.getParameter("salesId"));

// 매출 정보 조회
BranchSalesDto dto = BranchSalesDao.getInstance().getById(salesId, branchId);

String cpath = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/branch-sales/detail.jsp</title>
<jsp:include page="/WEB-INF/include/resource.jsp"/>
</head>
<body>
<div class="container mt-3">

<% if(dto == null){ %>
    <script>
        alert("권한이 없거나 존재하지 않는 매출입니다.");
        history.back();
    </script>
<% return; } %>

    <h2>매출 상세 보기</h2>

    <!-- 매출 상세 테이블 -->
    <table class="table table-bordered mt-3">
        <tr><th class="table-light" style="width: 150px;">매출 ID</th><td><%= dto.getSalesId() %></td></tr>
        <tr><th class="table-light">지점 ID</th><td><%= dto.getBranchId() %></td></tr>
        <tr><th class="table-light">매출 발생일</th><td><%= dto.getCreated_at() %></td></tr>
        <tr><th class="table-light">총 매출 금액</th><td><%= dto.getTotalAmount() %> 원</td></tr>
    </table>

    <!-- 버튼 영역 -->
    <div class="mt-3">
        <a href="<%= cpath %>/branch-sales/update-form.jsp?salesId=<%= dto.getSalesId() %>" class="btn btn-warning">수정</a>
        <a href="<%= cpath %>/branch-sales/delete.jsp?salesId=<%= dto.getSalesId() %>" 
           class="btn btn-danger" onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
        <a href="<%= cpath %>/branch-sales/list.jsp" class="btn btn-secondary">목록</a>
    </div>

</div>
</body>
</html>
<%@page import="dao.stock.PlaceOrderBranchDetailDao"%>
<%@page import="dto.stock.PlaceOrderBranchDetailDto"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    String orderIdStr = request.getParameter("order_id");
    int orderId = 0;
    try {
        orderId = Integer.parseInt(orderIdStr);
    } catch (Exception e) {
        out.println("<script>alert('잘못된 접근입니다.'); history.back();</script>");
        return;
    }

    List<PlaceOrderBranchDetailDto> list = PlaceOrderBranchDetailDao.getInstance().getDetailsByOrderId(orderId);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>출고 상세 내역</title>
    <jsp:include page="/WEB-INF/include/resource.jsp"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body {
            background-color: #f8f9fa;
        }

        .container {
            padding-top: 1rem;
            padding-bottom: 1rem;
            max-width: 900px;
            margin: 0 auto;
        }

        nav.breadcrumb {
            margin-bottom: 16px;
        }

        nav.breadcrumb .breadcrumb-item {
            font-size: 0.9rem;
        }

        nav.breadcrumb .breadcrumb-item a {
            color: #0d6efd;
            text-decoration: none;
        }

        nav.breadcrumb .breadcrumb-item.active {
            color: #6c757d;
            cursor: default;
        }

        h2 {
            margin-bottom: 20px;
            font-weight: 700;
            font-size: 28px;
            color: #212529;
            text-align: left;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 0;
            text-align: center;
            vertical-align: middle;
        }

        thead th {
            background-color: #e1e4e8;
            color: #212529;
            padding: 0.5rem 0.75rem;
            border-bottom: 2px solid #dee2e6;
            font-weight: 600;
        }

        tbody td {
            padding: 0.45rem 0.75rem;
            border-top: none;
        }

        .table-container {
            margin-top: 10px;
        }
    </style>
</head>
<body>

<div class="container">
    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" class="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/headquater.jsp">홈</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/stock.jsp">재고 관리</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/inandout.jsp">입고/출고</a></li>
            <li class="breadcrumb-item active" aria-current="page">출고 상세 내역</li>
        </ol>
    </nav>

    <!-- 제목 -->
    <h2>출고 상세 내역 (Order ID: <%= orderId %>)</h2>

    <!-- 테이블 -->
    <div class="table-container">
        <table class="table table-hover align-middle text-center">
            <thead class="table-secondary">
                <tr>
                    <th>상세ID</th>
                    <th>지점ID</th>
                    <th>상품명</th>
                    <th>현재 수량</th>
                    <th>신청 수량</th>
                    <th>승인 여부</th>
                    <th>담당자</th>
                </tr>
            </thead>
            <tbody>
                <% for (PlaceOrderBranchDetailDto dto : list) { %>
                <tr>
                    <td><%= dto.getDetail_id() %></td>
                    <td><%= dto.getBranch_id() %></td>
                    <td><%= dto.getProduct() %></td>
                    <td><%= dto.getCurrent_quantity() %></td>
                    <td><%= dto.getRequest_quantity() %></td>
                    <td><%= dto.getApproval_status() %></td>
                    <td><%= dto.getManager() %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <div class="text-center mt-4">
	    	<a href="<%=request.getContextPath()%>/headquater.jsp?page=stock/inandout.jsp" 
	        	class="btn btn-secondary"><i class="bi bi-list"></i> 목록</a>
	    </div>
    </div>
</div>

</body>
</html>
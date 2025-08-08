<%@page import="dao.StockRequestDao"%>
<%@page import="dto.StockRequestDto"%>
<%@page import="dto.stock.PlaceOrderBranchDto"%>
<%@page import="dao.stock.PlaceOrderBranchDao"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    List<StockRequestDto> list2 = StockRequestDao.getInstance().selectAll();
    List<PlaceOrderBranchDto> recentList = PlaceOrderBranchDao.getInstance().getRecentOrders();
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>발주 내역 보기</title>
    <jsp:include page="/WEB-INF/include/resource.jsp"/>

    <style>
        body {
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
        }

        .section {
            padding-top: 1rem;
            padding-bottom: 3rem;
            max-width: 900px;
            margin: 0 auto;
        }

        nav.breadcrumb {
            margin-bottom: 20px;
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
        }

        h2 {
            margin-top: 40px;
            margin-bottom: 20px;
            font-weight: 700;
            font-size: 28px;
            color: #212529;
            text-align: left;
        }

        table {
            width: 100%;
            border-collapse: collapse;
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
            border-top: 1px solid #dee2e6;
        }

        input.form-control-sm,
        select.form-select-sm {
            max-width: 120px;
            margin: 0 auto;
            display: block;
        }

        button.btn-primary {
            background-color: #003366 !important;
            border-color: #003366 !important;
            color: white !important;
            font-weight: 500;
            border-radius: 6px;
            height: 38px;
            padding: 0 16px;
        }

        button.btn-primary:hover {
            background-color: #002244 !important;
            border-color: #002244 !important;
        }

        .btn-outline-secondary {
            font-weight: 500;
        }

        .btn-submit {
            margin-top: 16px;
        }

        .text-center {
            margin-top: 30px;
        }
    </style>
</head>
<body>

<div class="section">
    <nav aria-label="breadcrumb" class="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath }/headquater.jsp">홈</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/placeorder.jsp">발주 관리</a></li>
            <li class="breadcrumb-item active" aria-current="page">발주 신청 내역</li>
        </ol>
    </nav>

    <h2>발주 신청 내역</h2>
    <form action="${pageContext.request.contextPath}/headquater.jsp?page=/stock/placeorder_branch_confirm.jsp" method="post">
        <table class="table table-hover align-middle">
            <thead class="table-secondary">
                <tr>
                    <th>주문번호</th>
                    <th>지점 ID</th>
                    <th>상품명</th>
                    <th>현재 수량</th>
                    <th>발주 수량</th>
                    <th>신청일</th>
                    <th>발주 상태</th>
                </tr>
            </thead>
            <tbody>
                <% for (StockRequestDto reqDto : list2) {
                    if (!"요청".equals(reqDto.getIsPlaceOrder())) continue;
                %>
                <tr>
                	<td>
                    	<a href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/placeorder_branch_detail.jsp?order_id=<%= reqDto.getOrderId() %>"
                         ><%= reqDto.getOrderId() %></a>
                    </td>
                    <td><%= reqDto.getBranchId() %></td>
                    <td><%= reqDto.getProduct() %></td>
                    <td><%= reqDto.getCurrentQuantity() %></td>
                    <td>
                        <input type="number" name="amount_<%= reqDto.getOrderId() %>" min="1"
                               value="<%= reqDto.getRequestQuantity() %>" required
                               class="form-control form-control-sm">
                    </td>
                    <td><%= reqDto.getRequestedAt() %></td>
                    <td>
                        <select name="approval_<%= reqDto.getOrderId() %>" class="form-select form-select-sm">
                            <option value="NO">반려</option>
                            <option value="YES">승인</option>
                        </select>
                    </td>
                </tr>
                <% } %>
            </tbody>
            <tfoot>
                <tr>
                    <td colspan="7" class="text-end pt-3">
                        <button type="submit" class="btn btn-primary">확인</button>
                    </td>
                </tr>
            </tfoot>
        </table>
    </form>

    <hr>

    <h2>최근 10건 발주 내역</h2>
    <table class="table table-hover align-middle">
        <thead class="table-secondary">
            <tr>
                <th>발주 ID</th>
                <th>발주일</th>
                <th>담당자</th>
                <th>상세 보기</th>
            </tr>
        </thead>
        <tbody>
            <% for (PlaceOrderBranchDto poDto : recentList) { %>
            <tr>
            	<td>
                    <a href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/placeorder_branch_detail.jsp?order_id=<%= poDto.getOrder_id() %>"
                       ><%= poDto.getOrder_id() %></a>
                </td>
                <td><%= poDto.getDate() %></td>
                <td><%= poDto.getManager() %></td>
                <td>
                    <a href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/placeorder_branch_detail.jsp?order_id=<%= poDto.getOrder_id() %>"
                       >상세</a>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>

    <div class="text-end mt-2">
        <a href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/placeorder_branch_all.jsp"
           >전체 발주 내역 보기</a>
    </div>
</div>

</body>
</html>
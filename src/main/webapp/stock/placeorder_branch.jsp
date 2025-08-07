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
    <!-- Bootstrap CSS 포함 -->
    <jsp:include page="/WEB-INF/include/resource.jsp"/>

    <style>
    body {
        background-color: #f8f9fa;
        min-height: 100vh;

        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;

        margin: 0;
        padding: 20px;
    }
    h2 {
        text-align: center;
        margin-top: 40px;
        font-weight: bold;
    }
    .section {
        max-width: 960px;
        width: 100%;
        margin-bottom: 50px;
    }
    table {
        width: 100%;
        margin: 20px 0;
        border-collapse: collapse;
    }
    table th {
        background-color: #007bff !important;
        color: white !important;
        text-align: center;
        vertical-align: middle;
        padding: 8px;
    }
    table td {
        vertical-align: middle;
        padding: 6px 8px;
        text-align: center;
    }
    input.form-control-sm, select.form-select-sm {
        display: block;
        margin: 0 auto;
        max-width: 120px;
    }
    .btn-submit {
        display: block;
        margin: 10px auto;
    }
    a.btn-link {
        text-decoration: none;
    }
</style>
</head>
<body>

<div class="section">
	<nav aria-label="breadcrumb" style="margin-bottom: 20px;">
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath }/index/headquaterindex.jsp">홈</a></li>
        <li class="breadcrumb-item"><a href="placeorder.jsp">발주 관리</a></li>
        <li class="breadcrumb-item active" aria-current="page">발주 신청 내역 </li>
      </ol>
    </nav>
    <h2>발주 신청 내역</h2>
    <form action="placeorder_branch_confirm.jsp" method="post">
        <table class="table table-bordered">
            <thead>
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
                    <td><%= reqDto.getOrderId() %></td>
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
                        <select name="approval_<%= reqDto.getOrderId() %>"
                                class="form-select form-select-sm">
                            <option value="NO">반려</option>
                            <option value="YES">승인</option>
                        </select>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>

        <button type="submit" class="btn btn-primary btn-sm btn-submit">발주 확정</button>
    </form>

    <h2>최근 10건 발주 내역</h2>
    <table class="table table-bordered">
        <thead>
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
                <td><%= poDto.getOrder_id() %></td>
                <td><%= poDto.getDate() %></td>
                <td><%= poDto.getManager() %></td>
                <td>
                    <a href="placeorder_branch_detail.jsp?order_id=<%= poDto.getOrder_id() %>"
                       class="btn btn-sm btn-outline-primary">상세 보기</a>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>

    <div class="text-center">
        <a href="placeorder_branch_all.jsp" class="btn btn-outline-secondary btn-sm">전체 발주 내역 보기</a>
        <a href="placeorder.jsp" class="btn btn-outline-secondary btn-sm">돌아가기</a>
    </div>
</div>

</body>
</html>
<%@ page import="java.util.List" %>
<%@ page import="dto.StockRequestDto" %>
<%@ page import="dao.StockRequestDao" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
String branchId = (String)session.getAttribute("branchId"); // 세션에서 branchId 가져옴
StockRequestDao dao = new StockRequestDao();
List<StockRequestDto> orderList = dao.selectAllByBranch(branchId); // 발주 내역 리스트
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>발주 현황</title>
    <jsp:include page="/WEB-INF/include/resource.jsp"></jsp:include>
    <style>
        table { border-collapse: collapse; width: 850px; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: center; }
        .btn { padding: 4px 14px; border-radius: 5px; font-size: 0.95em; }
        .btn-update { background: #695cff; color: #fff; border: none; }
        .btn-delete { background: #ff8b8b; color: #fff; border: none; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/include/branchnavbar.jsp">
	<jsp:param value="order" name="thisPage"/>
</jsp:include>
<h3>발주 현황</h3>
<table>
    <tr>
        <th>발주번호</th>
     <%--   <th>branch_stock번호</th>    branch_num 추가, 관리용 --%>
        <th>상품명</th>
        <th>현재 재고</th>
        <th>요청 수량</th>
        <th>승인여부</th>
        <th>상태</th>
        <th>신청일</th>
        <th>비고</th>
        <th>수정</th>
        <th>삭제</th>
    </tr>
<%
if (orderList == null || orderList.isEmpty()) {
%>
    <tr>
        <td colspan="10" style="text-align:center;">발주 내역이 없습니다.</td>
    </tr>
<%
} else {
    for(StockRequestDto dto : orderList) {
%>
    <tr>
        <td><%= dto.getOrderId() %></td>
        <%-- <td><%= dto.getBranchNum() %></td>   branch_num 표시, 필요없으면 생략 --%>
        <td><%= dto.getProduct() %></td>
        <td><%= dto.getCurrentQuantity() %></td>
        <td><%= dto.getRequestQuantity() %></td>
        <td>
  			<%= dto.getIsPlaceOrder() == null ? "대기중" :
      		dto.getIsPlaceOrder().equals("YES") ? "승인" : "거절" %>
		</td>
        <td><%= dto.getStatus() %></td>
        <td>
            <% if (dto.getRequestedAt() != null) { %>
                <%= dto.getRequestedAt() %>
            <% } %>
        </td>
        
        <td>
            <form action="update-form.jsp" method="get" style="margin:0;">
                <input type="hidden" name="orderId" value="<%= dto.getOrderId() %>">
                <input type="hidden" name="branchNum" value="<%= dto.getBranchNum() %>">
                <button type="submit" class="btn btn-update">수정</button>
            </form>
        </td>
        <td>
            <form action="delete.jsp" method="post" style="margin:0;" onsubmit="return confirm('정말 삭제하시겠습니까?');">
                <input type="hidden" name="orderId" value="<%= dto.getOrderId() %>">
                <input type="hidden" name="branchNum" value="<%= dto.getBranchNum() %>">
                <button type="submit" class="btn btn-delete">삭제</button>
            </form>
        </td>
    </tr>
<%
    }
}
%>
</table>
<div style="margin-top:18px;">
    <a href="insert.jsp" style="text-decoration:none;">
        <button class="btn btn-update" type="button">새 발주 요청</button>
    </a>
</div>
</body>
</html>
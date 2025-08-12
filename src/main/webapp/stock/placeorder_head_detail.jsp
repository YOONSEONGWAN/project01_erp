<%@page import="java.util.List"%>
<%@page import="dto.stock.PlaceOrderHeadDetailDto"%>
<%@page import="dao.stock.PlaceOrderHeadDetailDao"%>
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

    List<PlaceOrderHeadDetailDto> list = PlaceOrderHeadDetailDao.getInstance().getDetailsByOrderId(orderId);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>발주 상세 내역</title>

    <!-- Bootstrap CSS 포함 -->
<jsp:include page="/WEB-INF/include/resource.jsp"/>
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

<style>
  body {
      background-color: #f8f9fa;
      font-family: "Malgun Gothic", "맑은 고딕", "Segoe UI", "Noto Sans KR", sans-serif;
      color: #212529;
      margin: 0;
      padding: 0;
      overflow-x: hidden;
  }

  .container {
      max-width: 960px;
      width: 100%;
      margin: 20px auto 40px auto;
      background-color: #fff;
      padding: 30px 40px;
      border-radius: 6px;
      box-shadow: 0 0 10px rgba(0,0,0,0.1);
      box-sizing: border-box;
  }

  nav.breadcrumb {
      margin-bottom: 20px;
      background: transparent;
      padding: 0;
      font-size: 0.9rem;
      color: #212529;
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
      margin-top: 0;
      margin-bottom: 25px;
      font-weight: 700;
      font-size: 1.8rem;
      text-align: left;
  }

  table {
      width: 100%;
      border-collapse: collapse;
      font-size: 0.95rem;
  }

  thead th {
      background-color: #e9ecef;
      color: #212529;
      font-weight: 600;
      text-align: center;
      padding: 12px 10px;
      border-bottom: 3px solid #dee2e6;
      user-select: none;
  }

  tbody td {
      padding: 12px 10px;
      vertical-align: middle;
      text-align: center;
      border-bottom: 1px solid #dee2e6;
  }

  tbody tr:hover {
      background-color: #f1f5fb;
      transition: background-color 0.3s ease;
  }

  a {
      color: #007bff;
      text-decoration: none;
      font-weight: 500;
  }

  a:hover {
      text-decoration: underline;
  }

  @media (max-width: 576px) {
      .container {
          padding: 20px 15px;
          margin: 15px auto 30px auto;
      }

      thead th, tbody td {
          padding: 8px 6px;
          font-size: 0.85rem;
      }

      h2 {
          font-size: 1.4rem;
          margin-bottom: 20px;
      }
  }
  .navbar-user-link {
    color: white !important;
    text-decoration: underline; /* 밑줄 */
    
}
  
</style>
</head>
<body>

<div class="container">
    <nav aria-label="breadcrumb">
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/headquater.jsp">홈</a></li>
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/placeorder.jsp">발주 관리</a></li>
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/placeorder_head.jsp">본사 발주</a></li>
        <li class="breadcrumb-item active" aria-current="page">상세 발주 내역</li>
      </ol>
    </nav>

    <h2>발주 상세 내역 (Order ID: <%= orderId %>)</h2>

    <div class="table-container">
        <table class="table table-hover align-middle">
            <thead class="table-secondary">
                <tr>
                    <th>상품명</th>
                    <th>현재 수량</th>
                    <th>신청 수량</th>
                    <th>승인 여부</th>
                    <th>담당자</th>
                    <th>수정</th>
                </tr>
            </thead>
            <tbody>
                <% for (PlaceOrderHeadDetailDto dto : list) { %>
                <tr>
                    <td><%= dto.getProduct() %></td>
                    <td><%= dto.getCurrent_quantity() %></td>
                    <td><%= dto.getRequest_quantity() %></td>
                    <td><%= dto.getApproval_status() %></td>
                    <td><%= dto.getManager() %></td>
                    <td>
                        <a href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/placeorder_head_editform.jsp?detail_id=<%= dto.getDetail_id() %>&order_id=<%= dto.getOrder_id() %>">수정</a>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <div class="text-center mt-4">
	    	<a href="<%=request.getContextPath()%>/headquater.jsp?page=stock/placeorder_head.jsp" 
	        	class="btn btn-secondary"><i class="bi bi-list"></i> 목록</a>
	    </div>
    </div>

</div>

</body>
</html>
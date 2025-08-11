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
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
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

        /* 제목 좌측 정렬로 변경 */
        h2 {
            margin-top: 0;
            margin-bottom: 25px;
            font-weight: 700;
            font-size: 1.8rem;
            text-align: left; /* 변경된 부분 */
        }

        nav.breadcrumb {
            margin-bottom: 20px;
            background: transparent;
            padding: 0;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.95rem;
        }

        /* thead에 Bootstrap table-secondary 클래스가 있으므로 별도 색상 지정 지움 */
        thead th {
            text-align: center;
            padding: 12px 10px;
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

        .btn-outline-primary {
            color: #007bff;
            border-color: #007bff;
            font-size: 0.85rem;
            padding: 5px 10px;
            border-radius: 4px;
            transition: all 0.3s ease;
            text-decoration: none;
        }

        .btn-outline-primary:hover {
            background-color: #007bff;
            color: #fff;
            text-decoration: none;
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
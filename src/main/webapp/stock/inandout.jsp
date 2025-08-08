<%@page import="java.util.List"%>
<%@page import="dao.stock.InboundOrdersDao"%>
<%@page import="dao.stock.OutboundOrdersDao"%>
<%@page import="dto.stock.InboundOrdersDto"%>
<%@page import="dto.stock.OutboundOrdersDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    List<InboundOrdersDto> processedInbounds = InboundOrdersDao.getInstance().selectProcessedWithKeyword(10);
    List<OutboundOrdersDto> processedOutbounds = OutboundOrdersDao.getInstance().selectProcessedWithKeyword(10);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>입고/출고 관리</title>
    <jsp:include page="/WEB-INF/include/resource.jsp"/>
    <style>
        /* 컨테이너 최대 너비, 위아래 패딩 */
        .container {
            padding-top: 1rem;
            padding-bottom: 1rem;
            max-width: 900px;
        }

        /* Breadcrumb 스타일 */
        nav.breadcrumb {
            margin-bottom: 6px;
        }
        nav.breadcrumb .breadcrumb-item {
            font-size: 0.9rem;
        }
        nav.breadcrumb .breadcrumb-item a {
            color: #0d6efd; /* Bootstrap 기본 링크색 */
            text-decoration: none;
        }
        nav.breadcrumb .breadcrumb-item.active {
            color: #6c757d; /* Bootstrap secondary 텍스트 색 */
            cursor: default;
        }

        /* 제목 스타일 */
        h2 {
            margin-top: 0;
            margin-bottom: 16px;
            font-weight: 700;
            font-size: 28px;
            color: #212529; /* Bootstrap 기본 텍스트색 */
            text-align: left;
        }

        /* 테이블 스타일 */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 0;
            text-align: center;
            vertical-align: middle;
        }
        thead th {
            background-color: #e1e4e8; /* 재고 목록과 동일한 옅은 회색 */
            color: #212529; /* 진한 텍스트 색 */
            padding: 0.5rem 0.75rem;
            border-bottom: 2px solid #dee2e6;
            font-weight: 600;
        }
        tbody td {
            padding: 0.45rem 0.75rem;
            border-top: 1px solid #dee2e6;
        }

        /* 버튼 스타일 (부트스트랩 버튼은 resource.jsp에서 적용됨) */
        a.btn-link {
            display: inline-block;
            margin-top: 1rem;
            margin-bottom: 1rem;
            color: #0d6efd;
            text-decoration: none;
            cursor: pointer;
        }
        a.btn-link:hover {
            text-decoration: underline;
        }

        /* 중앙 정렬 wrapper */
        .main-wrapper {
            display: flex;
            flex-direction: column;
            justify-content: center;
            min-height: calc(100vh - 150px);
        }
        
        button.btn-primary {
		    background-color: #003366 !important;
		    border-color: #003366 !important;
		    color: white !important;
		    font-weight: 500;
		    border-radius: 6px;
		    height: 38px;
		}
		
		button.btn-primary:hover {
		    background-color: #002244 !important;
		    border-color: #002244 !important;
		    color: white !important;
		}
    </style>
</head>
<body class="bg-light">

<div class="container py-1">

    <!-- 중앙 정렬용 wrapper -->
    <div class="main-wrapper">

        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb" class="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/headquater.jsp">홈</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/stock.jsp">재고 관리</a></li>
                <li class="breadcrumb-item active" aria-current="page">입고 / 출고</li>
            </ol>
        </nav>

        <!-- 입고 내역 -->
        <h2>입고 처리 내역 (최근 10건)</h2>
        <table class="table">
            <thead class="table-secondary">
                <tr>
                    <th>입고 ID</th>
                    <th>입고 날짜</th>
                    <th>담당자</th>
                    <th>상세보기</th>
                </tr>
            </thead>
            <tbody>
            <% if (processedInbounds == null || processedInbounds.isEmpty()) { %>
                <tr><td colspan="4">-</td></tr>
            <% } else {
                for (InboundOrdersDto dto : processedInbounds) { %>
                    <tr>
                        <td><%= dto.getOrder_id() %></td>
                        <td><%= dto.getIn_date() != null ? dto.getIn_date() : "-" %></td>
                        <td><%= dto.getManager() != null ? dto.getManager() : "-" %></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/inbound_detail.jsp?order_id=<%= dto.getOrder_id() %>" >상세</a>
                        </td>
                    </tr>
            <% } } %>
            </tbody>
        </table>
        
        <div class="me-5" style="text-align: right;">
		    <a href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/inbound_list.jsp" class="btn btn-link">전체 입고 내역 보기</a>
		</div>
        
        <!-- 출고 내역 -->
        <h2>출고 처리 내역 (최근 10건)</h2>
        <table class="table">
            <thead class="table-secondary">
                <tr>
                    <th>출고 ID</th>
                    <th>출고 날짜</th>
                    <th>담당자</th>
                    <th>상세보기</th>
                </tr>
            </thead>
            <tbody>
            <% if (processedOutbounds == null || processedOutbounds.isEmpty()) { %>
                <tr><td colspan="4">-</td></tr>
            <% } else {
                for (OutboundOrdersDto dto : processedOutbounds) { %>
                    <tr>
                        <td><%= dto.getOrder_id() %></td>
                        <td><%= dto.getOut_date() != null ? dto.getOut_date() : "-" %></td>
                        <td><%= dto.getManager() != null ? dto.getManager() : "-" %></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/outbound_detail.jsp?order_id=<%= dto.getOrder_id() %>">상세</a>
                        </td>
                    </tr>
            <% } } %>
            </tbody>
        </table>
        
        <div class="me-5" style="text-align: right;">
		    <a href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/outbound_list.jsp" class="btn btn-link">전체 출고 내역 보기</a>
		</div>
        

    </div> <!-- /.main-wrapper -->

</div> <!-- /.container -->

</body>
</html>
<%@page import="dto.ProductDto"%>
<%@page import="dao.ProductDao"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    int num = Integer.parseInt(request.getParameter("num"));
    ProductDto dto = new ProductDao().getByNum(num);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>상품 상세</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* 화면 꽉 채우기 위해 기본 여백 제거 */
        html, body {
            margin: 0;
            padding: 0;
            height: 100%;
            width: 100%;
        }
        body {
            padding: 0 !important;
        }
        .container {
            max-width: 100% !important;
            padding: 0 15px; /* 좌우 약간의 여백만 줌 */
        }
        .card {
            margin: 0;
            border-radius: 0;
            height: 100%;
            box-shadow: none; /* 필요시 제거 */
        }
        .card-body {
            padding: 20px;
        }
    </style>
</head>
<body>

 <!-- breadcrumb 추가 시작 -->
    <nav aria-label="breadcrumb" class="mb-3" style="margin: 0 15px;">
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/headquater.jsp">홈</a></li>
        <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/headquater.jsp?page=product/list.jsp">상품 목록</a></li>
        <li class="breadcrumb-item active" aria-current="page">상품 상세 정보</li>
      </ol>
    </nav>
    <!-- breadcrumb 추가 끝 -->
	
	<div class="container">
	    <div class="card shadow-sm">
	        <div class="card-header bg-primary text-white">
	            <h4 class="mb-0">상품 상세 정보</h4>
	        </div>
	        <div class="card-body">
	            <% if (dto != null) { %>
	                <div class="text-center mb-4">
	                    <% if (dto.getImagePath() != null && !dto.getImagePath().isEmpty()) { %>
	                        <img src="<%=request.getContextPath() + "/image?name=" + dto.getImagePath()%>" 
	                             alt="상품 이미지" 
	                             class="img-thumbnail" 
	                             style="max-width: 200px; max-height: 200px;">
	                    <% } else { %>
	                        <div class="text-muted">이미지가 없습니다</div>
	                    <% } %>
	                </div>
	
	                <table class="table table-bordered align-middle">
	                    <tbody>
	                        <tr>
	                            <th class="table-secondary" style="width: 20%;">번호</th>
	                            <td><%=dto.getNum()%></td>
	                        </tr>
	                        <tr>
	                            <th class="table-secondary">상품명</th>
	                            <td><%=dto.getName()%></td>
	                        </tr>
	                        <tr>
	                            <th class="table-secondary">설명</th>
	                            <td><%=dto.getDescription()%></td>
	                        </tr>
	                        <tr>
	                            <th class="table-secondary">가격</th>
	                            <td><%=dto.getPrice()%>원</td>
	                        </tr>
	                        <tr>
	                            <th class="table-secondary">상태</th>
	                            <td><%=dto.getStatus()%></td>
	                        </tr>
	                    </tbody>
	                </table>
	
	                <div class="text-center mt-4">
	                    <a href="<%=request.getContextPath()%>/headquater.jsp?page=product/list.jsp" 
	                       class="btn btn-secondary">← 목록으로</a>
	                </div>
	            <% } else { %>
	                <div class="alert alert-danger text-center">
	                    존재하지 않는 상품입니다.
	                </div>
	                <div class="text-center">
	                    <a href="<%=request.getContextPath()%>/headquater.jsp?page=product/list.jsp" 
	                       class="btn btn-secondary">← 목록으로</a>
	                </div>
	            <% } %>
	        </div>
	    </div>
	</div>

</body>
</html>

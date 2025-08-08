<%@page import="dto.ProductDto"%>
<%@page import="dao.ProductDao"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    int num = Integer.parseInt(request.getParameter("num"));
    ProductDao dao = new ProductDao();
    ProductDto dto = dao.getByNum(num);

    Integer prevNum = dao.getPreviousNum(num);
    Integer nextNum = dao.getNextNum(num);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>상품 상세</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- ✅ Bootstrap Icons 추가 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
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
            max-width: 600px !important;
            margin: 0 auto !important;
            padding: 0 15px !important;
        }
        .card {
            margin: 0;
            border-radius: 0;
            height: 100%;
            box-shadow: none;
        }
        .card-body {
            padding: 20px;
        }
        .img-thumbnail {
            max-width: 100%;
            height: auto;
            max-height: 400px;
            object-fit: contain;
            display: inline-block;
        }
		.card-header {
		    background-color: #003366 !important;
		    color: white !important;
		    font-weight: 600;
		}
		.table-secondary {
		    background-color: #e6ecf3 !important;
		    color: #003366 !important;
		    font-weight: 600;
		}
		.btn-primary, .btn-outline-primary {
		    background-color: #003366 !important;
		    border-color: #003366 !important;
		    color: white !important;
		    font-weight: 500;
		    border-radius: 6px;
		    height: 38px;
		    box-shadow: 0 2px 6px rgba(0, 51, 102, 0.5);
		    transition: background-color 0.3s ease, border-color 0.3s ease;
		}
		.btn-primary:hover, .btn-outline-primary:hover {
		    background-color: #002244 !important;
		    border-color: #002244 !important;
		    color: white !important;
		    text-decoration: none;
		}
		.btn-outline-primary {
		    background-color: transparent !important;
		    color: #003366 !important;
		    box-shadow: none;
		}
		.btn-outline-primary:hover {
		    background-color: #003366 !important;
		    color: white !important;
		}
		.btn-secondary {
		    background-color: #5a6978 !important;
		    border-color: #5a6978 !important;
		    color: white !important;
		    font-weight: 600;
		    border-radius: 6px;
		    height: 38px;
		    box-shadow: none;
		}
		.btn-secondary:hover {
		    background-color: #434f60 !important;
		    border-color: #434f60 !important;
		    color: white !important;
		}	        
    </style>
</head>
<body>

<!-- breadcrumb -->
<nav aria-label="breadcrumb" class="mb-3" style="margin: 0 15px;">
  <ol class="breadcrumb">
    <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/headquater.jsp">홈</a></li>
    <li class="breadcrumb-item active" aria-current="page">상품 관리</li>
    <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/headquater.jsp?page=product/list.jsp">상품 목록</a></li>
    <li class="breadcrumb-item active" aria-current="page">상품 상세 정보</li>
  </ol>
</nav>

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
                         style="max-width: 100%; height: auto; max-height: 400px; object-fit: contain;">
                    <% } else { %>
                        <div class="text-muted">이미지가 없습니다</div>
                    <% } %>
                </div>

                <table class="table table-bordered align-middle">
                    <tbody>
                        <tr>
                            <th class="table-secondary" style="width: 20%;">상품번호</th>
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

                <div class="d-flex justify-content-between mt-4">
                    <div>
                        <% if (prevNum != null) { %>
                            <a href="<%=request.getContextPath()%>/headquater.jsp?page=product/detail.jsp&num=<%= prevNum %>" class="btn btn-primary">← 이전</a>
                        <% } else { %>
                            <button class="btn btn-primary" disabled>← 이전</button>
                        <% } %>
                    </div>

                    <div>
                        <!-- ✅ 목록 버튼 햄버거 아이콘 적용 -->
                        <a href="<%=request.getContextPath()%>/headquater.jsp?page=product/list.jsp" class="btn btn-secondary">
                            <i class="bi bi-list"></i> 목록
                        </a>
                    </div>

                    <div>
                        <% if (nextNum != null) { %>
                            <a href="<%=request.getContextPath()%>/headquater.jsp?page=product/detail.jsp&num=<%= nextNum %>" class="btn btn-primary">다음 →</a>
                        <% } else { %>
                            <button class="btn btn-primary" disabled>다음 →</button>
                        <% } %>
                    </div>
                </div>

            <% } else { %>
                <div class="alert alert-danger text-center">
                    존재하지 않는 상품입니다.
                </div>
                <div class="text-center">
                    <a href="<%=request.getContextPath()%>/headquater.jsp?page=product/list.jsp" class="btn btn-secondary">
                        <i class="bi bi-list"></i> 목록
                    </a>
                </div>
            <% } %>
        </div>
    </div>
</div>

</body>
</html>

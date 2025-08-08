<%@page import="dao.HrmDao"%>
<%@page import="dto.HrmDto"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    int num = Integer.parseInt(request.getParameter("num"));
    String from = request.getParameter("from");
    if (from == null || (!from.equals("admin") && !from.equals("branch"))) {
        from = "admin";
    }

    HrmDao dao = new HrmDao();
    HrmDto dto = dao.getByNum(num);

    // 이전글 번호와 다음글 번호 조회
    Integer prevNum = dao.getPreviousNum(num, from);
    Integer nextNum = dao.getNextNum(num, from);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>직원 상세 정보</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
    body, html {
        margin: 0;
        padding: 0;
        height: 100%;
        width: 100%;
    }
    .container {
        max-width: 600px;
        margin: 0 auto;
        padding: 15px;
    }
    .img-thumbnail {
        max-width: 100%;
        height: auto;
        max-height: 180px;
        object-fit: contain;
        display: inline-block;
    }
	    .card-header {
	    background-color: #003366 !important;
	    color: white !important;
	    font-weight: 600;
	}
	
	.table-secondary {
	    background-color: #e6ecf3 !important; /* 연한 남색 느낌 */
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
	    <li class="breadcrumb-item active" aria-current="page">직원 관리</li>
	    <li class="breadcrumb-item">
	      <a href="<%=request.getContextPath()%>/headquater.jsp?page=hrm/list.jsp&from=<%=from%>">
	        <%= ("admin".equals(from) ? "본사 직원 목록" : "지점 직원 목록") %>
	      </a>
	    </li>
	    <li class="breadcrumb-item active" aria-current="page">직원 상세 정보</li>
	  </ol>
	</nav>

<div class="container">
    <div class="card shadow-sm">
        <div class="card-header bg-primary text-white">
            <h4 class="mb-0">직원 상세 정보</h4>
        </div>
        <div class="card-body">
            <% if (dto != null) { %>
                <div class="text-center mb-4">
                    <% if (dto.getProfileImage() != null && !dto.getProfileImage().isEmpty()) { %>
                        <img src="<%=request.getContextPath() + "/image?name=" + dto.getProfileImage()%>" 
                             alt="프로필 이미지" 
                             class="img-thumbnail">
                    <% } else { %>
                        <div class="text-muted">이미지가 없습니다</div>
                    <% } %>
                </div>

                <table class="table table-bordered align-middle">
                    <tbody>
                        <tr>
                            <th class="table-secondary" style="width: 20%;">사원번호</th>
                            <td><%=dto.getNum()%></td>
                        </tr>
                        <tr>
                            <th class="table-secondary">이름</th>
                            <td><%=dto.getName()%></td>
                        </tr>
                        <tr>
                            <th class="table-secondary">직급</th>
                            <td><%=dto.getRole()%></td>
                        </tr>
                        <tr>
                            <th class="table-secondary">지점</th>
                            <td><%=dto.getBranchName()%></td>
                        </tr>
                        <tr>
                            <th class="table-secondary">전화번호</th>
                            <td><%=dto.getPhone()%></td>
                        </tr>
                        <tr>
                            <th class="table-secondary">주소</th>
                            <td><%=dto.getLocation()%></td>
                        </tr>
                    </tbody>
                </table>

                <!-- ✅ 프로필 이미지 등록/수정 버튼 -->
                <div class="text-end mt-3">
                    <a href="<%=request.getContextPath()%>/headquater.jsp?page=hrm/profileimage.jsp&num=<%=dto.getNum()%>&from=<%=from%>" 
                       class="btn btn-outline-primary">프로필 이미지 등록/수정</a>
                </div>

                <!-- 🔁 이전 / 다음 / 목록 버튼 -->
                <div class="d-flex justify-content-between mt-4">
                    <div>
                        <% if (prevNum != null) { %>
                            <a href="<%=request.getContextPath()%>/headquater.jsp?page=hrm/detail.jsp&num=<%= prevNum %>&from=<%= from %>" class="btn btn-primary">← 이전</a>
                        <% } else { %>
                            <button class="btn btn-primary" disabled>← 이전</button>
                        <% } %>
                    </div>

                    <div>
                        <a href="<%= request.getContextPath() %>/headquater.jsp?page=hrm/list.jsp&from=<%= from %>" 
                           class="btn btn-secondary">← 목록으로</a>
                    </div>

                    <div>
                        <% if (nextNum != null) { %>
                            <a href="<%=request.getContextPath()%>/headquater.jsp?page=hrm/detail.jsp&num=<%= nextNum %>&from=<%= from %>" class="btn btn-primary">다음 →</a>
                        <% } else { %>
                            <button class="btn btn-primary" disabled>다음 →</button>
                        <% } %>
                    </div>
                </div>

            <% } else { %>
                <div class="alert alert-danger text-center">
                    존재하지 않는 직원입니다.
                </div>
                <div class="text-center">
                    <a href="<%= request.getContextPath() %>/headquater.jsp?page=hrm/list.jsp&from=<%= from %>" 
                       class="btn btn-secondary">← 목록으로</a>
                </div>
            <% } %>
        </div>
    </div>
</div>
</body>
</html>

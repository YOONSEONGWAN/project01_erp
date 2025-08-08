<%@page import="dao.UserDaoAdmin"%>
<%@page import="dto.UserDtoAdmin"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    Long num = Long.parseLong(request.getParameter("num"));
    UserDtoAdmin dto = UserDaoAdmin.getInstance().getByNum(num);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/branch-admin/roleupdate-form.jsp</title>
<jsp:include page="/WEB-INF/include/resource.jsp"></jsp:include>
<style>
    .container {
        max-width: 100%;
        padding: 0 15px;
    }
    .card {
        border-radius: 0;
        box-shadow: none;
    }
    .card-body {
        padding: 20px;
        position: relative;
    }
    .btn-primary {
        background-color: #003366 !important;
        border-color: #003366 !important;
        color: white !important;
        font-weight: 500;
        border-radius: 6px;
    }
    .btn-primary:hover {
        background-color: #002244 !important;
        border-color: #002244 !important;
    }
    .btn-submit {
        background-color: #003366 !important;
        border-color: #003366 !important;
        color: white !important;
        font-weight: 600;
    }
    .btn-submit:hover {
        background-color: #002244 !important;
        border-color: #002244 !important;
        color: white !important;
    }
    .btn-cancel {
        background-color: #7f8c8d;
        color: white;
        font-weight: 600;
    }
    .btn-cancel:hover {
        background-color: #636e72;
    }
    
</style>
</head>
<body>

	<div class="container mt-4">
	    <!-- Breadcrumb -->
	    <nav aria-label="breadcrumb" class="mb-3">
	        <ol class="breadcrumb">
	            <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/headquater.jsp?page=index/headquaterindex.jsp">홈</a></li>
	            <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/list.jsp">지점 목록</a></li>
	            <li class="breadcrumb-item">
	                <a href="<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/detail.jsp?num=<%=dto.getBranch_num()%>">지점 상세보기</a>
	            </li>
	            <li class="breadcrumb-item active" aria-current="page">직원 상세정보</li>
	        </ol>
	    </nav>
	
	    <div class="card shadow-sm">
	        <div class="card-header bg-primary text-white">
	            <h4 class="mb-0">직원 상세 정보</h4>
	        </div>
	        <div class="card-body">
	            <form action="${pageContext.request.contextPath}/branch-admin/roleupdate.jsp" method="get">
	                <input type="hidden" name="returnUrl" value="<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/detail.jsp?num=<%=dto.getBranch_num()%>">
	                <input type="hidden" name="num" value="<%=dto.getNum()%>">
	
					<!-- 테이블 -->
					<table class="table table-bordered align-middle w-75 mx-auto">
					    <tr>
					        <th class="table-secondary" style="width: 25%;">회원 아이디</th>
					        <td><%= dto.getUser_id() %></td>
					    </tr>
					    <tr>
					        <th class="table-secondary">지점명</th>
					        <td><%= dto.getBranch_name() %></td>
					    </tr>
					    <tr>
					        <th class="table-secondary">이름</th>
					        <td><%= dto.getUser_name() %></td>
					    </tr>
					    <tr>
					        <th class="table-secondary">등급</th>
					        <td>
					            <select name="role" id="role" class="form-select w-auto">
					                <option value="manager" <%= dto.getRole().equals("manager") ? "selected" : "" %>>사장님</option>
					                <option value="clerk" <%= dto.getRole().equals("clerk") ? "selected" : "" %>>직원</option>
					                <option value="unapproved" <%= dto.getRole().equals("unapproved") ? "selected" : "" %>>미등록</option>
					            </select>
					        </td>
					    </tr>
					    <tr>
					        <th class="table-secondary">연락처</th>
					        <td><%= dto.getPhone() %></td>
					    </tr>
					    <tr>
					        <th class="table-secondary">주소지</th>
					        <td><%= dto.getLocation() %></td>
					    </tr>
					    <tr>
					        <th class="table-secondary">등록일</th>
					        <td><%= dto.getCreated_at() %></td>
					    </tr>
					    <tr>
					        <th class="table-secondary">수정일</th>
					        <td><%= dto.getUpdated_at() == null ? "" : dto.getUpdated_at() %></td>
					    </tr>
					</table>
					
					<!-- 수정 버튼: 테이블 아래 우측 정렬 -->
					<div class="w-75 mx-auto text-end mt-3">					    
					    <a class="btn btn-cancel" href="<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/detail.jsp?num=<%=dto.getBranch_num()%>">취소</a>
					    <button type="submit" class="btn btn-submit">수정</button>
					</div>
					
				</form>
	        </div>
	    </div>
	</div>

</body>
</html>

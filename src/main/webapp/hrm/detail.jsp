<%@page import="dao.HrmDao"%>
<%@page import="dto.HrmDto"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    int num = Integer.parseInt(request.getParameter("num"));
    HrmDto dto = new HrmDao().getByNum(num);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>직원 상세 정보</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="p-0">

<div class="container-fluid">
    <div class="card shadow-sm" style="width: 100%;">
        <div class="card-header bg-primary text-white">
            <h4 class="mb-0">직원 상세 정보</h4>
        </div>
        <div class="card-body">
            <% if (dto != null) { %>
                <div class="text-center mb-4">
                    <% if (dto.getProfileImage() != null && !dto.getProfileImage().isEmpty()) { %>
                        <img src="<%=request.getContextPath() + "/image?name=" + dto.getProfileImage()%>" 
                             alt="프로필 이미지" 
                             class="img-thumbnail" 
                             style="max-width: 180px; max-height: 180px;">
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

                <div class="text-center mt-4">
                    <a href="<%= request.getContextPath() %>/headquater.jsp?page=hrm/list.jsp" 
                       class="btn btn-secondary">← 목록으로</a>
                </div>
            <% } else { %>
                <div class="alert alert-danger text-center">
                    존재하지 않는 직원입니다.
                </div>
                <div class="text-center">
                    <a href="<%= request.getContextPath() %>/headquater.jsp?page=hrm/list.jsp" 
                       class="btn btn-secondary">← 목록으로</a>
                </div>
            <% } %>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

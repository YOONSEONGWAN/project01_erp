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
    <title>직원 상세</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f9f9f9;
            margin: 40px;
            color: #333;
        }
        h1 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 30px;
            font-weight: 700;
        }
        table {
            margin: 0 auto;
            border-collapse: collapse;
            width: 80%;
            max-width: 700px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            background-color: white;
            border-radius: 8px;
            overflow: hidden;
        }
        th, td {
            padding: 14px 20px;
            text-align: left;
            border-bottom: 1px solid #ddd;
            font-size: 1rem;
        }
        th {
            background-color: #34495e;
            color: #ecf0f1;
            font-weight: 600;
            width: 150px;
        }
        tr:hover {
            background-color: #f1f8ff;
        }
        .hrm-img {
            display: block;
            margin: 0 auto;
            max-width: 150px;
            height: auto;
            border-radius: 8px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.15);
        }
        .btn-link {
            display: inline-block;
            margin: 20px auto;
            padding: 10px 25px;
            background-color: #2980b9;
            color: white;
            text-decoration: none;
            font-weight: 600;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }
        .btn-link:hover {
            background-color: #1c5980;
        }
        p.error-message {
            text-align: center;
            color: #e74c3c;
            font-weight: 700;
            font-size: 1.2rem;
            margin-top: 50px;
        }
        .btn-container {
            text-align: center;
            margin-top: 30px;
        }
    </style>
</head>
<body>
    <h1>직원 상세 정보</h1>
    
   <% if (dto != null) { %>
    <table>
        <% if (dto.getProfileImage() != null && !dto.getProfileImage().isEmpty()) { %>
        <tr>
            <th>이미지</th>
            <td>
                <img src="<%=request.getContextPath() + "/image?name=" + dto.getProfileImage()%>" alt="프로필 이미지" class="hrm-img">
            </td>
        </tr>
        <% } %>
        
        <tr><th>번호</th><td><%=dto.getNum()%></td></tr>
        <tr><th>이름</th><td><%=dto.getName()%></td></tr>
        <tr><th>직급</th><td><%=dto.getRole()%></td></tr>
        <tr><th>지점</th><td><%=dto.getBranchName()%></td></tr>
        <tr><th>전화번호</th><td><%=dto.getPhone()%></td></tr>
        <tr><th>주소</th><td><%=dto.getLocation()%></td></tr>
    </table>
    
    <div class="btn-container">
        <a href="<%= request.getContextPath() %>/hrm/edit?num=<%= dto.getNum() %>" class="btn-link">사진등록</a>
    </div>
<% } else { %>
    <p class="error-message">존재하지 않는 직원입니다.</p>
<% } %>

<div class="btn-container">
    <a href="list.jsp" class="btn-link" style="background-color:#7f8c8d;">← 목록으로</a>
</div>
</body>
</html>

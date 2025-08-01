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
        .hrm-img {
            width: 150px;
            height: auto;
        }
    </style>

    
</head>
<body>
    <h1>직원 상세 정보</h1>
    
   <% if (dto != null) { %>
    <table border="1" cellpadding="10">
        <% if (dto.getProfileImage() != null && !dto.getProfileImage().isEmpty()) { %>
        <tr>
            <th>이미지</th>
            <td>
                <img src="<%=request.getContextPath() + "/image?name=" + dto.getProfileImage()%>" class="hrm-img">
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
    <br>
    <a href="<%= request.getContextPath() %>/hrm/edit?num=<%= dto.getNum() %>">사진등록</a>
<% } else { %>
    <p style="color:red; font-weight:bold;">존재하지 않는 직원입니다.</p>
<% } %>

<a href="list.jsp">← 목록으로</a>
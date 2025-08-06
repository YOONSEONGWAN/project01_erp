<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dto.HrmDto" %>
<%
    HrmDto dto = (HrmDto)request.getAttribute("dto");
    if (dto == null) {
        out.println("ERROR: dto가 null입니다. 데이터를 확인하세요.");
        return;
    }
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>프로필 이미지 등록</title>
</head>
<body>
<h1>프로필 이미지 등록</h1>
<form action="<%= contextPath %>/hrm/register" method="post" enctype="multipart/form-data">
    <input type="hidden" name="num" value="<%= dto.getNum() %>">
    
    <label>이름: </label>
    <input type="text" name="name" value="<%= dto.getName() %>" readonly /><br/>

    <label>직급: </label>
    <input type="text" name="role" value="<%= dto.getRole() %>" readonly /><br/>

    <label>기존 이미지: </label>
    <% if (dto.getProfileImage() != null && !dto.getProfileImage().isEmpty()) { %>
       <img src="<%= contextPath %>/image?name=<%= dto.getProfileImage() %>" width="100" alt="프로필 이미지" />
       <br/>
    <% } else { %>
        없음<br/>
    <% } %>

    <label>이미지 변경: </label>
    <input type="file" name="profile_image" accept="image/*" /><br/>

    <button type="submit">수정</button>
    <button type="button" onclick="location.href='<%= contextPath %>/headquater.jsp?page=hrm/detail.jsp&num=<%= dto.getNum() %>';">취소</button>
</form>

</body>
</html>

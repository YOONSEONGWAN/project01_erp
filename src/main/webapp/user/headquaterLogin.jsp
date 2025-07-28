<%@page import="org.mindrot.jbcrypt.BCrypt"%>
<%@page import="dao.UserDao"%>
<%@page import="dto.UserDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String name = request.getParameter("name");
    String password = request.getParameter("password");
    String url = request.getParameter("url");

    UserDto dto = UserDao.getInstance().getByName(name);

    boolean hashedPassword = false;

    if (dto != null) {
        
        hashedPassword = BCrypt.checkpw(password, dto.getPassword());

        if (hashedPassword) {
            session.setAttribute("name", name);
            
        }
    }
    session.setAttribute("userName", dto.getName());
    session.setMaxInactiveInterval(60*60);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>headquaterLogin</title>
</head>
<body>
    <script>
    <% if (dto == null) { %>
        alert("해당 사용자 정보가 없습니다.");
        location.href = "headquaterLoginForm.jsp";
    <% } else if (!hashedPassword) { %>
        alert("비밀번호가 일치하지 않습니다.");
        location.href = "headquaterLoginForm.jsp";
    <% } else { %>
        alert("본사 페이지로 이동합니다.");
        location.href = "<%= request.getContextPath() %>/index/headquaterindex.jsp";
    <% } %>
    </script>
</body>
</html>

<%@page import="dao.HrmDao"%>
<%@page import="dto.HrmDto"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    int num = Integer.parseInt(request.getParameter("num"));
    HrmDto dto = new HrmDao().getByNum(num);
%>

<h1>직원 상세 정보</h1>

<% if (dto != null) { %>
    <table class="hrm-detail-table">
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
        <a href="<%= request.getContextPath() %>/headquater.jsp?page=hrm/list.jsp" class="btn-link btn-back">← 목록으로</a>
    </div>
<% } else { %>
    <p class="error-message">존재하지 않는 직원입니다.</p>
<% } %>

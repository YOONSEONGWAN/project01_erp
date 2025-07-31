<%@page import="dao.HrmDao"%>
<%@page import="dto.HrmDto"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    HrmDao dao = new HrmDao();
    List<HrmDto> hqList = dao.selectHeadOffice();  // 본사 직원 리스트
    List<HrmDto> branchList = dao.selectBranch();  // 지점 직원 리스트
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/hrm/list.jsp</title>

<style>
.tab-button {
    padding: 10px 20px;
    cursor: pointer;
    background: #f0f0f0;
    border: 1px solid #ccc;
    display: inline-block;
}
.tab-button.active {
    background: #ddd;
    font-weight: bold;
}
.tab-content {
    display: none;
    margin-top: 20px;
}
.tab-content.active {
    display: block;
}
</style>

</head>
<body>
	<div>
    <div>
        <span class="tab-button active" id="btn-hq" onclick="showTab('hq')">본사 직원</span>
        <span class="tab-button" id="btn-branch" onclick="showTab('branch')">지점 직원</span>
    </div>

    <div class="tab-content active" id="hq">
        <h2>본사 직원 목록</h2>
        <table>
            <tr><th>번호</th><th>이름</th><th>직급</th><th>상세 페이지</th><th>삭제</th></tr>
            <% for(HrmDto dto : hqList){ %>
                <tr>
                    <td><%= dto.getNum() %></td>
                    <td><%= dto.getName() %></td>
                    <td><%= dto.getRole() %></td>
                    <td><a href="detail.jsp?num=<%= dto.getNum() %>">상세 페이지</a></td>
             	    <td>
                    	<a href="<%=request.getContextPath()%>/product/delete.jsp?num=<%= dto.getNum() %>" onclick="return confirm('삭제하시겠습니까?');">삭제</a>
                </td>
                </tr>
            <% } %>
        </table>
    </div>

    <div class="tab-content" id="branch">
        <h2>지점 직원 목록</h2>
        <table>
            <tr><th>번호</th><th>이름</th><th>직급</th><th>지점</th><th>상세 페이지</th><th>삭제</th></tr>
            <% for(HrmDto dto : branchList){ %>
                <tr>
                    <td><%= dto.getNum() %></td>
                    <td><%= dto.getName() %></td>
                    <td><%= dto.getRole() %></td>
                    <td><%= dto.getBranchName() %></td>
                    <td><a href="detail.jsp?num=<%= dto.getNum() %>">상세 페이지</a></td>
             	    <td>
                    	<a href="<%=request.getContextPath()%>/product/delete.jsp?num=<%= dto.getNum() %>" onclick="return confirm('삭제하시겠습니까?');">삭제</a>
                </tr>
            <% } %>
        </table>
    </div>
</div>

	<script>
		function showTab(tabName) {
		    const tabs = document.querySelectorAll('.tab-content');
		    const buttons = document.querySelectorAll('.tab-button');
		    tabs.forEach(tab => tab.classList.remove('active'));
		    buttons.forEach(btn => btn.classList.remove('active'));
		    document.getElementById(tabName).classList.add('active');
		    document.getElementById('btn-' + tabName).classList.add('active');
		}
	</script>	
</body>
</html>
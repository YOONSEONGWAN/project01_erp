<%@page import="dao.HrmDao"%>
<%@page import="dto.HrmDto"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String from = request.getParameter("from");
    String hqKeyword = request.getParameter("hqKeyword");
    String branchKeyword = request.getParameter("branchKeyword");

    if (hqKeyword == null) hqKeyword = "";
    if (branchKeyword == null) branchKeyword = "";

    HrmDao dao = new HrmDao();

    // 검색어 기반으로 필터링 
    List<HrmDto> hqList = dao.selectHeadOfficeByKeyword(hqKeyword);
    List<HrmDto> branchList = dao.selectBranchByKeyword(branchKeyword);

    String backUrl = "admin.jsp";
    if ("branch".equals(from)) backUrl = "branch.jsp";
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
		        <!-- 본사 직원 검색 폼 -->
		<form method="get" action="list.jsp">
		    <input type="hidden" name="from" value="admin">
		    <input type="text" name="hqKeyword" placeholder="이름 또는 직급 검색" value="<%= request.getParameter("hqKeyword") == null ? "" : request.getParameter("hqKeyword") %>">
		    <button type="submit">검색</button>
		</form>
        
        <table>
            <tr><th>번호</th><th>이름</th><th>직급</th><th>상세 보기</th><th>삭제</th></tr>
            <% for(HrmDto dto : hqList){ %>
                <tr>
                    <td><%= dto.getNum() %></td>
                    <td><%= dto.getName() %></td>
                    <td><%= dto.getRole() %></td>
                    <td><a href="detail.jsp?num=<%= dto.getNum() %>&from=admin">상세 보기</a></td>
             	    <td>
                    	<a href="<%=request.getContextPath()%>/hrm/delete.jsp?num=<%= dto.getNum() %>" onclick="return confirm('삭제하시겠습니까?');">삭제</a>
                </td>
                </tr>
            <% } %>
        </table>
    </div>

    <div class="tab-content" id="branch">
        <h2>지점 직원 목록</h2>
		        <!-- 지점 직원 검색 폼 -->
		<form method="get" action="list.jsp">
		    <input type="hidden" name="from" value="branch">
		    <input type="text" name="branchKeyword" placeholder="이름 또는 지점 검색" value="<%= request.getParameter("branchKeyword") == null ? "" : request.getParameter("branchKeyword") %>">
		    <button type="submit">검색</button>
		</form>
        <table>
            <tr><th>번호</th><th>이름</th><th>직급</th><th>지점</th><th>상세 페이지</th><th>삭제</th></tr>
            <% for(HrmDto dto : branchList){ %>
                <tr>
                    <td><%= dto.getNum() %></td>
                    <td><%= dto.getName() %></td>
                    <td><%= dto.getRole() %></td>
                    <td><%= dto.getBranchName() %></td>
                    <td><a href="detail.jsp?num=<%= dto.getNum() %>&from=branch">상세 보기</a></td>
             	    <td>
                    	<a href="<%=request.getContextPath()%>/hrm/delete.jsp?num=<%= dto.getNum() %>" onclick="return confirm('삭제하시겠습니까?');">삭제</a>
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

	// ⛳ 페이지 로딩 시 URL에서 from 파라미터 읽어서 탭 자동 설정
	window.onload = function() {
	    const params = new URLSearchParams(window.location.search);
	    const from = params.get('from');
	    if (from === 'branch') {
	        showTab('branch');
	    } else {
	        showTab('hq');  // 기본값
	    }
	}
	function showTab(tabName) {
	    const tabs = document.querySelectorAll('.tab-content');
	    const buttons = document.querySelectorAll('.tab-button');
	    tabs.forEach(tab => tab.classList.remove('active'));
	    buttons.forEach(btn => btn.classList.remove('active'));
	    document.getElementById(tabName).classList.add('active');
	    document.getElementById('btn-' + tabName).classList.add('active');

	    // ✅ 탭 상태 저장
	    localStorage.setItem("selectedTab", tabName);
	}

	window.onload = function () {
	    const urlParams = new URLSearchParams(window.location.search);
	    const from = urlParams.get('from');
	    
	    // 1순위: URL 파라미터
	    if (from === 'branch') {
	        showTab('branch');
	    } else if (from === 'admin') {
	        showTab('hq');
	    } 
	    // 2순위: localStorage
	    else {
	        const savedTab = localStorage.getItem("selectedTab");
	        showTab(savedTab || 'hq');
	    }
	};

</script>
	
</body>
</html>
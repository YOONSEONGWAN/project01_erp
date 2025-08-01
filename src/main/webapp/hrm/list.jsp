<%@page import="dao.HrmDao"%>
<%@page import="dto.HrmDto"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    // from 값은 admin (본사) or branch (지점) 만 허용
    String from = request.getParameter("from");
    if(from == null || (!from.equals("admin") && !from.equals("branch"))) {
        from = "admin";
    }

    String hqKeyword = request.getParameter("hqKeyword");
    if(hqKeyword == null) hqKeyword = "";

    String branchKeyword = request.getParameter("branchKeyword");
    if(branchKeyword == null) branchKeyword = "";

    int hqPageNum = 1;
    try {
        hqPageNum = Integer.parseInt(request.getParameter("hqPageNum"));
    } catch(Exception e) {}

    int branchPageNum = 1;
    try {
        branchPageNum = Integer.parseInt(request.getParameter("branchPageNum"));
    } catch(Exception e) {}

    HrmDao dao = new HrmDao();

    int hqPageSize = 10;
    int hqStart = (hqPageNum - 1) * hqPageSize;
    List<HrmDto> hqList = dao.selectHeadOfficeByKeywordWithPaging(hqKeyword, hqStart, hqPageSize);
    int hqTotalCount = dao.getHeadOfficeCountByKeyword(hqKeyword);
    int hqTotalPage = (int)Math.ceil(hqTotalCount / (double)hqPageSize);

    int branchPageSize = 10;
    int branchStart = (branchPageNum - 1) * branchPageSize;
    List<HrmDto> branchList = dao.selectBranchByKeywordWithPaging(branchKeyword, branchStart, branchPageSize);
    int branchTotalCount = dao.getBranchCountByKeyword(branchKeyword);
    int branchTotalPage = (int)Math.ceil(branchTotalCount / (double)branchPageSize);
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
            <span class="tab-button <%= "admin".equals(from) ? "active" : "" %>" id="btn-admin" onclick="showTab('admin')">본사 직원</span>
            <span class="tab-button <%= "branch".equals(from) ? "active" : "" %>" id="btn-branch" onclick="showTab('branch')">지점 직원</span>
        </div>

        <div class="tab-content <%= "admin".equals(from) ? "active" : "" %>" id="admin">
            <h2>본사 직원 목록</h2>
            <!-- 본사 직원 검색 폼 -->
            <form method="get" action="list.jsp">
                <input type="hidden" name="from" value="admin">
                <input type="text" name="hqKeyword" placeholder="이름 또는 직급 검색" value="<%= hqKeyword %>">
                <button type="submit">검색</button>
            </form>

            <table border="1" cellpadding="5" cellspacing="0">
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

            <!-- 본사 페이징 -->
            <div class="pagination">
                <% if (hqPageNum > 1) { %>
                    <a href="list.jsp?from=admin&hqPageNum=<%= hqPageNum - 1 %>&hqKeyword=<%= java.net.URLEncoder.encode(hqKeyword, "UTF-8") %>">이전</a>
                <% } else { %>
                    <span>이전</span>
                <% } %>

                <% for(int i=1; i <= hqTotalPage; i++) {
                    if(i == hqPageNum) { %>
                        <span class="current"><%= i %></span>
                    <% } else { %>
                        <a href="list.jsp?from=admin&hqPageNum=<%= i %>&hqKeyword=<%= java.net.URLEncoder.encode(hqKeyword, "UTF-8") %>"><%= i %></a>
                    <% }
                } %>

                <% if(hqPageNum < hqTotalPage) { %>
                    <a href="list.jsp?from=admin&hqPageNum=<%= hqPageNum + 1 %>&hqKeyword=<%= java.net.URLEncoder.encode(hqKeyword, "UTF-8") %>">다음</a>
                <% } else { %>
                    <span>다음</span>
                <% } %>
            </div>
        </div>

        <div class="tab-content <%= "branch".equals(from) ? "active" : "" %>" id="branch">
            <h2>지점 직원 목록</h2>
            <!-- 지점 직원 검색 폼 -->
            <form method="get" action="list.jsp">
                <input type="hidden" name="from" value="branch">
                <input type="text" name="branchKeyword" placeholder="이름 또는 지점 검색" value="<%= branchKeyword %>">
                <button type="submit">검색</button>
            </form>

            <table border="1" cellpadding="5" cellspacing="0">
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
                        </td>
                    </tr>
                <% } %>
            </table>

            <!-- 지점 페이징 -->
            <div class="pagination">
                <% if (branchPageNum > 1) { %>
                    <a href="list.jsp?from=branch&branchPageNum=<%= branchPageNum - 1 %>&branchKeyword=<%= java.net.URLEncoder.encode(branchKeyword, "UTF-8") %>">이전</a>
                <% } else { %>
                    <span>이전</span>
                <% } %>

                <% for(int i=1; i <= branchTotalPage; i++) {
                    if(i == branchPageNum) { %>
                        <span class="current"><%= i %></span>
                    <% } else { %>
                        <a href="list.jsp?from=branch&branchPageNum=<%= i %>&branchKeyword=<%= java.net.URLEncoder.encode(branchKeyword, "UTF-8") %>"><%= i %></a>
                    <% }
                } %>

                <% if(branchPageNum < branchTotalPage) { %>
                    <a href="list.jsp?from=branch&branchPageNum=<%= branchPageNum + 1 %>&branchKeyword=<%= java.net.URLEncoder.encode(branchKeyword, "UTF-8") %>">다음</a>
                <% } else { %>
                    <span>다음</span>
                <% } %>
            </div>
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

        // 탭 상태 저장
        localStorage.setItem("selectedTab", tabName);
    }

    window.onload = function () {
        const urlParams = new URLSearchParams(window.location.search);
        const from = urlParams.get('from');

        if (from === 'branch') {
            showTab('branch');
        } else if (from === 'admin') {
            showTab('admin');
        } else {
            const savedTab = localStorage.getItem("selectedTab");
            showTab(savedTab || 'admin');
        }
    };
    </script>
</body>
</html>

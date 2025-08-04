<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder, java.util.List, dao.HrmDao, dto.HrmDto" %>

<%
    // 탭 선택 (admin=본사, branch=지점)
    String from = request.getParameter("from");
    if (from == null || (!from.equals("admin") && !from.equals("branch"))) {
        from = "admin";
    }

    // 본사 키워드, 페이지
    String hqKeyword = request.getParameter("hqKeyword");
    if (hqKeyword == null) hqKeyword = "";

    int hqPageNum = 1;
    try {
        hqPageNum = Integer.parseInt(request.getParameter("hqPageNum"));
        if (hqPageNum < 1) hqPageNum = 1;
    } catch (Exception e) {}

    int hqPageSize = 10;
    int hqStart = (hqPageNum - 1) * hqPageSize;

    // 지점 키워드, 페이지
    String branchKeyword = request.getParameter("branchKeyword");
    if (branchKeyword == null) branchKeyword = "";

    int branchPageNum = 1;
    try {
        branchPageNum = Integer.parseInt(request.getParameter("branchPageNum"));
        if (branchPageNum < 1) branchPageNum = 1;
    } catch (Exception e) {}

    int branchPageSize = 10;
    int branchStart = (branchPageNum - 1) * branchPageSize;

    HrmDao dao = new HrmDao();

    // 본사 직원 목록, 총 개수, 총 페이지 계산
    List<HrmDto> hqList = dao.selectHeadOfficeByKeywordWithPaging(hqKeyword, hqStart, hqPageSize);
    int hqTotalCount = dao.getHeadOfficeCountByKeyword(hqKeyword);
    int hqTotalPage = (int) Math.ceil(hqTotalCount / (double) hqPageSize);

    // 지점 직원 목록, 총 개수, 총 페이지 계산
    List<HrmDto> branchList = dao.selectBranchByKeywordWithPaging(branchKeyword, branchStart, branchPageSize);
    int branchTotalCount = dao.getBranchCountByKeyword(branchKeyword);
    int branchTotalPage = (int) Math.ceil(branchTotalCount / (double) branchPageSize);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>직원 목록</title>
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
    table {
        width: 90%;
        border-collapse: collapse;
        margin: 20px auto;
    }
    th, td {
        border: 1px solid #ccc;
        padding: 10px;
        text-align: center;
    }
    th {
        background-color: #f0f0f0;
    }
    .pagination {
        text-align: center;
        margin: 10px;
    }
    .pagination a, .pagination span {
        margin: 0 5px;
        text-decoration: none;
        color: blue;
    }
    .pagination span.current {
        font-weight: bold;
        color: black;
    }
</style>
</head>
<body>
    <div>
        <div>
            <span class="tab-button <%= "admin".equals(from) ? "active" : "" %>" id="btn-admin" onclick="showTab('admin')">본사 직원</span>
            <span class="tab-button <%= "branch".equals(from) ? "active" : "" %>" id="btn-branch" onclick="showTab('branch')">지점 직원</span>
        </div>

        <!-- 본사 직원 탭 -->
        <div class="tab-content <%= "admin".equals(from) ? "active" : "" %>" id="admin">
            <h2>본사 직원 목록</h2>
            <form method="get" action="list.jsp">
                <input type="hidden" name="from" value="admin">
                <input type="text" name="hqKeyword" placeholder="이름 또는 직급 검색" value="<%= hqKeyword %>">
                <button type="submit">검색</button>
            </form>

            <table>
                <tr><th>번호</th><th>이름</th><th>직급</th><th>상세 보기</th><th>삭제</th></tr>
                <%
                    int hqDisplayNum = (hqPageNum - 1) * hqPageSize + 1;
                    for(HrmDto dto : hqList) {
                %>
                <tr>
                    <td><%= hqDisplayNum++ %></td>
                    <td><%= dto.getName() %></td>
                    <td><%= dto.getRole() %></td>
                    <td><a href="detail.jsp?num=<%= dto.getNum() %>&from=admin">상세 보기</a></td>
                    <td>
                        <a href="<%= request.getContextPath() %>/hrm/delete.jsp?num=<%= dto.getNum() %>" onclick="return confirm('삭제하시겠습니까?');">삭제</a>
                    </td>
                </tr>
                <% } %>
            </table>

            <div class="pagination">
                <% if(hqPageNum > 1) { %>
                    <a href="list.jsp?from=admin&hqPageNum=<%= hqPageNum - 1 %>&hqKeyword=<%= URLEncoder.encode(hqKeyword, "UTF-8") %>">이전</a>
                <% } else { %>
                    <span>이전</span>
                <% } %>

                <% for(int i = 1; i <= hqTotalPage; i++) {
                    if(i == hqPageNum) { %>
                        <span class="current"><%= i %></span>
                    <% } else { %>
                        <a href="list.jsp?from=admin&hqPageNum=<%= i %>&hqKeyword=<%= URLEncoder.encode(hqKeyword, "UTF-8") %>"><%= i %></a>
                    <% }
                } %>

                <% if(hqPageNum < hqTotalPage) { %>
                    <a href="list.jsp?from=admin&hqPageNum=<%= hqPageNum + 1 %>&hqKeyword=<%= URLEncoder.encode(hqKeyword, "UTF-8") %>">다음</a>
                <% } else { %>
                    <span>다음</span>
                <% } %>
            </div>
        </div>

        <!-- 지점 직원 탭 -->
        <div class="tab-content <%= "branch".equals(from) ? "active" : "" %>" id="branch">
            <h2>지점 직원 목록</h2>
            <form method="get" action="list.jsp">
                <input type="hidden" name="from" value="branch">
                <input type="text" name="branchKeyword" placeholder="이름 또는 지점 검색" value="<%= branchKeyword %>">
                <button type="submit">검색</button>
            </form>

            <table>
                <tr><th>번호</th><th>이름</th><th>직급</th><th>지점</th><th>상세 보기</th><th>삭제</th></tr>
                <%
                    int branchDisplayNum = (branchPageNum - 1) * branchPageSize + 1;
                    for(HrmDto dto : branchList) {
                %>
                <tr>
                    <td><%= branchDisplayNum++ %></td>
                    <td><%= dto.getName() %></td>
                    <td><%= dto.getRole() %></td>
                    <td><%= dto.getBranchName() %></td>
                    <td><a href="detail.jsp?num=<%= dto.getNum() %>&from=branch">상세 보기</a></td>
                    <td>
                        <a href="<%= request.getContextPath() %>/hrm/delete.jsp?num=<%= dto.getNum() %>" onclick="return confirm('삭제하시겠습니까?');">삭제</a>
                    </td>
                </tr>
                <% } %>
            </table>

            <div class="pagination">
                <% if(branchPageNum > 1) { %>
                    <a href="list.jsp?from=branch&branchPageNum=<%= branchPageNum - 1 %>&branchKeyword=<%= URLEncoder.encode(branchKeyword, "UTF-8") %>">이전</a>
                <% } else { %>
                    <span>이전</span>
                <% } %>

                <% for(int i = 1; i <= branchTotalPage; i++) {
                    if(i == branchPageNum) { %>
                        <span class="current"><%= i %></span>
                    <% } else { %>
                        <a href="list.jsp?from=branch&branchPageNum=<%= i %>&branchKeyword=<%= URLEncoder.encode(branchKeyword, "UTF-8") %>"><%= i %></a>
                    <% }
                } %> 

                <% if(branchPageNum < branchTotalPage) { %>
                    <a href="list.jsp?from=branch&branchPageNum=<%= branchPageNum + 1 %>&branchKeyword=<%= URLEncoder.encode(branchKeyword, "UTF-8") %>">다음</a>
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

    localStorage.setItem("selectedTab", tabName);
}

window.onload = function() {
    const urlParams = new URLSearchParams(window.location.search);
    const fromParam = urlParams.get('from');
    if (fromParam === 'admin' || fromParam === 'branch') {
        showTab(fromParam);
    } else {
        const savedTab = localStorage.getItem("selectedTab");
        showTab(savedTab || 'admin');
    }
};
</script>

</body>
</html>

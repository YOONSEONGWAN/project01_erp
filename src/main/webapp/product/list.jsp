<%@ page import="java.util.List" %>
<%@ page import="dto.ProductDto" %>
<%@ page import="dao.ProductDao" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<%
    String keyword = request.getParameter("keyword");
    if (keyword == null) keyword = "";

    String strPageNum = request.getParameter("pageNum");
    int pageNum = 1;
    try {
        pageNum = Integer.parseInt(strPageNum);
        if(pageNum < 1) pageNum = 1;
    } catch (Exception e) {}

    int pageSize = 10;
    int startRowNum = (pageNum - 1) * pageSize + 1;
    int endRowNum = pageNum * pageSize;

    ProductDao dao = new ProductDao();
    int totalCount = dao.getCountByKeyword(keyword);
    int totalPage = (int)Math.ceil(totalCount / (double) pageSize);
    if (pageNum > totalPage) pageNum = totalPage == 0 ? 1 : totalPage;

    List<ProductDto> productList = dao.selectByPageAndKeyword(startRowNum, endRowNum, keyword);

    String encodedKeyword = "";
    try {
        encodedKeyword = java.net.URLEncoder.encode(keyword, "UTF-8");
    } catch (Exception e) {
        encodedKeyword = keyword;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>상품 검색 및 목록</title>
    <jsp:include page="/WEB-INF/include/resource.jsp"></jsp:include>
    <style>
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: center; }
        th { background-color: #f4f4f4; }
        input[type="text"] { width: 300px; padding: 6px; }
        input[type="submit"] { padding: 6px 12px; }
        .pagination { margin-top: 20px; text-align: center; }
        .pagination a, .pagination span {
            margin: 0 5px; padding: 5px 10px;
            border: 1px solid #ccc; text-decoration: none;
            color: #333;
        }
        .pagination .current {
            background-color: #666; color: white;
            font-weight: bold;
        }
        .btn-register {
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
	<jsp:include page="/WEB-INF/include/navbar.jsp">
		<jsp:param value="branch-sales" name="thisPage"/>
	</jsp:include>
<!-- 상품 등록 버튼 -->
<form action="<%=request.getContextPath()%>/product/insertform.jsp" method="get" class="btn-register">
    <input type="submit" value="상품 등록" />
</form>

<h2>상품 검색 및 목록</h2>

<!-- 검색 폼 -->
<form action="<%=request.getContextPath()%>/product/list.jsp" method="get">
    <input type="text" name="keyword" placeholder="상품명 또는 설명 검색" value="<%= keyword %>" />
    <input type="submit" value="검색" />
</form>

<!-- 상품 테이블 -->
<form action="<%=request.getContextPath()%>/product/delete_checked.jsp" method="post" onsubmit="return confirm('선택한 상품을 삭제하시겠습니까?');">
    <table>
        <thead>
            <tr>
                <th><input type="checkbox" id="checkAll" onclick="toggleAll(this)"/></th>
                <th>번호</th>
                <th>상품명</th>
                <th>설명</th>
                <th>가격</th>
                <th>상태</th>
                <th>수정</th>
                <th>삭제</th>
            </tr>
        </thead>
        <tbody>
        <%
            if(productList == null || productList.isEmpty()) {
        %>
            <tr><td colspan="8">검색 결과가 없습니다.</td></tr>
        <%
            } else {
                int listSize = productList.size();
                for(int i = 0; i < listSize; i++) {
                    ProductDto dto = productList.get(i);
                    int number = totalCount - ((pageNum - 1) * pageSize + i);
        %>
            <tr>
                <td><input type="checkbox" name="productNums" value="<%= dto.getNum() %>"></td>
                <td><%= number %></td>
                <td><a href="detail.jsp?num=<%= dto.getNum() %>"><%= dto.getName() %></a></td>
                <td><%= dto.getDescription() %></td>
                <td><%= dto.getPrice() %>원</td>
                <td><%= dto.getStatus() %></td>
                <td><a href="updateform.jsp?num=<%= dto.getNum() %>">수정</a></td>
                <td>
                    <a href="<%=request.getContextPath()%>/product/delete.jsp?num=<%= dto.getNum() %>" onclick="return confirm('삭제하시겠습니까?');">삭제</a>
                </td>
            </tr>
        <%
                }
            }
        %>
        </tbody>
    </table>
    <input type="submit" value="선택 삭제" />
</form>

<!-- 페이지 네비게이션 -->
<div class="pagination">
    <% if(pageNum > 1) { %>
        <a href="list.jsp?pageNum=<%= pageNum - 1 %>&keyword=<%= encodedKeyword %>">이전</a>
    <% } else { %>
        <span>이전</span>
    <% } %>

    <% for(int i = 1; i <= totalPage; i++) {
        if(i == pageNum) { %>
            <span class="current"><%= i %></span>
        <% } else { %>
            <a href="list.jsp?pageNum=<%= i %>&keyword=<%= encodedKeyword %>"><%= i %></a>
        <% }
    } %>

    <% if(pageNum < totalPage) { %>
        <a href="list.jsp?pageNum=<%= pageNum + 1 %>&keyword=<%= encodedKeyword %>">다음</a>
    <% } else { %>
        <span>다음</span>
    <% } %>
</div>
<script>
	function toggleAll(source) {
	    const checkboxes = document.querySelectorAll('input[name="productNums"]');
	    checkboxes.forEach(cb => cb.checked = source.checked);
	}
</script>

</body>
</html>

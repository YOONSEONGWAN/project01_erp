<%@ page import="java.util.List" %>
<%@ page import="dto.ProductDto" %>
<%@ page import="dao.ProductDao" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<%
    // 검색어 받기 + 기본값 처리
    String keyword = request.getParameter("keyword");
    if (keyword == null) keyword = "";

    // 페이지 번호 받기 + 기본값 1
    String strPageNum = request.getParameter("pageNum");
    int pageNum = 1;
    try {
        pageNum = Integer.parseInt(strPageNum);
        if(pageNum < 1) pageNum = 1;
    } catch (Exception e) {}

    // 페이징 설정
    int pageSize = 10;
    int startRowNum = (pageNum - 1) * pageSize + 1;
    int endRowNum = pageNum * pageSize;

    ProductDao dao = new ProductDao();

    // 총 검색 결과 개수
    int totalCount = dao.getCountByKeyword(keyword);

    // 총 페이지 수 (올림 처리)
    int totalPage = (int) Math.ceil(totalCount / (double) pageSize);

    // 현재 페이지가 총 페이지를 초과하면 마지막 페이지로 보정
    if (pageNum > totalPage) pageNum = totalPage == 0 ? 1 : totalPage;

    // 목록 조회
    List<ProductDto> productList = dao.selectByPageAndKeyword(startRowNum, endRowNum, keyword);

    // 키워드 인코딩 (페이징 링크용)
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
<table>
    <thead>
        <tr>
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
        <% if(productList == null || productList.isEmpty()) { %>
            <tr><td colspan="7">검색 결과가 없습니다.</td></tr>
        <% } else {
            for(ProductDto dto : productList) { %>
            <tr>
                <td><%= dto.getNum() %></td>
                <td><a href="detail.jsp?num=<%= dto.getNum() %>"><%= dto.getName() %></a></td>
                <td><%= dto.getDescription() %></td>
                <td><%= dto.getPrice() %>원</td>
                <td><%= dto.getStatus() %></td>
                <td><a href="updateform.jsp?num=<%= dto.getNum() %>">수정</a></td>
                <td>
                    <a href="<%=request.getContextPath()%>/product/delete.jsp?num=<%= dto.getNum() %>" onclick="return confirm('삭제하시겠습니까?');">삭제</a>
                </td>
            </tr>
        <%  }
        } %>
    </tbody>
</table>

<!-- 페이지 네비게이션 -->
<div class="pagination">
    <% if(pageNum > 1) { %>
        <a href="<%=request.getContextPath()%>/product/list.jsp?pageNum=<%= pageNum - 1 %>&keyword=<%= encodedKeyword %>">이전</a>
    <% } else { %>
        <span>이전</span>
    <% } %>

    <% for(int i = 1; i <= totalPage; i++) {
        if(i == pageNum) { %>
            <span class="current"><%= i %></span>
        <% } else { %>
            <a href="<%=request.getContextPath()%>/product/list.jsp?pageNum=<%= i %>&keyword=<%= encodedKeyword %>"><%= i %></a>
        <% }
    } %>

    <% if(pageNum < totalPage) { %>
        <a href="<%=request.getContextPath()%>/product/list.jsp?pageNum=<%= pageNum + 1 %>&keyword=<%= encodedKeyword %>">다음</a>
    <% } else { %>
        <span>다음</span>
    <% } %>
</div>

</body>
</html>

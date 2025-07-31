<%@page import="dto.ProductDto"%>
<%@page import="dao.ProductDao"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // 페이지 번호 읽기 (기본 1)
    int pageNum = 1;
    String strPageNum = request.getParameter("pageNum");
    if(strPageNum != null) {
        try {
            pageNum = Integer.parseInt(strPageNum);
        } catch (Exception e) {
            pageNum = 1;
        }
    }

    final int PAGE_ROW_COUNT = 5;   // 한 페이지에 표시할 행 수
    final int PAGE_DISPLAY_COUNT = 3; // 페이지 링크 몇 개 보여줄지

    int startRowNum = 1 + (pageNum - 1) * PAGE_ROW_COUNT;
    int endRowNum = pageNum * PAGE_ROW_COUNT;

    ProductDao dao = new ProductDao();
    int totalRow = dao.getCount();  // 전체 게시물 수

    List<ProductDto> list = dao.selectByPage(startRowNum, endRowNum);

    // 페이지 링크 계산
    int startPageNum = 1 + ((pageNum - 1) / PAGE_DISPLAY_COUNT) * PAGE_DISPLAY_COUNT;
    int endPageNum = startPageNum + PAGE_DISPLAY_COUNT - 1;

    int totalPageCount = (int)Math.ceil(totalRow / (double)PAGE_ROW_COUNT);
    if(endPageNum > totalPageCount) endPageNum = totalPageCount;
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 목록</title>

</head>
<body>
<div class="container">
    <a href="insertform.jsp">상품 등록</a>
    <h1>상품 목록</h1>
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
            <% for(ProductDto dto : list) { %>
            <tr>
                <td><%= dto.getNum() %></td>
                <td><a href="detail.jsp?num=<%= dto.getNum() %>"><%= dto.getName() %></a></td>
                <td><%= dto.getDescription() %></td>
                <td><%= dto.getPrice() %></td>
                <td><%= dto.getStatus() %></td>
                <td><a href="updateform.jsp?num=<%= dto.getNum() %>">수정</a></td>
                <td>
                    <a href="<%=request.getContextPath()%>/product/delete.jsp?num=<%= dto.getNum() %>" onclick="return confirm('삭제하시겠습니까?');">삭제</a>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>

    <div class="pagination">
        <% if(pageNum > 1) { %>
            <a href="list.jsp?pageNum=<%= pageNum - 1 %>">이전</a>
        <% } %>

        <% for(int i = startPageNum; i <= endPageNum; i++) { %>
            <% if(i == pageNum) { %>
                <span class="current"><%= i %></span>
            <% } else { %>
                <a href="list.jsp?pageNum=<%= i %>"><%= i %></a>
            <% } %>
        <% } %>

        <% if(pageNum < totalPageCount) { %>
            <a href="list.jsp?pageNum=<%= pageNum + 1 %>">다음</a>
        <% } %>
    </div>
</div>
</body>
</html>

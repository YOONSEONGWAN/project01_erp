<%@ page import="java.util.List" %>
<%@ page import="dto.ProductDto" %>
<%@ page import="dao.ProductDao" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<%
    request.setCharacterEncoding("UTF-8");

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
    <title>상품 관리</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light p-4">

<div class="container bg-white p-4 rounded shadow-sm">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold">상품 관리</h3>
        <form action="<%=request.getContextPath()%>/headquater.jsp" method="get">
            <input type="hidden" name="page" value="product/insertform.jsp" />
            <button type="submit" class="btn btn-primary">
                <i class="bi bi-plus-circle"></i> 상품 등록
            </button>
        </form>
    </div>

   <!-- 검색 폼 -->
	<form action="<%=request.getContextPath()%>/headquater.jsp" method="get" 
	      class="d-flex justify-content-end mb-3">
	    <input type="hidden" name="page" value="product/list.jsp" />
	    <input type="hidden" name="pageNum" value="1" />
	    <input type="text" name="keyword" 
	           class="form-control me-2" 
	           placeholder="상품명 또는 설명 검색" 
	           value="<%= keyword %>" 
	           style="max-width: 300px;" />
	    <button type="submit" class="btn btn-primary">검색</button>
	</form>


    <!-- 상품 테이블 -->
    <form action="<%=request.getContextPath()%>/product/delete_checked.jsp" method="post" 
          onsubmit="return confirm('선택한 상품을 삭제하시겠습니까?');">
        <input type="hidden" name="pageNum" value="<%=pageNum%>">
        <input type="hidden" name="keyword" value="<%=keyword%>">

        <div class="table-responsive">
            <table class="table table-hover align-middle">
               <thead class="table-secondary">
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
                    <tr><td colspan="8" class="text-center text-muted py-4">검색 결과가 없습니다.</td></tr>
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
                        <td>
                            <a href="<%=request.getContextPath()%>/headquater.jsp?page=product/detail.jsp&num=<%= dto.getNum() %>" class="text-decoration-none fw-semibold text-primary">
                                <%= dto.getName() %>
                            </a>
                        </td>
                        <td class="text-muted"><%= dto.getDescription() %></td>
                        <td><%= dto.getPrice() %>원</td>
                        <td>
                            <% if("판매중".equals(dto.getStatus())) { %>
                                <span class="badge bg-success"><%= dto.getStatus() %></span>
                            <% } else { %>
                                <span class="badge bg-secondary"><%= dto.getStatus() %></span>
                            <% } %>
                        </td>
                        <td>
                            <a href="<%=request.getContextPath()%>/headquater.jsp?page=product/updateform.jsp&num=<%= dto.getNum() %>" class="btn btn-sm btn-outline-warning">수정</a>
                        </td>
                        <td>
                            <a href="<%=request.getContextPath()%>/product/delete.jsp?num=<%= dto.getNum() %>&pageNum=<%= pageNum %>&keyword=<%= encodedKeyword %>" 
                               onclick="return confirm('삭제하시겠습니까?');" 
                               class="btn btn-sm btn-outline-danger">삭제</a>
                        </td>
                    </tr>
                <%
                        }
                    }
                %>
                </tbody>
            </table>
        </div>

        <button type="submit" class="btn btn-danger btn-sm mt-2">선택 삭제</button>
    </form>

    <!-- 페이지 네비게이션 -->
    <nav aria-label="Page navigation" class="mt-4">
        <ul class="pagination justify-content-center">
            <% if(pageNum > 1) { %>
                <li class="page-item">
                    <a class="page-link" href="<%=request.getContextPath()%>/headquater.jsp?page=product/list.jsp&pageNum=<%= pageNum - 1 %>&keyword=<%= encodedKeyword %>">이전</a>
                </li>
            <% } else { %>
                <li class="page-item disabled"><span class="page-link">이전</span></li>
            <% } %>

            <% for(int i = 1; i <= totalPage; i++) {
                if(i == pageNum) { %>
                    <li class="page-item active"><span class="page-link"><%= i %></span></li>
                <% } else { %>
                    <li class="page-item">
                        <a class="page-link" href="<%=request.getContextPath()%>/headquater.jsp?page=product/list.jsp&pageNum=<%= i %>&keyword=<%= encodedKeyword %>"><%= i %></a>
                    </li>
                <% }
            } %>

            <% if(pageNum < totalPage) { %>
                <li class="page-item">
                    <a class="page-link" href="<%=request.getContextPath()%>/headquater.jsp?page=product/list.jsp&pageNum=<%= pageNum + 1 %>&keyword=<%= encodedKeyword %>">다음</a>
                </li>
            <% } else { %>
                <li class="page-item disabled"><span class="page-link">다음</span></li>
            <% } %>
        </ul>
    </nav>
</div>

<script>
function toggleAll(source) {
    const checkboxes = document.querySelectorAll('input[name="productNums"]');
    checkboxes.forEach(cb => cb.checked = source.checked);
}
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

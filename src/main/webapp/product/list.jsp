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
    <style>
        a.text-primary {
            color: #000 !important;
            font-weight: 600;
        }

        .btn-primary {
            background-color: #003366 !important;
            border-color: #003366 !important;
            color: white !important;
            font-weight: 500;
            border-radius: 6px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
        }

        .btn-primary:hover {
            background-color: #002244 !important;
            border-color: #002244 !important;
            color: white !important;
        }

        .pagination .page-link {
            color: #003366 !important;
            border-color: #003366 !important;
        }

        .pagination .page-item.active .page-link {
            background-color: #003366 !important;
            border-color: #003366 !important;
            color: white !important;
        }

        .pagination .page-link:hover {
            background-color: #002244 !important;
            border-color: #002244 !important;
            color: white !important;
        }

        /* 링크 스타일 */
        .link-button {
            color: #0d6efd;
            text-decoration: none;
            background: none;
            border: none;
            padding: 0;
            font: inherit;
            cursor: pointer;
        }

        .link-button:hover,
        .link-button:focus {
            text-decoration: underline;
        }

        /* 테이블 전체 테두리, 접합부 모두 확실히 */
        .table-bordered {
            border: 1px solid #dee2e6 !important;
            border-collapse: collapse !important;
        }

        /* 헤더 : hrm/list.jsp와 동일하게, 부트스트랩 기본 table-secondary 스타일 */
       .table-bordered thead th {
		    background-color: #e9ecef !important;  /* hrm/list.jsp와 동일한 부트스트랩 table-secondary 색상 */
		    color: #212529 !important;              /* 진한 회색 (기본 텍스트색) */
		    border: 1px solid #dee2e6 !important;
		    vertical-align: middle !important;
		    text-align: center !important;
		}

        }

        /* 바디 : 흰 배경, 테두리 동일 */
        .table-bordered tbody td {
            background-color: #fff !important;
            border: 1px solid #dee2e6 !important;
            vertical-align: middle !important;
            text-align: center !important;
        }
    </style>
</head>
<body>

<div class="container-fluid bg-white p-4">
    <!-- breadcrumb -->
    <nav aria-label="breadcrumb" class="mb-3">
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/headquater.jsp">홈</a></li>
        <li class="breadcrumb-item active" aria-current="page">상품 관리</li>
        <li class="breadcrumb-item active" aria-current="page">상품 목록</li>
      </ol>
    </nav>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold">상품 목록</h3>
        <form action="<%=request.getContextPath()%>/headquater.jsp" method="get">
            <input type="hidden" name="page" value="product/insertform.jsp" />
            <button type="submit" class="btn btn-primary">
                <i class="bi bi-plus-circle"></i> 상품 등록
            </button>
        </form>
    </div>

    <!-- 검색 -->
    <form action="<%=request.getContextPath()%>/headquater.jsp" method="get" class="d-flex justify-content-end mb-3">
        <input type="hidden" name="page" value="product/list.jsp" />
        <input type="hidden" name="pageNum" value="1" />
        <input type="text" name="keyword" class="form-control me-2" placeholder="상품명 또는 설명 검색" value="<%= keyword %>" style="max-width: 300px;" />
        <button type="submit" class="btn btn-primary">검색</button>
    </form>

    <!-- 상품 목록 테이블 -->
    <form action="<%=request.getContextPath()%>/product/delete_checked.jsp" method="post" onsubmit="return confirm('선택한 상품을 삭제하시겠습니까?');">
        <input type="hidden" name="pageNum" value="<%=pageNum%>">
        <input type="hidden" name="keyword" value="<%=keyword%>">

        <div class="table-responsive">
            <table class="table table-bordered table-hover align-middle text-center">
                <thead class="table-secondary">
                    <tr>
                        <th><input type="checkbox" id="checkAll" onclick="toggleAll(this)"/></th>
                        <th>번호</th>
                        <th>상품명</th>
                        <th>설명</th>
                        <th>가격</th>
                        <th>상태</th>
                        <th>상세 보기</th>
                        <th>수정</th>
                        <th>삭제</th>
                    </tr>
                </thead>
                <tbody>
    <%
        if(productList == null || productList.isEmpty()) {
    %>
        <tr><td colspan="9" class="text-center text-muted py-4">검색 결과가 없습니다.</td></tr>
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
            <td><%= dto.getName() %></td>
            <td class="text-muted"><%= dto.getDescription() %></td>
            <td><%= dto.getPrice() %>원</td>
            <td style="color: black;"><%= dto.getStatus() %></td>
            <td>
                <a href="<%=request.getContextPath()%>/headquater.jsp?page=product/detail.jsp&num=<%= dto.getNum() %>" class="link-button">상세</a>
            </td>
            <td>
                <a href="<%=request.getContextPath()%>/headquater.jsp?page=product/updateform.jsp&num=<%= dto.getNum() %>" class="link-button">수정</a>
            </td>
            <td>
                <a href="<%=request.getContextPath()%>/product/delete.jsp?num=<%= dto.getNum() %>&pageNum=<%= pageNum %>&keyword=<%= encodedKeyword %>" onclick="return confirm('삭제하시겠습니까?');" class="link-button">삭제</a>
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

    <!-- 페이지네이션 -->
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

</body>
</html>

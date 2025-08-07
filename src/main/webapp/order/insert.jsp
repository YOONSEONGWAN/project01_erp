<%@page import="java.util.List"%>
<%@page import="dto.IngredientDto"%>
<%@page import="dao.IngredientDao"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    List<IngredientDto> allIngredients = IngredientDao.getInstance().selectAllProducts();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>발주 요청 입력</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
    h3 {
    text-align: left;
    font-weight: 800;
    font-size: 2.1rem;
    margin-top: 38px;
    margin-bottom: 28px;
    letter-spacing: 0.08em;
    text-shadow: 0 3px 14px #cbe6ff, 0 1.5px 0 #fff;
    
    position: relative;
    display: block;
}
         table { 
        border-collapse: collapse; 
        width: 650px; 
    }
    th, td { 
        border: 1px solid #136ec7;  /* 파란 테두리 */
        padding: 8px; 
        text-align: center; 
    }
    th {
        background: #136ec7;     /* 진한 파랑 헤더 */
        color: #fff;             /* 헤더 글씨 흰색 */
    }
    tr:nth-child(even) td {
        background: #e7f2fd;     /* 짝수행 연파랑 */
    }
    tr:nth-child(odd) td {
        background: #f4faff;     /* 홀수행 아주 연파랑 */
    }
    .req-input { 
        width: 60px; 
        border: 1px solid #136ec7;
        border-radius: 6px;
        padding: 4px 6px;
        background: #fff;
        transition: border 0.2s;
    }
    .req-input:focus {
        border: 2px solid #2986d5;
        background: #f0f8ff;
    }
    .add-row-btn, .req-btn {
        background: linear-gradient(90deg, #2986d5, #136ec7 85%);
        color: #fff;
        border: none;
        border-radius: 8px;
        padding: 8px 20px;
        font-weight: 600;
        font-size: 1em;
        cursor: pointer;
        margin: 10px 0;
        transition: background 0.2s, box-shadow 0.15s;
        box-shadow: 0 2px 10px rgba(33,100,180,0.08);
    }
    .add-row-btn:hover, .req-btn:hover {
        background: linear-gradient(90deg, #136ec7, #2986d5 85%);
        box-shadow: 0 4px 14px rgba(19,110,199,0.13);
    }
      
        
    </style>
    <script>
        function addRow() {
            const tbody = document.getElementById('order-table').querySelector('tbody');
            // rowCount: 현재 행 개수(샘플행 제외)
            const rowCount = tbody.querySelectorAll('tr:not(#sample-row-template)').length;
            const template = document.getElementById('sample-row-template');
            const newRow = template.cloneNode(true);
            newRow.removeAttribute('id');
            newRow.style.display = '';
            // 인덱스 치환
             newRow.innerHTML = newRow.innerHTML.replaceAll('[0]', '[' + rowCount + ']')
                                       .replaceAll('_0', '_' + rowCount);

            tbody.appendChild(newRow);

            setTimeout(() => {
                updateHidden(newRow.querySelector('select'), rowCount);
            }, 10);
        }

        // select 변경시 hidden값 채우기
        function updateHidden(sel, idx) {
            var opt = sel.options[sel.selectedIndex];
            document.querySelector('#items' + idx + '_branchNum').value = opt.dataset.branchnum;
            document.querySelector('#items' + idx + '_branchId').value = opt.dataset.branchid;
            document.querySelector('#items' + idx + '_inventoryId').value = opt.dataset.inventoryid;
            document.querySelector('#items' + idx + '_currentQuantity').value = opt.dataset.currentqty;
        }

        // 페이지 로드시 첫 행의 hidden값도 세팅
        window.onload = function() {
            var selects = document.querySelectorAll('select[name^="items"]');
            selects.forEach(function(sel, idx){
                updateHidden(sel, idx);
            });
        }
    </script>
</head>
<body>
<h3>발주 요청 입력</h3>
<form action="${pageContext.request.contextPath}/branch.jsp?page=order/request-stock.jsp" method="post">
    <table id="order-table">
        <thead>
            <tr>
                <th>상품명</th>
                <th>수량</th>
            </tr>
        </thead>
        <tbody>
            <!-- 첫 번째 입력 행 -->
            <tr>
                <td>
                    <select name="items[0].product" onchange="updateHidden(this, 0)">
                    <% for(IngredientDto dto : allIngredients) { %>
                        <option
                            value="<%= dto.getProduct() %>"
                            data-branchnum="<%= dto.getBranchNum() %>"
                            data-branchid="<%= dto.getBranchId() %>"
                            data-inventoryid="<%= dto.getInventoryId() %>"
                            data-currentqty="<%= dto.getCurrentQuantity() %>">
                            <%= dto.getProduct() %>
                        </option>
                    <% } %>
                    </select>
                    <input type="hidden" name="items[0].branchNum" id="items0_branchNum">
                    <input type="hidden" name="items[0].branchId" id="items0_branchId">
                    <input type="hidden" name="items[0].inventoryId" id="items0_inventoryId">
                    <input type="hidden" name="items[0].currentQuantity" id="items0_currentQuantity">
                </td>
                <td>
                    <input type="number" name="items[0].requestQuantity" class="req-input" min="1" value="1" required>
                </td>
            </tr>
            <!-- 샘플 row (tr) - 실제로는 화면에 안 보임 -->
            <tr id="sample-row-template" style="display:none">
                <td>
                    <select name="items[0].product" onchange="updateHidden(this, 0)">
                    <% for(IngredientDto dto : allIngredients) { %>
                        <option
                            value="<%= dto.getProduct() %>"
                            data-branchnum="<%= dto.getBranchNum() %>"
                            data-branchid="<%= dto.getBranchId() %>"
                            data-inventoryid="<%= dto.getInventoryId() %>"
                            data-currentqty="<%= dto.getCurrentQuantity() %>">
                            <%= dto.getProduct() %>
                        </option>
                    <% } %>
                    </select>
                    <input type="hidden" name="items[0].branchNum" id="items0_branchNum">
                    <input type="hidden" name="items[0].branchId" id="items0_branchId">
                    <input type="hidden" name="items[0].inventoryId" id="items0_inventoryId">
                    <input type="hidden" name="items[0].currentQuantity" id="items0_currentQuantity">
                </td>
                <td>
                    <input type="number" name="items[0].requestQuantity" class="req-input" min="1" value="1" required>
                </td>
            </tr>
        </tbody>
    </table>
    <%--기능 삭제  <button type="button" class="add-row-btn" onclick="addRow()">상품 추가</button>--%>
    <button type="submit" class="req-btn">발주 요청</button>
</form>
</body>
</html>

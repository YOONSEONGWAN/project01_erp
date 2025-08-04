<%@page import="java.util.List"%>
<%@page import="dto.IngredientDto"%>
<%@page import="dao.IngredientDao"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    // 모든 상품 목록 불러오기 (상품, branchNum, branchId, inventoryId, currentQuantity 포함!)
    IngredientDao dao = new IngredientDao();
    List<IngredientDto> allIngredients = dao.selectAllProducts(); // 반드시 DTO에 값 다 담길 것!
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>발주 요청 입력</title>
    <style>
        table { border-collapse: collapse; width: 650px; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: center; }
        .req-input { width: 60px; }
        .add-row-btn { margin: 10px 0; }
    </style>
    <script>
        // 행 추가 JS
        function addRow() {
            const table = document.getElementById('order-table');
            const rowCount = table.rows.length - 1; // 헤더 빼고
            const newRow = table.insertRow();
            newRow.innerHTML = document.getElementById('sample-row').innerHTML.replace(/\[0\]/g, '[' + rowCount + ']')
                .replace(/_0/g, '_' + rowCount);
            // 행 추가 시 hidden값도 갱신 필요!
            setTimeout(() => {
                updateHidden(table.rows[rowCount+1].querySelector('select'), rowCount);
            }, 10);
        }
        // select 변경시 hidden값 채우기
        function updateHidden(sel, idx) {
            var opt = sel.options[sel.selectedIndex];
            document.getElementById('items'+idx+'_branchNum').value = opt.dataset.branchnum;
            document.getElementById('items'+idx+'_branchId').value = opt.dataset.branchid;
            document.getElementById('items'+idx+'_inventoryId').value = opt.dataset.inventoryid;
            document.getElementById('items'+idx+'_currentQuantity').value = opt.dataset.currentqty;
        }
        // 페이지 로드시 hidden값도 세팅
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
<form action="request-stock.jsp" method="post">
    <table id="order-table">
        <tr>
            <th>상품명</th>
            <th>수량</th>
        </tr>
        <!-- 샘플행 (JS로 복사용, style="display:none;") -->
        <tr id="sample-row" style="display:none;">
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
        <!-- 첫 번째 행 -->
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
    </table>
    <button type="button" class="add-row-btn" onclick="addRow()">상품 추가</button>
    <button type="submit" class="req-btn">발주 요청</button>
</form>
</body>
</html>
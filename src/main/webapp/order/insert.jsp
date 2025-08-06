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
    <style>
        table { border-collapse: collapse; width: 650px; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: center; }
        .req-input { width: 60px; }
        .add-row-btn { margin: 10px 0; }
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
            newRow.innerHTML = newRow.innerHTML.replace(/\[0\]/g, '[' + rowCount + ']')
                                               .replace(/_0/g, '_' + rowCount);
            tbody.appendChild(newRow);

            setTimeout(() => {
                updateHidden(newRow.querySelector('select'), rowCount);
            }, 10);
        }

        // select 변경시 hidden값 채우기
        function updateHidden(sel, idx) {
            var opt = sel.options[sel.selectedIndex];
            document.getElementById('items' + idx + '_branchNum').value = opt.dataset.branchnum;
            document.getElementById('items' + idx + '_branchId').value = opt.dataset.branchid;
            document.getElementById('items' + idx + '_inventoryId').value = opt.dataset.inventoryid;
            document.getElementById('items' + idx + '_currentQuantity').value = opt.dataset.currentqty;
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
<form action="<%=request.getContextPath()%>/headquater.jsp?page=request-stock.jsp" method="post">
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
    <button type="button" class="add-row-btn" onclick="addRow()">상품 추가</button>
    <button type="submit" class="req-btn">발주 요청</button>
</form>
</body>
</html>

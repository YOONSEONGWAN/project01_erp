<%@page import="dao.stock.InventoryDao"%>
<%@page import="java.util.Enumeration"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    Enumeration<String> paramNames = request.getParameterNames();

    while (paramNames.hasMoreElements()) {
        String paramName = paramNames.nextElement();
        String value = request.getParameter(paramName);

        if (paramName.startsWith("disposal_")) {
            int num = Integer.parseInt(paramName.substring(9));
            boolean disposal = "YES".equals(value);

            if (disposal) {
                // 1. 수량 0으로 설정
                InventoryDao.getInstance().setZeroQuantity(num);

                // 2. 다시 확인: 수량이 0이면 폐기 여부 NO로 리셋
                int quantity = InventoryDao.getInstance().getQuantityByNum(num);
                if (quantity == 0) {
                    InventoryDao.getInstance().updateDisposal(num, false); // 리셋
                } else {
                    InventoryDao.getInstance().updateDisposal(num, true); // YES 유지
                }
            } else {
                // 사용자가 NO 선택한 경우
                InventoryDao.getInstance().updateDisposal(num, false);
            }
        } else if (paramName.startsWith("order_")) {
            int num = Integer.parseInt(paramName.substring(6));
            boolean order = "YES".equals(value);

            InventoryDao.getInstance().updateOrder(num, order);
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>수정 완료</title>
</head>
<body>
<script>
    alert("수정이 완료되었습니다.");
    location.href = "stocklist.jsp";
</script>
</body>
</html>
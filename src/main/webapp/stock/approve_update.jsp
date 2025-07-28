<%@page import="dto.stock.InAndOutDto"%>
<%@page import="dao.stock.InAndOutDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	String inApproval = request.getParameter("inApproval");
	String outApproval = request.getParameter("outApproval");
	String orderIdStr = request.getParameter("orderId");
	String pageName = request.getParameter("pageName");
	String manager = (String)session.getAttribute("manager");

	String message = null;
    
    if (orderIdStr != null) {
        int orderId = Integer.parseInt(orderIdStr);
        InAndOutDto dto = new InAndOutDto();
        dto.setOrderId(orderId);
        dto.setManager(manager);

        boolean success = false;

        if (inApproval != null) {
            dto.setInApproval(inApproval);
            success = InAndOutDao.getInstance().updateInApproval(dto);
            message = success ? "입고 승인 상태가 성공적으로 변경되었습니다." : "입고 승인 상태 변경에 실패했습니다.";
        }

        if (outApproval != null) {
            dto.setOutApproval(outApproval);
            success = InAndOutDao.getInstance().updateOutApproval(dto);
            message = success ? "출고 승인 상태가 성공적으로 변경되었습니다." : "출고 승인 상태 변경에 실패했습니다.";
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>approve_update.jsp</title>

</head>
<body>
    <script>
    
    location.href = "<%= pageName %>";
</script>
</body>
</html>
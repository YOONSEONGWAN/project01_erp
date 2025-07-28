<%@page import="java.time.LocalDate"%>
<%@page import="java.sql.Date"%>
<%@page import="java.util.Calendar"%>
<%@page import="dao.stock.InventoryDao"%>
<%
	LocalDate today = LocalDate.now();
	LocalDate newExpirationDate = today.plusMonths(6);
	
	java.util.Enumeration<String> paramNames = request.getParameterNames();
	
	while (paramNames.hasMoreElements()) {
	    String paramName = paramNames.nextElement();
	    if (paramName.startsWith("approval_")) {
	        String numStr = paramName.substring("approval_".length());
	        String approval = request.getParameter(paramName);
	        String amountStr = request.getParameter("amount_" + numStr);
	
	        if ("YES".equals(approval)) {
	            try {
	                int num = Integer.parseInt(numStr);
	                int amount = Integer.parseInt(amountStr);
	
	                InventoryDao.getInstance().increaseQuantity(num, amount);
	                InventoryDao.getInstance().updateExpirationDate(num, newExpirationDate);
	                InventoryDao.getInstance().updateApproval(num, true);
	            } catch (Exception e) {
	                e.printStackTrace();
	            }
	        } else {
	            try {
	                int num = Integer.parseInt(numStr);
	                InventoryDao.getInstance().updateApproval(num, false);
	            } catch (Exception e) {
	                e.printStackTrace();
	            }
	        }
	    }
	}
	response.sendRedirect("placeOrder_head.jsp");
%>
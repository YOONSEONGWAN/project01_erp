<%@ page import="dao.stock.InboundOrdersDao" %>
<%@ page import="dao.stock.OutboundOrdersDao" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");

    String type = request.getParameter("type");         // "inbound" 또는 "outbound"
    String orderIdParam = request.getParameter("order_id");
    String approval = request.getParameter("approval"); // "승인" 또는 "반려"

    if (type != null && orderIdParam != null && approval != null) {
        try {
            int orderId = Integer.parseInt(orderIdParam);

            if ("inbound".equals(type)) {
                InboundOrdersDao.getInstance().updateApproval(orderId, approval);
            } else if ("outbound".equals(type)) {
                OutboundOrdersDao.getInstance().updateApproval(orderId, approval);
            }
        } catch (Exception e) {
            e.printStackTrace();
            // 에러 처리 로직 필요 시 여기에 추가 가능
        }
    }

    // 처리 후 목록 페이지로 리다이렉트
    response.sendRedirect("${pageContext.request.contextPath}/headquater.jsp?page=/stock/inandout.jsp");
%>
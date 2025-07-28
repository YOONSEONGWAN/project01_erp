<%@page import="dto.StockRequestDto"%>
<%@page import="dao.StockRequestDao"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");
	String branchId = request.getParameter("branchId");
	int ingredientId = Integer.parseInt(request.getParameter("ingredientId"));
	int quantity = Integer.parseInt(request.getParameter("quantity"));

	StockRequestDto dto = new StockRequestDto();
	dto.setBranchId(branchId);
	dto.setIngredientId(ingredientId);
	dto.setQuantity(quantity);

	boolean isSuccess = StockRequestDao.getInstance().insert(dto);

	String cPath = request.getContextPath();
	if(isSuccess){
		response.sendRedirect(cPath + "/order/list.jsp");
	}else{
		response.sendRedirect(cPath + "/order/insert.jsp?error=fail");
	}
%>
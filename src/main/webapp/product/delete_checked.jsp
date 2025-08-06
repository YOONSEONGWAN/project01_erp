<%@ page import="java.util.*" %>
<%@ page import="dao.ProductDao" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String[] numArr = request.getParameterValues("productNums");

    if (numArr != null && numArr.length > 0) {
        List<Integer> nums = new ArrayList<>();
        for (String numStr : numArr) {
            try {
                nums.add(Integer.parseInt(numStr));
            } catch (NumberFormatException e) {
                e.printStackTrace(); // 예외 처리
            }
        }

        ProductDao dao = new ProductDao();
        int deleted = dao.deleteMultiple(nums);
    }

    String redirectUrl = request.getContextPath() + "/headquater.jsp?page=product/list.jsp";
    response.sendRedirect(redirectUrl);

%>

<%@page import="dto.HqBoardDto"%>
<%@page import="dao.HqBoardDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// 폼 전송되는 내용을 읽어와서
	int num = Integer.parseInt(request.getParameter("num"));
	String title=request.getParameter("title");
	String content=request.getParameter("content");
	
	
	// 글 작성자와 로그인 된 userName 이 동일한지 비교해서 동일하지 않으면 에러를 응답한다.
		String writer=HqBoardDao.getInstance().getByNum(num).getWriter(); // 수정할 글 작성자
		String userName=(String)session.getAttribute("userName");
		// 만일 작성자와 userName 로그인 된 userName 하고 같이 않으면
		if(!writer.equals(userName)){
			// 에러 페이지 응답
			response.sendError(HttpServletResponse.SC_FORBIDDEN, " 수정 권한이 없습니다!");
			return;//메소드를 여기서 종료
		}
	
	// DB 에 수정 반영하고 (dao에 수정 메소드 필요)
	HqBoardDto dto=new HqBoardDto();
	dto.setNum(num);
	dto.setTitle(title);
	dto.setContent(content);
	HqBoardDao.getInstance().update(dto);
	
	// 응답한다.
	

%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/hqboard/hq-update.jsp</title>
</head>
<body>
	<script>
		alert("수정을 완료했습니다.")
		location.href="<%=request.getContextPath()%>/headquater.jsp?page=hqboard/hq-view.jsp?num=<%=num%>";
	</script>
</body>
</html>
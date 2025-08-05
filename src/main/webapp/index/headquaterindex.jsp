<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/index/headquater.jsp</title>
<jsp:include page="/WEB-INF/include/resource.jsp"></jsp:include>
</head>
<body>
	<jsp:include page="/WEB-INF/include/navbar.jsp">
		<jsp:param value="index" name="thisPage"/>
	</jsp:include>
	<h1>본사 인덱스 페이지</h1>
	<ul>
    	<li><a href="${pageContext.request.contextPath }/product/list.jsp">상품관리</a></li>
   		<li><a href="${pageContext.request.contextPath }/branch-admin/list.jsp">지점관리</a></li>
    	<li><a href="${pageContext.request.contextPath }/board/list.jsp">게시판</a></li>
    	<li><a href="${pageContext.request.contextPath }/headquater/sales.jsp">매출/회계</a></li>
    	<li><a href="${pageContext.request.contextPath }/headquater/stock.jsp">재고</a></li>
    	<li><a href="${pageContext.request.contextPath }/hqboard/hq-list.jsp">본사 내부 게시판</a></li>
	</ul>
	
		<!-- 
			발주 -> 지점에서 발주 요청 나오면 뜨도록 설정. 확인 누르면 자동 발주(최종 프로젝트에서는 여기서 공장별 페이지로 나뉘는 것 추천).
			지점관리 -> 전체 지점 페이지, 해당 지점 페이지. 해당 지점 페이지에서는 매출, 메뉴별 판매 현황, 재고관리 등등 확인할 수 있도록.
			게시판 -> (지점->본사 문의 게시판) + (본사 ->지점 공지 게시판). 총 2개
			승인 -> 회원가입,가맹점 탈퇴 등등 승인 여부 뜨도록. 우리가 확인/반려 할 수 있도록
		 -->
</body>
</html>
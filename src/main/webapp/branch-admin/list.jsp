<%@page import="java.util.List"%>
<%@page import="dto.BranchDto"%>
<%@page import="dao.BranchDao"%>
<%@page import="org.apache.tomcat.jakartaee.commons.lang3.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//검색 keyword 가 있는지 읽어와 본다.
	String keyword=request.getParameter("keyword");
	//System.out.println(keyword); // null or "" 또는 "검색어..." 
	if(keyword==null){
		keyword=""; // 이렇게 써주면 StringUtils.isEmpty() 가 필요 없음
	}
	
	//기본 페이지 번호는 1 로 설정하고 
	int pageNum=1;
	//페이지 번호를 읽어와서 
	String strPageNum=request.getParameter("pageNum");
	//전달되는 페이지 번호가 있다면 
	if(strPageNum != null){
		//해당 페이지 번호를 숫자로 변경해서 사용한다. 
		pageNum=Integer.parseInt(strPageNum);
	}
	
	//한 페이지에 몇개씩 표시할 것인지
	final int PAGE_ROW_COUNT=10;
	
	//하단 페이지를 몇개씩 표시할 것인지
	final int PAGE_DISPLAY_COUNT=5;

	//보여줄 페이지의 시작 ROWNUM
	int startRowNum=1+(pageNum-1)*PAGE_ROW_COUNT; //공차수열
	//보여줄 페이지의 끝 ROWNUM
	int endRowNum=pageNum*PAGE_ROW_COUNT; //등비수열 
	
	//하단 시작 페이지 번호 (정수를 정수로 나누면 소수점이 버려진 정수가 나온다)
	int startPageNum = 1 + ((pageNum-1)/PAGE_DISPLAY_COUNT)*PAGE_DISPLAY_COUNT;
	//하단 끝 페이지 번호
	int endPageNum=startPageNum+PAGE_DISPLAY_COUNT-1;
	
	//전체 글의 갯수 
	int totalRow=0;
	//만일 전달된 keyword 가 없다면 
	if(StringUtils.isEmpty(keyword)){
		totalRow=BranchDao.getInstance().getCount();
	}else{ //있다면 
		totalRow=BranchDao.getInstance().getCountByKeyword(keyword);
	}
	
	//전체 페이지의 갯수 구하기
	int totalPageCount=(int)Math.ceil(totalRow/(double)PAGE_ROW_COUNT);
	//끝 페이지 번호가 이미 전체 페이지 갯수보다 크게 계산되었다면 잘못된 값이다.
	if(endPageNum > totalPageCount){
		endPageNum=totalPageCount; //보정해 준다. 
	}	
	
	//dto 에 select 할 row 의 정보를 담고 
	BranchDto dto=new BranchDto();
	dto.setStartRowNum(startRowNum);
	dto.setEndRowNum(endRowNum);
		
	//글목록
	List<BranchDto> list =null;
	//만일 keyword 가 없으면
	if(StringUtils.isEmpty(keyword)){
		list = BranchDao.getInstance().selectPage(dto);
	}else{ //있다면
		//dto 에 keyword 를 담고
		dto.setKeyword(keyword);
		// 키워드에 해당하는 글 목록을 얻어낸다
		list=BranchDao.getInstance().selectPageByKeyword(dto);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/board/list.jsp</title>
</head>
<body>
	<div class="container">
		<a href="insert-form.jsp">지점 등록</a>
		<h1>지점 목록</h1>
		<div class="row">
			<div class="col">
				<form action="list.jsp" method="get">
					<div>
						<input value="<%=StringUtils.isEmpty(keyword) ? "" : keyword %>" type="text" name="keyword" placeholder="지점 이름 입력..." />
						<button type="submit">검색</button>
					</div>
				</form>
			</div>
		</div>		
	</div>
	<table>
		<thead>
			<tr>
				<th>지점명</th>
				<th>주소</th>
				<th>전화번호</th>
				<th>담당자</th>
			</tr>
		</thead>
		<tbody>
			<%for(BranchDto tmp:list){ %>
				<tr>
					<td>
						<a href="detail.jsp?num=<%=tmp.getNum() %>"><%=tmp.getName() %></a>
					</td> 
					<td><%=tmp.getAddress() %></td>
					<td><%=tmp.getPhone() %></td>
					<td><%=tmp.getUserName() %></td>
				</tr>
			<%} %>	
		</tbody>
	</table>
	
	<ul class="pagination">
		<%-- startPageNum 이 1이 아닐때 이전 page 가 존재하기 때문에... --%>
		<%if(startPageNum != 1){ %>
			<li class="page-item">
				<a class="page-link" href="list.jsp?pageNum=<%=startPageNum-1 %>&keyword=<%=keyword%>">&lsaquo;</a>
			</li>
		<%} %>			
		<%for(int i=startPageNum; i<=endPageNum ; i++){ %>
			<li class="page-item">
				<a class="page-link <%= i==pageNum ? "active":"" %>" href="list.jsp?pageNum=<%=i %>&keyword=<%=keyword%>"><%=i %></a>
			</li>
		<%} %>
		<%-- endPageNum 이 totalPageCount 보다 작을때 다음 page 가 있다 --%>		
		<%if(endPageNum < totalPageCount){ %>
			<li class="page-item">
				<a class="page-link" href="list.jsp?pageNum=<%=endPageNum+1 %>&keyword=<%=keyword%>">&rsaquo;</a>
			</li>
		<%} %>	
	</ul>
</body>
</html>
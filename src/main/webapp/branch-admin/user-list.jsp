
<%@page import="java.util.List"%>
<%@page import="dao.UserDaoAdmin"%>
<%@page import="org.apache.tomcat.jakartaee.commons.lang3.StringUtils"%>
<%@page import="dto.UserDtoAdmin"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
//검색 keyword 가 있는지 읽어와 본다.
	String keyword=request.getParameter("keyword");
	//System.out.println(keyword); // null or "" 또는 "검색어..." 
	if(keyword==null){
		keyword=""; // 이렇게 써주면 StringUtils.isEmpty() 가 필요 없음
	}
	
	
	
	// 등급(role) 파라미터 읽어오기
	String role = request.getParameter("role");
	if (role == null || "all".equals(role) || role.isEmpty()) {
		role = "all"; // "all" or null means no status filter
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
	UserDaoAdmin dao = UserDaoAdmin.getInstance();
	
	// 조건에 따라 분기하여 전체 row의 갯수를 얻어온다.
	boolean isKeywordEmpty = StringUtils.isEmpty(keyword);
	boolean isRollAll = "all".equals(role);
	
	if (isKeywordEmpty && isRollAll) { // 1. 키워드 X, 상태 X
	    totalRow = dao.getCount();
	} else if (!isKeywordEmpty && isRollAll) { // 2. 키워드 O, 상태 X
	    totalRow = dao.getCountByKeyword(keyword);
	} else if (isKeywordEmpty && !isRollAll) { // 3. 키워드 X, 상태 O
	    totalRow = dao.getCountByRole(role);
	} else { // 4. 키워드 O, 상태 O
	    totalRow = dao.getCountByKeywordAndRole(keyword, role);
	}
	
	//전체 페이지의 갯수 구하기
	int totalPageCount=(int)Math.ceil(totalRow/(double)PAGE_ROW_COUNT);
	//끝 페이지 번호가 이미 전체 페이지 갯수보다 크게 계산되었다면 잘못된 값이다.
	if(endPageNum > totalPageCount){
		endPageNum=totalPageCount; //보정해 준다. 
	}	
	
	//dto 에 select 할 row 의 정보를 담고 
	UserDtoAdmin dto=new UserDtoAdmin();
	dto.setStartRowNum(startRowNum);
	dto.setEndRowNum(endRowNum);
		
	//글목록
	List<UserDtoAdmin> list =null;
	// 조건에 따라 분기하여 목록을 얻어온다.
	if (isKeywordEmpty && isRollAll) { // 1. 키워드 X, 상태 X
	    list = dao.selectPage(dto);
	} else if (!isKeywordEmpty && isRollAll) { // 2. 키워드 O, 상태 X
	    dto.setKeyword(keyword);
	    list = dao.selectPageByKeyword(dto);
	} else if (isKeywordEmpty && !isRollAll) { // 3. 키워드 X, 상태 O
	    list = dao.selectPageByRole(dto, role);
	} else { // 4. 키워드 O, 상태 O
	    dto.setKeyword(keyword);
	    list = dao.selectPageByKeywordAndRole(dto, role);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/branch-admin/user-list.jsp</title>
</head>
<body>
<div class="container">
		<h1>등급 업데이트</h1>
		<a href="list.jsp">지점 목록으로</a>
		<div class="row">
			<div class="col">
				<form action="user-list.jsp" method="get">
					<div>
						<select name="role">
							<option value="all" <%= "all".equals(role) ? "selected" : "" %>>전체</option>
							<option value="manager" <%= "manager".equals(role) ? "selected" : "" %>>사장님</option>
							<option value="clerk" <%= "clerk".equals(role) ? "selected" : "" %>>직원</option>
							<option value="unapproved" <%= "unapproved".equals(role) ? "selected" : "" %>>미등록</option>
						</select>
						<input value="<%=StringUtils.isEmpty(keyword) ? "" : keyword %>" type="text" name="keyword" placeholder="아이디 or 이름 입력..." />
						<button type="submit">검색</button>
						<a href="user-list.jsp">초기화</a>
					</div>
				</form>
			</div>
		</div>		
		<table>
			<tr>
				<th>회원 아이디</th>
				<th>지점명</th>
				<th>이름</th>
				<th>등급</th>
			</tr>
			<tr>
			<%for(UserDtoAdmin tmp:list){ %>
				<tr>
					<td><%=tmp.getUser_id() %></td>
					<td><%=tmp.getBranch_name() %></td>
					<td><%=tmp.getUser_name() %></td>					
					<td><%=tmp.getRole() %></td>
					<td>
						<a href="roleupdate-form.jsp?num=<%=tmp.getNum()%>">등급 수정</a>
					</td>
				</tr>
			<%} %>	
			</tr>
		</table>
	</div>
	
	<ul class="pagination">
		<%-- startPageNum 이 1이 아닐때 이전 page 가 존재하기 때문에... --%>
		<%if(startPageNum != 1){ %>
			<li class="page-item">
				<a class="page-link" href="user-list.jsp?pageNum=<%=startPageNum-1 %>&keyword=<%=keyword%>&role=<%=role%>">&lsaquo;</a>
			</li>
		<%} %>			
		<%for(int i=startPageNum; i<=endPageNum ; i++){ %>
			<li class="page-item">
				<a class="page-link <%= i==pageNum ? "active":"" %>" href="user-list.jsp?pageNum=<%=i %>&keyword=<%=keyword%>&role=<%=role%>"><%=i %></a>
			</li>
		<%} %>
		<%-- endPageNum 이 totalPageCount 보다 작을때 다음 page 가 있다 --%>		
		<%if(endPageNum < totalPageCount){ %>
			<li class="page-item">
				<a class="page-link" href="user-list.jsp?pageNum=<%=endPageNum+1 %>&keyword=<%=keyword%>&role=<%=role%>">&rsaquo;</a>
			</li>
		<%} %>
	</ul>
</body>
</html>
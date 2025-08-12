<%@page import="org.apache.tomcat.jakartaee.commons.lang3.StringUtils"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.util.List"%>
<%@page import="dao.WorkLogDao"%>
<%@page import="dto.WorkLogDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
String branchId = (String)session.getAttribute("branchId");
String branchName = WorkLogDao.getInstance().getBranchName(branchId); // 지점명 받아오기
//기존 : List<WorkLogDto> logs = WorkLogDao.getInstance().getLogsByBranch(branchId);




List<String> branchList = WorkLogDao.getInstance().getBranchIdListFromLog();

String keyword=request.getParameter("keyword");
System.out.println(keyword);

if(keyword==null){
	keyword="";
}

int pageNum=1;


String strPageNum=request.getParameter("pageNum");
if(strPageNum !=null){
	pageNum = Integer.parseInt(strPageNum);
}
//한 페이지에 몇개의 표시 할 것인지
final int PAGE_ROW_COUNT=10;

//하단 페이지를 몇개씩 표시할 것인지
final int PAGE_DISPLAY_COUNT = 5;


int startRowNum=1+(pageNum-1)*PAGE_ROW_COUNT;
int endRowNum=pageNum*PAGE_ROW_COUNT;


	int startPageNum = 1 + ((pageNum-1)/PAGE_DISPLAY_COUNT)*PAGE_DISPLAY_COUNT;
	int endPageNum=startPageNum+PAGE_DISPLAY_COUNT-1;
	//전체 글의 갯수
  	int totalRow=0;
  	 //만일 전달된 keyword 가 없다면 
  	if (keyword == null || keyword.trim().isEmpty()) {
    totalRow = WorkLogDao.getInstance().getCountByBranch(branchId);
	} else {
    totalRow = WorkLogDao.getInstance().getCountByBranchAndKeyword(branchId, keyword.trim());
	}
  		
  	//전체 페이지의 갯수 구하기
  	int totalPageCount=(int)Math.ceil(totalRow/(double)PAGE_ROW_COUNT);
  	//끝 페이지 번호가 이미 전체 페이지 갯수보다 크게 계산되었다면 잘못된 값이다.
  	if(endPageNum > totalPageCount){
  		endPageNum=totalPageCount; //보정해 준다. 
  	}	
    
    
    //dto 에 select할 row 의 정보를 담고
   WorkLogDto dto2 = new WorkLogDto();
	dto2.setBranchId(branchId);
	dto2.setKeyword(keyword == null ? "" : keyword.trim());
	dto2.setStartRowNum(startRowNum);
	dto2.setEndRowNum(endRowNum);

	//변경 (필요한 것만 + 페이징)
	List<WorkLogDto> logs = (dto2.getKeyword().isEmpty())
	 ? WorkLogDao.getInstance().selectPage(dto2)
	 : WorkLogDao.getInstance().selectPageByKeyword(dto2);

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><%= branchName %> 출퇴근 현황</title>
<jsp:include page="/WEB-INF/include/resource.jsp"></jsp:include>
<style>
body {
    background: #f8fbff;
    margin: 0;
    padding: 0;
    font-family: 'Pretendard', '맑은 고딕', Arial, sans-serif;
    /* 기본 패딩 없이 꽉 채움 */
}
.big-table {
    border-collapse: collapse;
    width: 100vw;   /* 뷰포트 가로 전체 */
    min-width: 900px;
    background: #fff;
    border-radius: 0;
    overflow: visible;
    box-shadow: 0 2px 16px rgba(33,100,180,0.06);
}
.big-table th, .big-table td {
    border: 2px solid #003366;
    padding: 10px 7px;
    text-align: center;
    font-size: 1em;
    /* box-sizing 추가하면 td가 넘칠 때도 이쁘게 맞춰짐 */
    box-sizing: border-box;
}
.big-table th {
    background: #003366;
    color: #fff;
    font-weight: 700;
    font-size: 1.09em;
}
.big-table tr:nth-child(even) td {
    background: #e7f2fd;
}
.big-table tr:nth-child(odd) td {
    background: #f4faff;
}
.big-table tr:hover td {
    background: #c9e3fa;
}
/* 스크롤 대응: 모바일/작은화면에서 넘치면 가로스크롤 */
.table-wrapper {
    width: 100vw;
    overflow-x: auto;
}
</style>
</head>
<body>
<h3><%= branchName %> 출퇴근 현황</h3>
<div style="margin-top: 18px; margin-bottom:18px; text-align: right;">
    <a href="${pageContext.request.contextPath}/branch.jsp?page=work-log/work_log.jsp">
        <button type="button" style="font-size:1.08em; font-weight:bold; color:#fff; background:#003366; border:none; border-radius:7px; padding:10px 26px; cursor:pointer;">
            돌아가기
        </button>
    </a>
</div>
<table border="1" class="big-table" style="width:100%;">
    <tr>
        <th>아이디</th>
        <th>날짜</th>
        <th>출근 시간</th>
        <th>퇴근 시간</th>
        <th>근무 시간</th>
    </tr>
<%
    for (WorkLogDto dto : logs) {
        Timestamp checkIn = dto.getStartTime();
        Timestamp checkOut = dto.getEndTime();
        long hours = 0, minutes = 0;
        if (checkIn != null && checkOut != null) {
            long millis = checkOut.getTime() - checkIn.getTime();
            hours = millis / (1000 * 60 * 60);
            minutes = (millis / (1000 * 60)) % 60;
        }
%>
    <tr>
        <td><%= dto.getUserId() %></td>
        <td><%= dto.getWorkDate() %></td>
        <td><%= checkIn != null ? checkIn.toString().substring(11, 16) : "-" %></td>
        <td><%= checkOut != null ? checkOut.toString().substring(11, 16) : "-" %></td>
        <td><%= (checkIn != null && checkOut != null) ? hours + "시간 " + minutes + "분" : "-" %></td>
    </tr>
<% } %>
</table>
<ul class="pagination">
		<li class="page-item">
		<!-- pageNum>startPageNum 도 가능하지만 아래가 좀 더 명확함 -->
			<%if(startPageNum != 1){%>	
				<a class="page-link" 
				href="${pageContext.request.contextPath}/branch.jsp?page=/work-log/view-work_log.jsp&pageNum=<%=startPageNum-1%>
				&keyword=<%=keyword%>">&lsaquo;</a>
			<%}%>
			
		</li>
		<%for(int i=startPageNum;i<=endPageNum;i++){%>
		<li class="page-item">
		<a class ="page-link  <%=i==pageNum ? "active" : "" %>" 
		href="${pageContext.request.contextPath}/branch.jsp?page=/work-log/view-work_log.jsp&pageNum=<%=i%>
		&keyword=<%=keyword%>"><%=i %></a>
		</li>
		
		<% }%>
	
		<li class="page-item">
			<!-- pageNum<endPageNum 도 가능하지만 아래가 좀 더 명확함 -->
			<%if(endPageNum < totalPageCount){%>
				<a class="page-link" 
				href="${pageContext.request.contextPath}/branch.jsp?page=/work-log/view-work_log.jsp&pageNum=<%=endPageNum+1%>">&rsaquo;</a>
			<%} %>
			
		</li>
	</ul>
</body>
</html>
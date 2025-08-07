<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
	<nav id="sidebar" class="bg-light border-end" style="width: 250px; min-height: 100vh; flex-shrink: 0;">
	  <div class="p-3">
	  	<h4>지점 메뉴</h4>
		  	<ul class="nav nav-pills flex-column">
			  	<li class="nav-item">
		          	<a class="nav-link <%= "order/list.jsp".equals(request.getParameter("page")) ? "active" : "" %>"
		             	href="<%=request.getContextPath()%>/branch.jsp?page=order/list.jsp">
		             	발주신청
		          	</a>
	        	</li>
	        	<li class="nav-item">
		          <a class="nav-link <%= "board/list.jsp".equals(request.getParameter("page")) ? "active" : "" %>"
		             href="<%=request.getContextPath()%>/branch.jsp?page=board/list.jsp">
		             지점게시판
		          </a>
	        	</li>
	        	<li class="nav-item">
		          <a class="nav-link <%= "work-log/work_log.jsp".equals(request.getParameter("page")) ? "active" : "" %>"
		             href="<%=request.getContextPath()%>/branch.jsp?page=work-log/work_log.jsp">
		             출퇴근관리
		          </a>
	        	</li>
	        	<li class="nav-item">
		          <a class="nav-link <%= "branch-sales/list.jsp".equals(request.getParameter("page")) ? "active" : "" %>"
		             href="<%=request.getContextPath()%>/branch.jsp?page=branch-sales/list.jsp">
		             매출 관리
		          </a>
	        	</li>
        	</ul>
	  </div>
	</nav>
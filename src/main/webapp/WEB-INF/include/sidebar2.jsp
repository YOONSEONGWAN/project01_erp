<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" />

<%
    String pageParam = request.getParameter("page");
%>

	<nav id="sidebar" class="bg-light border-end" style="width: 250px; min-height: 100vh; flex-shrink: 0;">
	  <div class="p-3">
	    <h4>지점 메뉴</h4>
	    <ul class="nav flex-column gap-1">
	      <li class="nav-item">
	        <a href="<%=request.getContextPath()%>/branch.jsp?page=order/list.jsp"
	           class="nav-link d-flex align-items-center gap-2 <%= "order/list.jsp".equals(pageParam) ? "active" : "" %>">
	          <i class="bi bi-folder"></i> 발주 내역
	        </a>
	      </li>
	      <li class="nav-item">
	        <a href="<%=request.getContextPath()%>/branch.jsp?page=board/list.jsp"
	           class="nav-link d-flex align-items-center gap-2 <%= "board/list.jsp".equals(pageParam) ? "active" : "" %>">
	          <i class="bi bi-chat-left-text"></i> 지점게시판
	        </a>
	      </li>
	      <li class="nav-item">
	        <a href="<%=request.getContextPath()%>/branch.jsp?page=work-log/work_log.jsp"
	           class="nav-link d-flex align-items-center gap-2 <%= "work-log/work_log.jsp".equals(pageParam) ? "active" : "" %>">
	          <i class="bi bi-calendar-check"></i> 출퇴근관리
	        </a>
	      </li>
	      <li class="nav-item">
	        <a href="<%=request.getContextPath()%>/branch.jsp?page=branch-sales/list.jsp"
	           class="nav-link d-flex align-items-center gap-2 <%= "branch-sales/list.jsp".equals(pageParam) ? "active" : "" %>">
	          <i class="bi bi-graph-up"></i> 매출 관리
	        </a>
	      </li>
	    </ul>
	  </div>
	</nav>

<style>
	#sidebar .nav-link,
	#sidebar .nav-link i {
	  color: #003366;
	}
	#sidebar .nav-link:hover,
	#sidebar .nav-link:hover i {
	  color: #002244;
	}
	#sidebar .nav-link.active,
	#sidebar .nav-link.active i {
	  font-weight: 700;
	  color: #003366;
	}
</style>

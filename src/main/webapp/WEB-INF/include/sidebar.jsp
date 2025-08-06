<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<nav id="sidebar" class="bg-light border-end" style="width: 250px; min-height: 100vh; flex-shrink: 0;">
	  <div class="p-3">
		    <h4>본사 메뉴</h4>
		    <ul class="nav nav-pills flex-column">
		
		      <!-- 상품관리 -->
		      <li class="nav-item">
		        <a class="nav-link <%= "product/list.jsp".equals(request.getParameter("page")) ? "active" : "" %>"
		           href="<%=request.getContextPath()%>/headquater.jsp?page=product/list.jsp">
		           상품관리
		        </a>
		        <!-- 하위 메뉴 -->
		        <ul class="nav flex-column ms-3">
		          <li class="nav-item">
		            <a class="nav-link <%= "product/insertform.jsp".equals(request.getParameter("page")) ? "active" : "" %>"
		               href="<%=request.getContextPath()%>/headquater.jsp?page=product/insertform.jsp">
		               <i class="bi bi-caret-right-fill"></i> 상품 등록
		            </a>
		          </li>
		        </ul>
		      </li>
		
		      <!-- 지점관리 -->
		      <li class="nav-item">
		        <a class="nav-link <%= "branch-admin/list.jsp".equals(request.getParameter("page")) ? "active" : "" %>"
		           href="<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/list.jsp">
		           지점관리
		        </a>
		      </li>
		
		      <!-- 게시판 -->
		      <li class="nav-item">
		        <a class="nav-link <%= "board/list.jsp".equals(request.getParameter("page")) ? "active" : "" %>"
		           href="<%=request.getContextPath()%>/headquater.jsp?page=board/list.jsp">
		           게시판
		        </a>
		      </li>
		
		      <!-- 매출/회계 -->
		      <li class="nav-item">
		        <a class="nav-link <%= "headquater/sales.jsp".equals(request.getParameter("page")) ? "active" : "" %>"
		           href="<%=request.getContextPath()%>/headquater.jsp?page=headquater/sales.jsp">
		           매출/회계
		        </a>
		      </li>
		
		      <!-- 재고 -->
		      <li class="nav-item">
		        <a class="nav-link <%= "headquater/stock.jsp".equals(request.getParameter("page")) ? "active" : "" %>"
		           href="<%=request.getContextPath()%>/headquater.jsp?page=headquater/stock.jsp">
		           재고
		        </a>
		      </li>
		
		      <!-- 본사 내부 게시판 -->
		      <li class="nav-item">
		        <a class="nav-link <%= "hqboard/hq-list.jsp".equals(request.getParameter("page")) ? "active" : "" %>"
		           href="<%=request.getContextPath()%>/headquater.jsp?page=hqboard/hq-list.jsp">
		           본사 내부 게시판
		        </a>
		      </li>
		      
		      <!-- 직원 관리 -->
		      <li class="nav-item">
		        <a class="nav-link <%= "hrm/list.jsp".equals(request.getParameter("page")) ? "active" : "" %>"
		           href="<%=request.getContextPath()%>/headquater.jsp?page=hrm/list.jsp">
		           직원 관리
		        </a>
		      </li>
		    </ul>
	  </div>
	</nav>
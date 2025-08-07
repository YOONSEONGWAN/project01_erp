<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" />

<%
    String pageParam = request.getParameter("page");

    boolean isProductPage = pageParam != null && pageParam.startsWith("product/");
<<<<<<< HEAD
<<<<<<< HEAD
=======

>>>>>>> origin/main
    boolean isBranchPage = pageParam != null && pageParam.startsWith("branch-admin/");
    boolean isBoardPage = pageParam != null && pageParam.startsWith("board/");
    boolean isSalesPage = "headquater/sales.jsp".equals(pageParam);
    boolean isStockPage = "headquater/stock.jsp".equals(pageParam);
    boolean isHqBoardPage = pageParam != null && pageParam.startsWith("hqboard/");
<<<<<<< HEAD
    boolean isHrmPage = pageParam != null && pageParam.startsWith("hrm/");
%>
	
	<nav id="sidebar" class="bg-light border-end" style="width: 250px; min-height: 100vh; flex-shrink: 0;">
	  <div class="p-3">
	    <h4>본사 메뉴</h4>
	    <ul class="nav flex-column">
	
	      <!-- 상품관리 -->
	      <li class="nav-item">
	        <a href="#"
	           class="nav-link d-flex align-items-center gap-2"
	           id="toggleProductMenu"
	           onclick="event.preventDefault(); toggleSubmenu('productMenu', this);">
	          <i class="bi <%= isProductPage ? "bi-caret-down-fill" : "bi-caret-right-fill" %>"></i>
	          <i class="bi <%= isProductPage ? "bi-folder2-open" : "bi-folder" %>"></i>
	          상품관리
	        </a>
	        <ul id="productMenu" class="submenu <%= isProductPage ? "open" : "" %>" style="padding-left: 3rem;">
	          <li>
	            <a href="<%=request.getContextPath()%>/headquater.jsp?page=product/insertform.jsp"
	               class="nav-link <%= "product/insertform.jsp".equals(pageParam) ? "active" : "" %>">
	              <i class="bi bi-folder"></i> 상품 등록
	            </a>
	          </li>
	          <li>
	            <a href="<%=request.getContextPath()%>/headquater.jsp?page=product/list.jsp"
	               class="nav-link <%= "product/list.jsp".equals(pageParam) ? "active" : "" %>">
	              <i class="bi bi-folder"></i> 상품 목록
	            </a>
	          </li>
	        </ul>
	      </li>
	
	      <!-- 지점관리 -->
	      <li class="nav-item">
	        <a href="#"
	           class="nav-link d-flex align-items-center gap-2"
	           id="toggleBranchMenu"
	           onclick="event.preventDefault(); toggleSubmenu('branchMenu', this);">
	          <i class="bi <%= isBranchPage ? "bi-caret-down-fill" : "bi-caret-right-fill" %>"></i>
	          <i class="bi <%= isBranchPage ? "bi-folder2-open" : "bi-folder" %>"></i>
	          지점관리
	        </a>
	        <ul id="branchMenu" class="submenu <%= isBranchPage ? "open" : "" %>" style="padding-left: 3rem;">
	          <li>
	            <a href="<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/list.jsp"
	               class="nav-link <%= "branch-admin/list.jsp".equals(pageParam) ? "active" : "" %>">
	              <i class="bi bi-folder"></i> 지점 목록
	            </a>
	          </li>
	        </ul>
	      </li>
	
	      <!-- 게시판 -->
	      <li class="nav-item">
	        <a href="#"
	           class="nav-link d-flex align-items-center gap-2"
	           id="toggleBoardMenu"
	           onclick="event.preventDefault(); toggleSubmenu('boardMenu', this);">
	          <i class="bi <%= isBoardPage ? "bi-caret-down-fill" : "bi-caret-right-fill" %>"></i>
	          <i class="bi <%= isBoardPage ? "bi-folder2-open" : "bi-folder" %>"></i>
	          게시판
	        </a>
	        <ul id="boardMenu" class="submenu <%= isBoardPage ? "open" : "" %>" style="padding-left: 3rem;">
	          <li>
	            <a href="<%=request.getContextPath()%>/headquater.jsp?page=board/list.jsp"
	               class="nav-link <%= "board/list.jsp".equals(pageParam) ? "active" : "" %>">
	              <i class="bi bi-folder"></i> 게시판 목록
	            </a>
	          </li>
	        </ul>
	      </li>
	
	      <!-- 매출/회계 -->
	      <li class="nav-item">
	        <a href="#"
	           class="nav-link d-flex align-items-center gap-2"
	           id="toggleSalesMenu"
	           onclick="event.preventDefault(); toggleSubmenu('salesMenu', this);">
	          <i class="bi <%= isSalesPage ? "bi-caret-down-fill" : "bi-caret-right-fill" %>"></i>
	          <i class="bi <%= isSalesPage ? "bi-folder2-open" : "bi-folder" %>"></i>
	          매출/회계
	        </a>
	        <ul id="salesMenu" class="submenu <%= isSalesPage ? "open" : "" %>" style="padding-left: 3rem;">
	          <li>
	            <a href="<%=request.getContextPath()%>/headquater.jsp?page=headquater/sales.jsp"
	               class="nav-link <%= isSalesPage ? "active" : "" %>">
	              <i class="bi bi-folder"></i> 매출/회계 페이지
	            </a>
	          </li>
	        </ul>
	      </li>
	
	      <!-- 재고 -->
	      <li class="nav-item">
	        <a href="#"
	           class="nav-link d-flex align-items-center gap-2"
	           id="toggleStockMenu"
	           onclick="event.preventDefault(); toggleSubmenu('stockMenu', this);">
	          <i class="bi <%= isStockPage ? "bi-caret-down-fill" : "bi-caret-right-fill" %>"></i>
	          <i class="bi <%= isStockPage ? "bi-folder2-open" : "bi-folder" %>"></i>
	          재고
	        </a>
	        <ul id="stockMenu" class="submenu <%= isStockPage ? "open" : "" %>" style="padding-left: 3rem;">
	          <li>
	            <a href="<%=request.getContextPath()%>/headquater.jsp?page=headquater/stock.jsp"
	               class="nav-link <%= isStockPage ? "active" : "" %>">
	              <i class="bi bi-folder"></i> 재고 페이지
	            </a>
	          </li>
	        </ul>
	      </li>
	
	      <!-- 본사 내부 게시판 -->
	      <li class="nav-item">
	        <a href="#"
	           class="nav-link d-flex align-items-center gap-2"
	           id="toggleHqBoardMenu"
	           onclick="event.preventDefault(); toggleSubmenu('hqBoardMenu', this);">
	          <i class="bi <%= isHqBoardPage ? "bi-caret-down-fill" : "bi-caret-right-fill" %>"></i>
	          <i class="bi <%= isHqBoardPage ? "bi-folder2-open" : "bi-folder" %>"></i>
	          본사 내부 게시판
	        </a>
	        <ul id="hqBoardMenu" class="submenu <%= isHqBoardPage ? "open" : "" %>" style="padding-left: 3rem;">
	          <li>
	            <a href="<%=request.getContextPath()%>/headquater.jsp?page=hqboard/hq-list.jsp"
	               class="nav-link <%= "hqboard/hq-list.jsp".equals(pageParam) ? "active" : "" %>">
	              <i class="bi bi-folder"></i> 내부 게시판 목록
	            </a>
	          </li>
	        </ul>
	      </li>
	
	      <!-- 직원관리 -->
	      <li class="nav-item">
	        <a href="#"
	           class="nav-link d-flex align-items-center gap-2"
	           id="toggleHrmMenu"
	           onclick="event.preventDefault(); toggleSubmenu('hrmMenu', this);">
	          <i class="bi <%= isHrmPage ? "bi-caret-down-fill" : "bi-caret-right-fill" %>"></i>
	          <i class="bi <%= isHrmPage ? "bi-folder2-open" : "bi-folder" %>"></i>
	          직원관리
	        </a>
	        <ul id="hrmMenu" class="submenu <%= isHrmPage ? "open" : "" %>" style="padding-left: 3rem;">
	          <li>
	            <a href="<%=request.getContextPath()%>/headquater.jsp?page=hrm/list.jsp"
	               class="nav-link <%= "hrm/list.jsp".equals(pageParam) ? "active" : "" %>">
	              <i class="bi bi-folder"></i> 직원 목록
	            </a>
	          </li>
	        </ul>
	      </li>
	
	    </ul>
	  </div>
	</nav>
	
	<style>
	  .submenu {
	    height: 0;
	    overflow: hidden;
	    transition: height 0.3s ease;
	    margin: 0;
	    list-style: none;
	  }
	  .submenu.open {
	    height: auto !important;
	  }
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
	
	<script>
	  function toggleSubmenu(submenuId, toggleBtn) {
	    const submenu = document.getElementById(submenuId);
	    const isOpen = submenu.classList.contains('open');
	
	    if (isOpen) {
	      submenu.style.height = submenu.scrollHeight + 'px';
	      submenu.offsetHeight;
	      submenu.style.height = '0';
	      submenu.classList.remove('open');
	      toggleBtn.querySelectorAll('i')[0].className = 'bi bi-caret-right-fill';
	      toggleBtn.querySelectorAll('i')[1].className = 'bi bi-folder';
	    } else {
	      submenu.style.height = submenu.scrollHeight + 'px';
	      submenu.classList.add('open');
	      setTimeout(() => submenu.style.height = 'auto', 300);
	      toggleBtn.querySelectorAll('i')[0].className = 'bi bi-caret-down-fill';
	      toggleBtn.querySelectorAll('i')[1].className = 'bi bi-folder2-open';
	    }
	  }
	
	  document.addEventListener('DOMContentLoaded', () => {
	    document.querySelectorAll('.submenu.open').forEach(submenu => {
	      submenu.style.height = 'auto';
	    });
	  });
	</script>
=======
=======

>>>>>>> origin/main
    boolean isHrmPage = pageParam != null && pageParam.startsWith("hrm/");
%>

<nav id="sidebar" class="bg-light border-end" style="width: 250px; min-height: 100vh; flex-shrink: 0;">
  <div class="p-3">
    <h4>본사 메뉴</h4>
    <ul class="nav flex-column">

      <!-- 상품관리 -->
      <li class="nav-item">
        <a href="#"
           class="nav-link d-flex justify-content-between align-items-center"
           id="toggleProductMenu"
           aria-expanded="<%= isProductPage ? "true" : "false" %>"
           aria-controls="productMenu"
           onclick="event.preventDefault();">
          상품관리
<<<<<<< HEAD
          <i class="bi <%= isProductPage ? "bi-caret-down-fill" : "bi-caret-right-fill" %>"></i>
        </a>
        <ul id="productMenu" class="submenu <%= isProductPage ? "open" : "" %>" style="padding-left: 1rem;">
=======

        </a>
        <ul id="productMenu" class="submenu <%= isProductPage ? "open" : "" %>" style="padding-left: 3rem;">

>>>>>>> origin/main
          <li>
            <a class="nav-link <%= "product/insertform.jsp".equals(pageParam) ? "active" : "" %>"
               href="<%=request.getContextPath()%>/headquater.jsp?page=product/insertform.jsp">
              <i class="bi bi-caret-right-fill"></i> 상품 등록
            </a>
          </li>
          <li>
            <a class="nav-link <%= "product/list.jsp".equals(pageParam) ? "active" : "" %>"
               href="<%=request.getContextPath()%>/headquater.jsp?page=product/list.jsp">
              <i class="bi bi-caret-right-fill"></i> 상품 목록
            </a>
          </li>
        </ul>
      </li>

      <!-- 지점관리 -->
      <li class="nav-item">
<<<<<<< HEAD
        <a class="nav-link <%= "branch-admin/list.jsp".equals(request.getParameter("page")) ? "active" : "" %>"
           href="<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/main.jsp">
           지점관리
        </a>
=======

        <a href="#"
           class="nav-link d-flex align-items-center gap-2"
           id="toggleBranchMenu"
           onclick="event.preventDefault(); toggleSubmenu('branchMenu', this);">
          <i class="bi <%= isBranchPage ? "bi-caret-down-fill" : "bi-caret-right-fill" %>"></i>
          <i class="bi <%= isBranchPage ? "bi-folder2-open" : "bi-folder" %>"></i>
          지점관리
        </a>
        <ul id="branchMenu" class="submenu <%= isBranchPage ? "open" : "" %>" style="padding-left: 3rem;">
          <li>
            <a href="<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/list.jsp"
               class="nav-link <%= "branch-admin/list.jsp".equals(pageParam) ? "active" : "" %>">
              <i class="bi bi-folder"></i> 지점 목록
            </a>
          </li>
        </ul>

>>>>>>> origin/main
      </li>

      <!-- 게시판 -->
      <li class="nav-item">
        <a class="nav-link <%= "board/list.jsp".equals(pageParam) ? "active" : "" %>"
           href="<%=request.getContextPath()%>/headquater.jsp?page=board/list.jsp">게시판</a>
      </li>

      <!-- 매출/회계 -->
      <li class="nav-item">
        <a class="nav-link <%= "headquater/sales.jsp".equals(pageParam) ? "active" : "" %>"
           href="<%=request.getContextPath()%>/headquater.jsp?page=headquater/sales.jsp">매출/회계</a>
      </li>

      <!-- 재고 -->
      <li class="nav-item">
        <a class="nav-link <%= "headquater/stock.jsp".equals(pageParam) ? "active" : "" %>"
           href="<%=request.getContextPath()%>/headquater.jsp?page=headquater/stock.jsp">재고</a>
      </li>

      <!-- 본사 내부 게시판 -->
      <li class="nav-item">
        <a class="nav-link <%= "hqboard/hq-list.jsp".equals(pageParam) ? "active" : "" %>"
           href="<%=request.getContextPath()%>/headquater.jsp?page=hqboard/hq-list.jsp">본사 내부 게시판</a>
      </li>

      <!-- 직원관리 -->
      <li class="nav-item">
        <a href="#"
<<<<<<< HEAD
           class="nav-link d-flex justify-content-between align-items-center"
           id="toggleHrmMenu"
           aria-expanded="<%= isHrmPage ? "true" : "false" %>"
           aria-controls="hrmMenu"
           onclick="event.preventDefault();">
          직원 관리
          <i class="bi <%= isHrmPage ? "bi-caret-down-fill" : "bi-caret-right-fill" %>"></i>
        </a>
        <ul id="hrmMenu" class="submenu <%= isHrmPage ? "open" : "" %>" style="padding-left: 1rem;">
          <li>
            <a class="nav-link <%= "hrm/list.jsp".equals(pageParam) ? "active" : "" %>"
               href="<%=request.getContextPath()%>/headquater.jsp?page=hrm/list.jsp">
              <i class="bi bi-caret-right-fill"></i> 직원 목록
=======

           class="nav-link d-flex align-items-center gap-2"
           id="toggleHrmMenu"
           onclick="event.preventDefault(); toggleSubmenu('hrmMenu', this);">
          <i class="bi <%= isHrmPage ? "bi-caret-down-fill" : "bi-caret-right-fill" %>"></i>
          <i class="bi <%= isHrmPage ? "bi-folder2-open" : "bi-folder" %>"></i>
          직원관리
        </a>
        <ul id="hrmMenu" class="submenu <%= isHrmPage ? "open" : "" %>" style="padding-left: 3rem;">
          <li>
            <a href="<%=request.getContextPath()%>/headquater.jsp?page=hrm/list.jsp"
               class="nav-link <%= "hrm/list.jsp".equals(pageParam) ? "active" : "" %>">
              <i class="bi bi-folder"></i> 직원 목록

>>>>>>> origin/main
            </a>
          </li>
        </ul>
      </li>

    </ul>
  </div>
</nav>

<style>
  .submenu {
    width: 180px;
    height: 0;
    overflow: hidden;
    transition: height 0.3s ease;
    margin: 0;
    padding-left: 0;
    list-style: none;
  }
<<<<<<< HEAD
  .submenu.open { height: auto !important; }
  .submenu li { white-space: normal; }
  .submenu li a.nav-link { padding-left: 0.5rem; }
  #toggleProductMenu.active,
  #toggleHrmMenu.active {
=======

  .submenu.open {
    height: auto !important;
  }
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

>>>>>>> origin/main
    font-weight: 700;
    color: #0d6efd;
  }
</style>

<script>
<<<<<<< HEAD
  document.addEventListener('DOMContentLoaded', () => {
    const menus = [
      { btn: 'toggleProductMenu', list: 'productMenu' },
      { btn: 'toggleHrmMenu', list: 'hrmMenu' }
    ];

    function openMenu(toggleBtn, submenu) {
      submenu.style.height = submenu.scrollHeight + 'px';
      toggleBtn.setAttribute('aria-expanded', 'true');
      toggleBtn.classList.add('active');
      submenu.classList.add('open');
      toggleBtn.querySelector('i').className = 'bi bi-caret-down-fill';
      setTimeout(() => { submenu.style.height = 'auto'; }, 300);
    }

    function closeMenu(toggleBtn, submenu) {
      submenu.style.height = submenu.scrollHeight + 'px';
      submenu.offsetHeight;
      submenu.style.height = '0';
      toggleBtn.setAttribute('aria-expanded', 'false');
      toggleBtn.classList.remove('active');
      submenu.classList.remove('open');
      toggleBtn.querySelector('i').className = 'bi bi-caret-right-fill';
    }

    menus.forEach(({ btn, list }) => {
      const toggleBtn = document.getElementById(btn);
      const submenu = document.getElementById(list);
      const isOpen = submenu.classList.contains('open');

      toggleBtn.addEventListener('click', e => {
        e.preventDefault();
        submenu.classList.contains('open') ? closeMenu(toggleBtn, submenu) : openMenu(toggleBtn, submenu);
      });

      // 초기 로딩 상태
      if (isOpen) {
        toggleBtn.classList.add('active');
        toggleBtn.setAttribute('aria-expanded', 'true');
        submenu.style.height = 'auto';
        toggleBtn.querySelector('i').className = 'bi bi-caret-down-fill';
      } else {
        toggleBtn.classList.remove('active');
        toggleBtn.setAttribute('aria-expanded', 'false');
        submenu.style.height = '0';
        toggleBtn.querySelector('i').className = 'bi bi-caret-right-fill';
      }
=======

  function toggleSubmenu(submenuId, toggleBtn) {
    const submenu = document.getElementById(submenuId);
    const isOpen = submenu.classList.contains('open');

    if (isOpen) {

      submenu.style.height = submenu.scrollHeight + 'px';
      submenu.offsetHeight;
      submenu.style.height = '0';
      submenu.classList.remove('open');

      toggleBtn.querySelectorAll('i')[0].className = 'bi bi-caret-right-fill';
      toggleBtn.querySelectorAll('i')[1].className = 'bi bi-folder';
    } else {
      submenu.style.height = submenu.scrollHeight + 'px';
      submenu.classList.add('open');
      setTimeout(() => submenu.style.height = 'auto', 300);
      toggleBtn.querySelectorAll('i')[0].className = 'bi bi-caret-down-fill';
      toggleBtn.querySelectorAll('i')[1].className = 'bi bi-folder2-open';

    }
  }

  document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('.submenu.open').forEach(submenu => {
      submenu.style.height = 'auto';
>>>>>>> origin/main
    });
  });

</script>
>>>>>>> 72e7f5dc9479ee103b005f61aab18dc366d19d59

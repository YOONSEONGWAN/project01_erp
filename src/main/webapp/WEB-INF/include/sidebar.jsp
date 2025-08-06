<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" />

<%
    String pageParam = request.getParameter("page");
    boolean isProductPage = pageParam != null && pageParam.startsWith("product/");
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
           aria-expanded="<%= isProductPage ? "true" : "false" %>"
           aria-controls="productMenu"
           onclick="event.preventDefault(); toggleSubmenu('productMenu', this);">
          <i class="bi <%= isProductPage ? "bi-caret-down-fill" : "bi-caret-right-fill" %>"></i> <!-- 화살표 아이콘 -->
          <i class="bi <%= isProductPage ? "bi-folder2-open" : "bi-folder" %>"></i>           <!-- 폴더 아이콘 -->
          상품관리
        </a>
        <ul id="productMenu" class="submenu <%= isProductPage ? "open" : "" %>" style="padding-left: 3rem;">
          <li>
            <a href="<%=request.getContextPath()%>/headquater.jsp?page=product/insertform.jsp"
               class="nav-link d-flex align-items-center gap-2 <%= "product/insertform.jsp".equals(pageParam) ? "active" : "" %>">
              <i class="bi bi-folder"></i>
              상품 등록
            </a>
          </li>
          <li>
            <a href="<%=request.getContextPath()%>/headquater.jsp?page=product/list.jsp"
               class="nav-link d-flex align-items-center gap-2 <%= "product/list.jsp".equals(pageParam) ? "active" : "" %>">
              <i class="bi bi-folder"></i>
              상품 목록
            </a>
          </li>
        </ul>
      </li>

      <!-- 지점관리 -->
      <li class="nav-item">
        <a class="nav-link <%= "branch-admin/list.jsp".equals(pageParam) ? "active" : "" %>"
           href="<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/list.jsp">지점관리</a>
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
           class="nav-link d-flex align-items-center gap-2"
           id="toggleHrmMenu"
           aria-expanded="<%= isHrmPage ? "true" : "false" %>"
           aria-controls="hrmMenu"
           onclick="event.preventDefault(); toggleSubmenu('hrmMenu', this);">
          <i class="bi <%= isHrmPage ? "bi-caret-down-fill" : "bi-caret-right-fill" %>"></i> <!-- 화살표 아이콘 -->
          <i class="bi <%= isHrmPage ? "bi-folder2-open" : "bi-folder" %>"></i>           <!-- 폴더 아이콘 -->
          직원 관리
        </a>
        <ul id="hrmMenu" class="submenu <%= isHrmPage ? "open" : "" %>" style="padding-left: 3rem;">
          <li>
            <a href="<%=request.getContextPath()%>/headquater.jsp?page=hrm/list.jsp"
               class="nav-link d-flex align-items-center gap-2 <%= "hrm/list.jsp".equals(pageParam) ? "active" : "" %>">
              <i class="bi bi-folder"></i>
              직원 목록
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
  .submenu.open {
    height: auto !important;
  }
  .submenu li {
    white-space: normal;
  }
  .submenu li a.nav-link {
    padding-left: 0.5rem;
  }
  .nav-link.active {
    font-weight: 700;
    color: #0d6efd;
  }
</style>

<script>
  function toggleSubmenu(submenuId, toggleBtn) {
    const submenu = document.getElementById(submenuId);
    const isOpen = submenu.classList.contains('open');

    if (isOpen) {
      // 닫기
      submenu.style.height = submenu.scrollHeight + 'px';
      submenu.offsetHeight; // 강제 리플로우
      submenu.style.height = '0';
      submenu.classList.remove('open');

      // 화살표 -> 오른쪽, 폴더 -> 닫힘
      const icons = toggleBtn.querySelectorAll('i');
      icons[0].className = 'bi bi-caret-right-fill';
      icons[1].className = 'bi bi-folder';
    } else {
      // 열기
      submenu.style.height = submenu.scrollHeight + 'px';
      submenu.classList.add('open');
      setTimeout(() => {
        submenu.style.height = 'auto';
      }, 300);

      // 화살표 -> 아래, 폴더 -> 열림
      const icons = toggleBtn.querySelectorAll('i');
      icons[0].className = 'bi bi-caret-down-fill';
      icons[1].className = 'bi bi-folder2-open';
    }
  }

  document.addEventListener('DOMContentLoaded', () => {
    ['toggleProductMenu', 'toggleHrmMenu'].forEach(id => {
      const toggleBtn = document.getElementById(id);
      const submenu = document.getElementById(id === 'toggleProductMenu' ? 'productMenu' : 'hrmMenu');
      if (submenu.classList.contains('open')) {
        const icons = toggleBtn.querySelectorAll('i');
        icons[0].className = 'bi bi-caret-down-fill';
        icons[1].className = 'bi bi-folder2-open';
        submenu.style.height = 'auto';
      } else {
        const icons = toggleBtn.querySelectorAll('i');
        icons[0].className = 'bi bi-caret-right-fill';
        icons[1].className = 'bi bi-folder';
        submenu.style.height = '0';
      }
    });
  });
</script>

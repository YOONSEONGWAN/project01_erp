<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" />

<%
    String pageParam = request.getParameter("page");
    boolean isProductPage = pageParam != null && pageParam.startsWith("product/");
%>

<nav id="sidebar" class="bg-light border-end" style="width: 250px; min-height: 100vh; flex-shrink: 0;">
  <div class="p-3">
    <h4>본사 메뉴</h4>
    <ul class="nav flex-column">

      <!-- 상품관리 (토글 버튼) -->
      <li class="nav-item">
        <a href="#"
           class="nav-link d-flex justify-content-between align-items-center"
           id="toggleProductMenu"
           aria-expanded="<%= isProductPage ? "true" : "false" %>"
           aria-controls="productMenu"
           onclick="event.preventDefault();">
          상품관리
          <i class="bi bi-caret-down-fill"></i>
        </a>

        <!-- 서버에서 열림 상태면 open 클래스 붙여서 height auto 처리 -->
        <ul id="productMenu" class="submenu <%= isProductPage ? "open" : "" %>" style="padding-left: 1rem;">
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

      <!-- 나머지 메뉴들 -->
      <li class="nav-item">
        <a class="nav-link <%= "branch-admin/list.jsp".equals(pageParam) ? "active" : "" %>"
           href="<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/list.jsp">지점관리</a>
      </li>

      <li class="nav-item">
        <a class="nav-link <%= "board/list.jsp".equals(pageParam) ? "active" : "" %>"
           href="<%=request.getContextPath()%>/headquater.jsp?page=board/list.jsp">게시판</a>
      </li>

      <li class="nav-item">
        <a class="nav-link <%= "headquater/sales.jsp".equals(pageParam) ? "active" : "" %>"
           href="<%=request.getContextPath()%>/headquater.jsp?page=headquater/sales.jsp">매출/회계</a>
      </li>

      <li class="nav-item">
        <a class="nav-link <%= "headquater/stock.jsp".equals(pageParam) ? "active" : "" %>"
           href="<%=request.getContextPath()%>/headquater.jsp?page=headquater/stock.jsp">재고</a>
      </li>

      <li class="nav-item">
        <a class="nav-link <%= "hqboard/hq-list.jsp".equals(pageParam) ? "active" : "" %>"
           href="<%=request.getContextPath()%>/headquater.jsp?page=hqboard/hq-list.jsp">본사 내부 게시판</a>
      </li>

      <li class="nav-item">
        <a class="nav-link <%= "hrm/list.jsp".equals(pageParam) ? "active" : "" %>"
           href="<%=request.getContextPath()%>/headquater.jsp?page=hrm/list.jsp">직원 관리</a>
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

  /* 서버에서 open 클래스 붙은 건 바로 보이게 height auto 처리 */
  .submenu.open {
    height: auto !important;
  }

  .submenu li {
    white-space: normal;
  }

  .submenu li a.nav-link {
    padding-left: 0.5rem;
  }

  #toggleProductMenu.active {
    font-weight: 700;
    color: #0d6efd;
  }
</style>

<script>
  document.addEventListener('DOMContentLoaded', () => {
    const toggleBtn = document.getElementById('toggleProductMenu');
    const submenu = document.getElementById('productMenu');

    // 초기 열림 상태는 서버에서 결정해서 open 클래스 붙여놨음
    const isOpen = submenu.classList.contains('open');

    function openMenu() {
      submenu.style.height = submenu.scrollHeight + 'px';
      toggleBtn.setAttribute('aria-expanded', 'true');
      toggleBtn.classList.add('active');
      submenu.classList.add('open');

      setTimeout(() => {
        submenu.style.height = 'auto';
      }, 300);
    }

    function closeMenu() {
      submenu.style.height = submenu.scrollHeight + 'px';
      submenu.offsetHeight; // 강제 리플로우
      submenu.style.height = '0';
      toggleBtn.setAttribute('aria-expanded', 'false');
      toggleBtn.classList.remove('active');
      submenu.classList.remove('open');
    }

    toggleBtn.addEventListener('click', (e) => {
      e.preventDefault();
      if (submenu.classList.contains('open')) {
        closeMenu();
      } else {
        openMenu();
      }
    });

    // 초기 로딩 시 active 상태 세팅
    if (isOpen) {
      toggleBtn.classList.add('active');
      toggleBtn.setAttribute('aria-expanded', 'true');
      submenu.style.height = 'auto';
    } else {
      toggleBtn.classList.remove('active');
      toggleBtn.setAttribute('aria-expanded', 'false');
      submenu.style.height = '0';
    }
  });
</script>

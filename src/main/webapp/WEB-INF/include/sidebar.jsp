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
           class="nav-link d-flex justify-content-between align-items-center"
           id="toggleProductMenu"
           aria-expanded="<%= isProductPage ? "true" : "false" %>"
           aria-controls="productMenu"
           onclick="event.preventDefault();">
          상품관리
          <i class="bi <%= isProductPage ? "bi-caret-down-fill" : "bi-caret-right-fill" %>"></i>
        </a>
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
  .submenu.open { height: auto !important; }
  .submenu li { white-space: normal; }
  .submenu li a.nav-link { padding-left: 0.5rem; }
  #toggleProductMenu.active,
  #toggleHrmMenu.active {
    font-weight: 700;
    color: #0d6efd;
  }
</style>

<script>
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
    });
  });

</script>

<%
    String branchId = (String)session.getAttribute("branchId");
%>
   <nav id="sidebar" class="bg-light border-end" style="width: 250px; min-height: 100vh; flex-shrink: 0;">
     <div class="p-3">
        <%if("HQ".equals(branchId)) {%>
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
                 href="<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/main.jsp">
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
        <%}else if(branchId.startsWith("BC")) { %>
           <h4>지점 메뉴</h4>
           <ul class="nav nav-pills flex-column">
              <li class="nav-item">
                   <a class="nav-link <%= "order/list.jsp".equals(request.getParameter("page")) ? "active" : "" %>"
                      href="<%=request.getContextPath()%>/headquater.jsp?page=order/list.jsp">
                      발주신청
                   </a>
              </li>
              <li class="nav-item">
                <a class="nav-link <%= "board/list.jsp".equals(request.getParameter("page")) ? "active" : "" %>"
                   href="<%=request.getContextPath()%>/headquater.jsp?page=board/main.jsp">
                   지점게시판
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link <%= "work-log/view-work_log.jsp".equals(request.getParameter("page")) ? "active" : "" %>"
                   href="<%=request.getContextPath()%>/headquater.jsp?page=work-log/work_log.jsp">
                   출퇴근관리
                </a>
              </li>
           </ul>
        <%} %>
     </div>
   </nav>


</script>


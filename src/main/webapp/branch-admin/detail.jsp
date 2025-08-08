<%@page import="dto.UserDtoAdmin"%>
<%@page import="java.util.List"%>
<%@page import="dao.BranchDao"%>
<%@page import="dto.BranchDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//get 방식 파라미터로 전달되는 지점번호 얻어내기
	int num=Integer.parseInt(request.getParameter("num"));
	//DB 에서 해당 지점의 자세한 정보를 얻어낸다.
	BranchDto dto=BranchDao.getInstance().getByNum(num);
	
	List<UserDtoAdmin> clerkList=BranchDao.getInstance().getListWithRole(dto.getBranch_id());
	List<UserDtoAdmin> managerList=BranchDao.getInstance().getManagerListByBranchId(dto.getBranch_id());

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/branch-admin/detail.jsp</title>
<jsp:include page="/WEB-INF/include/resource.jsp"></jsp:include>

<style>
    .container {
        max-width: 100%;
        padding: 0 15px;
    }
    .card {
        border-radius: 0;
        box-shadow: none;
    }
    .card-body {
        padding: 20px;
    }
    .btn-primary {
        background-color: #003366 !important;
        border-color: #003366 !important;
        color: white !important;
        font-weight: 500;
        border-radius: 6px;
    }
    .btn-primary:hover {
        background-color: #002244 !important;
        border-color: #002244 !important;
        color: white !important;
    }
</style>
</head>
<body>

<div class="container mt-4">
    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" class="mb-3">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/headquater.jsp?page=index/headquaterindex.jsp">홈</a></li>
            <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/list.jsp">지점 목록</a></li>
            <li class="breadcrumb-item active" aria-current="page">지점 상세 정보</li>
        </ol>
    </nav>

    <div class="card shadow-sm">
        <div class="card-header bg-primary text-white">
            <h4 class="mb-0">지점 상세 정보</h4>
        </div>
        <div class="card-body">
            <table class="table table-bordered align-middle w-75 mx-auto">
                <tr>
                    <th class="table-secondary" style="width: 25%;">지점 고유 번호</th>
                    <td><%=dto.getBranch_id() %></td>
                </tr>
                <tr>
                    <th class="table-secondary">지점 이름</th>
                    <td><%=dto.getName() %></td>
                </tr>
                <tr>
                    <th class="table-secondary">주소</th>
                    <td><%=dto.getAddress() %></td>
                </tr>
                <tr>
                    <th class="table-secondary">지점 연락처</th>
                    <td><%=dto.getPhone() %></td>
                </tr>
                <tr>
                    <th class="table-secondary">지점장 목록</th>
                    <td>
                        <% for(UserDtoAdmin manager : managerList){ %>
                            <a href="<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/roleupdate-form.jsp?num=<%=manager.getNum()%>">
                                <%=manager.getUser_name()%>
                            </a><br/>
                        <% } %>
                    </td>
                </tr>
                <tr>
                    <th class="table-secondary">직원 목록</th>
                    <td>
                        <% for(UserDtoAdmin clerk : clerkList){ %>
                            <a href="<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/roleupdate-form.jsp?num=<%=clerk.getNum()%>">
                                <%=clerk.getUser_name()%>
                            </a> <%=clerk.getRole().equals("clerk") ? "(직원)" : "(미등록)" %><br/>
                        <% } %>
                    </td>
                </tr>
                <tr>
                    <th class="table-secondary">등록일</th>
                    <td><%=dto.getCreatedAt() %></td>
                </tr>
                <tr>
                    <th class="table-secondary">수정일</th>
                    <td><%=dto.getUpdatedAt() == null ? "" : dto.getUpdatedAt() %></td>
                </tr>
                <tr>
                    <th class="table-secondary">운영 상태</th>
                    <td><%=dto.getStatus() %></td>
                </tr>
            </table>

			<!-- 버튼 영역 -->
			<div class="w-75 mx-auto mt-4">
			    <div class="d-flex justify-content-between align-items-center">
			        <!-- 왼쪽에 빈 공간으로 밀어냄 -->
			        <div style="width: 33%;"></div>
			        
			        <!-- 목록 버튼: 가운데 정렬 -->
			        <div class="text-center" style="width: 33%;">
			            <a href="<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/list.jsp" 
			               class="btn btn-secondary">
			               <i class="bi bi-list"></i> 
			               목록</a>
			        </div>
			
			        <!-- 삭제 버튼: 오른쪽 정렬 -->
			        <div class="text-end" style="width: 33%;">
			            <a href="#"
			               class="btn btn-danger"
			               id="delete-btn"
			               data-num="<%=dto.getNum()%>">삭제</a>
			        </div>
			    </div>
			</div>
        </div>
    </div>
</div>

<script>
    document.querySelector("#delete-btn").addEventListener("click", (e) => {
        e.preventDefault();
        const num = e.currentTarget.getAttribute("data-num"); 
        const isDelete = confirm(num + " 번 지점을 삭제 하시겠습니까?");
        if (isDelete) {
            location.href = `<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/delete.jsp?num=\${num}`;
        }
    });
</script>

<%
    String alertMsg = (String) session.getAttribute("alertMsg");
    if (alertMsg != null) {
        session.removeAttribute("alertMsg");
%>
<script>
    alert("<%= alertMsg %>");
</script>
<% } %>

</body>
</html>
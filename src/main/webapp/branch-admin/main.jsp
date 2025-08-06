<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/branch-admin/main.jsp</title>
<jsp:include page="/WEB-INF/include/resource.jsp"></jsp:include>
<style>
    .btn-square {
        width: 160px;
        height: 160px;
        font-size: 1.2rem;
        font-weight: bold;
        display: flex;
        align-items: center;
        justify-content: center;
        text-align: center;
        white-space: normal;
    }
</style>
</head>
<body>
    <div class="container">
        <nav aria-label="breadcrumb">
          <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/index/headquaterindex.jsp">Home</a></li>
            <li class="breadcrumb-item active" aria-current="page">지점 관리</li>
          </ol>
        </nav>

        <!-- 가운데 정렬 영역 -->
        <div class="d-flex justify-content-center align-items-center" style="height: 70vh;">
            <div class="d-flex gap-4">
                <a class="btn btn-primary btn-square" href="<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/insert-form.jsp">지점 등록</a>
                <a class="btn btn-primary btn-square" href="<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/list.jsp">지점 목록</a>
                <a class="btn btn-primary btn-square" href="<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/user-list.jsp">직원 관리</a>
            </div>
        </div>
    </div>
</body>
</html>
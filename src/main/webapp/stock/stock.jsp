<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>재고 관리 메인</title>
<jsp:include page="/WEB-INF/include/resource.jsp"/>
</head>
<body class="bg-light">

    <div class="container py-5">
        <div class="text-center mb-4">
            <h1 class="fw-bold">재고 관리 시스템</h1>
            <p class="text-muted">원하는 메뉴를 선택하세요</p>
        </div>

        <div class="row justify-content-center">
            <div class="col-md-6">

                <div class="list-group shadow-sm">
                    <a href="stocklist.jsp" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                        <span> 재고 리스트</span>
                        
                    </a>
                    <a href="inandout.jsp" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                        <span>입고 / 출고</span>
                        
                    </a>
                </div>

            </div>
        </div>
    </div>

   
</body>
</html>
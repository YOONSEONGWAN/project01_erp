<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String thisPage = request.getParameter("thisPage");
    String userId = (String)session.getAttribute("userId");
    String branchId = (String)session.getAttribute("branchId");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>지점 대시보드</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" />
<style>
    body {
        background: #f9fafc;
    }
    .dashboard-card {
        border-radius: 1rem;
        box-shadow: 0 2px 12px rgba(0,0,0,0.04);
        background: #fff;
        padding: 2rem;
        height: 100%;
        min-height: 140px;
    }
    .dashboard-quick {
        background: #eef3fb;
        border-radius: 0.75rem;
        padding: 1.5rem;
    }
    .dashboard-title {
        color: #3a53ce;
        font-weight: 700;
    }
</style>
</head>
<body>
    <div class="container-fluid pt-5 px-4">
        <div class="row mb-4 align-items-center">
            <div class="col-md-8">
                <h2 class="dashboard-title mb-0">
                    <i class="bi bi-house-fill"></i>
                    <%= branchId != null ? branchId : "지점" %> 대시보드
                </h2>
                <div class="mt-1 text-secondary" style="font-size: 1.1rem;">
                    <%= userId %>님, 환영합니다!
                </div>
            </div>
        </div>

        <div class="row g-4 mb-2">
            <div class="col-md-3">
                <div class="dashboard-card">
                    <div class="d-flex align-items-center mb-2">
                        <i class="bi bi-box-seam fs-3 me-3 text-primary"></i>
                        <div>
                            <div class="fw-bold">오늘 발주 내역</div>
                            <div class="text-muted small">신규: <span style="font-weight:600">3건</span></div>
                        </div>
                    </div>
                    <a href="<%=request.getContextPath()%>/branch.jsp?page=order/list.jsp" class="btn btn-link ps-0">자세히 보기 <i class="bi bi-arrow-right"></i></a>
                </div>
            </div>
            <div class="col-md-3">
                <div class="dashboard-card">
                    <div class="d-flex align-items-center mb-2">
                        <i class="bi bi-graph-up-arrow fs-3 me-3 text-success"></i>
                        <div>
                            <div class="fw-bold">오늘 매출</div>
                            <div class="text-muted small">금액: <span style="font-weight:600">520,000원</span></div>
                        </div>
                    </div>
                    <a href="<%=request.getContextPath()%>/branch.jsp?page=branch-sales/list.jsp" class="btn btn-link ps-0">매출 상세 <i class="bi bi-arrow-right"></i></a>
                </div>
            </div>
            <div class="col-md-3">
                <div class="dashboard-card">
                    <div class="d-flex align-items-center mb-2">
                        <i class="bi bi-calendar-check fs-3 me-3 text-info"></i>
                        <div>
                            <div class="fw-bold">출근 현황</div>
                            <div class="text-muted small">출근: <span style="font-weight:600">2명</span></div>
                        </div>
                    </div>
                    <a href="<%=request.getContextPath()%>/branch.jsp?page=work-log/work_log.jsp" class="btn btn-link ps-0">출퇴근 관리 <i class="bi bi-arrow-right"></i></a>
                </div>
            </div>
            <div class="col-md-3">
                <div class="dashboard-card">
                    <div class="d-flex align-items-center mb-2">
                        <i class="bi bi-megaphone fs-3 me-3 text-warning"></i>
                        <div>
                            <div class="fw-bold">공지사항</div>
                            <div class="text-muted small">2건</div>
                        </div>
                    </div>
                    <a href="<%=request.getContextPath()%>/branch.jsp?page=board/list.jsp" class="btn btn-link ps-0">게시판 바로가기 <i class="bi bi-arrow-right"></i></a>
                </div>
            </div>
        </div>

        <div class="row mt-4">
            <div class="col">
                <div class="dashboard-quick d-flex align-items-center gap-4">
                    <span class="fs-5"><i class="bi bi-stars"></i> 빠른 메뉴:</span>
                    <a href="<%=request.getContextPath()%>/branch.jsp?page=order/insert.jsp" class="btn btn-outline-primary btn-sm">신규 발주</a>
                    <a href="<%=request.getContextPath()%>/branch.jsp?page=work-log/work_log.jsp" class="btn btn-outline-info btn-sm">출퇴근</a>
                    <a href="<%=request.getContextPath()%>/branch.jsp?page=branch-sales/list.jsp" class="btn btn-outline-success btn-sm">매출관리</a>
                    <a href="<%=request.getContextPath()%>/branch.jsp?page=board/list.jsp" class="btn btn-outline-warning btn-sm">게시판</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>

<%@page import="dao.BranchInfoDao"%>
<%@page import="dto.BranchInfoDto"%>
<%@page import="dao.UserDao"%>
<%@page import="dto.UserDto"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    //세션에 저장된 userName 을 읽어온다. (이미 로그인된 상태이기 때문에)
	 String userId=(String)session.getAttribute("userId");
	
	//DB 에서 사용자 정보를 읽어온다.
	BranchInfoDto dto=BranchInfoDao.getInstance().getByUserId(userId);
%> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/user/edit.jsp</title>
<jsp:include page="/WEB-INF/include/resource.jsp"></jsp:include>
</head>
<body>
	 <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white">
                        <h4 class="mb-0">가입정보 수정 양식</h4>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath }/branchinfo/update" method="post" enctype="multipart/form-data">
                            <input type="hidden" name="userId" value="<%=userId %>" />

                            <div class="mb-3">
							    <label for="branchName" class="form-label">지점 이름</label>
							    <input type="text" class="form-control bg-light border-0" name="branchName"
							           value="<%=dto.getBranch_name() %>" readonly style="pointer-events: none;" />
							</div>

                            <div class="mb-3">
							    <label for="userName" class="form-label">지점장 이름</label>
							    <input type="text" class="form-control bg-light border-0" name="userName"
							           value="<%=dto.getUser_name() %>" readonly style="pointer-events: none;" />
							</div>

                            <div class="mb-3">
                                <label for="branchAddress" class="form-label">지점 주소</label>
                                <input type="text" class="form-control" name="branchAddress" value="<%=dto.getBranch_address() %>" />
                            </div>

                            <div class="mb-3">
                                <label for="branchPhone" class="form-label">지점 연락처</label>
                                <input type="text" class="form-control" name="branchPhone" value="<%=dto.getBranch_phone() %>" />
                            </div>

                            <div class="mb-3">
                                <label for="userRole" class="form-label">직급</label>
                                <input type="text" class="form-control" name="userRole" value="<%=dto.getUser_role() %>" />
                            </div>

                            <div class="text-end">
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-check-circle"></i> 수정확인
                                </button>
                                <button type="reset" class="btn btn-secondary">
                                    <i class="bi bi-x-circle"></i> 취소
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>








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
<title>info2</title>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white">
                        지점 정보
                    </div>
                    <div class="card-body">
                        <table class="table table-bordered">
                            <tbody>
                                <tr>
                                    <th scope="row">지점 이름</th>
                                    <td><%= dto.getBranch_name() %></td>
                                </tr>
                                <tr>
                                    <th scope="row">지점장 이름</th>
                                    <td><%= dto.getUser_name() %></td>
                                </tr>
                                <tr>
                                    <th scope="row">비밀번호</th>
                                    <td>
                                        <a href="edit-password2.jsp" class="btn btn-outline-secondary btn-sm">
                                            비밀번호 수정
                                        </a>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">지점 주소</th>
                                    <td><%= dto.getBranch_address() %></td>
                                </tr>
                                <tr>
                                    <th scope="row">지점 연락처</th>
                                    <td><%= dto.getBranch_phone() %></td>
                                </tr>
                                <tr>
                                    <th scope="row">직급</th>
                                    <td><%= (dto.getUser_role() != null && !dto.getUser_role().isEmpty()) ? dto.getUser_role() : "직급 정보 없음" %></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="card-footer text-end">
                        <a href="<%=request.getContextPath()%>/branch.jsp?page=branchinfo/edit2.jsp" class="btn btn-primary">
                            <i class="bi bi-gear"></i> 지점 정보 수정
                        </a>
                        <a href="${pageContext.request.contextPath}/branch.jsp" class="btn btn-primary">
                             지점으로가기<i class="bi bi-back"></i>
                        </a>
                    </div>          
                </div>
            </div>
        </div>
    </div>
</body>
</html>
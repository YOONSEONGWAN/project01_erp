
<%@page import="dto.UserDto"%>
<%@page import="dao.UserDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//세션에 저장된 userName 을 읽어온다. (이미 로그인된 상태이기 때문에)
	 String userId=(String)session.getAttribute("userId");
	
	//DB 에서 사용자 정보를 읽어온다.
	UserDto dto=UserDao.getInstance().getByUserId(userId);
%> 



<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/userp/userpinfo.jsp</title>
</head>

<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                        <h4 class="mb-0">회원 가입 정보</h4>
                        
                    </div>
                    <div class="card-body">
                        <table class="table table-bordered align-middle text-center">
                            <tr>
                                <th style="width: 30%;">프로필 이미지</th>
                                <td>
                                    <% if(dto != null) { %>
                                        <% if(dto.getProfile_image() == null){ %>
                                            <i style="font-size:200px;" class="bi bi-person-add"></i>
                                        <% } else { %>
                                            <img src="${pageContext.request.contextPath }/upload/<%=dto.getProfile_image() %>" 
                                                style="width:200px;height:200px;"/>
                                        <% } %>
                                    <% } else { %>
                                        <p>사용자 정보를 불러올 수 없습니다.</p>
                                    <% } %>
                                </td>
                            </tr>
                            <tr>
                                <th>지점장 이름</th>
                                <td><%= (dto.getUser_name() != null) ? dto.getUser_name() : "이름 정보 없음" %></td>
                            </tr>
                            <tr>
                                <th>비밀번호</th>
                                <td>
                                    <a href="<%=request.getContextPath()%>/branch.jsp?page=userp/edit-password.jsp" class="btn btn-outline-secondary btn-sm">
                                        비밀번호 수정
                                    </a>
                                </td>
                            </tr>
                            <tr>
                                <th>회원 주소</th>
                                <td><%= (dto.getLocation() != null) ? dto.getLocation() : "주소 정보 없음" %></td>
                            </tr>
                            <tr>
                                <th>전화번호</th>
                                <td><%= (dto.getPhone() != null) ? dto.getPhone() : "전화번호 정보 없음" %></td>
                            </tr>
                            <tr>
                                <th>직급</th>
                                <td><%=(dto.getRole() != null && !dto.getRole().isEmpty()) ? dto.getRole() : "직급 정보 없음" %></td>
                            </tr>
                            <tr>
                                <th>가입 날짜</th>
                                <td><%= (dto.getCreated_at() != null) ? dto.getCreated_at() : "가입일 정보 없음" %></td>
                            </tr>
                        </table>
                    </div>
                    <div class="card-footer text-end">
                        <a href="<%=request.getContextPath()%>/branch.jsp?page=userp/edit.jsp" class="btn btn-primary">
                            <i class="bi bi-person-lines-fill"></i> 개인 정보 수정
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
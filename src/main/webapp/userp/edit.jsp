
<%@page import="dao.UserDao"%>
<%@page import="dto.UserDto"%>

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
<title>/user/edit.jsp</title>
<jsp:include page="/WEB-INF/include/resource.jsp"></jsp:include>
</head>
<body>
	 <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card shadow">
                    <div class="card-header bg-success text-white">
                        <h4 class="mb-0">가입정보 수정 양식</h4>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath }/userp/update" method="post" enctype="multipart/form-data">
                            <input class="form-control" type="hidden" name="userId" value="<%=userId %>" />

                            <div class="mb-3 text-center">
                                <label class="form-label">프로필 이미지</label><br/>
                                <a href="javascript:" id="profileLink">
                                    <% if(dto.getProfile_image() == null){ %>
                                        <i style="font-size:200px;" class="bi bi-person-add"></i>
                                    <% } else { %>
                                        <img src="${pageContext.request.contextPath }/upload/<%=dto.getProfile_image() %>" 
                                            style="width:200px;height:200px;" class="img-thumbnail"/>
                                    <% } %>
                                </a>
                                <input class="form-control mt-2" type="file" name="profileImage" accept="image/*" style="display:none;" />
                            </div>

                            <div class="mb-3">
    							<label class="form-label" for="userName">지점장 이름</label>
    							<input class="form-control bg-light border-0" type="text" name="userName" 
          								value="<%=dto.getUser_id() %>" readonly style="pointer-events: none;" />
							</div>

                            <div class="mb-3">
                                <label class="form-label" for="userLocation">회원 주소</label>
                                <input class="form-control" type="text" name="userLocation" value="<%= (dto.getLocation() != null && !dto.getLocation().isEmpty()) ? dto.getLocation() : "주소 정보 없음" %>" />
                            </div>

                            <div class="mb-3">
                                <label class="form-label" for="userPhone">전화번호</label>
                                <input class="form-control" type="text" name="userPhone" value="<%= (dto.getPhone() != null && !dto.getPhone().isEmpty()) ? dto.getPhone() : "전화번호 정보 없음" %>" />
                            </div>

                            <div class="mb-3">
                                <label class="form-label" for="userRole">직급</label>
                                <input class="form-control" type="text" name="userRole" value="<%= (dto.getRole() != null && !dto.getRole().isEmpty()) ? dto.getRole() : "" %>" />
                            </div>

                           <div class="mb-3">
							    <label class="form-label" for="userCreated">가입 날짜</label>
							    <input class="form-control bg-light border-0" type="text" name="userCreated" 
							           value="<%=dto.getCreated_at() %>" readonly style="pointer-events: none;" />
							</div>

                            <div class="text-end">
                                <button class="btn btn-primary" type="submit">
                                    <i class="bi bi-check-circle"></i> 수정확인
                                </button>
                                <button class="btn btn-secondary" type="reset">
                                    <i class="bi bi-x-circle"></i> 취소
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.querySelector("#profileLink").addEventListener("click", () => {
            document.querySelector("input[name=profileImage]").click();
        });

        document.querySelector("input[name=profileImage]").addEventListener("change", (e) => {
            const files = e.target.files;
            const reader = new FileReader();
            reader.readAsDataURL(files[0]);
            reader.onload = () => {
                const img = `<img src="\${reader.result}" style="width:100px;height:100px;border-radius:50%" class="img-thumbnail">`;
                document.querySelector("#profileLink").innerHTML = img;
            };
        });
    </script>
</body>
</html>








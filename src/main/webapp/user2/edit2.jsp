<%@page import="branch.dao.UserDao"%>
<%@page import="branch.dto.UserDto"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String userName=(String)session.getAttribute("userName");
	UserDto dto=UserDao.getInstance().getByUserName(userName);
%> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/user/edit.jsp</title>
<jsp:include page="/WEB-INF/include/resource.jsp"></jsp:include>
</head>
<body>
	<div class="container">
		<h1>가입정보 수정 양식</h1>
		
		
		<%-- 
			input type="file" 이 있는 form 의 전송 방식은 다르다
			따라서 enctype="multipart/form-data" 속성을 form 에 추가해준다.
			서버에서 해당 요청을 처리하는 방법도 다르기 때문에 jsp 가 아닌 서블릿에서 처리를 하자 
		--%>
		<form action="${pageContext.request.contextPath }/user2/update2" method="post" 
			enctype="multipart/form-data">
			<div>
				<label>프로필 이미지</label>
				<div>
					<a href="javascript:" href="javascript:" id="profileLink">
						<%if(dto.getProfileImage() == null){ %>
							<i style="font-size:100px;" class="bi bi-person-circle"></i>
						<%}else{ %>
							<img src="${pageContext.request.contextPath }/upload2/<%=dto.getProfileImage() %>" 
							style="width:100px;height:100px;border-radius:50%;"/>
						<%} %>
					</a>
				</div>
				<input type="file" name="profileImage" accept="image/*" style="display:none;"/>
			</div>
		
			<div>
				<label for="userName">이름</label>
				<input type="text" name="userName" value="<%=dto.getName() %>" />
			</div>
			<div>
				<label for="branchNum">지점 번호</label>
				<input type="text" name="branchNum" value="<%=dto.getBranchNum() == null ? "" : dto.getBranchNum() %>" />
			</div>
						
			<div>
				<label for="grade">직급</label>
				<input type="text" name="grade" value="<%=dto.getGrade() == null ? "" : dto.getGrade() %>" />
			</div>
			
			<div>
				<label for="branchLocation">지점 주소</label>
				<input type="text" name="branchLocation" value="<%=dto.getBranchLocation() == null ? "" : dto.getBranchLocation() %>" />
			</div>
			
			<button type="submit">수정확인</button>
			<button type="reset">취소</button>
		</form>
	</div>
	<script>
		//이미지를 감싸고 있는 링크를 클릭했을때
		document.querySelector("#profileLink").addEventListener("click", ()=>{
			//input type="file" 을 강제로 클릭
			document.querySelector("input[name=profileImage]").click();
		});
	
		// input 요소중에 name 속성의 값이 profileImage 인 요소를 선택해서 이벤트 리스너 함수 등록
		document.querySelector("input[name=profileImage]").addEventListener("change", (e)=>{
			//선택한 파일을 배열로 얻어내기 
			const files = e.target.files;
			//FileReader 객체를 생성해서 
            const reader=new FileReader();
			//배열의 0 번방에 있는 파일 객체를 읽어들이고 
            reader.readAsDataURL(files[0]);
			//다 읽었을때 실행할 함수 등록
            reader.onload = ()=>{
            	//읽은 데이터를 이용해서 img 요소를 만들 준비를 한다.
            	const img=`<img src="\${reader.result}" 
            		style="width:100px;height:100px;border-radius:50%">`;
            	// img 마크업 형식의 문자열을 실제로 HTML 로 해석이 되게끔 a 요소안에 넣기
            	document.querySelector("#profileLink").innerHTML = img;
            };
		});
	</script>
</body>
</html>
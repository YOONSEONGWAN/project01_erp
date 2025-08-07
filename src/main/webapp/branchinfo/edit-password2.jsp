<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>edit-password.jsp</title>

<!-- 부트스트랩 CDN -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</head>
<body>
	<div class="container mt-5 mb-5">
		<div class="row justify-content-center">
			<div class="col-md-6">
				<div class="card shadow">
					<div class="card-header bg-primary text-white">
						<h5 class="mb-0">비밀번호 수정</h5>
					</div>
					<div class="card-body">
						<form action="update-password2.jsp" method="post" id="editForm">
							<div class="mb-3">
								<label for="password" class="form-label">기존 비밀번호</label>
								<input type="password" name="password" id="password" class="form-control" />
							</div>
							<div class="mb-3">
								<label for="newPassword" class="form-label">새 비밀번호</label>
								<input type="password" name="newPassword" id="newPassword" class="form-control" />
							</div>
							<div class="mb-3">
								<label for="newPassword2" class="form-label">새 비밀번호 확인</label>
								<input type="password" name="newPassword2" id="newPassword2" class="form-control" />
							</div>
							<div class="text-end">
								<button type="submit" class="btn btn-primary">
									<i class="bi bi-shield-lock"></i> 수정하기
								</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- Bootstrap Icons (선택) -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

	<!-- 유효성 검사 스크립트 -->
	<script>
		document.querySelector("#editForm").addEventListener("submit", (e) => {
			const pwd = document.querySelector("#password").value;
			const newPwd = document.querySelector("#newPassword").value;
			const newPwd2 = document.querySelector("#newPassword2").value;

			if(pwd.trim() == ""){
				alert("기존 비밀번호를 입력하세요!");
				e.preventDefault();
			}else if(newPwd.trim() == ""){
				alert("새 비밀번호를 입력하세요!");
				e.preventDefault();
			}else if(newPwd.trim() != newPwd2.trim()){
				alert("새 비밀번호를 확인란과 동일하게 입력하세요!");
				e.preventDefault();
			}
		});
	</script>
</body>
</html>
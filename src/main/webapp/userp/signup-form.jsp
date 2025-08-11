<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<jsp:include page="/WEB-INF/include/resource.jsp"></jsp:include>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/js/bootstrap.bundle.min.js" integrity="sha384-ndDqU0Gzau9qJ1lfW4pNLlhNTkCfHzAVBReH9diLvGRem5+R9g2FzA8ZGN954O5Q" crossorigin="anonymous"></script>
<style>
    body {
        margin: 0;
        height: 100vh;
        background-color: #f0f2f5;
        display: flex;
        justify-content: center;
        align-items: flex-start;
        font-family: 'Noto Sans KR', sans-serif;
        padding-top: 50px;
    }
    .signup-card {
        position: relative;
        background-color: white;
        padding: 40px 50px 60px;
        border-radius: 12px;
        box-shadow: 0 6px 25px rgba(0, 40, 85, 0.2);
        width: 600px;
        
    }
    .signup-card h1 {
        text-align: center;
        color: #002855;
        margin-bottom: 30px;
        font-weight: 700;
        font-size: 28px;
        letter-spacing: 1.2px;
    }
    .btn-primary {
        background-color: #002855;
        border-color: #002855;
        font-weight: 700;
        border-radius: 10px;
    }
    .btn-primary:hover {
        background-color: #001f3f;
        border-color: #001f3f;
        box-shadow: 0 0 12px #001f3f;
    }
    .nav-tabs .nav-link.active {
        background-color: #002855;
        color: white;
        font-weight: 700;
    }
    .nav-tabs .nav-link {
        color: #002855;
        border-radius: 8px 8px 0 0;
        font-weight: 600;
    }

    .back-link {
        position: absolute;
        bottom: 15px;
        right: 20px;
        color: #002855;
        font-weight: normal;
        text-decoration: none;
        font-size: 14px;
    }

    .back-link:hover {
        text-decoration: underline;
        color: #001f3f;
    }
</style>
</head>
<body>
    <div class="signup-card">
        <h1>회원가입</h1>

        <!-- 본사/지점 탭 -->
        <ul class="nav nav-tabs mb-4 justify-content-center" id="branchTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="hq-tab" data-bs-toggle="tab" data-bs-target="#hq" type="button" role="tab">
                    본사
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="branch-tab" data-bs-toggle="tab" data-bs-target="#branch" type="button" role="tab">
                    지점
                </button>
            </li>
        </ul>

        <!-- 탭 내용 -->
        <div class="tab-content" id="branchTabsContent">
            <!-- 본사 회원가입 -->
            <div class="tab-pane fade show active" id="hq" role="tabpanel">
                <form action="signup.jsp" method="post">
				    <input type="hidden" name="branchType" value="HQ">
				    <div class="mb-3">
				        <label class="form-label">본사 코드 (branch_id)</label>
				        <input type="text" class="form-control" name="branchId" required>
				    </div>
				    <div class="mb-3">
				        <label class="form-label">아이디</label>
				        <input type="text" class="form-control" name="userId" required>
				    </div>
				    <div class="mb-3">
				        <label class="form-label">비밀번호</label>
				        <input type="password" class="form-control" name="password" required>
				    </div>
				    <div class="mb-3">
				        <label class="form-label">이름</label>
				        <input type="text" class="form-control" name="userName" required>
				    </div>
				
				    <!-- 버튼과 링크 묶음 -->
				    <div class="d-grid">
				        <button type="submit" class="btn btn-primary py-2">본사 회원가입</button>
				    </div>
				    <div style="text-align: right; margin-top: 8px;">
				        <a href="${pageContext.request.contextPath}/index.jsp" style="color: #002855; font-weight: normal; text-decoration: none;">뒤로 가기</a>
				    </div>
				</form>
            </div>

            <!-- 지점 회원가입 -->
            <div class="tab-pane fade" id="branch" role="tabpanel">
			    <form action="signup.jsp" method="post">
			        <input type="hidden" name="branchType" value="BRANCH">
			        <div class="mb-3">
			            <label class="form-label">지점 코드 (branch_id)</label>
			            <input type="text" class="form-control" name="branchId" placeholder="BC" required>
			        </div>
			        <div class="mb-3">
			            <label class="form-label">아이디</label>
			            <input type="text" class="form-control" name="userId" required>
			        </div>
			        <div class="mb-3">
			            <label class="form-label">비밀번호</label>
			            <input type="password" class="form-control" name="password" required>
			        </div>
			        <div class="mb-3">
			            <label class="form-label">이름</label>
			            <input type="text" class="form-control" name="userName" required>
			        </div>
			
			        <!-- 버튼과 링크 묶음 -->
			        <div class="d-grid">
			            <button type="submit" class="btn btn-primary py-2">지점 회원가입</button>
			        </div>
			        <div style="text-align: right; margin-top: 8px;">
			            <a href="${pageContext.request.contextPath}/index.jsp" style="color: #002855; font-weight: normal; text-decoration: none;">뒤로 가기</a>
			        </div>
			    </form>
			</div>

        
    </div>
</body>
</html>

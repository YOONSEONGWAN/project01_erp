<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>통합 회원가입 페이지</title>
    <style>
        body {
            text-align: center;
            font-family: sans-serif;
            margin-top: 100px;
        }

        .container {
            display: flex;
            justify-content: center;
            gap: 100px;
        }

        .box {
            border: 3px solid;
            padding: 30px;
            width: 300px;
            height: 300px;
        }

        .hq {
            border-color: red;
            color: red;
        }

        .branch {
            border-color: blue;
            color: blue;
        }

        .inner-box {
            border: 2px solid;
            margin-top: 40px;
            padding: 20px;
            cursor: pointer;
        }

        .hq .inner-box {
            border-color: red;
            color: red;
        }

        .branch .inner-box {
            border-color: blue;
            color: blue;
        }

        .inner-box:hover {
            background-color: #f5f5f5;
        }

        a {
            text-decoration: none;
        }
    </style>
</head>
<body>

    <h1>회원가입 페이지</h1>

    <div class="container">
        <!-- 본사 -->
        <div class="box hq">
            <h2>본사 회원가입</h2>
            <a href="signup-form.jsp?branch=HQ">
                <div class="inner-box">
                    회원가입하러 가기
                </div>
            </a>
        </div>

        <!-- 지점 -->
        <div class="box branch">
            <h2>지점 회원가입</h2>
            <a href="signup-form.jsp?branch=BRANCH">
                <div class="inner-box">
                    회원가입하러 가기
                </div>
            </a>
        </div>
    </div>

</body>
</html>
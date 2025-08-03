<%@page import="java.util.List"%>
<%@page import="dto.HqBoardFileDto"%>
<%@page import="dao.HqBoardDao"%>
<%@page import="dto.HqBoardDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    // 수정 할 글의 정보를 얻어와서 
    int num = Integer.parseInt(request.getParameter("num"));
    HqBoardDto dto = HqBoardDao.getInstance().getByNum(num);
    List<HqBoardFileDto> fileList = dto.getFileList(); // 첨부파일 목록
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/hqboard/hq-edit.jsp</title>
<!-- Toast UI Editor CSS/JS 필요시 include 추가 -->
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
<script src="https://uicdn.toast.com/editor/latest/i18n/ko-kr.js"></script>
</head>
<body>
    <div class="container">
        <nav>
         <ol class="breadcrumb">
           <li class="breadcrumb-item">
            <a href="${pageContext.request.contextPath }/">Home</a>
           </li>
           <li class="breadcrumb-item">
            <a href="${pageContext.request.contextPath }/hqboard/hq-list.jsp">Board</a>
           </li>
           <li class="breadcrumb-item active" >Edit</li>
         </ol>
        </nav>
        <h1>글 수정 페이지</h1>
        <form action="hq-update.jsp" method="post" id="editForm" enctype="multipart/form-data"> <!-- !!! 파일첨부 위해 multipart -->
            <div>
                <label for="num" class="">글 번호</label>
                <input type="text" class="" name="num" id="num"
                 value="<%=dto.getNum() %>" readonly/>
            </div>
            <div>
                <label for="writer" class="">작성자</label>
                <input type="text" class="" name="writer" id="writer"
                 value="<%=dto.getWriter() %>" readonly/>
            </div>
            <div>
                <label for="title" class="">제목</label>
                <input type="text" class="" name="title" id="title"
                    value="<%=dto.getTitle() %>" />
            </div>
            <div>
                <label for="editor" class="">내용</label>
                <div id="editor"></div>
                <textarea class="" name="content" id="hiddencontent" style="display:none;"><%=dto.getContent() %></textarea>
            </div>

            <!-- 첨부파일 영역 -->
            <% if (fileList != null && !fileList.isEmpty()) { %>
                <div>
                    <strong>첨부파일:</strong>
                    <ul>
                    <% for (HqBoardFileDto file : fileList) { %>
                        <li>
                            <a href="${pageContext.request.contextPath }/test/download?orgFileName=<%=file.getOrgFileName()%>&saveFileName=<%=file.getSaveFileName()%>&fileSize=<%=file.getFileSize()%>">
                                <%=file.getOrgFileName()%>
                            </a>
                            <!-- 삭제 링크 추가 (삭제 기능 구현 필요) -->
                            <a href="hq-file-delete.jsp?fileNum=<%=file.getNum()%>&boardNum=<%=dto.getNum()%>" onclick="return confirm('이 파일을 삭제할까요?');">[삭제]</a>
                        </li>
                    <% } %>
                    </ul>
                </div>
            <% } %>
            <!-- 새 파일 첨부 -->
            <div>
                <label>파일 추가</label>
                <input type="file" name="myFile" multiple>
                <small>(새로운 파일 첨부, 여러 개 가능)</small>
            </div>

            <button class="">수정 확인</button>
            <button type="reset" class="">리셋</button>
        </form>
    </div>
    <script>
        const editor = new toastui.Editor({
            el: document.querySelector('#editor'),
            height: '500px',
            initialEditType: 'wysiwyg',
            previewStyle: 'vertical',
            language: 'ko',
            initialValue: `<%=dto.getContent().replace("`", "\\`") %>` // 작은 따옴표 문제 예방
        });

        document.querySelector("#editForm").addEventListener("submit", (e)=>{
            // Editor 로 작성된 문자열 읽어오기
            const content = editor.getHTML();
            // 폼 전송용 textarea에 입력
            document.querySelector("#hiddencontent").value = content;
        });
    </script>
</body>
</html>

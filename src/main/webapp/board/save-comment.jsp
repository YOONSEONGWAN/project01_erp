<%@page import="dto.CommentDto"%>
<%@page import="dao.CommentDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    // context path
    String cPath = request.getContextPath();

    // 세션에서 로그인 사용자 정보 얻기
    String writer = (String)session.getAttribute("userId");

    // 로그인 안 된 사용자면 로그인 페이지로 리다이렉트
    if (writer == null || writer.trim().isEmpty()) {
        response.sendRedirect(cPath + "/user/loginform.jsp");
        return;
    }

    // 폼 파라미터 추출
    int boardNum = Integer.parseInt(request.getParameter("board_num"));
    String boardType = request.getParameter("board_type");
    String content = request.getParameter("content");

    // 댓글 번호 시퀀스 받아오기
    int num = CommentDao.getInstance().getSequence();

    // DTO 생성 및 데이터 저장
    CommentDto dto = new CommentDto();
    dto.setNum(num);
    dto.setWriter(writer);
    dto.setContent(content);
    dto.setBoardNum(boardNum);
    dto.setBoard_type(boardType);

    // DB 저장
    boolean isSuccess = CommentDao.getInstance().insert(dto);

    // 글 상세보기 페이지로 리다이렉트
    String redirectUrl = "HQ".equalsIgnoreCase((String)session.getAttribute("branchId"))
        ? cPath + "/headquater.jsp?page=board/view.jsp&num=" + boardNum + "&board_type=" + boardType
        : cPath + "/branch.jsp?page=board/view.jsp&num=" + boardNum + "&board_type=" + boardType;
    response.sendRedirect(redirectUrl);
%>
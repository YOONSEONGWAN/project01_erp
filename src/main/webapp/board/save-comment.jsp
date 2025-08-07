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
    if(writer == null || writer.trim().isEmpty()) {
        response.sendRedirect(cPath + "/user/loginform.jsp");
        return;
    }

    // 폼 파라미터 추출
    int parentNum = Integer.parseInt(request.getParameter("parent_num"));
    String boardType = request.getParameter("board_type");
    String targetUserId = request.getParameter("target_user_id");
    String content = request.getParameter("content");

    // 대댓글일 경우 groupNum 전달됨
    String strGroupNum = request.getParameter("groupNum");
    int groupNum = 0;
    if(strGroupNum != null && !strGroupNum.trim().isEmpty()) {
        groupNum = Integer.parseInt(strGroupNum);
    }

    // 댓글 번호 시퀀스 받아오기
    int num = CommentDao.getInstance().getSequence();

    // DTO 생성 및 데이터 저장
    CommentDto dto = new CommentDto();
    dto.setNum(num);
    dto.setWriter(writer);
    dto.setTargetUserId(targetUserId);
    dto.setContent(content);
    dto.setParentNum(parentNum);
    dto.setBoard_type(boardType);
    dto.setGroupNum(groupNum == 0 ? num : groupNum); // 원댓글이면 자기 번호, 아니면 받은 그룹번호

    // DB 저장
    boolean isSuccess = CommentDao.getInstance().insert(dto);

    // view.jsp 로 redirect
    response.sendRedirect(cPath + "/board/view.jsp?num=" + parentNum + "&board_type=" + boardType);
%>
<!-- html로 응답하는게 아니기 때문에 html은 삭제해도 무방하다. -->
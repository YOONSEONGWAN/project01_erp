package servlet;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import dao.BoardFileDao;
import dto.BoardFileDto;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/board/file-download")
public class BoardDownloadServlet extends HttpServlet {
    private String fileLocation; // web.xml의 context-param

    @Override
    public void init() throws ServletException {
        fileLocation = getServletContext().getInitParameter("fileLocation");
    }

    @Override
    protected void service(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        // 1) 파라미터(fileId) 검증
        String fileIdParam = req.getParameter("fileId");
        if (fileIdParam == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        final int fileId;
        try {
            fileId = Integer.parseInt(fileIdParam);
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        // 2) DB 조회
        BoardFileDto f = BoardFileDao.getInstance().getByNum(fileId);
        if (f == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        /* ===== STEP 2.5) 권한 체크 추가 ===== */
        jakarta.servlet.http.HttpSession session = req.getSession(false);
        String branchId = null;
        if (session != null) {
            branchId = (String) session.getAttribute("branchId"); // 세션 키 프로젝트 기준
        }
        if (branchId != null) branchId = branchId.trim().toUpperCase();

        // 파일이 속한 게시판 타입 얻기 (파일 DTO에 boardType이 저장되어 있다면 그걸 사용)
        String boardType = f.getBoardType();
        if (boardType == null || boardType.isBlank()) {
            // 만약 파일 테이블에 boardType을 안 넣었다면, 글에서 조회 (선택)
            // BoardDto post = BoardDao.getInstance().getData(f.getBoardNum(), null);
            // boardType = post != null ? post.getBoard_type() : null;
        }
        if (boardType == null) boardType = "QNA"; 
        boardType = boardType.trim().toUpperCase();

        // 정책: 공지사항(NOTICE)은 HQ/지점 모두 허용, 그 외는 HQ만 허용
        if (!"NOTICE".equals(boardType) && (branchId == null || !"HQ".equals(branchId))) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "다운로드 권한이 없습니다.");
            return;
        }
        /* ===== 권한 체크 끝 ===== */
        
        // 3) 실제 파일 존재 확인
        File file = new File(fileLocation, f.getSaveFileName());
        if (!file.exists() || !file.isFile()) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // 4) 헤더 세팅
        String mime = getServletContext().getMimeType(file.getName());
        if (mime == null) mime = "application/octet-stream";
        resp.setContentType(mime);
        resp.setHeader("X-Content-Type-Options", "nosniff");

        // 원본 파일명
        String original = (f.getOrgFileName() != null && !f.getOrgFileName().isBlank())
                ? f.getOrgFileName()
                : file.getName();

        // ✅ ASCII fallback (UUID 등 저장파일명이 ASCII라면 그걸 써도 됨)
        String asciiFallback = f.getSaveFileName().replaceAll("[^\\x20-\\x7E]", "_"); // 공백~~ 표시 가능한 ASCII만

        // RFC 5987 UTF-8 percent-encoding
        String encoded = java.net.URLEncoder
                .encode(original, java.nio.charset.StandardCharsets.UTF_8)
                .replace("+", "%20");

        // 최종 Content-Disposition
        String contentDisp = "attachment; filename=\"" + asciiFallback.replace("\"", "'") + "\"; " +
                             "filename*=UTF-8''" + encoded;
        resp.setHeader("Content-Disposition", contentDisp);


        // 5) 스트리밍
        try (FileInputStream fis = new FileInputStream(file);
             BufferedOutputStream bos = new BufferedOutputStream(resp.getOutputStream())) {
            byte[] buf = new byte[1024 * 1024];
            int n;
            while ((n = fis.read(buf)) != -1) {
                bos.write(buf, 0, n);
            }
            bos.flush();
        }
    }
}
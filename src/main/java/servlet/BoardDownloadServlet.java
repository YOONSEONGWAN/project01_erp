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

        String original = (f.getOrgFileName() != null && !f.getOrgFileName().isBlank())
                ? f.getOrgFileName() : file.getName();

        String asciiFallback = f.getSaveFileName().replaceAll("[^\\x20-\\x7E]", "_");
        String encoded = java.net.URLEncoder
                .encode(original, java.nio.charset.StandardCharsets.UTF_8)
                .replace("+", "%20");

        String contentDisp = "attachment; filename=\"" + asciiFallback.replace("\"", "'") + "\"; " +
                             "filename*=UTF-8''" + encoded;
        resp.setHeader("Content-Disposition", contentDisp);

        // (선택) 용량 알려주기
        resp.setContentLengthLong(file.length());

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
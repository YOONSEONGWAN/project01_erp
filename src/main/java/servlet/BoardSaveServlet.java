package servlet;

import java.io.File;
import java.io.IOException;
import java.util.Collection;
import java.util.UUID;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import dao.BoardDao;
import dao.BoardFileDao;
import dto.BoardDto;
import dto.BoardFileDto;

@WebServlet("/board/save")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 10,   // 10MB 메모리 임계
    maxFileSize       = 1024L * 1024L * 50L,   // 50MB 단일 파일
    maxRequestSize    = 1024L * 1024L * 200L   // 200MB 전체 요청
)
public class BoardSaveServlet extends HttpServlet {

    private String fileLocation; // 업로드 디렉토리(절대경로)

    @Override
    public void init() throws ServletException {
        // web.xml에 <context-param name="fileLocation" 
        fileLocation = getServletContext().getInitParameter("fileLocation");
        if (fileLocation == null || fileLocation.isBlank()) {
            // 없으면 웹앱 내부 경로로 폴백
            fileLocation = getServletContext().getRealPath("/upload/board");
        }
        File dir = new File(fileLocation);
        if (!dir.exists() && !dir.mkdirs()) {
            throw new ServletException("업로드 폴더 생성 실패: " + fileLocation);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        // === 1) 세션 · 사용자 식별 ===
        HttpSession session = req.getSession(false);
       
        // 프로젝트에서 사용하는 세션 키 통일: userId, user_name, branch_id
        String userId   = (String) session.getAttribute("userId");      // 내부 ID
        String userName = (String) session.getAttribute("userName");   // 화면 표시용 이름(작성자)
        String branchId = (String) session.getAttribute("branchId");   // HQ / 지점코드

        

        // 정규화 (공백 제거 + 대문자)
        if (branchId != null) branchId = branchId.trim().toUpperCase();

        // === 2) 파라미터 ===
        String boardType = req.getParameter("board_type"); // 폼 hidden으로 NOTICE / QNA 전달
        if (boardType == null || boardType.isBlank()) boardType = "QNA"; // 안전 기본값
        boardType = boardType.trim().toUpperCase();

        String title   = nvl(req.getParameter("title"), "").trim();
        String content = nvl(req.getParameter("content"), "").trim();
        
        System.out.printf("[DEBUG][Save] board_type=%s, branch_id='%s'%n",
                boardType, branchId);
        java.util.Enumeration<String> names = session.getAttributeNames();
        while (names.hasMoreElements()) {
            String n = names.nextElement();
            System.out.printf("  - session[%s]=%s%n", n, String.valueOf(session.getAttribute(n)));
        }
        // === 3) 권한 체크 (NOTICE는 HQ만) ===
        if ("NOTICE".equals(boardType) && !"HQ".equals(branchId)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "공지사항은 본사(HQ)만 등록할 수 있습니다.");
            return;
        }

        // === 4) 글번호 채번 ===
        int boardNum = BoardDao.getInstance().getSequence(boardType);

        // === 5) 본문 저장 ===
        BoardDto dto = new BoardDto();
        dto.setNum(boardNum);
        dto.setBoard_type(boardType);
        dto.setWriter(userName != null ? userName : userId); // 작성자명 없으면 userId 대체
        dto.setUser_id(userId);
        dto.setBranch_id(branchId);
        dto.setTitle(title);
        dto.setContent(content);

        // 디버그: 실제 들어가는 값 확인 (필요없으면 주석처리)
        System.out.printf("[SAVE] type=%s, branch_id='%s', writer=%s, userId=%s, num=%d%n",
                boardType, branchId, dto.getWriter(), userId, boardNum);

        boolean isSuccess = BoardDao.getInstance().insert(dto);

        // === 6) 첨부파일 저장 ===
        if (isSuccess) {
            // input name="files" 또는 "file" 둘 다 지원
            Collection<Part> parts = req.getParts();
            for (Part part : parts) {
                String name = part.getName();
                if (!"files".equals(name) && !"file".equals(name)) continue;
                if (part.getSize() <= 0) continue;

                String orgFileName = safeFilename(part.getSubmittedFileName());
                if (orgFileName.isBlank()) continue;

                String saveFileName = UUID.randomUUID() + "_" + orgFileName;
                File dest = new File(fileLocation, saveFileName);
                part.write(dest.getAbsolutePath());

                BoardFileDto fd = new BoardFileDto();
                fd.setBoardNum(boardNum);
                fd.setBoardType(boardType);
                fd.setOrgFileName(orgFileName);
                fd.setSaveFileName(saveFileName);
                fd.setFileSize(part.getSize());

                BoardFileDao.getInstance().insert(fd);
            }
        }

        // === 7) 결과 이동 ===
        // 프로젝트 라우팅에 맞게 유지(기존 코드에 headquater.jsp 사용) - 필요시 'headquarter'로 교정
        String base = "HQ".equals(branchId) ? "/headquater.jsp" : "/branch.jsp";
        if (isSuccess) {
            String url = req.getContextPath()
                + base + "?page=/board/view.jsp"
                + "&num=" + boardNum
                + "&board_type=" + boardType;
            System.out.println("[REDIRECT] " + url);
            resp.sendRedirect(url);
            return;
        }
     }

    /** 원본 파일명에서 경로 분리 및 위험 문자 제거 */
    private String safeFilename(String submitted) {
        if (submitted == null) return "";
        String name = submitted.replace("\\", "/");
        name = name.substring(name.lastIndexOf('/') + 1);
        name = name.replaceAll("[\\r\\n]", "").trim();
        return name;
    }

    private String nvl(String s, String def) {
        return (s == null) ? def : s;
    }
}
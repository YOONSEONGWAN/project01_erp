package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import dto.BoardFileDto;
import util.DbcpBean;

public class BoardFileDao {
    private static BoardFileDao dao;
    private BoardFileDao() {}
    public static BoardFileDao getInstance() {
        if (dao == null) dao = new BoardFileDao();
        return dao;
    }

    public boolean insert(BoardFileDto dto) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int rowCount = 0;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                INSERT INTO board_file_p
                (num, board_num, board_type, org_file_name, save_file_name, file_size, created_at)
                VALUES (board_file_p_seq.NEXTVAL, ?, ?, ?, ?, ?, SYSDATE)
            """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, dto.getBoardNum());
            pstmt.setString(2, dto.getBoardType());
            pstmt.setString(3, dto.getOrgFileName());
            pstmt.setString(4, dto.getSaveFileName());
            pstmt.setLong(5, dto.getFileSize());
            rowCount = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return rowCount > 0;
    }

    public List<BoardFileDto> getList(int boardNum, String boardType) {
        List<BoardFileDto> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = """	
            	SELECT * FROM board_file_p 
            	WHERE board_num=? 
            	AND board_type=? 
            	ORDER BY num ASC
            	""";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, boardNum);
            pstmt.setString(2, boardType);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                BoardFileDto dto = new BoardFileDto();
                dto.setNum(rs.getInt("num"));
                dto.setBoardNum(rs.getInt("board_num"));
                dto.setBoardType(rs.getString("board_type"));
                dto.setOrgFileName(rs.getString("org_file_name"));
                dto.setSaveFileName(rs.getString("save_file_name"));
                dto.setFileSize(rs.getLong("file_size"));
                dto.setCreatedAt(rs.getDate("created_at"));
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return list;
    }
    
    public BoardFileDto getByNum(int fileNum) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        BoardFileDto dto = null;

        try {
            conn = new DbcpBean().getConn();
            String sql = """
                SELECT * 
                FROM board_file_p 
                WHERE num = ?
            """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, fileNum);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                dto = new BoardFileDto();
                dto.setNum(rs.getInt("num"));
                dto.setBoardNum(rs.getInt("board_num"));
                dto.setBoardType(rs.getString("board_type"));
                dto.setOrgFileName(rs.getString("org_file_name"));
                dto.setSaveFileName(rs.getString("save_file_name"));
                dto.setFileSize(rs.getLong("file_size"));
                dto.setCreatedAt(rs.getDate("created_at"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }

        return dto;
    }
    
    // 첨부파일 삭제
    public boolean delete(int fileId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int rowCount = 0;
        try {
            conn = new DbcpBean().getConn();
            String sql = "DELETE FROM board_file_p WHERE num = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, fileId);
            rowCount = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return rowCount > 0;
    }

}
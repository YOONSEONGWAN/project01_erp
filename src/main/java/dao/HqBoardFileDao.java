package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import dto.HqBoardFileDto;
import util.DbcpBean;

public class HqBoardFileDao {

    // static 필드 & 초기화
    public static HqBoardFileDao dao;
    static {
        dao = new HqBoardFileDao();
    }

    // 생성자 private
    private HqBoardFileDao() {}

    // 싱글톤 패턴
    public static HqBoardFileDao getInstance() {
        return dao;
    }

    /* ************************************************** */
    // 첨부파일 저장 (insert)
    public boolean insert(HqBoardFileDto dto) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int rowCount = 0;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                INSERT INTO hqboard_file
                (num, board_num, org_file_name, save_file_name, file_size, created_at)
                VALUES (hqboard_file_seq.NEXTVAL, ?, ?, ?, ?, SYSDATE)
            """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, dto.getBoardNum());
            pstmt.setString(2, dto.getOrgFileName());
            pstmt.setString(3, dto.getSaveFileName());
            pstmt.setLong(4, dto.getFileSize());
            rowCount = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        if (rowCount == 0) {
            System.out.println("[첨부파일 insert실패] boardNum=" + dto.getBoardNum()
                + ", orgFileName=" + dto.getOrgFileName()
                + ", saveFileName=" + dto.getSaveFileName()
                + ", fileSize=" + dto.getFileSize());
        } /*에러체크코드*/
        if (rowCount > 0) {
			return true; // row 가 생겼으면 트루 반환 (boolean type 메소드)
		} else {
			return false;
		}
    }

    /* ************************************************** */
    // 특정 게시글의 첨부파일 목록 리턴
    public List<HqBoardFileDto> getListByBoardNum(int boardNum) {
        
    	List<HqBoardFileDto> list = new ArrayList<>();
        
    	Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                SELECT num, board_num, org_file_name, save_file_name, file_size, TO_CHAR(created_at, 'YYYY-MM-DD HH24:MI:SS') AS created_at
                FROM hqboard_file
                WHERE board_num = ?
                ORDER BY num
            """;
            
            pstmt = conn.prepareStatement(sql);
            // 바인딩 값 입력
            pstmt.setInt(1, boardNum);
            
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                HqBoardFileDto dto = new HqBoardFileDto();
                dto.setNum(rs.getInt("num"));
                dto.setBoardNum(rs.getInt("board_num"));
                dto.setOrgFileName(rs.getString("org_file_name"));
                dto.setSaveFileName(rs.getString("save_file_name"));
                dto.setFileSize(rs.getLong("file_size"));
                dto.setCreatedAt(rs.getString("created_at"));
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return list;
    }

    /* ************************************************** */
    // 첨부파일 1개 정보 리턴 (PK로)
    public HqBoardFileDto getByNum(int num) {
        HqBoardFileDto dto = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                SELECT num, board_num, org_file_name, save_file_name, file_size, TO_CHAR(created_at, 'YYYY-MM-DD HH24:MI:SS') AS created_at
                FROM hqboard_file
                WHERE num = ?
            """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, num);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                dto = new HqBoardFileDto();
                dto.setNum(rs.getInt("num"));
                dto.setBoardNum(rs.getInt("board_num"));
                dto.setOrgFileName(rs.getString("org_file_name"));
                dto.setSaveFileName(rs.getString("save_file_name"));
                dto.setFileSize(rs.getLong("file_size"));
                dto.setCreatedAt(rs.getString("created_at"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return dto;
    }

    /* ************************************************** */
    // 첨부파일 삭제 (PK로)
    public boolean delete(int num) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int rowCount = 0;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                DELETE FROM hqboard_file
                WHERE num = ?
            """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, num);
            rowCount = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return rowCount > 0;
    }

    /* ************************************************** */
    // 특정 게시글의 첨부파일 모두 삭제
    public boolean deleteByBoardNum(int boardNum) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int rowCount = 0;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                DELETE FROM hqboard_file
                WHERE board_num = ?
            """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, boardNum);
            rowCount = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        if (rowCount > 0) {
			return true;
		} else {
			return false;
		}
    }
}

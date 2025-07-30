package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import dto.BoardDto;
import util.DbcpBean;

public class BoardDao {
    private static BoardDao dao;

    static {
        dao = new BoardDao();
    }

    private BoardDao() {}

    public static BoardDao getInstance() {
        return dao;
    }
    
    // 작성된 글을 삭제하는 메소드 
 	public boolean deleteByNum(int num) {
 		Connection conn = null;
 		PreparedStatement pstmt = null;

 		// 변화된 row 의 갯수를 담을 변수 선언하고 0으로 초기화
 		int rowCount = 0;

 		try {
 			conn = new DbcpBean().getConn();
 			String sql = """
 					DELETE FROM board
 					WHERE num =?
 					""";
 			pstmt = conn.prepareStatement(sql);
 			// ? 에 순서대로 필요한 값 바인딩 
 			pstmt.setInt(1, num);
 			// pstmt.setInt(1, dto.getNum()); UPDATE할 때 사용할 참조값 
 			// sql 문 실행하고 변화된(추가된, 수정된, 삭제된) row 의 갯수 리턴받기
 			rowCount = pstmt.executeUpdate();

 		} catch (Exception e) { // 예외가 발생시 표시한다 
 			e.printStackTrace();
 		} finally {
 			try {
 				// 메소드 호출하기 전에 null 인지 아닌지 체크, 아닌경우에만 호출하도록 
 				if (pstmt != null)
 					pstmt.close();
 				if (conn != null)
 					conn.close();
 			} catch (Exception e) {
 			}

 		}
 		// 변화된 rowCount 값을 조사해서 작업의 성공 여부를 알아 낼수 있다.
 		if (rowCount > 0) {
 			return true; // 작업 성공이라는 의미에서 true 리턴하기
 		}else {
 			return false; // 작업 실패라는 의미에서 false 리턴하기 
 		}
 	}
    
    // boardType 에 따라 공지사항, 문의사항 리스트를 가져오는 메소드
    public List<BoardDto> getListByType(String boardType){
    	List<BoardDto> list = new ArrayList<>();
    	Connection conn = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;

    	try {
    		conn = new DbcpBean().getConn();
    		String sql = "SELECT * FROM board2 WHERE LOWER(boardType) = LOWER(?) ORDER BY num DESC";
    		pstmt = conn.prepareStatement(sql);
    		pstmt.setString(1, boardType);
    		
    		rs = pstmt.executeQuery();
    		while(rs.next()) {
    			BoardDto dto = new BoardDto();
    			dto.setNum(rs.getInt("num"));
    			dto.setTitle(rs.getString("title"));
    			dto.setWriter(rs.getString("writer"));
    			dto.setCreatedAt(rs.getString("createdAt"));
    			list.add(dto);
    		}
    	} catch(Exception e){
    		e.printStackTrace();
    	} finally {
    		try {
    			if(rs != null) rs.close();
    			if(pstmt != null) pstmt.close();
    			if(conn != null) conn.close();
    		} catch(Exception e){}
    	}
    	return list;
    }
    
    // 1. 글 저장 메서드
    public boolean insert(BoardDto dto) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int rowCount = 0;

        try {
            conn = new DbcpBean().getConn();
            String sql = """
                INSERT INTO board2
                (num, writer, title, content, boardType, viewCount, createdAt)
                VALUES
                (board2_seq.NEXTVAL, ?, ?, ?, ?, 0, SYSDATE)
            """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dto.getWriter());
            pstmt.setString(2, dto.getTitle());
            pstmt.setString(3, dto.getContent());
            pstmt.setString(4, dto.getBoardType()); // ✅ boardType 바인딩

            rowCount = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }

        return rowCount > 0;
    }
    // 3. 저장할 글의 글번호를 리턴해주는 메소드
    public int getSequence() {
        int num = 0;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = "SELECT board2_seq.NEXTVAL AS num FROM DUAL";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                num = rs.getInt("num");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {}
        }
        return num;
    }
    // 4. 글번호에 해당하는 게시글의 정보를 DB에서 조회하는 메소드
    public BoardDto getData(int num) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        BoardDto dto = null;

        try {
            conn = new DbcpBean().getConn();
            String sql = """
                SELECT num, writer, title, content, viewCount, createdAt, boardType
                FROM board2
                WHERE num = ?
            """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, num);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                dto = new BoardDto();
                dto.setNum(rs.getInt("num"));
                dto.setWriter(rs.getString("writer"));
                dto.setTitle(rs.getString("title"));
                dto.setContent(rs.getString("content"));
                dto.setViewCount(rs.getInt("viewCount"));
                dto.setCreatedAt(rs.getString("createdAt"));
                dto.setBoardType(rs.getString("boardType")); // ✅ boardType 포함
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
}
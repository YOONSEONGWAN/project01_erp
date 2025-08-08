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
     
 
 // 글 이전 번호 가져오기
    public Integer getPrevNum(int currentNum, String boardType) {
        Integer prevNum = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = new DbcpBean().getConn();
            String sql = """
                SELECT MAX(num) AS prev_num
                FROM board_p
                WHERE num < ? AND board_type = ?
            """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, currentNum);
            pstmt.setString(2, boardType);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                prevNum = rs.getInt("prev_num");
                if (rs.wasNull()) prevNum = null;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DbcpBean.close(conn, pstmt, rs);
        }

        return prevNum;
    }

    // 글 다음 번호 가져오기
    public Integer getNextNum(int currentNum, String boardType) {
        Integer nextNum = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = new DbcpBean().getConn();
            String sql = """
                SELECT MIN(num) AS next_num
                FROM board_p
                WHERE num > ? AND board_type = ?
            """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, currentNum);
            pstmt.setString(2, boardType);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                nextNum = rs.getInt("next_num");
                if (rs.wasNull()) nextNum = null;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DbcpBean.close(conn, pstmt, rs);
        }

        return nextNum;
    }
    
    // board_type 에 따라 페이징 처리를 위한 메소드
    public int getCountByType(String board_type) {
        int count = 0;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                SELECT COUNT(*) AS count
                FROM board_p
                WHERE board_type = ?
            """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, board_type);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt("count");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return count;
    }
    
    
    
    // 조회수를 증가시키는 메소드
 	public boolean addViewCount(int num) {
 		
 		Connection conn = null;
 		PreparedStatement pstmt = null;

 		// 변화된 row 의 갯수를 담을 변수 선언하고 0으로 초기화
 		int rowCount = 0;

 		try {
 			conn = new DbcpBean().getConn();
 			String sql = """
 					UPDATE board_p
 					SET view_count = view_count+1
 					WHERE num = ?
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
 		} else {
 			return false; // 작업 실패라는 의미에서 false 리턴하기 
 		}
 	}
    
 	// 검색 키워드 + 게시판 유형에 부합하는 글의 갯수를 리턴하는 메소드
 	public int getCountByKeyword(String boardType, String keyword) {
 	    int count = 0;
 	    Connection conn = null;
 	    PreparedStatement pstmt = null;
 	    ResultSet rs = null;
 	    
 	    try {
 	        conn = new DbcpBean().getConn();
 	        String sql = """
 	            SELECT COUNT(*) AS count
 	            FROM board_p
 	            WHERE board_type = ?
 	              AND (title LIKE '%' || ? || '%' OR content LIKE '%' || ? || '%')
 	        """;
 	        pstmt = conn.prepareStatement(sql);
 	        pstmt.setString(1, boardType);   // NOTICE 또는 QNA
 	        pstmt.setString(2, keyword);
 	        pstmt.setString(3, keyword);

 	        rs = pstmt.executeQuery();
 	        if (rs.next()) {
 	            count = rs.getInt("count");
 	        }
 	    } catch (Exception e) {
 	        e.printStackTrace();
 	    } finally {
 	        try { if (rs != null) rs.close(); } catch (Exception e) {}
 	        try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
 	        try { if (conn != null) conn.close(); } catch (Exception e) {}
 	    }
 	    return count;
 	}
    
    
    // 전체 글의 갯수를 리턴하는 메소드
 	public int getCount() {
 		// count 값을 담을 지역변수 선언 
 		int count=0;
 		
 		Connection conn = null;
 		PreparedStatement pstmt = null;
 		ResultSet rs = null;
 		try {
 			conn = new DbcpBean().getConn();
 			// 실행할 sql 문 
 			String sql = """
 					SELECT MAX(ROWNUM) AS count
 					FROM board_p
 					""";
 			pstmt = conn.prepareStatement(sql);
 			// ? 값에 바인딩

 			// select 문 실행하고 결과를 ResultSet 으로 받아온다. 
 			rs = pstmt.executeQuery();
 			// 반복문 돌면서 ResultSet 에 담긴 데이터를 추출해서 어떤 객체에 담는다. 
 			if (rs.next()) {
 				count=rs.getInt("count");
 			}
 		} catch (Exception e) {
 			e.printStackTrace();
 		} finally {
 			try {
 				// 메소드 호출하기 전에 null 인지 아닌지 체크, 아닌경우에만 호출하도록 
 				// 닫아줄때 위에서 객체를 선언한 conn, pstmt, rs 순의 반대 순으로 닫아준다
 				// rs -> pstmt -> conn 
 				if (rs != null)
 					pstmt.close();
 				if (pstmt != null)
 					pstmt.close();
 				if (conn != null)
 					conn.close();
 			} catch (Exception e) {}
 		}
 		return count;
 	}
    
    
    // 특정 page 와 keyword 에 해당하는 row 만 select 해서 리턴하는 메소드
 	// BoardDto 객체에 startRowNum 과 endRowNum 을 담아와서 select
 	public List<BoardDto> selectPageByKeyword(BoardDto dto) {
 	    List<BoardDto> list = new ArrayList<>();
 	    Connection conn = null;
 	    PreparedStatement pstmt = null;
 	    ResultSet rs = null;

 	    try {
 	        conn = new DbcpBean().getConn();
 	        String sql = """
 	            SELECT *
 	            FROM (
 	                SELECT result.*, ROWNUM AS rnum
 	                FROM (
 	                    SELECT num, writer, title, view_count, created_at
 	                    FROM board_p
 	                    WHERE (title LIKE '%' || ? || '%' OR content LIKE '%' || ? || '%')
 	                      AND board_type = ?
 	                    ORDER BY num DESC
 	                ) result
 	                WHERE ROWNUM <= ?
 	            )
 	            WHERE rnum >= ?
 	        """;

 	        pstmt = conn.prepareStatement(sql);
 	        pstmt.setString(1, dto.getKeyword());
 	        pstmt.setString(2, dto.getKeyword());
 	        pstmt.setString(3, dto.getBoard_type());
 	        pstmt.setInt(4, dto.getEndRowNum());    // WHERE ROWNUM <= ?
 	        pstmt.setInt(5, dto.getStartRowNum());  // WHERE rnum >= ?

 	        rs = pstmt.executeQuery();
 	        while (rs.next()) {
 	            BoardDto dto2 = new BoardDto();
 	            dto2.setNum(rs.getInt("num"));
 	            dto2.setWriter(rs.getString("writer"));
 	            dto2.setTitle(rs.getString("title"));
 	            dto2.setView_count(rs.getInt("view_count"));
 	            dto2.setCreated_at(rs.getString("created_at"));
 	            dto2.setBoard_type(dto.getBoard_type());
 	            list.add(dto2);
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
    
    
    // 특정 page 에 해당하는 row 만 selelct 해서 리턴하는 메소드
 	// BoardDto 객체에 startRowNum 과 endRowNum 을 담아와서 select
 	public List<BoardDto> selectPage(BoardDto dto) {
 	    List<BoardDto> list = new ArrayList<>();
 	    
 	    Connection conn = null;
 	    PreparedStatement pstmt = null;
 	    ResultSet rs = null;
 	    try {
 	        conn = new DbcpBean().getConn();
 	        // 안전한 Oracle 페이징 쿼리
 	        String sql = """
 	            SELECT *
 	            FROM (
 	                SELECT result.*, ROWNUM AS rnum
 	                FROM (
 	                    SELECT num, writer, title, view_count, created_at
 	                    FROM board_p
 	                    WHERE board_type = ?
 	                    ORDER BY num DESC ) result
 	                WHERE ROWNUM <= ?
 	            )
 	            WHERE rnum >= ?
 	        """;

 	        pstmt = conn.prepareStatement(sql);
 	        pstmt.setString(1, dto.getBoard_type());        
 	        pstmt.setInt(2, dto.getEndRowNum());            
 	        pstmt.setInt(3, dto.getStartRowNum());         

 	        rs = pstmt.executeQuery();
 	        while (rs.next()) {
 	            BoardDto dto2 = new BoardDto();
 	            dto2.setNum(rs.getInt("num"));
 	            dto2.setWriter(rs.getString("writer"));
 	            dto2.setTitle(rs.getString("title"));
 	            dto2.setView_count(rs.getInt("view_count"));
 	            dto2.setCreated_at(rs.getString("created_at"));
 	            dto2.setBoard_type(dto.getBoard_type());
 	            list.add(dto2);
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
    
    
    // 작성된 글을 수정하는 메소드
 	public boolean update(BoardDto dto) {
 		Connection conn = null;
 		PreparedStatement pstmt = null;

 		// 변화된 row 의 갯수를 담을 변수 선언하고 0으로 초기화
 		int rowCount = 0;

 		try {
 			conn = new DbcpBean().getConn();
 			String sql = """
 					UPDATE board_p 
 					SET title=?, content=?
 					WHERE num=? AND board_type = ?
 					""";
 			pstmt = conn.prepareStatement(sql);
 			// ? 에 순서대로 필요한 값 바인딩 
 			pstmt.setString(1, dto.getTitle());
 			pstmt.setString(2, dto.getContent());
 			pstmt.setInt(3, dto.getNum());
 			pstmt.setString(4, dto.getBoard_type());
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
 		} else {
 			return false; // 작업 실패라는 의미에서 false 리턴하기 
 		}
 	}
    
    
    // 작성된 글을 삭제하는 메소드 
 	public boolean deleteByNum(int num, String board_type) {
 		Connection conn = null;
 		PreparedStatement pstmt = null;

 		// 변화된 row 의 갯수를 담을 변수 선언하고 0으로 초기화
 		int rowCount = 0;

 		try {
 			conn = new DbcpBean().getConn();
 			String sql = """
 					DELETE FROM board_p
 					WHERE num = ? AND board_type = ?
 					""";
 			pstmt = conn.prepareStatement(sql);
 			// ? 에 순서대로 필요한 값 바인딩 
 			pstmt.setInt(1, num);
 			pstmt.setString(2, board_type);
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
    
    
    // 글 전체 목록을 리턴하는 메소드
  	public List<BoardDto> selectAll(){
  		//글목록을 담을 객체 생성
  		List<BoardDto> list=new ArrayList<>();
  		//필요한 객체를 담을 지역변수를 미리 만든다 
  		Connection conn = null;
  		PreparedStatement pstmt = null;
  		ResultSet rs = null;
  		try {
  			conn = new DbcpBean().getConn();
  			//실행할 sql문
  			String sql = """
  				SELECT num, writer, title, view_count, created_at
  				FROM board_p
  				ORDER BY num DESC
  			""";
  			pstmt = conn.prepareStatement(sql);
  			//? 에 값 바인딩

  			// select 문 실행하고 결과를 ResultSet 으로 받아온다
  			rs = pstmt.executeQuery();
  			//반복문 돌면서 ResultSet 에 담긴 데이터를 추출해서 리턴해줄 객체에 담는다
  			while (rs.next()) {
  				BoardDto dto=new BoardDto();
  				dto.setNum(rs.getInt("num"));
  				dto.setWriter(rs.getString("writer"));
  				dto.setTitle(rs.getString("title"));
  				dto.setView_count(rs.getInt("view_count"));
  				dto.setCreated_at(rs.getString("created_at"));
  				
  				list.add(dto);
  			}
  		} catch (Exception e) {
  			e.printStackTrace();
  		} finally {
  			try {
  				if (rs != null)
  					rs.close();
  				if (pstmt != null)
  					pstmt.close();
  				if (conn != null)
  					conn.close();
  			} catch (Exception e) {
  			}
  		}
  		return list;
  	}	
    
    
    // 글 하나의 정보를 리턴하는 메소드
    public BoardDto getByNum(int num, String board_type) {
    	BoardDto dto = null;
    	Connection conn = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
    	try {
    		conn = new DbcpBean().getConn();
    		String sql = """
    			SELECT *
    			FROM (
    				SELECT b.num, writer, title, content, view_count, 
    					TO_CHAR(b.created_at, 'YY"년" MM"월" DD"일" HH24:MI') AS created_at, 
    					profile_image, board_type,
    					LAG(b.num, 1, 0) OVER (ORDER BY b.num DESC) AS prevNum,
    					LEAD(b.num, 1, 0) OVER (ORDER BY b.num DESC) AS nextNum
    				FROM board_p b
    				JOIN users_p u ON b.writer = u.user_name
    				WHERE LOWER(board_type) = LOWER(?)
    			)
    			WHERE num = ?
    		""";
    		pstmt = conn.prepareStatement(sql);
    		pstmt.setString(1, board_type);
    		pstmt.setInt(2, num);

    		rs = pstmt.executeQuery();
    		if (rs.next()) {
    			dto = new BoardDto();
    			dto.setNum(num);
    			dto.setWriter(rs.getString("writer"));
    			dto.setTitle(rs.getString("title"));
    			dto.setContent(rs.getString("content"));
    			dto.setView_count(rs.getInt("view_count"));
    			dto.setCreated_at(rs.getString("created_at"));
    			dto.setProfile_image(rs.getString("profile_image"));
    			dto.setBoard_type(rs.getString("board_type"));
    			dto.setPrevNum(rs.getInt("prevNum"));
    			dto.setNextNum(rs.getInt("nextNum"));
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
    	return dto;
    }
    
    
    // 게시판 유형에 따라 분류할 수 있는 메소드
    public List<BoardDto> getListByType(String board_type){
    	List<BoardDto> list = new ArrayList<>();
    	Connection conn = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;

    	try {
    		conn = new DbcpBean().getConn();
    		String sql = """
    			    SELECT num, title, writer, board_type, created_at, user_id
    			    FROM board_p
    			    WHERE LOWER(board_type) = LOWER(?)
    			    ORDER BY num DESC
    			""";
    		
    		pstmt = conn.prepareStatement(sql);
    		pstmt.setString(1, board_type);
    		
    		rs = pstmt.executeQuery();
    		while(rs.next()) {
    			BoardDto dto = new BoardDto();
    			dto.setNum(rs.getInt("NUM"));
    			dto.setTitle(rs.getString("TITLE"));
    			dto.setWriter(rs.getString("WRITER"));
    			dto.setCreated_at(rs.getString("CREATED_AT"));
    			dto.setBoard_type(rs.getString("BOARD_TYPE"));  
                dto.setUser_id(rs.getString("USER_ID"));        
    			list.add(dto);
    		}
    	} catch(Exception e){
    	    System.out.println("❌ SQL 실행 중 예외 발생: " + e.getMessage());
    	    e.printStackTrace();
    	} finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    	return list;
    }
    
    // 글 저장 메서드
    public boolean insert(BoardDto dto) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int rowCount = 0;

        try {
            // 회원 유형 검사 추가
            if ("NOTICE".equalsIgnoreCase(dto.getBoard_type()) && !"HQ".equalsIgnoreCase(dto.getBranch_id())) {
                System.out.println("❌ 지점 회원은 공지사항 등록 불가");
                return false;
            }
            if ("QNA".equalsIgnoreCase(dto.getBoard_type()) && "HQ".equalsIgnoreCase(dto.getBranch_id())) {
                System.out.println("❌ 본사 회원은 문의사항 등록 불가");
                return false;
            }

            conn = new DbcpBean().getConn();

            // 시퀀스 분기
            String sql;
            if ("NOTICE".equalsIgnoreCase(dto.getBoard_type())) {
                sql = """
                    INSERT INTO board_p
                    (num, writer, title, content, board_type, branch_id, user_id, view_count, created_at)
                    VALUES
                    (?, ?, ?, ?, ?, ?, ?, 0, SYSDATE)
                """;
            } else {
                sql = """
                    INSERT INTO board_p
                    (num, writer, title, content, board_type, branch_id, user_id, view_count, created_at)
                    VALUES
                    (?, ?, ?, ?, ?, ?, ?, 0, SYSDATE)
                """;
            }

            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, dto.getNum()); // save.jsp에서 받은 시퀀스
            pstmt.setString(2, dto.getWriter());
            pstmt.setString(3, dto.getTitle());
            pstmt.setString(4, dto.getContent());
            pstmt.setString(5, dto.getBoard_type());
            pstmt.setString(6, dto.getBranch_id());
            pstmt.setString(7, dto.getUser_id());

            rowCount = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("insert 실패!", e);
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }

        return rowCount > 0;
    }
    // 4. 글번호에 해당하는 게시글의 정보를 DB에서 조회하는 메소드
    public BoardDto getData(int num, String board_type) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        BoardDto dto = null;
        
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                SELECT num, writer, title, content, view_count, created_at, board_type, user_id, branch_id
                FROM board_p
                WHERE num = ? AND TRIM(board_type) = ?
            """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, num);
            pstmt.setString(2, board_type.trim());
            rs = pstmt.executeQuery();

            if (rs.next()) {
                dto = new BoardDto();
                dto.setNum(rs.getInt("num"));
                dto.setWriter(rs.getString("writer"));
                dto.setTitle(rs.getString("title"));
                dto.setContent(rs.getString("content"));
                dto.setView_count(rs.getInt("view_count"));
                dto.setCreated_at(rs.getString("created_at"));
                dto.setBoard_type(rs.getString("board_type")); // ✅ boardType 포함
                dto.setUser_id(rs.getString("user_id"));
                dto.setBranch_id(rs.getString("branch_id"));
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
    
    public int getSequence(String boardType) {
        int seq = 0;
        String sql = "SELECT " + 
            ("NOTICE".equalsIgnoreCase(boardType) ? "board_notice_seq" : "board_qna_seq") +
            ".NEXTVAL AS seq FROM dual";

        try (Connection conn = new DbcpBean().getConn();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                seq = rs.getInt("seq");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return seq;
    }
    
}

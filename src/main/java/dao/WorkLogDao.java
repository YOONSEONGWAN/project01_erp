package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import dto.WorkLogDto;
import util.DbcpBean;

//change
public class WorkLogDao{
	private static WorkLogDao dao;
	
	static {
		dao=new WorkLogDao();
	}
	private WorkLogDao() {
		
	};
	
	public static WorkLogDao getInstance() {
		return dao;
	}
	//08-11 페이지 기능을 위해 추가됨

	// 지점 전체 카운트
	public int getCountByBranch(String branchId) {
	    int count = 0;
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
	            SELECT COUNT(*) AS count
	            FROM work_log
	            WHERE branch_id = ?
	        """;
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, branchId);
	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            count = rs.getInt("count");
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
	    return count;
	}

	
	// 지점 + user_id 키워드 카운트
	public int getCountByBranchAndKeyword(String branchId, String keyword) {
	    int count = 0;
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
	            SELECT COUNT(*) AS count
	            FROM work_log
	            WHERE branch_id = ?
	              AND user_id LIKE '%' || ? || '%'
	        """;
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, branchId);
	        pstmt.setString(2, keyword);
	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            count = rs.getInt("count");
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
	    return count;
	}
		//08-11 추가함
		public int getCount() {
			
			int count=0;
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				conn = new DbcpBean().getConn();
				// 실행할 sql문
				String sql = """
						SELECT MAX(ROWNUM) AS count
						FROM work_log
						

						""";

				pstmt = conn.prepareStatement(sql);
				// ? 에 값 바인딩

				// select 문 실행하고 결과를 ResultSet 으로 받아온다
				rs = pstmt.executeQuery();
				// 반복문 돌면서 ResultSet 에 담긴 데이터를 추출해서 리턴해줄 객체에 담는다
				if (rs.next()) {

					
					count=rs.getInt("count");

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
					e.printStackTrace();
				}
			}

			return count;
			
			
		}
		// 지점 페이지(필요한 컬럼만)
		public List<WorkLogDto> selectPage(WorkLogDto dto) {
		    List<WorkLogDto> list = new ArrayList<>();
		    Connection conn = null;
		    PreparedStatement pstmt = null;
		    ResultSet rs = null;
		    try {
		        conn = new DbcpBean().getConn();
		        String sql = """
		            SELECT user_id, work_date, start_time, end_time
		            FROM (
		                SELECT result1.*, ROWNUM AS rnum
		                FROM (
		                    SELECT user_id, work_date, start_time, end_time
		                    FROM work_log
		                    WHERE branch_id = ?
		                   ORDER BY work_date DESC, start_time DESC, NVL(end_time, start_time) DESC
		                ) result1
		            )
		            WHERE rnum BETWEEN ? AND ?
		        """;
		        pstmt = conn.prepareStatement(sql);
		        pstmt.setString(1, dto.getBranchId());
		        pstmt.setInt(2, dto.getStartRowNum());
		        pstmt.setInt(3, dto.getEndRowNum());
		        rs = pstmt.executeQuery();
		        while (rs.next()) {
		            WorkLogDto tmp = new WorkLogDto();
		            tmp.setUserId(rs.getString("user_id"));
		            tmp.setWorkDate(rs.getDate("work_date"));
		            tmp.setStartTime(rs.getTimestamp("start_time"));
		            tmp.setEndTime(rs.getTimestamp("end_time"));
		            list.add(tmp);
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
		    return list;
		}
		// 지점 + 키워드 페이지
		public List<WorkLogDto> selectPageByKeyword(WorkLogDto dto) {
		    List<WorkLogDto> list = new ArrayList<>();
		    Connection conn = null;
		    PreparedStatement pstmt = null;
		    ResultSet rs = null;
		    try {
		        conn = new DbcpBean().getConn();
		        String sql = """
		            SELECT user_id, work_date, start_time, end_time
		            FROM (
		                SELECT result1.*, ROWNUM AS rnum
		                FROM (
		                    SELECT user_id, work_date, start_time, end_time
		                    FROM work_log
		                    WHERE branch_id = ?
		                      AND user_id LIKE '%' || ? || '%'
		                   ORDER BY work_date DESC, start_time DESC, NVL(end_time, start_time) DESC
		                ) result1
		            )
		            WHERE rnum BETWEEN ? AND ?
		        """;
		        pstmt = conn.prepareStatement(sql);
		        pstmt.setString(1, dto.getBranchId());
		        pstmt.setString(2, dto.getKeyword());
		        pstmt.setInt(3, dto.getStartRowNum());
		        pstmt.setInt(4, dto.getEndRowNum());
		        rs = pstmt.executeQuery();
		        while (rs.next()) {
		            WorkLogDto tmp = new WorkLogDto();
		            tmp.setUserId(rs.getString("user_id"));
		            tmp.setWorkDate(rs.getDate("work_date"));
		            tmp.setStartTime(rs.getTimestamp("start_time"));
		            tmp.setEndTime(rs.getTimestamp("end_time"));
		            list.add(tmp);
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
		    return list;
		}
		
		public List<WorkLogDto> getLogsByBranch(String branchId, int startRow, int endRow, String keyword) {
		    List<WorkLogDto> list = new ArrayList<>();
		    String cond = (keyword == null || keyword.trim().isEmpty()) ? "" : " AND w.user_id LIKE '%' || ? || '%'";
		    String sql = """
		        SELECT * FROM (
		          SELECT x.*, ROWNUM rnum FROM (
		            SELECT w.log_id, w.branch_id, w.user_id, w.work_date, w.start_time, w.end_time
		            FROM work_log w
		            WHERE w.branch_id = ?""" + cond + """
		            ORDER BY w.work_date DESC, w.user_id, w.start_time
		          ) x
		        ) WHERE rnum BETWEEN ? AND ?
		    """;

		    try (Connection conn = new DbcpBean().getConn();
		         PreparedStatement ps = conn.prepareStatement(sql)) {

		        int i = 1;
		        ps.setString(i++, branchId);
		        if (!cond.isEmpty()) ps.setString(i++, keyword.trim());
		        ps.setInt(i++, startRow);
		        ps.setInt(i,   endRow);

		        try (ResultSet rs = ps.executeQuery()) {
		            while (rs.next()) {
		                WorkLogDto dto = new WorkLogDto();
		                dto.setLogId(rs.getInt("log_id"));
		                dto.setBranchId(rs.getString("branch_id"));
		                dto.setUserId(rs.getString("user_id"));
		                dto.setWorkDate(rs.getDate("work_date"));
		                dto.setStartTime(rs.getTimestamp("start_time"));
		                dto.setEndTime(rs.getTimestamp("end_time"));
		                list.add(dto);
		            }
		        }
		    } catch (Exception e) { e.printStackTrace(); }
		    return list;
		}
		
		
	
	
	public boolean insertStartTime(String branchId, String userId){
		Connection conn = null;
		PreparedStatement pstmt = null;
		//변화된 row 의 갯수를 담을 변수 선언하고 0으로 초기화
		int rowCount = 0;
		try {
			conn = new DbcpBean().getConn();
			String sql = """
						 INSERT INTO work_log
       (log_id, branch_id, user_id, work_date, start_time)
       VALUES(work_log_seq.NEXTVAL, ?, ?, TRUNC(SYSDATE), SYSTIMESTAMP)
					""";
			pstmt = conn.prepareStatement(sql);
			// ? 에 순서대로 필요한 값 바인딩
			pstmt.setString(1, branchId);
	        pstmt.setString(2, userId);
			// sql 문 실행하고 변화된(추가된, 수정된, 삭제된) row 의 갯수 리턴받기
			rowCount = pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception e) {
			}
		}

		//변화된 rowCount 값을 조사해서 작업의 성공 여부를 알아 낼수 있다.
		if (rowCount > 0) {
			return true; //작업 성공이라는 의미에서 true 리턴하기
		} else {
			return false; //작업 실패라는 의미에서 false 리턴하기
		}
	}
	
	public boolean updateEndTime(String branchId, String userId) {
		Connection conn = null;
		PreparedStatement pstmt = null;

		int rowCount = 0;
		try {
			conn = new DbcpBean().getConn();
			String sql = """
			UPDATE work_log
               SET end_time = SYSTIMESTAMP
             WHERE log_id = (
                SELECT MAX(log_id)
                FROM work_log
                WHERE branch_id = ?
                  AND user_id = ?
                  AND work_date = TRUNC(SYSDATE)
                  AND end_time IS NULL
            )
										""";
			 	pstmt = conn.prepareStatement(sql);
		        pstmt.setString(1, branchId);
		        pstmt.setString(2, userId);

			rowCount = pstmt.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
		    try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
		    try { if (conn != null) conn.close(); } catch (Exception e) {}
		}
		// 변화된 rowCount 값을 조사해서 작업의 성공 여부를 알아낼 수 있다.
		if (rowCount >= 0) {
			return true;
		} else {
			return false;
		}
	}
	
	public List<WorkLogDto> getLogsByUser(String userId) {
		 List<WorkLogDto> list = new ArrayList<>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = new DbcpBean().getConn();
			// 실행할 sql문
			String sql = """
							SELECT w.log_id, w.branch_id, w.user_id, w.work_date, w.start_time, w.end_time,
					            u.user_name
					     FROM work_log w
					     JOIN users_p u ON w.user_id = u.user_id
					     WHERE w.user_id = ?
					     ORDER BY w.work_date DESC, w.start_time DESC
					
							""";
			
			pstmt = conn.prepareStatement(sql);
			// ? 에 값 바인딩
			  pstmt.setString(1, userId);
			// select 문 실행하고 결과를 ResultSet 으로 받아온다
			rs = pstmt.executeQuery();
			// 반복문 돌면서 ResultSet 에 담긴 데이터를 추출해서 리턴해줄 객체에 담는다
			while (rs.next()) {
				WorkLogDto dto = new WorkLogDto();
	            dto.setLogId(rs.getInt("log_id"));
	            dto.setBranchId(rs.getString("branch_id"));
	            dto.setUserId(rs.getString("user_id"));
	            dto.setWorkDate(rs.getDate("work_date"));
	            dto.setStartTime(rs.getTimestamp("start_time"));
	            dto.setEndTime(rs.getTimestamp("end_time"));
	         
	            list.add(dto);
				
				// dto에 값이 다 해당이 됐기 때문에 그냥 array인 dto 자체를 arraylist인 list에 add하면 됨.
				
				
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
				e.printStackTrace();
			}
		}

		return list;
	}
	
	public List<WorkLogDto> getAllLogs() {
		List<WorkLogDto> list = new ArrayList<>();
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String sql = """
	       SELECT w.log_id, w.branch_id, w.user_id, w.work_date, w.start_time, w.end_time
                 
            FROM work_log w
            JOIN users_p u ON w.user_id = u.user_id
            JOIN branches b ON w.branch_id = b.branch_id
            ORDER BY w.work_date DESC, w.start_time DESC
	    """;

	    try {
	        conn = new DbcpBean().getConn();
	        pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            WorkLogDto dto = new WorkLogDto();
	            dto.setLogId(rs.getInt("log_id"));
	            dto.setBranchId(rs.getString("branch_id"));
	            dto.setUserId(rs.getString("user_id"));
	            dto.setWorkDate(rs.getDate("work_date"));
	            dto.setStartTime(rs.getTimestamp("start_time"));
	            dto.setEndTime(rs.getTimestamp("end_time"));
	           
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
				e.printStackTrace();
			}
		}

		return list;
}
	public List<WorkLogDto> getLogsByBranch(String branchId) {
	    List<WorkLogDto> list = new ArrayList<>();
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
	            SELECT w.log_id, w.branch_id, w.user_id, w.work_date, w.start_time, w.end_time,
	                   u.user_name
	            FROM work_log w
	            JOIN users_p u ON w.user_id = u.user_id
	            WHERE w.branch_id = ?
	            ORDER BY w.work_date DESC, w.user_id, w.start_time
	        """;
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, branchId);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            WorkLogDto dto = new WorkLogDto();
	            dto.setLogId(rs.getInt("log_id"));
	            dto.setBranchId(rs.getString("branch_id"));
	            dto.setUserId(rs.getString("user_id"));
	            dto.setWorkDate(rs.getDate("work_date"));
	            dto.setStartTime(rs.getTimestamp("start_time"));
	            dto.setEndTime(rs.getTimestamp("end_time"));
	           
	            list.add(dto);
	        }
	    } catch (Exception e) { e.printStackTrace(); }
	    finally {
	        try { if (rs != null) rs.close(); } catch (Exception e) {}
	        try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
	        try { if (conn != null) conn.close(); } catch (Exception e) {}
	    }
	    return list;
	}
	public List<String> getBranchIdListFromLog() {
	    List<String> list = new ArrayList<>();
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    try {
	        conn = new DbcpBean().getConn();
	        String sql = "SELECT DISTINCT branch_id FROM work_log ORDER BY branch_id";
	        pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            list.add(rs.getString("branch_id"));
	        }
	    } catch (Exception e) { e.printStackTrace(); }
	    finally {
	        try { if (rs != null) rs.close(); } catch (Exception e) {}
	        try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
	        try { if (conn != null) conn.close(); } catch (Exception e) {}
	    }
	    return list;
	}
	public String getBranchName(String branchId) {
	    String name = "";
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    try {
	        conn = new DbcpBean().getConn();
	        String sql = "SELECT name FROM branches WHERE branch_id = ?";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, branchId);
	        rs = pstmt.executeQuery();
	        if(rs.next()) {
	            name = rs.getString("name");
	        }
	    } catch(Exception e) { e.printStackTrace(); }
	    finally {
	        try { if(rs!=null) rs.close(); } catch(Exception e){}
	        try { if(pstmt!=null) pstmt.close(); } catch(Exception e){}
	        try { if(conn!=null) conn.close(); } catch(Exception e){}
	    }
	    return name;
	}
}


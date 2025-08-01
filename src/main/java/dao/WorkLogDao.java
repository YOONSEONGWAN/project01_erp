package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import dto.WorkLogDto;
import util.DbcpBean;

public class WorkLogDao{

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
					       VALUES(work_log_seq.NEXTVAL, ?, ?, SYSDATE, SYSTIMESTAMP)
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
					       WHERE branch_id = ? AND user_id = ? AND work_date = TRUNC(SYSDATE) 
					       AND end_time IS NULL
										""";
			 	pstmt = conn.prepareStatement(sql);
		        pstmt.setString(1, branchId);
		        pstmt.setString(2, userId);

			rowCount = pstmt.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				// null인지 아닌지 체크 안하면 오류가남
				if (pstmt != null)
					pstmt.close();
				if (pstmt != null)
					conn.close();
			} catch (Exception e) {

			}
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
	       SELECT w.log_id, w.branch_id, w.user_id, w.work_date, w.start_time, w.end_time,
                 
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


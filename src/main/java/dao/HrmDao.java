package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import dto.HrmDto;
import util.DbcpBean;

public class HrmDao {
	
	
	
	// 본사 직원 리스트
	public List<HrmDto> selectHeadOffice() {
	    List<HrmDto> list = new ArrayList<>();
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    try {
	        conn = new DbcpBean().getConn();
	        String sql = "SELECT * FROM users_p WHERE role IN ('king', 'admin') ORDER BY role DESC";
	        pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            HrmDto dto = new HrmDto();
	            dto.setNum(rs.getInt("num"));
	            dto.setName(rs.getString("user_name"));
	            dto.setRole(rs.getString("role"));
	            list.add(dto);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        try {
	            if(rs!=null) rs.close();
	            if(pstmt!=null) pstmt.close();
	            if(conn!=null) conn.close();
	        } catch(Exception e) {}
	    }
	    return list;
	}

	// 지점 직원 리스트
	public List<HrmDto> selectBranch() {
	    List<HrmDto> list = new ArrayList<>();
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    try {
	        conn = new DbcpBean().getConn();
	        String sql = 
	        	    "SELECT users_p.num, users_p.user_name, users_p.role, branches.name AS branch_name " +
	        	    "FROM users_p " +
	        	    "JOIN branches ON users_p.branch_id = branches.branch_id " +
	        	    "WHERE users_p.role IN ('manager', 'clerk') " +
	        	    "ORDER BY users_p.role DESC";
	        pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            HrmDto dto = new HrmDto();
	            dto.setNum(rs.getInt("num"));
	            dto.setName(rs.getString("user_name"));
	            dto.setRole(rs.getString("role"));
	            dto.setBranchName(rs.getString("branch_name"));
	            list.add(dto);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        try {
	            if(rs!=null) rs.close();
	            if(pstmt!=null) pstmt.close();
	            if(conn!=null) conn.close();
	        } catch(Exception e) {}
	    }
	    return list;
	}

	
	public int getCount() {
	    int count = 0;
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    try {
	        conn = new DbcpBean().getConn();
	        String sql = "SELECT COUNT(*) AS cnt FROM users_p";
	        pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            count = rs.getInt("cnt");
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

	
	public List<HrmDto> selectByPage(int startRow, int endRow) {
	    List<HrmDto> list = new ArrayList<>();
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
	            SELECT * FROM (
	                SELECT tmp.*, ROWNUM rnum FROM (
	                    SELECT * FROM users_p ORDER BY num DESC
	                ) tmp WHERE ROWNUM <= ?
	            ) WHERE rnum >= ?
	        """;

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, endRow);
	        pstmt.setInt(2, startRow);
	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            HrmDto dto = new HrmDto();
	            dto.setNum(rs.getInt("num"));
	            dto.setName(rs.getString("name"));
	            dto.setRole(rs.getString("role"));
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
	
			

	// 직원 정보 삭제
			public boolean deleteByNum(int num) {
				Connection conn = null;
				PreparedStatement pstmt = null;
				// 변화된 row 의 갯수를 담을 변수 선언하고 0으로 초기화
				int rowCount = 0;
				try {
					conn = new DbcpBean().getConn();
					String sql = """
							DELETE FROM users_p
							WHERE num=?
							""";
					pstmt = conn.prepareStatement(sql);
					// ? 에 순서대로 필요한 값 바인딩
					pstmt.setInt(1, num);
					// sql 문 실행하고 변화된(추가된, 수정된, 삭제된) row 의 갯수 리턴받기
					rowCount = pstmt.executeUpdate();

				} catch (Exception e) {
					e.printStackTrace();
				} finally {
					try {
						// null 일 경우 흐름을 건너뛰고 catch 로 넘어가기 때문에 if 문 으로 null 을 감지한다
						if (pstmt != null)
							pstmt.close();
						if (conn != null)
							conn.close();
					} catch (Exception e) {
					} // 작업 사항이 없으므로 {}는 그냥 닫는다

				}
				// 변화된 rowCount 값을 조사해서 작업의 성공 여부를 알아낼 수 있다.
				if (rowCount > 0) {
					return true; // 작업 성공이라는 의미에서 true 리턴하기
				} else {
					return false; // 작업 실패라는 의미에서 false 리턴하기
				}
			}
		
	
	// 이미지 업로드 전용 메서드
	public boolean updateProfileImage(int num, String profileImage) {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    int rowCount = 0;
	    
	    try {
	        conn = new DbcpBean().getConn();
	        String sql = "UPDATE users_p SET profile_image=? WHERE num=?";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, profileImage);
	        pstmt.setInt(2, num);

	        rowCount = pstmt.executeUpdate();

	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        try {
	            if (pstmt != null) pstmt.close();
	            if (conn != null) conn.close();
	        } catch (Exception e) {}
	    }

	    return rowCount > 0;
	}


	// 직원 하나의 정보 리턴
		public HrmDto getByNum(int num) {
			HrmDto dto = null;
			// 필요한 객체를 담을 지역변수를 미리 만든다.
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				conn = new DbcpBean().getConn();
				// 실행할 sql 문
				String sql = """
					    SELECT u.user_name, u.role, u.profile_image, b.name AS branchName, u.phone, u.location
					    FROM users_p u
					    JOIN branches b ON u.branch_id = b.branch_id
					    WHERE u.num = ?
					""";
				pstmt = conn.prepareStatement(sql);
				// ? 에 값 바인딩
				pstmt.setInt(1, num);
				// Select 문 실행하고 결과를 ResultSet 으로 받아온다
				rs = pstmt.executeQuery();
				// 만일 select 된 row가 있다면
				if (rs.next()) {
					// BookDto 객체를 생성해서 책 정보를 담는다
					dto=new HrmDto();
					dto.setNum(num);
					dto.setName(rs.getString("user_name"));
					dto.setRole(rs.getString("role"));
					dto.setProfileImage(rs.getString("profile_image"));
					dto.setBranchName(rs.getString("branchName"));
					dto.setPhone(rs.getString("phone"));
					dto.setLocation(rs.getString("location"));

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
			return dto;
		}
	
	//직원 리스트 조회
	
	
	public List<HrmDto> selectAll(){
		// select 한 직원 목록을 담을 객체 생성
		List<HrmDto> list = new ArrayList<>();
		// 필요한 객체를 담을 지역변수를 미리 만든다.
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = new DbcpBean().getConn();
			// 실행할 sql 문
			String sql = """
				    SELECT u.num, u.user_name, u.role, u.profile_image, u.phone, u.location,
				           b.name AS branch_name
				    FROM users_p u
				    JOIN branches b ON u.branch_id = b.branch_id
				    ORDER BY u.num DESC
				""";
			pstmt = conn.prepareStatement(sql);
			// ? 에 값 바인딩
			
			// Select 문 실행하고 결과를 ResultSet 으로 받아온다
			rs = pstmt.executeQuery();
			// 반복문 돌면서 ResultSet 에 담긴 데이터를 추출해서 어떤 객체에 담는다
			while (rs.next()) {
				//
				HrmDto dto = new HrmDto();
				dto.setNum(rs.getInt("num"));
				dto.setName(rs.getString("user_name"));
				dto.setRole(rs.getString("role"));
				dto.setProfileImage(rs.getString("profile_image"));
				dto.setPhone(rs.getString("phone"));
				dto.setLocation(rs.getString("location"));
				dto.setBranchName(rs.getString("branch_name"));
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
}

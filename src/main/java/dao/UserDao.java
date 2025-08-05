package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import dto.UserDto;
import util.DbcpBean;

public class UserDao {

private static UserDao dao;
	
	static {
		dao=new UserDao();
	}
	private UserDao() {}
	
	public static UserDao getInstance() {
		return dao;
	}
	

	// 지점코드와 일치하는 사용자인지 확인하는 메소드
	public UserDto getByCredentials(String user_id, String password) {
	    UserDto dto = null;
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = new DbcpBean().getConn(); // 커넥션 풀에서 연결 가져오기

	        String sql = """
	            SELECT user_id, user_name, branch_id, role
	            FROM users_p
	            WHERE user_id = ? AND password = ?
	        """;

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, user_id);
	        pstmt.setString(2, password);

	        rs = pstmt.executeQuery();

	        if (rs.next()) {
	            dto = new UserDto();
	            dto.setUser_id(rs.getString("user_id"));
	            dto.setUser_name(rs.getString("user_name"));
	            dto.setBranch_id(rs.getString("branch_id")); // 지점 여부
	            dto.setRole(rs.getString("role")); // 선택적: "branch", "hq" 등
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
	        
	// branch_id와 user_id가 모두 일치하는 사용자 정보 조회
	public UserDto getByBIandUI(String branch_id, String user_id) {
	    UserDto dto = null;
	    Connection conn = null;
	    PreparedStatement psmt = null;
	    ResultSet rs = null;

	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
	            SELECT num, branch_id, password, user_name, location, phone, profile_image, role, updated_at, created_at
	            FROM users_p
	            WHERE branch_id = ? AND user_id = ?
	        """;
	        psmt = conn.prepareStatement(sql);
	        psmt.setString(1, branch_id);
	        psmt.setString(2, user_id);
	        rs = psmt.executeQuery();
	        if (rs.next()) {
	            dto = new UserDto();
	            dto.setNum(rs.getLong("num"));
	            dto.setUser_id(user_id);
	            dto.setBranch_id(branch_id);
	            dto.setPassword(rs.getString("password"));
	            dto.setUser_name(rs.getString("user_name"));
	            dto.setLocation(rs.getString("location"));
	            dto.setPhone(rs.getString("phone"));
	            dto.setProfile_image(rs.getString("profile_image"));
	            dto.setRole(rs.getString("role"));
	            dto.setUpdated_at(rs.getString("updated_at"));
	            dto.setCreated_at(rs.getString("created_at"));
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	    	try {
	            if (rs != null) rs.close();
	            if (psmt != null) psmt.close();
	            if (conn != null) conn.close();
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
	    return dto;  
	}
	
	// user_id 를 이용해서 정보 불러오기
	public UserDto getByUserId(String user_id) {
		UserDto dto = null;
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;

		try {
			conn = new DbcpBean().getConn();
			String sql = """
					SELECT num, branch_id, password, user_name, location, phone, profile_image, role, updated_at, created_at
					FROM users_p
					WHERE user_id = ?
					""";
			psmt = conn.prepareStatement(sql);
			psmt.setString(1, user_id);
			rs = psmt.executeQuery();
			if (rs.next()) {
				dto = new UserDto();
				dto.setNum(rs.getLong("num"));
				dto.setUser_id(user_id);
				dto.setBranch_id(rs.getString("branch_id"));
				dto.setPassword(rs.getString("password"));
				dto.setUser_name(rs.getString("user_name"));
				dto.setLocation(rs.getString("location"));
				dto.setPhone(rs.getString("phone"));
				dto.setProfile_image(rs.getString("profile_image"));
				dto.setRole(rs.getString("role"));
				dto.setUpdated_at(rs.getString("updated_at"));
				dto.setCreated_at(rs.getString("created_at"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null) rs.close();
				if (psmt != null) psmt.close();
				if (conn != null) conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return dto;
	}
	
	public boolean insert(UserDto dto) {
	    Connection conn = null;
	    PreparedStatement psmt = null;
	    int rowCount = 0;
	    try {
	        System.out.println("▶ insert() 진입");

	        System.out.println("▶ getConn() 호출 전");
	        conn = new DbcpBean().getConn();
	        System.out.println("▶ getConn() 완료");

	        String sql = """
	            INSERT INTO users_p
	            (num, branch_id, user_id, password, user_name, updated_at, created_at)
	            VALUES(user_p_seq.NEXTVAL, ?, ?, ?, ?, SYSDATE, SYSDATE)
	        """;
	        System.out.println("▶ SQL 준비 완료");

	        psmt = conn.prepareStatement(sql);
	        System.out.println("▶ prepareStatement 완료");

	        // DTO 값 체크
	        System.out.println("▶ DTO 값 체크");
	        System.out.println("branchId: " + dto.getBranch_id());
	        System.out.println("userId: " + dto.getUser_id());
	        System.out.println("password: " + dto.getPassword());
	        System.out.println("userName: " + dto.getUser_name());

	        // 바인딩
	        psmt.setString(1, dto.getBranch_id());
	        psmt.setString(2, dto.getUser_id());
	        psmt.setString(3, dto.getPassword());
	        psmt.setString(4, dto.getUser_name());

	        System.out.println("▶ executeUpdate() 호출 전");
	        rowCount = psmt.executeUpdate();
	        System.out.println("▶ executeUpdate() 완료");

	    } catch (SQLException e) {
	        System.out.println("🚨 SQLException 발생");
	        System.out.println("📌 SQL ErrorCode: " + e.getErrorCode());
	        System.out.println("📌 SQL Message: " + e.getMessage());
	        e.printStackTrace();
	    } catch (Exception e) {
	        System.out.println("🚨 Exception 발생");
	        e.printStackTrace();
	    } finally {
	        try {
	            if (psmt != null) psmt.close();
	            if (conn != null) conn.close();
	            System.out.println("▶ 커넥션 정리 완료");
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }

	    System.out.println("▶ 최종 rowCount = " + rowCount);
	    return rowCount > 0;
	}
}
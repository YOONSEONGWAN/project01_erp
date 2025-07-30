package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

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

	// 회원가입
	public boolean insert(UserDto dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int rowCount = 0;

		try {
			conn = new DbcpBean().getConn();
			String sql = """
					INSERT INTO users2
                    (user_id, user_name, password, branch_id, myLocation, phoneNum, grade, profileImage, registratedAt)
					VALUES (?, ?, ?, ?, ?, ?, ?, ?, SYSDATE)
					""";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getUserId());
			pstmt.setString(2, dto.getUserName());
			pstmt.setString(3, dto.getPassword());
			pstmt.setString(4, dto.getBranchId());
			pstmt.setString(5, dto.getMyLocation());
			pstmt.setString(6, dto.getPhoneNum());
			pstmt.setString(7, dto.getGrade());
			pstmt.setString(8, dto.getProfileImage());
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
			return true; // 작업 성공이라는 의미에서 true 리턴하기
		} else {
			return false; // 작업 실패라는 의미에서 false 리턴하기
		}
	}
	
	public UserDto getByUserId(String userId) {
	    UserDto dto = null;
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
	            SELECT user_id, user_name, password, branch_id,
	                   myLocation, phoneNum, grade, profileImage,
	                   TO_CHAR(updatedAt, 'YYYY-MM-DD HH24:MI:SS') AS updatedAt,
	                   TO_CHAR(registratedAt, 'YYYY-MM-DD HH24:MI:SS') AS registratedAt
	            FROM users2
	            WHERE user_id = ?
	        """;
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, userId);
	        rs = pstmt.executeQuery();

	        if (rs.next()) {
	            dto = new UserDto();
	            dto.setUserId(rs.getString("user_id"));
	            dto.setUserName(rs.getString("user_name"));
	            dto.setPassword(rs.getString("password"));  // BCrypt 해시
	            dto.setBranchId(rs.getString("branch_id"));
	            dto.setMyLocation(rs.getString("myLocation"));
	            dto.setPhoneNum(rs.getString("phoneNum"));
	            dto.setGrade(rs.getString("grade"));
	            dto.setProfileImage(rs.getString("profileImage"));
	            dto.setUpdatedAt(rs.getString("updatedAt"));
	            dto.setRegistratedAt(rs.getString("registratedAt"));
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
}
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

	
	
	public boolean insert(UserDto dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		//변화된 row 의 갯수를 담을 변수 선언하고 0으로 초기화
		int rowCount = 0;
		try {
			conn = new DbcpBean().getConn();
			String sql = """
					  		INSERT INTO users_p
                            (user_id, password, user_name, myLocation,
                            phoneNum, grade, profileImage, registeredAt, updatedAt)
                            VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)
							""";
			pstmt = conn.prepareStatement(sql);
			
			// ? 에 순서대로 필요한 값 바인딩
		     	pstmt.setString(1, dto.getUserId());
	            pstmt.setString(2, dto.getPassword());
	            pstmt.setString(3, dto.getUserName());
	            pstmt.setString(4, dto.getMyLocation());
	            pstmt.setString(5, dto.getPhoneNum());
	            pstmt.setString(6, dto.getGrade());
	            pstmt.setString(7, dto.getProfileImage()); // UserDto의 getProfileImage() 사용
	            pstmt.setString(8, dto.getRegisteredAt());
	            pstmt.setString(9, dto.getUpdatedAt());
			
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
	
	public UserDto getByUserId(String name) {
		//MemberDto 객체의 참조값을 담을 지역변수를 미리 만든다. 
		UserDto dto=null;
		
		//필요한 객체를 담을 지역변수를 미리 만든다 
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = new DbcpBean().getConn();
			//실행할 sql문
			String sql = """
                SELECT user_id, password, user_name, myLocation,
                       phoneNum, grade, profileImage, registeredAt, updatedAt
                FROM users_p
                WHERE user_id=?
			""";
				pstmt = conn.prepareStatement(sql);
			//? 에 값 바인딩
			pstmt.setString(1, name);
			// select 문 실행하고 결과를 ResultSet 으로 받아온다
			rs = pstmt.executeQuery();
			//반복문 돌면서 ResultSet 에 담긴 데이터를 추출해서 리턴해줄 객체에 담는다
			while (rs.next()) {
				
				//객체 생성후 
				dto=new UserDto();
				//회원 한명의 정보를 담는다
				
				dto.setUserId(rs.getString("user_id"));
				dto.setUserName(rs.getString("user_name"));
				dto.setPassword(rs.getString("password"));
				dto.setMyLocation(rs.getString("myLocation"));
				dto.setPhoneNum(rs.getString("phoneNum"));
				dto.setGrade(rs.getString("grade"));
				dto.setProfileImage(rs.getString("profileImage"));
				dto.setUpdatedAt(rs.getString("updatedAt"));
				dto.setRegisteredAt(rs.getString("registeredAt"));
				
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
}
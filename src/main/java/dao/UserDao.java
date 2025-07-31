package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import brnach.util.DbcpBean;
import dto.UserDto;

public class UserDao {
	// 자신 타입의 정적 필드 선언 
	private static UserDao dao;
		
	// static 초기화 블럭 ( 이 클래스가 최초로 사용될때 한번 실행되는 블럭) 
	static {
		// 자신의 객체를 생성해서 초기화
		// static 초기화 작업을 여기서 한다 (UserDao 객체를 생성해서 static 필드에 담는다)
		dao=new UserDao();
		}
		
		// 외부에서 UserDao 객체를 생성하지 못하도록 생성자를 private 으로 막는다 
		private UserDao() {}
		
		public static UserDao getInstance() {
	        return dao;
	    }
		
		//1. 회원정보를 추가하는 메소드
		public boolean insert(UserDto dto) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			//변화된 row 의 갯수를 담을 변수 선언하고 0으로 초기화
			int rowCount = 0;
			try {
				conn = new DbcpBean().getConn();
				String sql = """
					INSERT INTO users_p
					(num, user_name, password, updated_at, created_at)
					VALUES(users_p_seq.NEXTVAL, ?, ?, SYSDATE, SYSDATE)
				""";
				pstmt = conn.prepareStatement(sql);
				// ? 에 순서대로 필요한 값 바인딩
				pstmt.setString(1, dto.getUser_name());
				pstmt.setString(2, dto.getPassword());
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
			if (rowCount > 0) {
				return true; 
			} else {
				return false; 
			}
		}
		
		// 2. userName 을 이용해서 회원 한명의 정보를 리턴하는 메소드
		public UserDto getByUserName(String user_name) {
			UserDto dto=null;
			//필요한 객체를 담을 지역변수를 미리 만든다 
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				conn = new DbcpBean().getConn();
				//실행할 sql문
				String sql = """
					SELECT num, password, role, updated_at, created_at
					FROM users_p
					WHERE user_name=?
				""";
				pstmt = conn.prepareStatement(sql);
				//? 에 값 바인딩
				pstmt.setString(1, user_name);
				// select 문 실행하고 결과를 ResultSet 으로 받아온다
				rs = pstmt.executeQuery();
				//만일 select 되는 row 가 존재한다면
				if(rs.next()) {
					//UserDto 객체를 생성해서 
					dto=new UserDto();
					//select 된 정보를 담는다.
					dto.setNum(rs.getLong("num"));
					dto.setUser_name(user_name);
					dto.setPassword(rs.getString("password"));
					dto.setRole(rs.getString("role"));
					dto.setUpdated_at(rs.getString("updated_at"));
					dto.setCreated_at(rs.getString("created_at"));
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
		
		// 3. 비밀번호를 수정 반영하는 메소드
		public boolean updatePassword(UserDto dto) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			
			// 변화된 row 의 갯수를 담을 변수 선언하고 0으로 초기화
			int rowCount = 0;

			try {
				conn = new DbcpBean().getConn();
				String sql = """
						UPDATE users_p
						SET password=?, updated_at=SYSDATE
						WHERE user_name=?
						""";
				pstmt = conn.prepareStatement(sql);
				// ? 에 순서대로 필요한 값 바인딩 
				pstmt.setString(1, dto.getPassword());
				pstmt.setString(2, dto.getUser_name());
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
}

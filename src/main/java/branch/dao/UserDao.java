package branch.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import branch.dto.UserDto;
import brnach.util.DbcpBean;

public class UserDao {
	
private static UserDao dao;
	
	static {
		dao=new UserDao();
	}
	
	private UserDao() {}
	
	public static UserDao getInstance() {
		return dao;
	}
	
	//이메일과 프로필을 수정하는 메소드
		public boolean updateProfile(UserDto dto) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			//변화된 row 의 갯수를 담을 변수 선언하고 0으로 초기화
			int rowCount = 0;
			try {
				conn = new DbcpBean().getConn();
				String sql = """
					UPDATE users2
					SET branchLocation =?,
		                myLocation=?, branchNum=?, phoneNum=?, grade=?, profileImage=?, 
		                updatedAt=SYSDATE
					WHERE name=?
				""";
				pstmt = conn.prepareStatement(sql);
				System.out.println("[UserDao.updateProfile] DTO 값: branchLocation=" + dto.getBranchLocation() +
		                ", myLocation=" + dto.getMyLocation() + ", branchNum=" + dto.getBranchNum() +
		                ", phoneNum=" + dto.getPhoneNum() + ", grade=" + dto.getGrade() +
		                ", profileImage=" + dto.getProfileImage() + ", name=" + dto.getName());
				// ? 에 순서대로 필요한 값 바인딩
				pstmt.setString(1, dto.getBranchLocation());
				pstmt.setString(2, dto.getMyLocation());
				pstmt.setString(3, dto.getBranchNum());
				pstmt.setString(4, dto.getPhoneNum());
				pstmt.setString(5, dto.getGrade());
				pstmt.setString(6, dto.getProfileImage());
				pstmt.setString(7, dto.getName());
				// sql 문 실행하고 변화된(추가된, 수정된, 삭제된) row 의 갯수 리턴받기
				rowCount = pstmt.executeUpdate();
				 System.out.println("[UserDao.updateProfile] update 실행 결과, 영향받은 행(rowCount): " + rowCount);
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
		
		

	
	
	//비밀번호를 수정 반영하는 메소드
		public boolean updatePassword(UserDto dto) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			// 변화된 row 의 갯수를 담을 변수 선언하고 0으로 초기화
			int rowCount = 0;
			try {
				conn = new DbcpBean().getConn();
				String sql = """
							UPDATE users2
							SET password=?, updatedAt=SYSDATE
							WHERE name=?
						""";
				pstmt = conn.prepareStatement(sql);
				// ? 에 순서대로 필요한 값 바인딩
				pstmt.setString(1, dto.getPassword());
				pstmt.setString(2, dto.getName());
				
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

			// 변화된 rowCount 값을 조사해서 작업의 성공 여부를 알아 낼수 있다.
			if (rowCount > 0) {
				return true; // 작업 성공이라는 의미에서 true 리턴하기
			} else {
				return false; // 작업 실패라는 의미에서 false 리턴하기
			}
		}
	
	//name 을 이용해서 회원 한며의 정보를 리턴하는 메소드
		public UserDto getByUserName(String userName) {
		    UserDto dto = null;

		    Connection conn = null;
		    PreparedStatement pstmt = null;
		    ResultSet rs = null;

		    try {
		        conn = new DbcpBean().getConn();
		        String sql = """
		            SELECT num, name, password, branchLocation,
		                   myLocation, branchNum, phoneNum, grade,
		                   updatedAt, registratedAt, profileImage
		            FROM users2
		            WHERE name = ?
		        """;
		        pstmt = conn.prepareStatement(sql);
		        pstmt.setString(1,userName);
		        rs = pstmt.executeQuery();

		        if (rs.next()) {
		            dto = new UserDto();
		            dto.setNum(rs.getInt("num"));
		            dto.setName(rs.getString("name"));
		            dto.setPassword(rs.getString("password"));
		            dto.setBranchLocation(rs.getString("branchLocation"));
		            dto.setMyLocation(rs.getString("myLocation"));
		            dto.setBranchNum(rs.getString("branchNum"));
		            dto.setPhoneNum(rs.getString("phoneNum"));
		            dto.setGrade(rs.getString("grade"));
		            dto.setUpdatedAt(rs.getString("updatedAt"));
		            dto.setRegistratedAt(rs.getString("registratedAt"));
		            dto.setProfileImage(rs.getString("profileImage"));
		            
		            
		        } else {
		            // 검색 결과가 없을 때 빈 객체를 반환
		            dto = new UserDto();
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
	
	
	public boolean insert(UserDto dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		//변화된 row 의 갯수를 담을 변수 선언하고 0으로 초기화
		int rowCount = 0;
		try {
			conn = new DbcpBean().getConn();
			String sql = """
							INSERT INTO users2
							(num, name, password, branchLocation, myLocation,
							branchNum, phoneNum, grade, registratedAt)
							VALUES(member_seq.NEXTVAL, ?,?,?,?,?,?,?,SYSDATE)	
							""";
			pstmt = conn.prepareStatement(sql);
			
			// ? 에 순서대로 필요한 값 바인딩
			pstmt.setString(1, dto.getName());
			pstmt.setString(2, dto.getPassword());
			pstmt.setString(3, dto.getBranchLocation());
			pstmt.setString(4, dto.getMyLocation());
			pstmt.setString(5, dto.getBranchNum());
			pstmt.setString(6, dto.getPhoneNum());;
			pstmt.setString(7, dto.getGrade());;
			
			
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
	
	public UserDto getByName(String name) {
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
					SELECT num, name, password, branchLocation, myLocation,
						   branchNum, phoneNum, grade, updatedAt, registratedAt, profileImage
					FROM users2
					WHERE name=?
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
				
				dto.setNum(rs.getInt("num"));
				dto.setName(rs.getString("name"));
				dto.setPassword(rs.getString("password"));
				dto.setBranchLocation(rs.getString("branchLocation"));
				dto.setMyLocation(rs.getString("myLocation"));
				dto.setBranchNum(rs.getString("branchNum"));
				dto.setPhoneNum(rs.getString("phoneNum"));
				dto.setGrade(rs.getString("grade"));
				dto.setUpdatedAt(rs.getString("updatedAt"));
				dto.setRegistratedAt(rs.getString("registratedAt"));
				dto.setProfileImage(rs.getString("profileImage"));
				
				
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

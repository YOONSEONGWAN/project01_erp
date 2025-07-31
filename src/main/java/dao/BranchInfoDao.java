package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import dao.BranchInfoDao;
import dto.BranchInfoDto;
import util.DbcpBean;





public class BranchInfoDao {
	
	private static BranchInfoDao dao;
	
	// static 초기화 블럭 (이클래스가 최초로 사용될때 한번 실행되는 블럭)
	static {
		//static 초기화 작업을 여기서 한다 (UserDao 객체를 생성해서 static 필드에 담는다)
		dao=new BranchInfoDao();
	}
	
	//외부에서 UserDao 객체를 생성하지 못하도록 생성자를 private 로 막는다.
	private BranchInfoDao() {}
	
	//UserDao 객체의 참조값을 리턴해주는 public static 메소드 제공
	public static BranchInfoDao getInstance() {
		//static 필드에 저장된 dao 의 참조값을 리턴해 준다. 
		return dao;
	}
	
		
	
	
	
	//비밀번호를 수정 반영하는 메소드
		public boolean updatePassword(BranchInfoDto dto) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			//변화된 row 의 갯수를 담을 변수 선언하고 0으로 초기화
			int rowCount = 0;
			try {
				conn = new util.DbcpBean().getConn();
				String sql = """
					UPDATE users_p
					SET password=?, updatedAt=SYSDATE
					WHERE user_id=?
				""";
				pstmt = conn.prepareStatement(sql);
				// ? 에 순서대로 필요한 값 바인딩
				pstmt.setString(1, dto.getUser_password());
				pstmt.setString(2, dto.getUser_id());
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
	
	
	//userName 을 이용해서 회원 한명의 정보를 리턴하는 메소드
		public BranchInfoDto getByUserName(String user_name) {
			BranchInfoDto dto=null;
			//필요한 객체를 담을 지역변수를 미리 만든다 
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				conn = new util.DbcpBean().getConn();
				//실행할 sql문
				String sql = """
					SELECT
							    
							    u.user_id,
							    u.password AS user_password,
							    u.user_name ,
							    u.phone AS user_phone,
							    u.profile_image AS user_profile_image,
							    u.role AS user_role,
							    b.name AS branch_name,
							    b.address AS branch_address,
							    b.phone AS branch_phone
							FROM
							    users_p u
							JOIN
							    branches b
							ON
							    u.branch_id = b.branch_id
							    WHERE
							u.user_name = ?
				""";
				pstmt = conn.prepareStatement(sql);
				//? 에 값 바인딩
				pstmt.setString(1, user_name);
				// select 문 실행하고 결과를 ResultSet 으로 받아온다
				rs = pstmt.executeQuery();
				//만일 select 되는 row 가 존재한다면
				if(rs.next()) {
					//UserDto 객체를 생성해서 
					dto=new BranchInfoDto();
					//select 된 정보를 담는다.
					
					dto.setUser_id(rs.getString("user_id"));
					dto.setUser_password(rs.getString("user_password"));
					dto.setUser_name(user_name);
					dto.setUser_phone(rs.getString("user_phone"));
					dto.setUser_profile_image(rs.getString("user_profile_image"));
					dto.setUser_role(rs.getString("user_role"));

					dto.setBranch_name(rs.getString("branch_name"));
					dto.setBranch_address(rs.getString("branch_address"));
					dto.setBranch_phone(rs.getString("branch_phone"));
				
					
					
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




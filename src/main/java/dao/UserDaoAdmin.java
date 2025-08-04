package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import dto.BranchDto;
import dto.UserDtoAdmin;
import util.DbcpBean;

public class UserDaoAdmin {
	//자신의 참조값을 저장할 static 필드
	private static UserDaoAdmin dao;
	//static 초기화 블럭에서 객체 생성해서 static 필드에 저장
	static {
		dao=new UserDaoAdmin();
	}
	//외부에서 객체 생성하지 못하도록 생성자의 접근 지정자를 private 로 설정
	private UserDaoAdmin() {}
	
	//참조값을 리턴해주는 static 메소드 제공
	public static UserDaoAdmin getInstance() {
		return dao;
	}
	
	//등급을 수정하는 메소드
	public boolean update(UserDtoAdmin dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		//변화된 row의 갯수를 담을 변수 선언하고 0으로 초기화
		int rowCount = 0;
		try {
			conn = new DbcpBean().getConn();
			String sql = """
					UPDATE users_p
					SET role=?
					WHERE num=?
					""";
			pstmt = conn.prepareStatement(sql);
			// ? 에 순서대로 필요한 값 바인딩
			pstmt.setString(1, dto.getRole());
			pstmt.setLong(2, dto.getNum());
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
		// 변화된 rowCount 값을 조사해서 작업의 성공 여부를 알아낼 수 있다
		if (rowCount > 0) {
			return true; // 작업 성공이라는 의미에서 true 리턴하기
		} else {
			return false; // 작업 실패라는 의미에서 false 리턴하기
		}
	}
	
	//회원 한 명의 정보를 리턴하는 메소드
	public UserDtoAdmin getByNum(Long num) {
		UserDtoAdmin dto=null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = new DbcpBean().getConn();
			//실행할 sql문
			String sql = """
					SELECT *
						FROM (
							SELECT 
								u.num,
								u.user_id,
								b.name as branch_name,
								u.user_name,
								u.role,
								u.location,
								u.phone,
								b.branch_id,
								b.num AS branch_num,
								TO_CHAR(b.created_at, 'YY"년" MM"월" DD"일" HH24:MI') AS created_at,
								TO_CHAR(b.updated_at, 'YY"년" MM"월" DD"일" HH24:MI') AS updated_at
							FROM users_p u
							LEFT OUTER JOIN branches b ON u.branch_id = b.branch_id
						) 
						WHERE num = ?
					""";
			pstmt = conn.prepareStatement(sql);
			// ? 에 값 바인딩
			pstmt.setLong(1, num);
			// select 문 실행하고 결과를 ResultSet 으로 받아온다
			rs = pstmt.executeQuery();
			//반복문 돌면서 ResultSet 에 담긴 데이터를 추출해서 리턴해줄 객체에 담는다
			if (rs.next()) {
				dto=new UserDtoAdmin();
				dto.setNum(rs.getLong("num"));
				dto.setUser_id(rs.getString("user_id"));
				dto.setBranch_name(rs.getString("branch_name"));
				dto.setUser_name(rs.getString("user_name"));
				dto.setRole(rs.getString("role"));
				dto.setLocation(rs.getString("location"));
				dto.setPhone(rs.getString("phone"));
				dto.setBranch_id(rs.getString("branch_id"));
				dto.setCreated_at(rs.getString("created_at"));
				dto.setUpdated_at(rs.getString("updated_at"));
				dto.setBranch_num(rs.getInt("branch_num"));
				dto.setRole(rs.getNString("role"));

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
	
	//전체 회원의 갯수를 리턴하는 메소드
		public int getCount() {
			int count=0;
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				conn = new DbcpBean().getConn();
				//실행할 sql문
				String sql = """
						SELECT MAX(ROWNUM) AS count
						FROM users_p
						""";
				pstmt = conn.prepareStatement(sql);
				// ? 에 값 바인딩

				// select 문 실행하고 결과를 ResultSet 으로 받아온다
				rs = pstmt.executeQuery();
				//반복문 돌면서 ResultSet 에 담긴 데이터를 추출해서 리턴해줄 객체에 담는다
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
				}
			}
			return count;
		}
		
		//검색 키워드에 부합하는 회원의 갯수를 리턴하는 메소드
		public int getCountByKeyword(String keyword) {
			int count=0;
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				conn = new DbcpBean().getConn();
				//실행할 sql문
				String sql = """
						SELECT MAX(ROWNUM) AS count
						FROM (
							SELECT * FROM users_p WHERE role='manager' or role='clerk' or role='unapproved'
							)
						WHERE user_name LIKE '%'||?||'%' or user_id LIKE '%'||?||'%'
						""";
				pstmt = conn.prepareStatement(sql);
				// ? 에 값 바인딩
				pstmt.setString(1, keyword);
				pstmt.setString(2, keyword);
				// select 문 실행하고 결과를 ResultSet 으로 받아온다
				rs = pstmt.executeQuery();
				//반복문 돌면서 ResultSet 에 담긴 데이터를 추출해서 리턴해줄 객체에 담는다
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
				}
			}
			return count;
		}
		
		// 특정 page 에 해당하는 row 만 select 해서 리턴하는 메소드
		// UserDtoAdmin 객체에 startRowNum 과 endRowNum 을 담아와서 select
		public List<UserDtoAdmin> selectPage(UserDtoAdmin dto){
			List<UserDtoAdmin> list=new ArrayList<>();
			
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				conn = new DbcpBean().getConn();
				//실행할 sql문
				String sql = """
						SELECT *
						FROM
							(SELECT result1.*, ROWNUM AS rnum
							FROM
								(SELECT 
									u.num,
									u.user_id,
									b.name,
									u.user_name,
									u.role								
								FROM (
									SELECT * FROM users_p WHERE role='manager' or role='clerk' or role='unapproved'
									) u
								LEFT OUTER JOIN branches b
								ON b.branch_id = u.branch_id
								ORDER BY u.created_at DESC) result1)
						WHERE rnum BETWEEN ? AND ?
						""";
				pstmt = conn.prepareStatement(sql);
				// ? 에 값 바인딩
				pstmt.setInt(1, dto.getStartRowNum());
				pstmt.setInt(2, dto.getEndRowNum());
				// select 문 실행하고 결과를 ResultSet 으로 받아온다
				rs = pstmt.executeQuery();
				//반복문 돌면서 ResultSet 에 담긴 데이터를 추출해서 리턴해줄 객체에 담는다
				while (rs.next()) {
					UserDtoAdmin dto2=new UserDtoAdmin();
					dto2.setNum(rs.getInt("num"));
					dto2.setUser_id(rs.getString("user_id"));
					dto2.setBranch_name(rs.getString("name"));
					dto2.setUser_name(rs.getString("user_name"));					
					dto2.setRole(rs.getString("role"));					
					
					list.add(dto2);
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
		
		// 특정 page 와 keyword 에 해당하는 row 만 select 해서 리턴하는 메소드
		// UserDtoAdmin 객체에 startRowNum 과 endRowNum 을 담아와서 select
		public List<UserDtoAdmin> selectPageByKeyword(UserDtoAdmin dto){
		List<UserDtoAdmin> list=new ArrayList<>();
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = new DbcpBean().getConn();
			//실행할 sql문
			String sql = """
					SELECT *
					FROM
						(SELECT result1.*, ROWNUM AS rnum
						FROM
							(SELECT 
								u.num,
								u.user_id,
								b.name,
								u.user_name,
								u.role								
							FROM users_p u
							LEFT OUTER JOIN branches b
							ON b.branch_id = u.branch_id
							WHERE user_name LIKE '%'||?||'%' or user_id LIKE '%'||?||'%'
							ORDER BY u.created_at DESC) result1)
					WHERE rnum BETWEEN ? AND ?
					""";
			pstmt = conn.prepareStatement(sql);
			// ? 에 값 바인딩
			pstmt.setString(1, dto.getKeyword());
			pstmt.setString(2, dto.getKeyword());
			pstmt.setInt(3, dto.getStartRowNum());
			pstmt.setInt(4, dto.getEndRowNum());
			// select 문 실행하고 결과를 ResultSet 으로 받아온다
			rs = pstmt.executeQuery();
			//반복문 돌면서 ResultSet 에 담긴 데이터를 추출해서 리턴해줄 객체에 담는다
			while (rs.next()) {
				UserDtoAdmin dto2=new UserDtoAdmin();
				dto2.setNum(rs.getInt("num"));
				dto2.setUser_id(rs.getString("user_id"));
				dto2.setBranch_name(rs.getString("name"));
				dto2.setUser_name(rs.getString("user_name"));					
				dto2.setRole(rs.getString("role"));
				
				list.add(dto2);
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
	
	// 등급(role)에 맞는 글의 갯수를 리턴
    public int getCountByRole(String role) {
        int count=0;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                    SELECT COUNT(*) AS count
                    FROM users_p
                    WHERE role=?
                    """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, role);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                count=rs.getInt("count");
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
    
    // 등급(role)와 키워드에 맞는 글의 갯수를 리턴
    public int getCountByKeywordAndRole(String keyword, String role) {
        int count=0;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                    SELECT COUNT(*) AS count
                    FROM users_p
                    WHERE (user_name LIKE '%'||?||'%' OR user_id LIKE '%'||?||'%') AND role=?
                    """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, keyword);
            pstmt.setString(2, keyword);
            pstmt.setString(3, role);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                count=rs.getInt("count");
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

    // 등급(role)에 맞는 페이지 정보를 리턴
    public List<UserDtoAdmin> selectPageByRole(UserDtoAdmin dto, String role){
        List<UserDtoAdmin> list=new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                    SELECT *
                    FROM
                        (SELECT result1.*, ROWNUM AS rnum
                        FROM
                            (SELECT 
								u.num,
								u.user_id,
								b.name AS branch_name,
								u.user_name,
								u.role,
								b.branch_id								
							FROM users_p u
							LEFT OUTER JOIN branches b
							ON b.branch_id = u.branch_id
                            WHERE u.role = ?
                            ORDER BY b.branch_id DESC) result1)
                    WHERE rnum BETWEEN ? AND ?
                    """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, role);
            pstmt.setInt(2, dto.getStartRowNum());
            pstmt.setInt(3, dto.getEndRowNum());
            rs = pstmt.executeQuery();
            while (rs.next()) {
            	UserDtoAdmin dto2=new UserDtoAdmin();
                dto2.setNum(rs.getInt("num"));
                dto2.setBranch_id(rs.getString("user_id"));
                dto2.setBranch_name(rs.getNString("branch_name"));
                dto2.setUser_name(rs.getString("user_name"));
                dto2.setRole(rs.getString("role"));
                dto2.setBranch_id(rs.getString("branch_id"));                
                
                list.add(dto2);
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
    
    // 등급(role)와 키워드에 맞는 페이지 정보를 리턴
    public List<UserDtoAdmin> selectPageByKeywordAndRole(UserDtoAdmin dto, String role){
        List<UserDtoAdmin> list=new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                    SELECT *
                    FROM
                        (SELECT result1.*, ROWNUM AS rnum
                        FROM
                            (SELECT
								u.num,
								u.user_id,
								b.name AS branch_name,
								u.role,
								b.branch_id,							
                                MAX(u.user_name) AS user_name
                            FROM branches b
                            LEFT OUTER JOIN  users_p u 
                            ON b.branch_id = u.branch_id
                            WHERE (u.user_name LIKE '%'||?||'%' OR u.user_id LIKE '%'||?||'%') AND u.role = ?
                            GROUP BY u.num, u.user_id, b.name, u.role, b.branch_id, u.user_name
                            ORDER BY b.branch_id DESC) result1)
                    WHERE rnum BETWEEN ? AND ?
                    """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dto.getKeyword());
            pstmt.setString(2, dto.getKeyword());
            pstmt.setString(3, role);
            pstmt.setInt(4, dto.getStartRowNum());
            pstmt.setInt(5, dto.getEndRowNum());
            rs = pstmt.executeQuery();
            while (rs.next()) {
            	UserDtoAdmin dto2=new UserDtoAdmin();
                dto2.setNum(rs.getInt("num"));
                dto2.setBranch_id(rs.getString("branch_id"));
                dto2.setUser_id(rs.getString("user_id"));
                dto2.setBranch_name(rs.getString("branch_name"));
                dto2.setUser_name(rs.getString("user_name"));
                
                list.add(dto2);
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


}

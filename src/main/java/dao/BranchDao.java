package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import dto.BranchDto;
import dto.UserDtoAdmin;
import util.DbcpBean;

public class BranchDao {
	//자신의 참조값을 저장할 static 필드
	private static BranchDao dao;
	//static 초기화 블럭에서 객체 생성해서 static 필드에 저장
	static {
		dao=new BranchDao();
	}
	//외부에서 객체 생성하지 못하도록 생성자의 접근 지정자를 private 로 설정
	private BranchDao() {}
	
	//참조값을 리턴해주는 static 메소드 제공
	public static BranchDao getInstance() {
		return dao;
	}
	
	// 랜덤한 branch_id 생성
	public String generate() {
		Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Random rand = new Random();
        String branchId = null;

        try {
            conn = new DbcpBean().getConn();

            while (true) {
                int num = rand.nextInt(100000);
                String candidate = "JB" + String.format("%05d", num);

                String sql = "SELECT COUNT(*) FROM branches WHERE branch_id = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, candidate);
                rs = pstmt.executeQuery();
                if (rs.next() && rs.getInt(1) == 0) {
                    branchId = candidate;
                    break;
                }

                rs.close();
                pstmt.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); if (pstmt != null) pstmt.close(); if (conn != null) conn.close(); } catch (Exception e) {}
        }

        return branchId;
	}
	
	// 직원 목록 반환
    public List<UserDtoAdmin> getListWithRole(String branch_id) {
        List<UserDtoAdmin> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
       

        try {
            conn = new DbcpBean().getConn();
            String sql = """
                    SELECT num, user_name, role
                    FROM users_p
                    WHERE (role='clerk' or role='unapproved')
            		    AND branch_id=?
                    ORDER BY created_at ASC
                """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, branch_id);
            rs = pstmt.executeQuery();

            while (rs.next()) {
            	UserDtoAdmin dto=new UserDtoAdmin();
                dto.setNum(rs.getLong("num"));
            	dto.setUser_name(rs.getString("user_name"));
                dto.setRole(rs.getString("role"));
            	
                list.add(dto);
            }

        } catch (SQLException e) {
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
	
	//매니저 목록 반환
    public List<UserDtoAdmin> getManagerListByBranchId(String branch_id) {
        List<UserDtoAdmin> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
       

        try {
            conn = new DbcpBean().getConn();
            String sql = """
                    SELECT num, user_name, role
                    FROM users_p
                    WHERE role='manager' AND branch_id=?
                    ORDER BY created_at ASC
                """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, branch_id);
            rs = pstmt.executeQuery();

            while (rs.next()) {
            	UserDtoAdmin dto = new UserDtoAdmin();
            	dto.setNum(rs.getLong("num"));
            	dto.setUser_name(rs.getString("user_name"));
            	dto.setRole(rs.getString("role"));
            	
                list.add(dto);
            }

        } catch (SQLException e) {
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
	
	//지점 정보를 저장하는 메소드
	public boolean insert(BranchDto dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		//변화된 row의 갯수를 담을 변수 선언하고 0으로 초기화
		int rowCount = 0;
		try {
			conn = new DbcpBean().getConn();
			String sql = """
					INSERT INTO branches
					(num, branch_id, name, address, phone, created_at, status)
					VALUES(branches_seq.NEXTVAL, ?, ?, ?, ?, SYSDATE, '운영중')
					""";
			pstmt = conn.prepareStatement(sql);
			// ? 에 순서대로 필요한 값 바인딩
			pstmt.setString(1, dto.getBranch_id());
			pstmt.setString(2, dto.getName());
			pstmt.setString(3, dto.getAddress());
			pstmt.setString(4, dto.getPhone());
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
	
	//지점을 삭제하는 메소드
	public boolean deleteByNum(int num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		//변화된 row의 갯수를 담을 변수 선언하고 0으로 초기화
		int rowCount = 0;
		try {
			conn = new DbcpBean().getConn();
			String sql = """
					DELETE FROM branches
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

	//지점 하나의 정보를 리턴하는 메소드
	public BranchDto getByNum(int num) {
		BranchDto dto=null;
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
						b.num,
						b.branch_id,
						b.name,
						b.address,
						b.phone,
						u.user_name,
						b.status,
						TO_CHAR(b.created_at, 'YY"년" MM"월" DD"일" HH24:MI') AS created_at,
						TO_CHAR(b.updated_at, 'YY"년" MM"월" DD"일" HH24:MI') AS updated_at
					FROM branches b
					LEFT OUTER JOIN  (
								SELECT * FROM users_p WHERE role = 'manager'
					) u ON b.branch_id = u.branch_id
						) 
					WHERE num = ?
				""";
			pstmt = conn.prepareStatement(sql);
			// ? 에 값 바인딩
			pstmt.setInt(1, num);
			// select 문 실행하고 결과를 ResultSet 으로 받아온다
			rs = pstmt.executeQuery();
			//반복문 돌면서 ResultSet 에 담긴 데이터를 추출해서 리턴해줄 객체에 담는다
			if (rs.next()) {
				dto=new BranchDto();
				dto.setNum(rs.getInt("num"));
				dto.setBranch_id(rs.getString("branch_id"));
				dto.setName(rs.getString("name"));
				dto.setUserName(rs.getString("user_name"));
				dto.setAddress(rs.getString("address"));
				dto.setPhone(rs.getString("phone"));
				dto.setCreatedAt(rs.getString("created_at"));
				dto.setUpdatedAt(rs.getString("updated_at"));
				dto.setStatus(rs.getString("status"));
				dto.setUser_num(rs.getLong("user_num"));

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
	
	//전체 지점의 갯수를 리턴하는 메소드
	public int getCount() {
		int count=0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = new DbcpBean().getConn();
			//실행할 sql문
			String sql = """
					SELECT COUNT(*) AS count
					FROM branches
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
	
	//검색 키워드에 부합하는 글의 갯수를 리턴하는 메소드
	public int getCountByKeyword(String keyword) {
		int count=0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = new DbcpBean().getConn();
			//실행할 sql문
			String sql = """
					SELECT COUNT(*) AS count
					FROM branches
					WHERE name LIKE '%'||?||'%' or branch_id LIKE '%'||?||'%'
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
	// BranchDto 객체에 startRowNum 과 endRowNum 을 담아와서 select
	public List<BranchDto> selectPage(BranchDto dto){
		List<BranchDto> list=new ArrayList<>();
		
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
								b.num,
								b.branch_id,
								b.name,
								b.address,
								b.phone,
								b.status,
								MAX(u.user_name) AS user_name
							FROM branches b
							LEFT OUTER JOIN  (
								SELECT * FROM users_p WHERE role = 'manager'
							) u ON b.branch_id = u.branch_id
							GROUP BY b.num, b.branch_id, b.name, b.address, b.phone, b.status
							ORDER BY b.branch_id DESC) result1)
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
				BranchDto dto2=new BranchDto();
				dto2.setNum(rs.getInt("num"));
				dto2.setBranch_id(rs.getString("branch_id"));
				dto2.setName(rs.getString("name"));
				dto2.setAddress(rs.getString("address"));
				dto2.setPhone(rs.getString("phone"));
				dto2.setUserName(rs.getString("user_name"));
				dto2.setStatus(rs.getString("status"));
				
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
	// BranchDto 객체에 startRowNum 과 endRowNum 을 담아와서 select
	public List<BranchDto> selectPageByKeyword(BranchDto dto){
		List<BranchDto> list=new ArrayList<>();
		
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
								b.num,
								b.branch_id,
								b.name,
								b.address,
								b.phone,
								b.status,
								MAX(u.user_name) AS user_name
							FROM branches b
							LEFT OUTER JOIN  (
								SELECT * FROM users_p WHERE role = 'manager'
							) u ON b.branch_id = u.branch_id
							WHERE b.name LIKE '%'||?||'%' or b.branch_id LIKE '%'||?||'%'
							GROUP BY b.num, b.branch_id, b.name, b.address, b.phone, b.status
							ORDER BY b.branch_id DESC) result1)
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
				BranchDto dto2=new BranchDto();
				dto2.setNum(rs.getInt("num"));
				dto2.setBranch_id(rs.getString("branch_id"));
				dto2.setName(rs.getString("name"));
				dto2.setAddress(rs.getString("address"));
				dto2.setPhone(rs.getString("phone"));
				dto2.setUserName(rs.getString("user_name"));
				dto2.setStatus(rs.getString("status"));
				
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
	
	// 상태(status)에 맞는 글의 갯수를 리턴
    public int getCountByStatus(String status) {
        int count=0;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                    SELECT COUNT(*) AS count
                    FROM branches
                    WHERE status=?
                    """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
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

    // 상태(status)와 키워드에 맞는 글의 갯수를 리턴
    public int getCountByKeywordAndStatus(String keyword, String status) {
        int count=0;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                    SELECT COUNT(*) AS count
                    FROM branches
                    WHERE (name LIKE '%'||?||'%' OR branch_id LIKE '%'||?||'%') AND status=?
                    """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, keyword);
            pstmt.setString(2, keyword);
            pstmt.setString(3, status);
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

    // 상태(status)에 맞는 페이지 정보를 리턴
    public List<BranchDto> selectPageByStatus(BranchDto dto, String status){
        List<BranchDto> list=new ArrayList<>();
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
                                b.num,
                                b.branch_id,
                                b.name,
                                b.address,
                                b.phone,
                                b.status,
                                MAX(u.user_name) AS user_name
                            FROM branches b
                            LEFT OUTER JOIN  (
                                SELECT * FROM users_p WHERE role = 'manager'
                            ) u ON b.branch_id = u.branch_id
                            WHERE b.status = ?
                            GROUP BY b.num, b.branch_id, b.name, b.address, b.phone, b.status
                            ORDER BY b.branch_id DESC) result1)
                    WHERE rnum BETWEEN ? AND ?
                    """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
            pstmt.setInt(2, dto.getStartRowNum());
            pstmt.setInt(3, dto.getEndRowNum());
            rs = pstmt.executeQuery();
            while (rs.next()) {
                BranchDto dto2=new BranchDto();
                dto2.setNum(rs.getInt("num"));
                dto2.setBranch_id(rs.getString("branch_id"));
                dto2.setName(rs.getString("name"));
                dto2.setAddress(rs.getString("address"));
                dto2.setPhone(rs.getString("phone"));
                dto2.setUserName(rs.getString("user_name"));
                dto2.setStatus(rs.getString("status"));
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

    // 상태(status)와 키워드에 맞는 페이지 정보를 리턴
    public List<BranchDto> selectPageByKeywordAndStatus(BranchDto dto, String status){
        List<BranchDto> list=new ArrayList<>();
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
                                b.num,
                                b.branch_id,
                                b.name,
                                b.address,
                                b.phone,
                                b.status,
                                MAX(u.user_name) AS user_name
                            FROM branches b
                            LEFT OUTER JOIN  (
                                SELECT * FROM users_p WHERE role = 'manager'
                            ) u ON b.branch_id = u.branch_id
                            WHERE (b.name LIKE '%'||?||'%' OR b.branch_id LIKE '%'||?||'%') AND b.status = ?
                            GROUP BY b.num, b.branch_id, b.name, b.address, b.phone, b.status
                            ORDER BY b.branch_id DESC) result1)
                    WHERE rnum BETWEEN ? AND ?
                    """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dto.getKeyword());
            pstmt.setString(2, dto.getKeyword());
            pstmt.setString(3, status);
            pstmt.setInt(4, dto.getStartRowNum());
            pstmt.setInt(5, dto.getEndRowNum());
            rs = pstmt.executeQuery();
            while (rs.next()) {
                BranchDto dto2=new BranchDto();
                dto2.setNum(rs.getInt("num"));
                dto2.setBranch_id(rs.getString("branch_id"));
                dto2.setName(rs.getString("name"));
                dto2.setAddress(rs.getString("address"));
                dto2.setPhone(rs.getString("phone"));
                dto2.setUserName(rs.getString("user_name"));
                dto2.setStatus(rs.getString("status"));
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

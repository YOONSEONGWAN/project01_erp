package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import dto.BranchDto;
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
	
	//지점을 삭제하는 메소드
	public boolean deleteByBranchId(int num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		//변화된 row의 갯수를 담을 변수 선언하고 0으로 초기화
		int rowCount = 0;
		try {
			conn = new DbcpBean().getConn();
			String sql = """
					DELETE FROM branches
					WHERE branch_id=?
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
	public BranchDto getByBranchId(int num) {
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
								b.branch_id,
								b.branch_name,
								b.branchLocation AS branch_location,
								b.branchPhone AS branch_phone,
								u.user_name,
								TO_CHAR(u.registeredAt, 'YY"년" MM"월" DD"일" HH24:MI') AS registered_at,
								TO_CHAR(u.updatedAt, 'YY"년" MM"월" DD"일" HH24:MI') AS updated_at
							FROM branches b
							INNER JOIN users2 u ON b.branch_id = u.branch_id
						) 
						WHERE branch_id = ?
					""";
			pstmt = conn.prepareStatement(sql);
			// ? 에 값 바인딩
			pstmt.setInt(1, num);
			// select 문 실행하고 결과를 ResultSet 으로 받아온다
			rs = pstmt.executeQuery();
			//반복문 돌면서 ResultSet 에 담긴 데이터를 추출해서 리턴해줄 객체에 담는다
			if (rs.next()) {
				dto=new BranchDto();
				dto.setBranch_id(rs.getInt("branch_id"));
				dto.setBranch_name(rs.getString("branch_name"));
				dto.setAddress(rs.getString("address"));
				dto.setPhone(rs.getString("phone"));
				dto.setUser_name(rs.getString("user_name"));
				dto.setRegisteredAt(rs.getString("registered_at"));
				dto.setUpdatedAt(rs.getString("updated_at"));
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
	
	//전체 글의 갯수를 리턴하는 메소드
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
					WHERE banch_name LIKE '%'||?||'%'
					""";
			pstmt = conn.prepareStatement(sql);
			// ? 에 값 바인딩
			pstmt.setString(1, keyword);
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
	// BoardDto 객체에 startRowNum 과 endRowNum 을 담아와서 select
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
								b.branch_id,
								b.branch_name,
								b.branchLocation AS branch_location,
								b.branchPhone AS branch_phone,
								u.user_name								
							FROM branches b
							INNER JOIN users2 u
							ON b.branch_id = u.branch_id
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
				dto2.setBranchName(rs.getString("branch_name"));
				dto2.setBranchLocation(rs.getString("branch_location"));
				dto2.setBranchPhone(rs.getString("branch_phone"));
				dto2.setUserName(rs.getString("user_name"));
				dto2.setBranchId(rs.getInt("branch_id"));
				
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
	// BoardDto 객체에 startRowNum 과 endRowNum 을 담아와서 select
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
								b.branch_id,
								b.branch_name,
								b.branchLocation AS branch_location,
								b.branchPhone AS branch_phone,
								u.user_name								
							FROM branches b
							INNER JOIN users2 u
							ON b.branch_id = u.branch_id
							WHERE b.branch_name LIKE '%'||?||'%'
							ORDER BY b.branch_id DESC) result1)
					WHERE rnum BETWEEN ? AND ?
					""";
			pstmt = conn.prepareStatement(sql);
			// ? 에 값 바인딩
			pstmt.setString(1, dto.getKeyword());
			pstmt.setInt(2, dto.getStartRowNum());
			pstmt.setInt(3, dto.getEndRowNum());
			// select 문 실행하고 결과를 ResultSet 으로 받아온다
			rs = pstmt.executeQuery();
			//반복문 돌면서 ResultSet 에 담긴 데이터를 추출해서 리턴해줄 객체에 담는다
			while (rs.next()) {
				BranchDto dto2=new BranchDto();
				dto2.setBranchName(rs.getString("branch_name"));
				dto2.setBranchLocation(rs.getString("branch_location"));
				dto2.setBranchPhone(rs.getString("branch_phone"));
				dto2.setUserName(rs.getString("user_name"));
				dto2.setBranchId(rs.getInt("branch_id"));
				
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
}

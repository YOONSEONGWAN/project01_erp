package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import dto.SalesDto;
import util.DbcpBean;

public class SalesDao {

private static SalesDao dao;

	static {
		dao = new SalesDao();
	}
	
	private SalesDao() {}
	
	public static SalesDao getInstance() {
		return dao;
	}
	
	// 주간별 매출 통계
	public List<SalesDto> getWeeklyStats() {
	    List<SalesDto> list = new ArrayList<>();
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
	            SELECT TO_CHAR(created_at, 'IYYY') || '-W' || TO_CHAR(created_at, 'IW') AS period,
	                   branch,
	                   SUM(totalamount) AS total_sales
	            FROM sales
	            GROUP BY TO_CHAR(created_at, 'IYYY') || '-W' || TO_CHAR(created_at, 'IW'), branch
	            ORDER BY period DESC
	        """;
	        pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            SalesDto dto = new SalesDto();
	            dto.setPeriod(rs.getString("period"));   // "2025-W30" 같은 형태
	            dto.setBranch(rs.getString("branch"));
	            dto.setTotalSales(rs.getInt("total_sales"));
	            list.add(dto);
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

	
	// 월별 매출 통계
	public List<SalesDto> getMonthlyStats() {
		List<SalesDto> list = new ArrayList<>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = new DbcpBean().getConn();
			String sql = """
					    SELECT TO_CHAR(created_at, 'YYYY-MM') AS period,
					           branch,
					           SUM(totalamount) AS total_sales
					    FROM sales
					    GROUP BY TO_CHAR(created_at, 'YYYY-MM'), branch
					    ORDER BY period DESC
					""";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				SalesDto dto = new SalesDto();
				dto.setPeriod(rs.getString("period"));
				dto.setBranch(rs.getString("branch"));
				dto.setTotalSales(rs.getInt("total_sales"));
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
	
	// 지점별 연간 매출 통계
	public List<SalesDto> getYearlyStats() {
	    List<SalesDto> list = new ArrayList<>();
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
	            SELECT TO_CHAR(created_at, 'YYYY') AS period,
	                   branch,
	                   SUM(totalamount) AS total_sales
	            FROM sales
	            GROUP BY TO_CHAR(created_at, 'YYYY'), branch
	            ORDER BY period DESC, branch
	        """;
	        pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            SalesDto dto = new SalesDto();
	            dto.setPeriod(rs.getString("period"));      // 연도 (예: 2025)
	            dto.setBranch(rs.getString("branch"));      // 지점 이름
	            dto.setTotalSales(rs.getInt("total_sales")); // 합계 금액
	            list.add(dto);
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

	
	// 일일 마감 매출 데이터를 sales 테이블에 삽입하는 메소드 (이전에 작성된 insert 메소드)
	
	
	//글 전체 목록을 리턴하는 메소드
	public List<SalesDto> selectAll(){
		List<SalesDto> list=new ArrayList<>();
		//필요한 객체를 담을 지역변수를 미리 만든다 
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = new DbcpBean().getConn();
			//실행할 sql문
			String sql = """
				SELECT 	sales_id, branch, created_at, totalamount
				FROM sales
				ORDER BY sales_id DESC	
			""";
			pstmt = conn.prepareStatement(sql);
			//? 에 값 바인딩

			// select 문 실행하고 결과를 ResultSet 으로 받아온다
			rs = pstmt.executeQuery();
			//반복문 돌면서 ResultSet 에 담긴 데이터를 추출해서 리턴해줄 객체에 담는다
			while (rs.next()) {
				SalesDto dto = new SalesDto();
				dto.setSales_id(rs.getInt("sales_id"));
				dto.setBranch(rs.getString("branch"));
				dto.setCreated_at(rs.getString("created_at"));
				dto.setTotalamount(rs.getInt("totalamount"));
				
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











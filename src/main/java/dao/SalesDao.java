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
	
	// 달력 기능 메소드
	
	public SalesDto getStatsBetweenDates(String start, String end) {
	    SalesDto dto = new SalesDto();
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    PreparedStatement pstmt2 = null;
	    ResultSet rs2 = null;

	    try {
	        conn = new DbcpBean().getConn();

	        // 총 매출 & 일수 & 평균
	        String sql = """
	            SELECT COUNT(DISTINCT created_at) AS day_count, 
	                   SUM(totalamount) AS total_sales,
	                   ROUND(SUM(totalamount) / COUNT(DISTINCT created_at)) AS avg_sales
	            FROM sales
	            WHERE created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
	        """;

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, start);
	        pstmt.setString(2, end);
	        rs = pstmt.executeQuery();

	        if (rs.next()) {
	            dto.setDayCount(rs.getInt("day_count"));
	            dto.setTotalSales(rs.getInt("total_sales"));
	            dto.setAverageSales(rs.getInt("avg_sales"));
	        }

	        // 최고 매출 지점
	        String sql2 = """
	            SELECT *
	            FROM (
	                SELECT b.name AS branch_name, SUM(s.totalamount) AS branch_sales
	                FROM sales s
	                JOIN branches b ON s.branch_id = b.branch_id
	                WHERE s.created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
	                GROUP BY b.name
	                ORDER BY branch_sales DESC
	            )
	            WHERE ROWNUM = 1
	        """;

	        pstmt2 = conn.prepareStatement(sql2);
	        pstmt2.setString(1, start);
	        pstmt2.setString(2, end);
	        rs2 = pstmt2.executeQuery();

	        if (rs2.next()) {
	            dto.setTopBranchName(rs2.getString("branch_name"));
	            dto.setTopBranchSales(rs2.getInt("branch_sales"));
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        try {
	            if (rs2 != null) rs2.close();
	            if (pstmt2 != null) pstmt2.close();
	            if (rs != null) rs.close();
	            if (pstmt != null) pstmt.close();
	            if (conn != null) conn.close();
	        } catch (Exception e) {}
	    }

	    return dto;
	}


	
	// 지점별 연간 매출 순위
	public List<SalesDto> getYearlySalesRanking() {
	    List<SalesDto> list = new ArrayList<>();
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
				SELECT 
				    TO_CHAR(s.created_at, 'YYYY') AS period,
				    b.name AS branch_name,
				    SUM(s.totalamount) AS total_sales,
				    ROW_NUMBER() OVER (
				        PARTITION BY TO_CHAR(s.created_at, 'YYYY')
				        ORDER BY SUM(s.totalamount) DESC
				    ) AS rnk
				FROM sales s
				JOIN branches b ON s.branch_id = b.branch_id
				GROUP BY TO_CHAR(s.created_at, 'YYYY'), b.name
	        """;

	        pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            SalesDto dto = new SalesDto();
	            dto.setPeriod(rs.getString("period"));
	            dto.setBranch_name(rs.getString("branch_name"));
	            dto.setTotalSales(rs.getInt("total_sales"));
	            dto.setRank(rs.getInt("rnk"));
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
	// 지점별 월간 매출 순위
	
	public List<SalesDto> getMonthlySalesRanking() {
	    List<SalesDto> list = new ArrayList<>();
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
				SELECT 
				    TO_CHAR(s.created_at, 'YYYY-MM') AS period,
				    b.name AS branch_name,
				    SUM(s.totalamount) AS total_sales,
				    ROW_NUMBER() OVER (
				        PARTITION BY TO_CHAR(s.created_at, 'YYYY-MM')
				        ORDER BY SUM(s.totalamount) DESC
				    ) AS rnk
				FROM sales s
				JOIN branches b ON s.branch_id = b.branch_id
				GROUP BY TO_CHAR(s.created_at, 'YYYY-MM'), b.name
	        """;

	        pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            SalesDto dto = new SalesDto();
	            dto.setPeriod(rs.getString("period"));
	            dto.setBranch_name(rs.getString("branch_name"));
	            dto.setTotalSales(rs.getInt("total_sales"));
	            dto.setRank(rs.getInt("rnk"));
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
	
	// 지점별 주간 매출 랭킹
	public List<SalesDto> getWeeklySalesRanking() {
	    List<SalesDto> list = new ArrayList<>();
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
				SELECT 
				    TO_CHAR(s.created_at, 'IYYY-"W"IW') AS period,
				    b.name AS branch_name,
				    SUM(s.totalamount) AS total_sales,
				    ROW_NUMBER() OVER (
				        PARTITION BY TO_CHAR(s.created_at, 'IYYY-"W"IW')
				        ORDER BY SUM(s.totalamount) DESC
				    ) AS rnk
				FROM sales s
				JOIN branches b ON s.branch_id = b.branch_id
				GROUP BY TO_CHAR(s.created_at, 'IYYY-"W"IW'), b.name
	        """;

	        pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            SalesDto dto = new SalesDto();
	            dto.setPeriod(rs.getString("period"));
	            dto.setBranch_name(rs.getString("branch_name"));
	            dto.setTotalSales(rs.getInt("total_sales"));
	            dto.setRank(rs.getInt("rnk"));
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

	
	// 연간 최저 매출일
	public List<SalesDto> getYearlyMinSalesDates() {
		List<SalesDto> list = new ArrayList<>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = new DbcpBean().getConn();
			String sql = """
						SELECT *
						FROM (
						    SELECT 
						        TO_CHAR(s.created_at, 'YYYY') AS period, -- 월 단위
						        b.name AS branch_name,
						        TO_CHAR(s.created_at, 'YYYY-MM-DD') AS sales_date,
						        s.totalamount,
						        RANK() OVER (
						            PARTITION BY TO_CHAR(s.created_at, 'YYYY'), b.name
						            ORDER BY s.totalamount ASC
						        ) AS rnk
						    FROM sales s
						    JOIN branches b ON s.branch_id = b.branch_id
						)
						WHERE rnk = 1
						ORDER BY period DESC, branch_name
			""";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				SalesDto dto = new SalesDto();
				dto.setPeriod(rs.getString("period"));
				dto.setBranch_name(rs.getString("branch_name"));
				dto.setMinSalesDate(rs.getString("sales_date"));
				dto.setTotalSales(rs.getInt("totalamount"));
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
	
	
	// 월간 최저 매출일
	
	public List<SalesDto> getMonthlyMinSalesDates() {
		List<SalesDto> list = new ArrayList<>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = new DbcpBean().getConn();
			String sql = """
						SELECT *
						FROM (
						    SELECT 
						        TO_CHAR(s.created_at, 'YYYY-MM') AS period, -- 월 단위
						        b.name AS branch_name,
						        TO_CHAR(s.created_at, 'YYYY-MM-DD') AS sales_date,
						        s.totalamount,
						        RANK() OVER (
						            PARTITION BY TO_CHAR(s.created_at, 'YYYY-MM'), b.name
						            ORDER BY s.totalamount ASC
						        ) AS rnk
						    FROM sales s
						    JOIN branches b ON s.branch_id = b.branch_id
						)
						WHERE rnk = 1
						ORDER BY period DESC, branch_name
			""";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				SalesDto dto = new SalesDto();
				dto.setPeriod(rs.getString("period"));
				dto.setBranch_name(rs.getString("branch_name"));
				dto.setMinSalesDate(rs.getString("sales_date"));
				dto.setTotalSales(rs.getInt("totalamount"));
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
	
	
	// 주간 최저 매출일
	
	public List<SalesDto> getweeklyMinSalesDates() {
		List<SalesDto> list = new ArrayList<>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = new DbcpBean().getConn();
			String sql = """
				SELECT *
				FROM (
				    SELECT 
				        TO_CHAR(s.created_at, 'IYYY') || '-W' || TO_CHAR(s.created_at, 'IW') AS period,
				        b.name AS branch_name,
				        TO_CHAR(s.created_at, 'YYYY-MM-DD') AS sales_date,
				        s.totalamount,
				        RANK() OVER (
				            PARTITION BY TO_CHAR(s.created_at, 'IYYY') || '-W' || TO_CHAR(s.created_at, 'IW'), b.name
				            ORDER BY s.totalamount ASC
				        ) AS rnk
				    FROM sales s
				    JOIN branches b ON s.branch_id = b.branch_id
				)
				WHERE rnk = 1
				ORDER BY period DESC, branch_name
			""";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				SalesDto dto = new SalesDto();
				dto.setPeriod(rs.getString("period"));
				dto.setBranch_name(rs.getString("branch_name"));
				dto.setMinSalesDate(rs.getString("sales_date"));
				dto.setTotalSales(rs.getInt("totalamount"));
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

	
	// 연간 최고 매출일
	
	public List<SalesDto> getYearlyMaxSalesDates() {
		List<SalesDto> list = new ArrayList<>();
		
		//필요한 객체를 담을 지역변수를 미리 만든다 
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
						TO_CHAR(s.created_at, 'YYYY') AS period,
						b.name AS branch_name,
						TO_CHAR(s.created_at, 'YYYY-MM-DD') AS sales_date,
						s.totalamount,
						RANK() OVER (
							PARTITION BY TO_CHAR(s.created_at, 'YYYY'), b.name
							ORDER BY s.totalamount DESC
						) AS rnk
					FROM sales s
					JOIN branches b ON s.branch_id = b.branch_id
				)
				WHERE rnk = 1
				ORDER BY period DESC, branch_name
					""";
			pstmt = conn.prepareStatement(sql);
			//? 에 값 바인딩

			// select 문 실행하고 결과를 ResultSet 으로 받아온다
			rs = pstmt.executeQuery();
			//반복문 돌면서 ResultSet 에 담긴 데이터를 추출해서 리턴해줄 객체에 담는다
			while (rs.next()) {
				SalesDto dto = new SalesDto();
				dto.setPeriod(rs.getString("period"));
				dto.setBranch_name(rs.getString("branch_name"));
				dto.setMaxSalesDate(rs.getString("sales_date"));
				dto.setTotalSales(rs.getInt("totalamount"));
				
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
	
	// 지점별 월간 최고 매출일
	public List<SalesDto> getMonthlyMaxSalesDates() {
		List<SalesDto> list = new ArrayList<>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = new DbcpBean().getConn();
			String sql = """
				SELECT *
				FROM (
					SELECT 
						TO_CHAR(s.created_at, 'YYYY-MM') AS period,
						b.name AS branch_name,
						TO_CHAR(s.created_at, 'YYYY-MM-DD') AS sales_date,
						s.totalamount,
						RANK() OVER (
							PARTITION BY TO_CHAR(s.created_at, 'YYYY-MM'), b.name
							ORDER BY s.totalamount DESC
						) AS rnk
					FROM sales s
					JOIN branches b ON s.branch_id = b.branch_id
				)
				WHERE rnk = 1
				ORDER BY period DESC, branch_name
			""";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				SalesDto dto = new SalesDto();
				dto.setPeriod(rs.getString("period"));
				dto.setBranch_name(rs.getString("branch_name"));
				dto.setMaxSalesDate(rs.getString("sales_date"));
				dto.setTotalSales(rs.getInt("totalamount"));
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

	
	// 지점별 주간 최고 매출일
	public List<SalesDto> getWeeklyMaxSalesDates(){
		List<SalesDto> list = new ArrayList<>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = new DbcpBean().getConn();
			String sql = """
				SELECT *
				FROM (
				    SELECT
				        TO_CHAR(s.created_at, 'IYYY') || '-W' || TO_CHAR(s.created_at, 'IW') AS period,
				        b.name AS branch_name,
				        TO_CHAR(s.created_at, 'YYYY-MM-DD') AS sales_date,
				        s.totalamount,
				        RANK() OVER (
				            PARTITION BY TO_CHAR(s.created_at, 'IYYY-IW'), b.name
				            ORDER BY s.totalamount DESC
				        ) AS rnk
				    FROM sales s
				    JOIN branches b ON s.branch_id = b.branch_id
				)
				WHERE rnk = 1
				ORDER BY period DESC, branch_name
			""";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				SalesDto dto = new SalesDto();
				dto.setPeriod(rs.getString("period"));
				dto.setBranch_name(rs.getString("branch_name"));
				dto.setMaxSalesDate(rs.getString("sales_date"));
				dto.setTotalSales(rs.getInt("totalamount"));
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



	
	// 지점별 일 평균 매출 구하기
	public List<SalesDto> getDailyAvgSales() {
	    List<SalesDto> list = new ArrayList<>();
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
	            SELECT 
	                s.branch_id,
	                b.name AS branch_name,
	                SUM(s.totalamount) AS total_sales,
	                COUNT(DISTINCT TRUNC(s.created_at)) AS day_count,
	                ROUND(SUM(s.totalamount) / COUNT(DISTINCT TRUNC(s.created_at))) AS avg_per_day
	            FROM sales s
	            JOIN branches b ON s.branch_id = b.branch_id
	            GROUP BY s.branch_id, b.name
	            ORDER BY avg_per_day DESC
	        """;
	        pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            SalesDto dto = new SalesDto();
	            dto.setBranch_name(rs.getString("branch_name"));        // 지점 이름
	            dto.setTotalSales(rs.getInt("total_sales"));            // 총 매출
	            dto.setDayCount(rs.getInt("day_count"));                // 날짜 수
	            dto.setAverageSalesPerDay(rs.getInt("avg_per_day"));    // 일 평균 매출
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


	
	// 주간별 평균 매출 통계
	public List<SalesDto> getWeeklyAvgSats() {
		List<SalesDto> list = new ArrayList<>();

		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = new DbcpBean().getConn();
			String sql = """
			    SELECT
			        TO_CHAR(s.created_at, 'IYYY') || '-W' || TO_CHAR(s.created_at, 'IW') AS period,
			        s.branch_id,
			        b.name AS branch_name,
			        SUM(s.totalamount) AS total_sales,
			        ROUND(AVG(s.totalamount)) AS average_sales
			    FROM sales s
			    JOIN branches b ON s.branch_id = b.branch_id
			    GROUP BY TO_CHAR(s.created_at, 'IYYY') || '-W' || TO_CHAR(s.created_at, 'IW'), s.branch_id, b.name
			    ORDER BY period DESC
			""";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				SalesDto dto = new SalesDto();
				dto.setPeriod(rs.getString("period"));               // 주차
				dto.setBranch_name(rs.getString("branch_name"));     // 지점 이름
				dto.setTotalSales(rs.getInt("total_sales"));         // 총합
				dto.setAverageSales(rs.getInt("average_sales"));     // 평균
				list.add(dto);
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

		return list;
	}


	
	
	
	// 월간별 평균 매출 통계
	public List<SalesDto> getMonthlyAvgSats() {
		List<SalesDto> list = new ArrayList<>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = new DbcpBean().getConn();
			String sql = """
				SELECT 
					TO_CHAR(s.created_at, 'YYYY-MM') AS period,
					s.branch_id,
					b.name AS branch_name,
					SUM(s.totalamount) AS total_sales,
					ROUND(AVG(s.totalamount)) AS average_sales
				FROM sales s
				JOIN branches b ON s.branch_id = b.branch_id
				GROUP BY TO_CHAR(s.created_at, 'YYYY-MM'), s.branch_id, b.name
				ORDER BY period DESC
			""";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				SalesDto dto = new SalesDto();
				dto.setPeriod(rs.getString("period"));
				dto.setBranch_id(rs.getString("branch_id")); // 또는 dto.setBranch_name() 가능
				dto.setBranch_name(rs.getString("branch_name"));
				dto.setTotalSales(rs.getInt("total_sales"));
				dto.setAverageSales(rs.getInt("average_sales"));
				list.add(dto);
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
		return list;
	}

	
	// 주간별 매출 통계 (지점 이름 포함)
	public List<SalesDto> getWeeklyStats() {
	    List<SalesDto> list = new ArrayList<>();
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
	            SELECT 
	                TO_CHAR(s.created_at, 'IYYY') || '-W' || TO_CHAR(s.created_at, 'IW') AS period,
	                s.branch_id,
	                b.name AS branch_name,
	                SUM(s.totalamount) AS total_sales
	            FROM sales s
	            JOIN branches b ON s.branch_id = b.branch_id
	            GROUP BY 
	                TO_CHAR(s.created_at, 'IYYY') || '-W' || TO_CHAR(s.created_at, 'IW'),
	                s.branch_id,
	                b.name
	            ORDER BY period DESC
	        """;
	        pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            SalesDto dto = new SalesDto();
	            dto.setPeriod(rs.getString("period"));                 
	            dto.setBranch_id(rs.getString("branch_id"));              
	            dto.setBranch_name(rs.getString("branch_name"));       
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



	
	// 월간 매출 통계
	public List<SalesDto> getMonthlyStats() {
		List<SalesDto> list = new ArrayList<>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = new DbcpBean().getConn();
			String sql = """
						SELECT 
						    TO_CHAR(s.created_at, 'YYYY-MM') AS period,
						    s.branch_id,
						    b.name AS branch_name,
						    SUM(s.totalamount) AS total_sales
						FROM sales s
						JOIN branches b ON s.branch_id = b.branch_id
						GROUP BY TO_CHAR(s.created_at, 'YYYY-MM'), s.branch_id, b.name
						ORDER BY period DESC
					""";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				SalesDto dto = new SalesDto();
				dto.setPeriod(rs.getString("period"));
				dto.setBranch_name(rs.getString("branch_name"));
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
	
	// 연간 매출 합계
	public List<SalesDto> getYearlyStats() {
	    List<SalesDto> list = new ArrayList<>();
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
	            SELECT TO_CHAR(s.created_at, 'YYYY') AS period,
	                   s.branch_id,
	                   b.name AS branch_name,
	                   SUM(s.totalamount) AS total_sales
	            FROM sales s
	            JOIN branches b ON s.branch_id = b.branch_id
	            GROUP BY TO_CHAR(s.created_at, 'YYYY'), s.branch_id, b.name
	            ORDER BY period DESC, branch_name
	        """;
	        pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            SalesDto dto = new SalesDto();
	            dto.setPeriod(rs.getString("period"));
	            dto.setBranch_name(rs.getString("branch_name"));
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


	
	// 일일 마감 매출 데이터를 sales 테이블에 삽입하는 메소드 (이전에 작성된 insert 메소드)
	
	
	// 글 전체 목록을 리턴하는 메소드
	public List<SalesDto> selectAll() {
	    List<SalesDto> list = new ArrayList<>();
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    try {
	        conn = new DbcpBean().getConn();
	        // 실행할 SQL 문: branches 테이블과 조인해서 지점 이름 가져오기
	        String sql = """
					SELECT
					    s.sales_id,
					    s.branch_id,
					    b.name AS branch_name,
					    TO_CHAR(s.created_at, 'YYYY-MM-DD') AS created_at,
					    s.totalamount
					FROM sales s
					JOIN branches b ON s.branch_id = b.branch_id
					ORDER BY s.sales_id DESC
	        """;
	        pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            SalesDto dto = new SalesDto();
	            dto.setSales_id(rs.getInt("sales_id"));
	            dto.setBranch_id(rs.getString("branch_id")); 
	            dto.setBranch_name(rs.getString("branch_name")); 
	            dto.setCreated_at(rs.getString("created_at"));
	            dto.setTotalamount(rs.getInt("totalamount"));

	            list.add(dto);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        try {
	            if (rs != null) rs.close();
	            if (pstmt != null) pstmt.close();
	            if (conn != null) conn.close();
	        } catch (Exception e) {
	        }
	    }
	    return list;
	}

}











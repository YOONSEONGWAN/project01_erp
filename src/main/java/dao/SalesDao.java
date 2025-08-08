package dao;

import java.sql.Connection;
import java.sql.DriverManager;
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
	
	public List<SalesDto> getYearlyRankStatsPageBetween(String start, String end, int startRow, int endRow) {
	    List<SalesDto> list = new ArrayList<>();
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
	            SELECT * FROM (
	                SELECT ROWNUM rn, data.* FROM (
	                    SELECT 
	                        TO_CHAR(s.created_at, 'YYYY') AS period,
	                        s.branch_id,
	                        b.name AS branch_name,
	                        SUM(s.totalamount) AS totalSales,
	                        RANK() OVER (PARTITION BY TO_CHAR(s.created_at, 'YYYY') ORDER BY SUM(s.totalamount) DESC) AS rank
	                    FROM sales s
	                    JOIN branches b ON s.branch_id = b.branch_id
	                    WHERE s.created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
	                    GROUP BY TO_CHAR(s.created_at, 'YYYY'), s.branch_id, b.name
	                    ORDER BY period DESC, rank
	                ) data
	            )
	            WHERE rn BETWEEN ? AND ?
	        """;

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, start);
	        pstmt.setString(2, end);
	        pstmt.setInt(3, startRow);
	        pstmt.setInt(4, endRow);

	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            SalesDto dto = new SalesDto();
	            dto.setPeriod(rs.getString("period"));
	            dto.setBranch_id(rs.getString("branch_id"));
	            dto.setBranch_name(rs.getString("branch_name"));
	            dto.setTotalSales(rs.getInt("totalSales"));
	            dto.setRank(rs.getInt("rank"));  // ✅ 순위 설정 추가
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
	
	public int getYearlyRankStatsCountBetween(String start, String end) {
	    int count = 0;
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
	            SELECT COUNT(*) FROM (
	                SELECT TO_CHAR(s.created_at, 'YYYY') AS period, s.branch_id
	                FROM sales s
	                WHERE s.created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
	                GROUP BY TO_CHAR(s.created_at, 'YYYY'), s.branch_id
	            )
	        """;

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, start);
	        pstmt.setString(2, end);

	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            count = rs.getInt(1);
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

	    return count;
	}


	
	// yearly-rank 연간 매출 순위---------------------------------------------------------
	
	public int getYearlyMinStatsCountBetween(String start, String end) {
	    int count = 0;
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
				SELECT COUNT(*) FROM (
				    SELECT *
				    FROM (
				        SELECT 
				            TO_CHAR(TRUNC(s.created_at), 'YYYY-MM') AS period,
				            s.branch_id,
				            TO_CHAR(TRUNC(s.created_at), 'YYYY-MM-DD') AS sales_date,
				            SUM(s.totalamount) AS total_sales,
				            RANK() OVER (
				                PARTITION BY TO_CHAR(TRUNC(s.created_at), 'YYYY-MM'), s.branch_id
				                ORDER BY SUM(s.totalamount) ASC
				            ) AS rnk
				        FROM sales s
				        WHERE s.created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
				        GROUP BY TO_CHAR(TRUNC(s.created_at), 'YYYY-MM'), s.branch_id, TRUNC(s.created_at)
				    )
				    WHERE rnk = 1
				)
	        """;

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, start);
	        pstmt.setString(2, end);

	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            count = rs.getInt(1);
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

	    return count;
	}

	
	
	
	public List<SalesDto> getYearlyMinStatsPageBetween(String start, String end, int startRow, int endRow) {
	    List<SalesDto> list = new ArrayList<>();
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
				SELECT * FROM (
				    SELECT ROWNUM rn, data.* FROM (
				        SELECT
				            period,
				            branch_id,
				            branch_name,
				            sales_date,
				            total_sales
				        FROM (
				            SELECT
				                TO_CHAR(day_group, 'YYYY-MM') AS period,
				                s.branch_id,
				                b.name AS branch_name,
				                TO_CHAR(day_group, 'YYYY-MM-DD') AS sales_date,
				                total_sales,
				                RANK() OVER (
				                    PARTITION BY TO_CHAR(day_group, 'YYYY-MM'), s.branch_id
				                    ORDER BY total_sales ASC
				                ) AS rnk
				            FROM (
				                SELECT
				                    TRUNC(s.created_at) AS day_group,
				                    s.branch_id,
				                    SUM(s.totalamount) AS total_sales
				                FROM sales s
				                WHERE s.created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
				                GROUP BY TRUNC(s.created_at), s.branch_id
				            ) s
				            JOIN branches b ON s.branch_id = b.branch_id
				        )
				        WHERE rnk = 1
				        ORDER BY period DESC, branch_name
				    ) data
				)
				WHERE rn BETWEEN ? AND ?
	        """;

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, start);
	        pstmt.setString(2, end);
	        pstmt.setInt(3, startRow);
	        pstmt.setInt(4, endRow);

	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            SalesDto dto = new SalesDto();
	            dto.setPeriod(rs.getString("period"));
	            dto.setBranch_id(rs.getString("branch_id"));
	            dto.setBranch_name(rs.getString("branch_name"));
	            dto.setCreated_at(rs.getString("sales_date"));
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
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }

	    return list;
	}
	
	
	
	// yearly-min 연간 최저 매출일 페이징 메소드-------------------------------------------------------
	
	public int getYearlyMaxStatsCountBetween(String start, String end) {
	    int count = 0;
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
					SELECT COUNT(*) FROM (
					    SELECT *
					    FROM (
					        SELECT TO_CHAR(s.created_at, 'YYYY-MM') AS period,
					               s.branch_id,
					               s.created_at,
					               RANK() OVER (
					                   PARTITION BY TO_CHAR(s.created_at, 'YYYY-MM'), s.branch_id
					                   ORDER BY SUM(s.totalamount) DESC
					               ) AS rnk
					        FROM sales s
					        WHERE s.created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
					        GROUP BY TO_CHAR(s.created_at, 'YYYY-MM'), s.branch_id, s.created_at
					    )
					    WHERE rnk = 1
					)
	        """;

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, start);
	        pstmt.setString(2, end);

	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            count = rs.getInt(1);
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

	    return count;
	}

	
	
	
	public List<SalesDto> getYearlyMaxStatsPageBetween(String start, String end, int startRow, int endRow) {
	    List<SalesDto> list = new ArrayList<>();
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
				    SELECT * FROM (
			        SELECT ROWNUM rn, data.* FROM (
			            SELECT period, branch_id, branch_name, created_at, totalSales
			            FROM (
			                SELECT 
			                    TO_CHAR(s.created_at, 'YYYY') AS period,
			                    s.branch_id,
			                    b.name AS branch_name,
			                    TO_CHAR(s.created_at, 'YYYY-MM-DD') AS created_at,  -- ✅ 여기가 중요!
			                    SUM(s.totalamount) AS totalSales,
			                    RANK() OVER (
			                        PARTITION BY TO_CHAR(s.created_at, 'YYYY'), s.branch_id
			                        ORDER BY SUM(s.totalamount) DESC
			                    ) AS rnk
			                FROM sales s
			                JOIN branches b ON s.branch_id = b.branch_id
			                WHERE s.created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
			                GROUP BY TO_CHAR(s.created_at, 'YYYY'), s.branch_id, b.name, s.created_at
			            )
			            WHERE rnk = 1
			            ORDER BY period DESC, branch_name
			        ) data
			    )
			    WHERE rn BETWEEN ? AND ?
	        """;

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, start);
	        pstmt.setString(2, end);
	        pstmt.setInt(3, startRow);
	        pstmt.setInt(4, endRow);

	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            SalesDto dto = new SalesDto();
	            dto.setPeriod(rs.getString("period"));
	            dto.setBranch_id(rs.getString("branch_id"));
	            dto.setBranch_name(rs.getString("branch_name"));
	            dto.setTotalSales(rs.getInt("totalSales"));
	            dto.setCreated_at(rs.getString("created_at")); 
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
	
	
	// yearly-max 연간 최대 매출일 페이징 메소드--------------------------------------------------
	
	public List<SalesDto> getYearlyStatsPageBetween(String start, String end, int startRow, int endRow) {
	    List<SalesDto> list = new ArrayList<>();
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
				    SELECT * FROM (
				        SELECT ROWNUM rn, data.* FROM (
				            SELECT 
				                TO_CHAR(s.created_at, 'YYYY') AS period,
				                s.branch_id,
				                b.name AS branch_name,
				                SUM(s.totalamount) AS totalSales
				            FROM sales s
				            JOIN branches b ON s.branch_id = b.branch_id
				            WHERE s.created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
				            GROUP BY TO_CHAR(s.created_at, 'YYYY'), s.branch_id, b.name
				            ORDER BY period DESC, branch_name
				        ) data
				    )
				    WHERE rn BETWEEN ? AND ?
	        """;

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, start);
	        pstmt.setString(2, end);
	        pstmt.setInt(3, startRow);
	        pstmt.setInt(4, endRow);

	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            SalesDto dto = new SalesDto();
	            dto.setPeriod(rs.getString("period"));
	            dto.setBranch_id(rs.getString("branch_id"));
	            dto.setBranch_name(rs.getString("branch_name"));
	            dto.setTotalSales(rs.getInt("totalSales"));
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

	
	public int getYearlyStatsCountBetween(String start, String end) {
	    int count = 0;
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
			    SELECT COUNT(*) FROM (
			        SELECT 
			            TO_CHAR(s.created_at, 'YYYY') AS year, 
			            s.branch_id
			        FROM sales s
			        WHERE s.created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
			        GROUP BY TO_CHAR(s.created_at, 'YYYY'), s.branch_id
			    )
	        """;

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, start);
	        pstmt.setString(2, end);

	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            count = rs.getInt(1);
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

	    return count;
	}

	
	
	// yearly 연간 총 매출 페이징 메소드-------------------------------------------------------------------
	
	public List<SalesDto> getWeeklyRankStatsPageBetween(String start, String end, int startRow, int endRow) {
	    List<SalesDto> list = new ArrayList<>();
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
					SELECT * FROM (
					    SELECT ROWNUM rn, data.* FROM (
					        SELECT TO_CHAR(s.created_at, 'YYYY-MM') AS period,
					               s.branch_id,
					               b.name AS branch_name,
					               SUM(s.totalamount) AS totalSales,
					               RANK() OVER (PARTITION BY TO_CHAR(s.created_at, 'YYYY-MM') ORDER BY SUM(s.totalamount) DESC) AS rank
					        FROM sales s
					        JOIN branches b ON s.branch_id = b.branch_id
					        WHERE s.created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
					        GROUP BY TO_CHAR(s.created_at, 'YYYY-MM'), s.branch_id, b.name
					        ORDER BY period DESC, rank
					    ) data
					)
					WHERE rn BETWEEN ? AND ?
	        """;

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, start);
	        pstmt.setString(2, end);
	        pstmt.setInt(3, startRow);
	        pstmt.setInt(4, endRow);

	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            SalesDto dto = new SalesDto();
	            dto.setPeriod(rs.getString("period"));
	            dto.setBranch_id(rs.getString("branch_id"));
	            dto.setBranch_name(rs.getString("branch_name"));
	            dto.setTotalSales(rs.getInt("totalSales"));
	            dto.setRank(rs.getInt("rank"));
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
	
	
	
	public int getWeeklyRankStatsCountBetween(String start, String end) {
	    int count = 0;
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
					SELECT COUNT(*) FROM (
					    SELECT TO_CHAR(s.created_at, 'YYYY-MM') AS period, s.branch_id
					    FROM sales s
					    WHERE s.created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
					    GROUP BY TO_CHAR(s.created_at, 'YYYY-MM'), s.branch_id
					)
	        """;

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, start);
	        pstmt.setString(2, end);

	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            count = rs.getInt(1);
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

	    return count;
	}
	
	

	// weekly-rank 주간 매출 순위 페이징 메소드------------------------------------------------------------------
	
	
	    public List<SalesDto> getWeeklyMaxSalesDatesBetween(String start, String end, int startRow, int endRow) {
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
	                        rn, period, branch_name, sales_date, totalamount, rnk
	                    FROM (
	                        SELECT
	                            TO_CHAR(TRUNC(s.created_at), 'IYYY-WW') AS period,
	                            b.name AS branch_name,
	                            TO_CHAR(TRUNC(s.created_at), 'YYYY-MM-DD') AS sales_date,
	                            SUM(s.totalamount) AS totalamount,
	                            RANK() OVER (PARTITION BY TO_CHAR(TRUNC(s.created_at), 'IYYY-WW'), b.name ORDER BY SUM(s.totalamount) DESC) AS rnk,
	                            ROW_NUMBER() OVER (ORDER BY TO_CHAR(TRUNC(s.created_at), 'IYYY-WW') DESC, b.name ASC) AS rn -- 페이징을 위한 고유한 행 번호
	                        FROM sales s
	                        JOIN branches b ON s.branch_id = b.branch_id
	                        WHERE TRUNC(s.created_at) BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
	                        GROUP BY TRUNC(s.created_at), b.name
	                    )
	                    WHERE rnk = 1
	                )
	                WHERE rn BETWEEN ? AND ?
	                ORDER BY period DESC, branch_name ASC
	            """;

	            pstmt = conn.prepareStatement(sql);
	            pstmt.setString(1, start);
	            pstmt.setString(2, end);
	            pstmt.setInt(3, startRow);
	            pstmt.setInt(4, endRow);
	            rs = pstmt.executeQuery();

	            while (rs.next()) {
	                SalesDto dto = new SalesDto();
	                dto.setPeriod(rs.getString("period"));
	                dto.setBranch_name(rs.getString("branch_name"));
	                dto.setMaxSalesDate(rs.getString("sales_date")); // ✅ maxSalesDate에 매핑
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

	    /**
	     * 특정 기간 동안의 지점별 주간 최고 매출일 항목의 총 개수를 가져오는 메소드
	     * (페이징을 위한 총 행 수 계산)
	     * @param start 시작일 (YYYY-MM-DD)
	     * @param end 종료일 (YYYY-MM-DD)
	     * @return 조건에 맞는 주간 최고 매출일 항목의 총 개수
	     */
	    public int getWeeklyMaxCountBetween(String start, String end) {
	        int count = 0;
	        Connection conn = null;
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;

	        try {
	            conn = new DbcpBean().getConn();
	            String sql = """
	                SELECT COUNT(*)
	                FROM (
	                    SELECT
	                        TO_CHAR(TRUNC(s.created_at), 'IYYY-WW') AS period,
	                        b.name AS branch_name,
	                        RANK() OVER (PARTITION BY TO_CHAR(TRUNC(s.created_at), 'IYYY-WW'), b.name ORDER BY SUM(s.totalamount) DESC) AS rnk
	                    FROM sales s
	                    JOIN branches b ON s.branch_id = b.branch_id
	                    WHERE TRUNC(s.created_at) BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
	                    GROUP BY TRUNC(s.created_at), b.name
	                )
	                WHERE rnk = 1
	            """;

	            pstmt = conn.prepareStatement(sql);
	            pstmt.setString(1, start);
	            pstmt.setString(2, end);
	            rs = pstmt.executeQuery();

	            if (rs.next()) {
	                count = rs.getInt(1);
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

	    // ✅ 전체 기간에 대한 주간 최고 매출일 데이터를 페이징하여 가져오는 메소드
	    public List<SalesDto> getWeeklyMaxSalesDates(String start, String end, int startRow, int endRow) {
	        return getWeeklyMaxSalesDatesBetween(start, end, startRow, endRow);
	    }

	    // ... (나머지 SalesDao 메소드들은 기존대로 유지) ...
	

	
	public List<SalesDto> getWeekyMaxPageBetween(String start, String end, int startRow, int endRow) {
	    List<SalesDto> list = new ArrayList<>();
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
						SELECT * FROM (
						    SELECT ROWNUM rn, data.* FROM (
						        SELECT 
						            TO_CHAR(s.created_at, 'IYYY-IW') AS period,
						            s.branch_id,
						            b.name AS branch_name,
						            SUM(s.totalamount) AS totalSales,
						            COUNT(DISTINCT TO_CHAR(s.created_at, 'YYYY-MM-DD')) AS dayCount,
						            ROUND(SUM(s.totalamount) / COUNT(DISTINCT TO_CHAR(s.created_at, 'YYYY-MM-DD'))) AS averageSalesPerDay
						        FROM sales s
						        JOIN branches b ON s.branch_id = b.branch_id
						        WHERE s.created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
						        GROUP BY TO_CHAR(s.created_at, 'IYYY-IW'), s.branch_id, b.name
						        ORDER BY period DESC, branch_name
						    ) data
						)
						WHERE rn BETWEEN ? AND ?
	        """;

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, start);
	        pstmt.setString(2, end);
	        pstmt.setInt(3, startRow);
	        pstmt.setInt(4, endRow);

	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            SalesDto dto = new SalesDto();
	            dto.setPeriod(rs.getString("period"));
	            dto.setBranch_id(rs.getString("branch_id"));
	            dto.setBranch_name(rs.getString("branch_name"));
	            dto.setTotalSales(rs.getInt("totalSales"));
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

	
	 /* public int getWeeklyMaxCountBetween(String start, String end) {
	    int count = 0;
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
				SELECT COUNT(*) FROM (
				    SELECT 
				        TO_CHAR(s.created_at, 'IYYY-IW') AS period,
				        s.branch_id,
				        COUNT(DISTINCT TO_CHAR(s.created_at, 'YYYY-MM-DD')) AS dayCount
				    FROM sales s
				    WHERE s.created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
				    GROUP BY TO_CHAR(s.created_at, 'IYYY-IW'), s.branch_id
				)
	        """;

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, start);
	        pstmt.setString(2, end);

	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            count = rs.getInt(1);
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

	    return count;
	} */
	
	// weekly-max 주간별 최고 매출일 페이징 메소드 ------------------------------------------------------------
	
	public List<SalesDto> getWeekyAvgPageBetween(String start, String end, int startRow, int endRow) {
	    List<SalesDto> list = new ArrayList<>();
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
			SELECT * FROM (
			    SELECT ROWNUM rn, data.* FROM (
			        SELECT
			            TO_CHAR(s.created_at, 'IYYY-IW') AS period,
			            s.branch_id,
			            b.name AS branch_name,
			            SUM(s.totalamount) AS totalSales,
			            ROUND(SUM(s.totalamount) / COUNT(DISTINCT TRUNC(s.created_at))) AS averageSalesPerDay
			        FROM sales s
			        JOIN branches b ON s.branch_id = b.branch_id
			        WHERE s.created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
			        GROUP BY TO_CHAR(s.created_at, 'IYYY-IW'), s.branch_id, b.name
			        ORDER BY period DESC, branch_name
			    ) data
			)
			WHERE rn BETWEEN ? AND ?
	        """;

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, start);
	        pstmt.setString(2, end);
	        pstmt.setInt(3, startRow);
	        pstmt.setInt(4, endRow);

	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            SalesDto dto = new SalesDto();
	            dto.setPeriod(rs.getString("period"));
	            dto.setBranch_id(rs.getString("branch_id"));
	            dto.setBranch_name(rs.getString("branch_name"));
	            dto.setTotalSales(rs.getInt("totalSales"));
	            dto.setAverageSalesPerDay(rs.getInt("averageSalesPerDay")); // Add this line
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

	
	public int getWeeklyAvgCountBetween(String start, String end) {
	    int count = 0;
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
				SELECT COUNT(*) FROM (
				    SELECT TO_CHAR(s.created_at, 'IYYY-IW') AS week, s.branch_id, b.name
				    FROM sales s
				    JOIN branches b ON s.branch_id = b.branch_id
				    WHERE s.created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
				    GROUP BY TO_CHAR(s.created_at, 'IYYY-IW'), s.branch_id, b.name
				)
	        """;

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, start);
	        pstmt.setString(2, end);

	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            count = rs.getInt(1);
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

	    return count;
	}

	
	// weekly-avg 주간 평균 매출 페이지 필터 메소드------------------------------------------------------------
	
	public List<SalesDto> getWeekySumPageBetween(String start, String end, int startRow, int endRow) {
	    List<SalesDto> list = new ArrayList<>();
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
				    SELECT * FROM (
				        SELECT ROWNUM rn, data.* FROM (
				            SELECT TO_CHAR(s.created_at, 'IYYY-IW') AS period,
				                   s.branch_id,
				                   b.name AS branch_name,
				                   SUM(s.totalamount) AS totalSales
				            FROM sales s
				            JOIN branches b ON s.branch_id = b.branch_id
				            WHERE s.created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
				            GROUP BY TO_CHAR(s.created_at, 'IYYY-IW'), s.branch_id, b.name
				            ORDER BY period DESC, branch_name
				        ) data
				    )
				    WHERE rn BETWEEN ? AND ?
	        """;

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, start);
	        pstmt.setString(2, end);
	        pstmt.setInt(3, startRow);
	        pstmt.setInt(4, endRow);

	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            SalesDto dto = new SalesDto();
	            dto.setPeriod(rs.getString("period"));
	            dto.setBranch_id(rs.getString("branch_id"));
	            dto.setBranch_name(rs.getString("branch_name"));
	            dto.setTotalSales(rs.getInt("totalSales"));
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

	
	public int getWeeklySumCountBetween(String start, String end) {
	    int count = 0;
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
	            SELECT COUNT(*) FROM (
	                SELECT TO_CHAR(s.created_at, 'IYYY-IW') AS week, s.branch_id
	                FROM sales s
	                WHERE s.created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
	                GROUP BY TO_CHAR(s.created_at, 'IYYY-IW'), s.branch_id
	            )
	        """;

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, start);
	        pstmt.setString(2, end);

	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            count = rs.getInt(1);
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

	    return count;
	}

	
	// weekly 주간별 매출 총 합계 페이징 메소드--------------------------------------------------------------
	
	public int getMonthlyMinStatsCountBetween(String start, String end) {
	    int count = 0;
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
					SELECT COUNT(*) FROM (
					    SELECT *
					    FROM (
					        SELECT TO_CHAR(s.created_at, 'YYYY-MM') AS period,
					               s.branch_id,
					               s.created_at,
					               RANK() OVER (
					                   PARTITION BY TO_CHAR(s.created_at, 'YYYY-MM'), s.branch_id
					                   ORDER BY SUM(s.totalamount) ASC
					               ) AS rnk
					        FROM sales s
					        WHERE s.created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
					        GROUP BY TO_CHAR(s.created_at, 'YYYY-MM'), s.branch_id, s.created_at
					    )
					    WHERE rnk = 1
					)
	        """;

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, start);
	        pstmt.setString(2, end);

	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            count = rs.getInt(1);
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

	    return count;
	}

	
	
	
	public List<SalesDto> getMonthlyMinStatsPageBetween(String start, String end, int startRow, int endRow) {
	    List<SalesDto> list = new ArrayList<>();
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
				    SELECT * FROM (
				        SELECT ROWNUM rn, data.* FROM (
				            SELECT
				                period,
				                branch_id,
				                branch_name,
				                sales_date,
				                total_sales
				            FROM (
				                SELECT
				                    TO_CHAR(day_group, 'YYYY-MM') AS period,
				                    branch_id,
				                    branch_name,
				                    TO_CHAR(day_group, 'YYYY-MM-DD') AS sales_date,
				                    total_sales,
				                    RANK() OVER (
				                        PARTITION BY TO_CHAR(day_group, 'YYYY-MM'), branch_name
				                        ORDER BY total_sales ASC
				                    ) AS rnk
				                FROM (
				                    SELECT
				                        TRUNC(s.created_at) AS day_group,
				                        s.branch_id,
				                        b.name AS branch_name,
				                        SUM(s.totalamount) AS total_sales
				                    FROM sales s
				                    JOIN branches b ON s.branch_id = b.branch_id
				                    WHERE s.created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
				                    GROUP BY TRUNC(s.created_at), s.branch_id, b.name
				                )
				            )
				            WHERE rnk = 1
				            ORDER BY period DESC, branch_name
				        ) data
				    )
				    WHERE rn BETWEEN ? AND ?
	        """;

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, start);
	        pstmt.setString(2, end);
	        pstmt.setInt(3, startRow);
	        pstmt.setInt(4, endRow);

	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            SalesDto dto = new SalesDto();
	            dto.setPeriod(rs.getString("period"));
	            dto.setBranch_id(rs.getString("branch_id"));
	            dto.setBranch_name(rs.getString("branch_name"));
	            dto.setCreated_at(rs.getString("sales_date"));
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
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }

	    return list;
	}
	
	// monthly-min 페이징 필터 메소드----------------------------------------------------------
	
	public List<SalesDto> getMonthlyRankStatsPageBetween(String start, String end, int startRow, int endRow) {
	    List<SalesDto> list = new ArrayList<>();
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
					SELECT * FROM (
					    SELECT ROWNUM rn, data.* FROM (
					        SELECT TO_CHAR(s.created_at, 'YYYY-MM') AS period,
					               s.branch_id,
					               b.name AS branch_name,
					               SUM(s.totalamount) AS totalSales,
					               RANK() OVER (PARTITION BY TO_CHAR(s.created_at, 'YYYY-MM') ORDER BY SUM(s.totalamount) DESC) AS rank
					        FROM sales s
					        JOIN branches b ON s.branch_id = b.branch_id
					        WHERE s.created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
					        GROUP BY TO_CHAR(s.created_at, 'YYYY-MM'), s.branch_id, b.name
					        ORDER BY period DESC, rank
					    ) data
					)
					WHERE rn BETWEEN ? AND ?
	        """;

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, start);
	        pstmt.setString(2, end);
	        pstmt.setInt(3, startRow);
	        pstmt.setInt(4, endRow);

	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            SalesDto dto = new SalesDto();
	            dto.setPeriod(rs.getString("period"));
	            dto.setBranch_id(rs.getString("branch_id"));
	            dto.setBranch_name(rs.getString("branch_name"));
	            dto.setTotalSales(rs.getInt("totalSales"));
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
	
	
	
	public int getMonthlyRankStatsCountBetween(String start, String end) {
	    int count = 0;
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
					SELECT COUNT(*) FROM (
					    SELECT TO_CHAR(s.created_at, 'YYYY-MM') AS period, s.branch_id
					    FROM sales s
					    WHERE s.created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
					    GROUP BY TO_CHAR(s.created_at, 'YYYY-MM'), s.branch_id
					)
	        """;

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, start);
	        pstmt.setString(2, end);

	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            count = rs.getInt(1);
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

	    return count;
	}
	
	
	
	// monthly-rank 페이징 필터 메소드---------------------------------------------------
	
	public int getMonthlyMaxStatsCountBetween(String start, String end) {
	    int count = 0;
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
					SELECT COUNT(*) FROM (
					    SELECT *
					    FROM (
					        SELECT TO_CHAR(s.created_at, 'YYYY-MM') AS period,
					               s.branch_id,
					               s.created_at,
					               RANK() OVER (
					                   PARTITION BY TO_CHAR(s.created_at, 'YYYY-MM'), s.branch_id
					                   ORDER BY SUM(s.totalamount) DESC
					               ) AS rnk
					        FROM sales s
					        WHERE s.created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
					        GROUP BY TO_CHAR(s.created_at, 'YYYY-MM'), s.branch_id, s.created_at
					    )
					    WHERE rnk = 1
					)
	        """;

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, start);
	        pstmt.setString(2, end);

	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            count = rs.getInt(1);
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

	    return count;
	}

	
	
	
	public List<SalesDto> getMonthlyMaxStatsPageBetween(String start, String end, int startRow, int endRow) {
	    List<SalesDto> list = new ArrayList<>();
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
			    SELECT * FROM (
			        SELECT ROWNUM rn, data.* FROM (
			            SELECT period, branch_id, branch_name, totalSales
			            FROM (
			                SELECT TO_CHAR(s.created_at, 'YYYY-MM') AS period,
			                       s.branch_id,
			                       b.name AS branch_name,
			                       SUM(s.totalamount) AS totalSales,
			                       RANK() OVER (PARTITION BY TO_CHAR(s.created_at, 'YYYY-MM') ORDER BY SUM(s.totalamount) DESC) AS rnk
			                FROM sales s
			                JOIN branches b ON s.branch_id = b.branch_id
			                WHERE s.created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
			                GROUP BY TO_CHAR(s.created_at, 'YYYY-MM'), s.branch_id, b.name
			            )
			            WHERE rnk = 1
			            ORDER BY period DESC, branch_name
			        ) data
			    )
			    WHERE rn BETWEEN ? AND ?
	        """;

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, start);
	        pstmt.setString(2, end);
	        pstmt.setInt(3, startRow);
	        pstmt.setInt(4, endRow);

	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            SalesDto dto = new SalesDto();
	            dto.setPeriod(rs.getString("period"));
	            dto.setBranch_id(rs.getString("branch_id"));
	            dto.setBranch_name(rs.getString("branch_name"));
	            dto.setTotalSales(rs.getInt("totalSales"));
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
	
	
	
	
	// monthly-max 페이징 메소드 -----------------------------------------------------------
	

	
	public int getMonthlyAvgStatsCountBetween(String start, String end) {
	    int count = 0;
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
	            SELECT COUNT(*) FROM (
	                SELECT TO_CHAR(s.created_at, 'YYYY-MM') AS month, s.branch_id
	                FROM sales s
	                WHERE s.created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
	                GROUP BY TO_CHAR(s.created_at, 'YYYY-MM'), s.branch_id
	            )
	        """;

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, start);
	        pstmt.setString(2, end);

	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            count = rs.getInt(1);
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

	    return count;
	}

	
	public List<SalesDto> getMonthlyAvgStatsPageBetween(String start, String end, int startRow, int endRow) {
	    List<SalesDto> list = new ArrayList<>();
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
	            SELECT * FROM (
	                SELECT ROWNUM rn, data.* FROM (
	                    SELECT TO_CHAR(s.created_at, 'YYYY-MM') AS period,
	                           s.branch_id,
	                           b.name AS branch_name,
	                           SUM(s.totalamount) AS totalSales
	                    FROM sales s
	                    JOIN branches b ON s.branch_id = b.branch_id
	                    WHERE s.created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
	                    GROUP BY TO_CHAR(s.created_at, 'YYYY-MM'), s.branch_id, b.name
	                    ORDER BY period DESC, branch_name
	                ) data
	            )
	            WHERE rn BETWEEN ? AND ?
	        """;

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, start);
	        pstmt.setString(2, end);
	        pstmt.setInt(3, startRow);
	        pstmt.setInt(4, endRow);

	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            SalesDto dto = new SalesDto();
	            dto.setPeriod(rs.getString("period"));
	            dto.setBranch_id(rs.getString("branch_id"));
	            dto.setBranch_name(rs.getString("branch_name"));
	            dto.setTotalSales(rs.getInt("totalSales"));
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

	
	// monthly-avg.jsp 페이징 필터 메소드 ------------------------------------------------
	
	public List<SalesDto> getMonthlyStatsPageBetween(String start, String end, int startRow, int endRow) {
	    List<SalesDto> list = new ArrayList<>();
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
	            SELECT * FROM (
	                SELECT ROWNUM rn, data.* FROM (
	                    SELECT TO_CHAR(s.created_at, 'YYYY-MM') AS period,
	                           s.branch_id,
	                           b.name AS branch_name,
	                           SUM(s.totalamount) AS totalSales
	                    FROM sales s
	                    JOIN branches b ON s.branch_id = b.branch_id
	                    WHERE s.created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
	                    GROUP BY TO_CHAR(s.created_at, 'YYYY-MM'), s.branch_id, b.name
	                    ORDER BY period DESC, branch_name
	                ) data
	            )
	            WHERE rn BETWEEN ? AND ?
	        """;

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, start);
	        pstmt.setString(2, end);
	        pstmt.setInt(3, startRow);
	        pstmt.setInt(4, endRow);

	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            SalesDto dto = new SalesDto();
	            dto.setPeriod(rs.getString("period"));
	            dto.setBranch_id(rs.getString("branch_id"));
	            dto.setBranch_name(rs.getString("branch_name"));
	            dto.setTotalSales(rs.getInt("totalSales"));
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

	
	public int getMonthlyStatsCountBetween(String start, String end) {
	    int count = 0;
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
	            SELECT COUNT(*) FROM (
	                SELECT TO_CHAR(s.created_at, 'YYYY-MM') AS month, s.branch_id
	                FROM sales s
	                WHERE s.created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
	                GROUP BY TO_CHAR(s.created_at, 'YYYY-MM'), s.branch_id
	            )
	        """;

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, start);
	        pstmt.setString(2, end);

	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            count = rs.getInt(1);
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

	    return count;
	}

	
	
	
	
	
	
	
	
	// monthly.jsp 페이징 필터 메소드------------------------------------------------------
	
	public int getTotalCount() {
	    int count = 0;
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    try {
	        conn = new DbcpBean().getConn();
	        String sql = "SELECT COUNT(*) FROM sales";
	        pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            count = rs.getInt(1);
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

	
	
	public List<SalesDto> selectPage(int startRow, int endRow) {
	    List<SalesDto> list = new ArrayList<>();
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
	            SELECT * FROM (
	                SELECT ROWNUM rn, data.* FROM (
	                    SELECT s.sales_id, s.branch_id, b.name AS branch_name,
	                           TO_CHAR(s.created_at, 'YYYY-MM-DD') AS created_at,
	                           s.totalamount
	                    FROM sales s
	                    JOIN branches b ON s.branch_id = b.branch_id
	                    ORDER BY s.sales_id DESC
	                ) data
	            ) 
	            WHERE rn BETWEEN ? AND ?
	        """;
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, startRow);
	        pstmt.setInt(2, endRow);
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
	        } catch (Exception e) {}
	    }
	    return list;
	}
	
	

	
	
	
	// 전체 매출 목록 페이징 처리 메소드---------------------------------------------------------
	
	public List<SalesDto> getDailyAvgSalesPage(int startRow, int endRow) {
	    List<SalesDto> list = new ArrayList<>();
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
	            SELECT * FROM (
	                SELECT ROWNUM rn, data.* FROM (
	                    SELECT s.branch_id, b.name AS branch_name,
	                           SUM(s.totalamount) AS totalSales,
	                           COUNT(DISTINCT s.created_at) AS dayCount,
	                           ROUND(SUM(s.totalamount) / COUNT(DISTINCT s.created_at)) AS averageSalesPerDay
	                    FROM sales s
	                    JOIN branches b ON s.branch_id = b.branch_id
	                    GROUP BY s.branch_id, b.name
	                    ORDER BY averageSalesPerDay DESC
	                ) data
	            )
	            WHERE rn BETWEEN ? AND ?
	        """;
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, startRow);
	        pstmt.setInt(2, endRow);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            SalesDto dto = new SalesDto();
	            dto.setBranch_id(rs.getString("branch_id"));
	            dto.setBranch_name(rs.getString("branch_name"));
	            dto.setTotalSales(rs.getInt("totalSales"));
	            dto.setDayCount(rs.getInt("dayCount"));
	            dto.setAverageSalesPerDay(rs.getInt("averageSalesPerDay"));
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

	
	public int getDailyAvgCount() {
	    int count = 0;
	    String sql = "SELECT COUNT(*) FROM (SELECT DISTINCT s.branch_id FROM sales s)";
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    try {
	        conn = new DbcpBean().getConn();
	        pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            count = rs.getInt(1);
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

	
	public List<SalesDto> getDailyAvgSalesPageBetween(String start, String end, int startRow, int endRow) {
	    List<SalesDto> list = new ArrayList<>();
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
	            SELECT * FROM (
	                SELECT ROWNUM rn, data.* FROM (
	                    SELECT s.branch_id, b.name AS branch_name,
	                           SUM(s.totalamount) AS totalSales,
	                           COUNT(DISTINCT s.created_at) AS dayCount,
	                           ROUND(SUM(s.totalamount) / COUNT(DISTINCT s.created_at)) AS averageSalesPerDay
	                    FROM sales s
	                    JOIN branches b ON s.branch_id = b.branch_id
	                    WHERE s.created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
	                    GROUP BY s.branch_id, b.name
	                    ORDER BY averageSalesPerDay DESC
	                ) data
	            )
	            WHERE rn BETWEEN ? AND ?
	        """;
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, start);
	        pstmt.setString(2, end);
	        pstmt.setInt(3, startRow);
	        pstmt.setInt(4, endRow);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            SalesDto dto = new SalesDto();
	            dto.setBranch_id(rs.getString("branch_id"));
	            dto.setBranch_name(rs.getString("branch_name"));
	            dto.setTotalSales(rs.getInt("totalSales"));
	            dto.setDayCount(rs.getInt("dayCount"));
	            dto.setAverageSalesPerDay(rs.getInt("averageSalesPerDay"));
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




	
	public int getDailyAvgCountBetween(String start, String end) {
	    int count = 0;
	    String sql = "SELECT COUNT(DISTINCT branch_id) FROM sales "
	               + "WHERE created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')";
	    Connection conn = null;
	    PreparedStatement ps = null;
	    ResultSet rs = null;
	    try {
	        conn = new DbcpBean().getConn();
	        ps = conn.prepareStatement(sql);
	        ps.setString(1, start);
	        ps.setString(2, end);
	        rs = ps.executeQuery();
	        if (rs.next()) {
	            count = rs.getInt(1);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        try {
	            if (rs != null) rs.close();
	            if (ps != null) ps.close();
	            if (conn != null) conn.close();
	        } catch (Exception e) {}
	    }
	    return count;
	}


	
	// daily-avg 페이징처리 메소드--------------------------------------------------------------
	
	
	// 페이징처리 처음 필요하는 메소드--------------------------------------------------------------
	
	public int getFilteredCount(String start, String end) {
	    int count = 0;
	    String sql = "SELECT COUNT(*) FROM sales "
	               + "WHERE created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')";
	    Connection conn = null;
	    PreparedStatement ps = null;
	    ResultSet rs = null;

	    try {
	        Class.forName("oracle.jdbc.OracleDriver");
	        conn = DriverManager.getConnection(
	            "jdbc:oracle:thin:@localhost:1521:xe", "scott", "tiger");

	        ps = conn.prepareStatement(sql);
	        ps.setString(1, start);
	        ps.setString(2, end);
	        rs = ps.executeQuery();

	        if (rs.next()) {
	            count = rs.getInt(1);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        try { if (rs != null) rs.close(); } catch (Exception e) {}
	        try { if (ps != null) ps.close(); } catch (Exception e) {}
	        try { if (conn != null) conn.close(); } catch (Exception e) {}
	    }

	    return count;
	}
	
	public List<SalesDto> selectFilteredPage(String start, String end, int startRow, int endRow) {
	    List<SalesDto> list = new ArrayList<>();
	    String sql = "SELECT * FROM ( "
	               + "    SELECT ROWNUM rn, A.* FROM ( "
	               + "        SELECT s.sales_id, s.branch_id, b.branch_name, s.totalamount, s.created_at "
	               + "        FROM sales s "
	               + "        JOIN branches b ON s.branch_id = b.branch_id "
	               + "        WHERE s.created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD') "
	               + "        ORDER BY s.created_at DESC "
	               + "    ) A "
	               + "    WHERE ROWNUM <= ? "
	               + ") "
	               + "WHERE rn >= ?";

	    Connection conn = null;
	    PreparedStatement ps = null;
	    ResultSet rs = null;

	    try {
	        Class.forName("oracle.jdbc.OracleDriver");
	        conn = DriverManager.getConnection(
	            "jdbc:oracle:thin:@localhost:1521:xe", "scott", "tiger");

	        ps = conn.prepareStatement(sql);
	        ps.setString(1, start);
	        ps.setString(2, end);
	        ps.setInt(3, endRow);
	        ps.setInt(4, startRow);
	        rs = ps.executeQuery();

	        while (rs.next()) {
	            SalesDto dto = new SalesDto();
	            dto.setSales_id(rs.getInt("sales_id"));
	            dto.setBranch_id(rs.getString("branch_id"));
	            dto.setBranch_name(rs.getString("branch_name"));
	            dto.setTotalamount(rs.getInt("totalamount"));
	            dto.setCreated_at(rs.getString("created_at"));
	            list.add(dto);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        try { if (rs != null) rs.close(); } catch (Exception e) {}
	        try { if (ps != null) ps.close(); } catch (Exception e) {}
	        try { if (conn != null) conn.close(); } catch (Exception e) {}
	    }

	    return list;
	}


	
	
	//--------------------------------------------------------------------------------------
	
	
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


	
	// 지점별 연간 매출 순위 (날짜 범위 필터 적용)
	public List<SalesDto> getYearlySalesRankingBetween(String start, String end) {
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
	                    TO_CHAR(s.created_at, 'YYYY') AS period,
	                    b.name AS branch_name,
	                    SUM(s.totalamount) AS total_sales,
	                    ROW_NUMBER() OVER (
	                        PARTITION BY TO_CHAR(s.created_at, 'YYYY')
	                        ORDER BY SUM(s.totalamount) DESC
	                    ) AS rnk
	                FROM sales s
	                JOIN branches b ON s.branch_id = b.branch_id
	                WHERE s.created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
	                GROUP BY TO_CHAR(s.created_at, 'YYYY'), b.name
	            )
	            ORDER BY period DESC, rnk
	        """;

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, start);
	        pstmt.setString(2, end);
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

	// 지점별 연간 매출 순위 전체 조회
	public List<SalesDto> getYearlySalesRanking() {
	    return getYearlySalesRankingBetween("2000-01-01", "2099-12-31");
	}

	
	// 지점별 월간 매출 순위 (날짜 범위 필터 적용)
	public List<SalesDto> getMonthlySalesRankingBetween(String start, String end) {
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
	                    SUM(s.totalamount) AS total_sales,
	                    ROW_NUMBER() OVER (
	                        PARTITION BY TO_CHAR(s.created_at, 'YYYY-MM')
	                        ORDER BY SUM(s.totalamount) DESC
	                    ) AS rnk
	                FROM sales s
	                JOIN branches b ON s.branch_id = b.branch_id
	                WHERE s.created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
	                GROUP BY TO_CHAR(s.created_at, 'YYYY-MM'), b.name
	            )
	            ORDER BY period DESC, rnk
	        """;

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, start);
	        pstmt.setString(2, end);
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
	
	// 지점별 월간 매출 순위 전체 조회
	public List<SalesDto> getMonthlySalesRanking() {
	    return getMonthlySalesRankingBetween("2000-01-01", "2099-12-31");
	}

	
	// 지점별 월간 최고 매출일 (날짜 범위 필터 적용)
	public List<SalesDto> getMonthlyMaxSalesDatesBetween(String start, String end) {
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
	                WHERE s.created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
	            )
	            WHERE rnk = 1
	            ORDER BY period DESC, branch_name
	        """;

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, start);
	        pstmt.setString(2, end);
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

	// 지점별 주간 매출 순위 (날짜 범위 필터 적용)
	public List<SalesDto> getWeeklySalesRankingBetween(String start, String end) {
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
	                    TO_CHAR(s.created_at, 'IYYY-"W"IW') AS period,
	                    b.name AS branch_name,
	                    SUM(s.totalamount) AS total_sales,
	                    ROW_NUMBER() OVER (
	                        PARTITION BY TO_CHAR(s.created_at, 'IYYY-"W"IW')
	                        ORDER BY SUM(s.totalamount) DESC
	                    ) AS rnk
	                FROM sales s
	                JOIN branches b ON s.branch_id = b.branch_id
	                WHERE s.created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
	                GROUP BY TO_CHAR(s.created_at, 'IYYY-"W"IW'), b.name
	            )
	            ORDER BY period DESC, rnk
	        """;

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, start);
	        pstmt.setString(2, end);
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

	// 지점별 주간 매출 순위 전체 조회
	public List<SalesDto> getWeeklySalesRanking() {
	    return getWeeklySalesRankingBetween("2000-01-01", "2099-12-31");
	}
	
	

	// 지점별 연간 최저 매출일 (날짜 범위 필터 적용)
	public List<SalesDto> getYearlyMinSalesDatesBetween(String start, String end) {
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
	                    TO_CHAR(day_group, 'YYYY') AS period,
	                    branch_name,
	                    TO_CHAR(day_group, 'YYYY-MM-DD') AS sales_date,
	                    total_sales,
	                    RANK() OVER (
	                        PARTITION BY TO_CHAR(day_group, 'YYYY'), branch_name
	                        ORDER BY total_sales ASC
	                    ) AS rnk
	                FROM (
	                    SELECT
	                        TRUNC(s.created_at) AS day_group,
	                        b.name AS branch_name,
	                        SUM(s.totalamount) AS total_sales
	                    FROM sales s
	                    JOIN branches b ON s.branch_id = b.branch_id
	                    WHERE s.created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
	                    GROUP BY TRUNC(s.created_at), b.name
	                )
	            )
	            WHERE rnk = 1
	            ORDER BY period DESC, branch_name
	        """;

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, start);
	        pstmt.setString(2, end);
	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            SalesDto dto = new SalesDto();
	            dto.setPeriod(rs.getString("period"));
	            dto.setBranch_name(rs.getString("branch_name"));
	            dto.setMaxSalesDate(rs.getString("sales_date")); // 최고 매출일에도 이 필드 재사용
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

	
	// 지점별 연간 최저 매출일 (전체 조회)
	public List<SalesDto> getYearlyMinSalesDates() {
	    return getYearlyMinSalesDatesBetween("2000-01-01", "2099-12-31");
	}

	
	// 지점별 월간 최저 매출일 (날짜 범위 필터 적용)
	public List<SalesDto> getMonthlyMinSalesDatesBetween(String start, String end) {
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
	                        ORDER BY s.totalamount ASC
	                    ) AS rnk
	                FROM sales s
	                JOIN branches b ON s.branch_id = b.branch_id
	                WHERE s.created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
	            )
	            WHERE rnk = 1
	            ORDER BY period DESC, branch_name
	        """;

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, start);
	        pstmt.setString(2, end);
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
	
	// 지점별 월간 최저 매출일 (전체 조회)
	public List<SalesDto> getMonthlyMinSalesDates() {
	    return getMonthlyMinSalesDatesBetween("2000-01-01", "2099-12-31");
	}

	
	// 지점별 주간 최저 매출일 (날짜 필터 적용)
	public List<SalesDto> getWeeklyMinSalesDatesBetween(String start, String end) {
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
	                    TO_CHAR(s.created_at, 'IYYY') || '-W' || TO_CHAR(s.created_at, 'IW') AS period,  -- 주차
	                    b.name AS branch_name,
	                    TO_CHAR(s.created_at, 'YYYY-MM-DD') AS sales_date,
	                    s.totalamount,
	                    RANK() OVER (
	                        PARTITION BY TO_CHAR(s.created_at, 'IYYY-IW'), b.name
	                        ORDER BY s.totalamount ASC
	                    ) AS rnk
	                FROM sales s
	                JOIN branches b ON s.branch_id = b.branch_id
	                WHERE s.created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
	            )
	            WHERE rnk = 1
	            ORDER BY period DESC, branch_name
	        """;

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, start);
	        pstmt.setString(2, end);
	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            SalesDto dto = new SalesDto();
	            dto.setPeriod(rs.getString("period")); // 주차
	            dto.setBranch_name(rs.getString("branch_name"));
	            dto.setMaxSalesDate(rs.getString("sales_date")); // 실제 매출일
	            dto.setTotalSales(rs.getInt("totalamount")); // 매출액
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

	// 지점별 주간 최저 매출일 (전체 조회)
	public List<SalesDto> getWeeklyMinSalesDates() {
	    return getWeeklyMinSalesDatesBetween("2000-01-01", "2099-12-31");
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

	// 지점별 연간 최고 매출일 (날짜 필터 적용)
	public List<SalesDto> getYearlyMaxSalesDatesBetween(String start, String end) {
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
	                WHERE s.created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
	            )
	            WHERE rnk = 1
	            ORDER BY period DESC, branch_name
	        """;

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, start);
	        pstmt.setString(2, end);
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

	// 전체 연간 최고 매출일 조회용 기본 메서드
	public List<SalesDto> getYearlyMaxSalesDates() {
	    return getYearlyMaxSalesDatesBetween("2000-01-01", "2099-12-31");
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

	// 지점별 주간 최고 매출일 (날짜 필터 적용)
	public List<SalesDto> getWeeklyMaxSalesDatesBetween(String start, String end) {
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
	                WHERE s.created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
	            )
	            WHERE rnk = 1
	            ORDER BY period DESC, branch_name
	        """;
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, start);
	        pstmt.setString(2, end);
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
	
	// 지점별 주간 최고 매출일 (전체 조회)
	public List<SalesDto> getWeeklyMaxSalesDates() {
	    return getWeeklyMaxSalesDatesBetween("2000-01-01", "2099-12-31");
	}


	// 지점별 일 평균 매출 구하기 (날짜 필터 적용)
	public List<SalesDto> getDailyAvgSalesBetween(String start, String end) {
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
	            WHERE s.created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
	            GROUP BY s.branch_id, b.name
	            ORDER BY avg_per_day DESC
	        """;
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, start);
	        pstmt.setString(2, end);
	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            SalesDto dto = new SalesDto();
	            dto.setBranch_id(rs.getString("branch_id"));
	            dto.setBranch_name(rs.getString("branch_name"));
	            dto.setTotalSales(rs.getInt("total_sales"));
	            dto.setDayCount(rs.getInt("day_count"));
	            dto.setAverageSalesPerDay(rs.getInt("avg_per_day"));
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

	// 월간 평균 매출 (날짜 범위 필터 적용)
	public List<SalesDto> getMonthlyAvgStatsBetween(String start, String end) {
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
	                ROUND(AVG(s.totalamount)) AS avg_sales
	            FROM sales s
	            JOIN branches b ON s.branch_id = b.branch_id
	            WHERE s.created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
	            GROUP BY TO_CHAR(s.created_at, 'YYYY-MM'), s.branch_id, b.name
	            ORDER BY period DESC
	        """;

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, start);
	        pstmt.setString(2, end);
	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            SalesDto dto = new SalesDto();
	            dto.setPeriod(rs.getString("period"));
	            dto.setBranch_id(rs.getString("branch_id"));
	            dto.setBranch_name(rs.getString("branch_name"));
	            dto.setTotalSales(rs.getInt("total_sales"));
	            dto.setAverageSales(rs.getInt("avg_sales"));
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
	
	// 월간 평균 매출 (전체 범위)
	public List<SalesDto> getMonthlyAvgStats() {
	    return getMonthlyAvgStatsBetween("2000-01-01", "2099-12-31");
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

	
	// ✅ 최종: 날짜 범위 필터용 메서드 (하나만 유지)
	public List<SalesDto> getWeeklyStatsBetween(String start, String end) {
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
	            WHERE s.created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
	            GROUP BY 
	                TO_CHAR(s.created_at, 'IYYY') || '-W' || TO_CHAR(s.created_at, 'IW'),
	                s.branch_id,
	                b.name
	            ORDER BY period DESC
	        """;

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, start);
	        pstmt.setString(2, end);
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


	// ✅ 전체 주간 매출 조회
	public List<SalesDto> getWeeklyStats() {
	    return getWeeklyStatsBetween("2000-01-01", "2099-12-31");
	}

	// 월간 매출 합계 (날짜 범위 필터 적용)
	public List<SalesDto> getMonthlyStatsBetween(String start, String end) {
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
	            WHERE s.created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
	            GROUP BY TO_CHAR(s.created_at, 'YYYY-MM'), s.branch_id, b.name
	            ORDER BY period DESC
	        """;

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, start);
	        pstmt.setString(2, end);
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

	// 연간 매출 합계 (날짜 범위 필터 적용)
	public List<SalesDto> getYearlyStatsBetween(String start, String end) {
	    List<SalesDto> list = new ArrayList<>();
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
	            SELECT 
	                TO_CHAR(s.created_at, 'YYYY') AS period,
	                s.branch_id,
	                b.name AS branch_name,
	                SUM(s.totalamount) AS total_sales
	            FROM sales s
	            JOIN branches b ON s.branch_id = b.branch_id
	            WHERE s.created_at BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
	            GROUP BY TO_CHAR(s.created_at, 'YYYY'), s.branch_id, b.name
	            ORDER BY period DESC
	        """;

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, start);
	        pstmt.setString(2, end);
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











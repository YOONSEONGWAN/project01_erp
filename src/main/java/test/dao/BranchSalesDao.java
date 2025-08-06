package test.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import test.dto.BranchSalesDto;
import test.dto.BranchSalesSummaryDto;
import util.DbcpBean;

public class BranchSalesDao {
    private static BranchSalesDao dao = new BranchSalesDao();
    private BranchSalesDao() {}
    public static BranchSalesDao getInstance() {
        return dao;
    }

    /* ----------------------
       1. 매출 CRUD
    ---------------------- */

 // 매출 등록
    public boolean insert(BranchSalesDto dto) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int rowCount = 0; // 변화된 row 수

        try {
            conn = new DbcpBean().getConn();
            String sql = """
                INSERT INTO sales (sales_id, branch_id, created_at, totalamount)
                VALUES (sales_seq.NEXTVAL, ?, SYSDATE, ?)
            """;
            pstmt = conn.prepareStatement(sql);
            // ? 순서대로 값 바인딩
            pstmt.setString(1, dto.getBranchId());
            pstmt.setInt(2, dto.getTotalAmount());

            // sql 실행 후 변화된 row 수 반환
            rowCount = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {}
        }

        // 변화된 row 수에 따라 성공 여부 반환
        return rowCount > 0;
    }

    public List<BranchSalesDto> getList(String branchId) {
        List<BranchSalesDto> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = new DbcpBean().getConn();
            String sql = """
                SELECT sales_id, branch_id,
                       TO_CHAR(created_at, 'YYYY-MM-DD') AS created_at,
                       totalamount
                FROM sales
                WHERE branch_id = ?
                ORDER BY sales_id DESC
            """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, branchId);

            rs = pstmt.executeQuery();
            while (rs.next()) {
                BranchSalesDto dto = new BranchSalesDto();
                dto.setSalesId(rs.getInt("sales_id"));
                dto.setBranchId(rs.getString("branch_id"));
                dto.setCreated_at(rs.getString("created_at"));
                dto.setTotalAmount(rs.getInt("totalamount"));
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

    public BranchSalesDto getById(int salesId, String branchId) {
        BranchSalesDto dto = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = new DbcpBean().getConn();
            String sql = """
                SELECT sales_id, branch_id,
                       TO_CHAR(created_at, 'YYYY-MM-DD') AS created_at,
                       totalamount
                FROM sales
                WHERE sales_id = ? AND branch_id = ?
            """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, salesId);
            pstmt.setString(2, branchId);

            rs = pstmt.executeQuery();
            if (rs.next()) {
                dto = new BranchSalesDto();
                dto.setSalesId(rs.getInt("sales_id"));
                dto.setBranchId(rs.getString("branch_id"));
                dto.setCreated_at(rs.getString("created_at"));
                dto.setTotalAmount(rs.getInt("totalamount"));
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

        return dto;
    }
    // 매출 수정
    public boolean update(BranchSalesDto dto) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int rowCount = 0; // 변화된 row 수를 담을 변수

        try {
            conn = new DbcpBean().getConn();
            String sql = """
                UPDATE sales
                SET totalamount = ?
                WHERE sales_id = ? AND branch_id = ?
            """;
            pstmt = conn.prepareStatement(sql);
            // ? 순서대로 값 바인딩
            pstmt.setInt(1, dto.getTotalAmount());
            pstmt.setInt(2, dto.getSalesId());
            pstmt.setString(3, dto.getBranchId());

            // sql 실행 후 변화된 row 수 반환
            rowCount = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {}
        }

        // 변화된 row 수에 따라 성공 여부 반환
        return rowCount > 0;
    }

 // 매출 삭제
    public boolean delete(int salesId, String branchId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int rowCount = 0; // 변화된 row 수

        try {
            conn = new DbcpBean().getConn();
            String sql = "DELETE FROM sales WHERE sales_id = ? AND branch_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, salesId);
            pstmt.setString(2, branchId);

            rowCount = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {}
        }

        // 변화된 row 수에 따라 성공 여부 반환
        return rowCount > 0;
    }
    /* ----------------------
       2. 지점별 일자별 매출 요약
    ---------------------- */

    public List<BranchSalesSummaryDto> getDailySummaryByBranch(String branchId) {
        List<BranchSalesSummaryDto> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = new DbcpBean().getConn();
            String sql = """
                SELECT TO_CHAR(created_at, 'YYYY-MM-DD') AS salesDate,
                       SUM(totalamount) AS totalAmount
                FROM sales
                WHERE branch_id = ?
                GROUP BY TO_CHAR(created_at, 'YYYY-MM-DD')
                ORDER BY salesDate DESC
            """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, branchId);

            rs = pstmt.executeQuery();
            while (rs.next()) {
                BranchSalesSummaryDto dto = new BranchSalesSummaryDto();
                dto.setSalesDate(rs.getString("salesDate"));
                dto.setBranch(branchId); // 지점 정보 직접 설정
                dto.setTotalAmount(rs.getInt("totalAmount"));
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
     * 지점별 기간별 일자별 매출 요약
     * 종료일 포함 조회 (TRUNC 사용)
     */
    public List<BranchSalesSummaryDto> getDailySummaryByBranchAndPeriod(String branchId, String startDate, String endDate) {
        List<BranchSalesSummaryDto> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = new DbcpBean().getConn();
            String sql = """
                SELECT TO_CHAR(created_at, 'YYYY-MM-DD') AS salesDate,
                       SUM(totalamount) AS totalAmount
                FROM sales
                WHERE branch_id = ?
                  AND TRUNC(created_at) BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
                GROUP BY TO_CHAR(created_at, 'YYYY-MM-DD')
                ORDER BY salesDate DESC
            """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, branchId);
            pstmt.setString(2, startDate);
            pstmt.setString(3, endDate);

            rs = pstmt.executeQuery();
            while (rs.next()) {
                BranchSalesSummaryDto dto = new BranchSalesSummaryDto();
                dto.setSalesDate(rs.getString("salesDate"));
                dto.setBranch(branchId);
                dto.setTotalAmount(rs.getInt("totalAmount"));
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
     * 지점별 기간별 매출 상세 목록 조회
     * 종료일 포함 조회 (TRUNC 사용)
     */
    public List<BranchSalesDto> getListByPeriod(String branchId, String startDate, String endDate) {
        List<BranchSalesDto> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = new DbcpBean().getConn();
            String sql = """
                SELECT sales_id, branch_id,
                       TO_CHAR(created_at, 'YYYY-MM-DD') AS created_at,
                       totalamount
                FROM sales
                WHERE branch_id = ?
                  AND TRUNC(created_at) BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
                ORDER BY sales_id DESC
            """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, branchId);
            pstmt.setString(2, startDate);
            pstmt.setString(3, endDate);

            rs = pstmt.executeQuery();
            while (rs.next()) {
                BranchSalesDto dto = new BranchSalesDto();
                dto.setSalesId(rs.getInt("sales_id"));
                dto.setBranchId(rs.getString("branch_id"));
                dto.setCreated_at(rs.getString("created_at"));
                dto.setTotalAmount(rs.getInt("totalamount"));
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
}

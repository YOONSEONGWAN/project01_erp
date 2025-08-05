package test.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import test.dto.SalesDto;
import test.dto.SalesSummaryDto;
import util.DbcpBean;

public class SalesDao {
    private static SalesDao dao = new SalesDao();
    private SalesDao() {}
    public static SalesDao getInstance() {
        return dao;
    }

    // 매출 등록
    public boolean insert(SalesDto dto) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean isSuccess = false;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                INSERT INTO sales
                (sales_id, branch_id, created_at, totalamount)
                VALUES (sales_seq.NEXTVAL, ?, SYSDATE, ?)
            """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dto.getBranchId());
            pstmt.setInt(2, dto.getTotalAmount());
            int rowCount = pstmt.executeUpdate();
            isSuccess = rowCount > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return isSuccess;
    }

    // 전체 매출 목록 조회
    public List<SalesDto> getList(String branchId) {
        List<SalesDto> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                SELECT sales_id, branch_id,
                       TO_CHAR(created_at, 'YYYY-MM-DD') AS createdAt,
                       totalamount
                FROM sales
                WHERE branch_id = ?
                ORDER BY sales_id DESC
            """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, branchId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                SalesDto dto = new SalesDto();
                dto.setSalesId(rs.getInt("sales_id"));
                dto.setBranchId(rs.getString("branch_id"));
                dto.setCreatedAt(rs.getString("createdAt"));
                dto.setTotalAmount(rs.getInt("totalamount"));
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return list;
    }

    // 매출 삭제
    public boolean delete(int salesId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean isSuccess = false;
        try {
            conn = new DbcpBean().getConn();
            String sql = "DELETE FROM sales WHERE sales_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, salesId);
            int rowCount = pstmt.executeUpdate();
            isSuccess = rowCount > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return isSuccess;
    }

    // 매출 수정
    public boolean update(SalesDto dto) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean isSuccess = false;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                UPDATE sales
                SET branch_id = ?, totalamount = ?
                WHERE sales_id = ?
            """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dto.getBranchId());
            pstmt.setInt(2, dto.getTotalAmount());
            pstmt.setInt(3, dto.getSalesId());
            int rowCount = pstmt.executeUpdate();
            isSuccess = rowCount > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return isSuccess;
    }
    
    // 특정 sales_id로 매출 정보 가져오기
    public SalesDto getById(int salesId) {
        SalesDto dto = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                SELECT sales_id, branch_id,
                       TO_CHAR(createdAt, 'YYYY-MM-DD') AS createdAt,
                       totalamount
                FROM sales
                WHERE sales_id = ?
            """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, salesId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                dto = new SalesDto();
                dto.setSalesId(rs.getInt("sales_id"));
                dto.setBranchId(rs.getString("branch_id"));
                dto.setCreatedAt(rs.getString("createdAt"));
                dto.setTotalAmount(rs.getInt("totalamount"));
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
    // 지점별 매출 합계 + 지점명 조회
    public List<SalesSummaryDto> getBranchSalesSummary() {
        List<SalesSummaryDto> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                SELECT s.branch_id AS branch,
                       b.name AS branchName,
                       SUM(s.totalamount) AS totalAmount
                FROM sales s
                JOIN branches b ON s.branch_id = b.branch_id
                GROUP BY s.branch_id, b.name
                ORDER BY s.branch_id
            """;
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                SalesSummaryDto dto = new SalesSummaryDto();
                dto.setBranch(rs.getString("branch"));
                dto.setBranchName(rs.getString("branchName"));
                dto.setTotalAmount(rs.getInt("totalAmount"));
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return list;
    }
    // 날짜 + 지점별 매출 합계 조회
    public List<SalesSummaryDto> getDailyBranchSummary() {
        List<SalesSummaryDto> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                SELECT TO_CHAR(s.createdAt, 'YYYY-MM-DD') AS salesDate,
                       s.branch_id,
                       b.name AS branchName,
                       SUM(s.totalamount) AS totalAmount
                FROM sales s
                JOIN branches b ON s.branch_id = b.branch_id
                GROUP BY TO_CHAR(s.createdAt, 'YYYY-MM-DD'), s.branch_id, b.name
                ORDER BY salesDate DESC, s.branch_id
            """;
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                SalesSummaryDto dto = new SalesSummaryDto();
                dto.setSalesDate(rs.getString("salesDate"));
                dto.setBranch(rs.getString("branch_id"));
                dto.setBranchName(rs.getString("branchName"));
                dto.setTotalAmount(rs.getInt("totalAmount"));
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return list;
    }
}

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

    public boolean insert(SalesDto dto) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int flag = 0;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                INSERT INTO sales (sales_id, branch, created_at, totalamount)
                VALUES (sales_seq.NEXTVAL, ?, TO_DATE(?, 'YYYY-MM-DD'), ?)
                """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dto.getBranch());
            pstmt.setString(2, dto.getCreatedAt());
            pstmt.setInt(3, dto.getTotalAmount());
            flag = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {}
        }
        return flag > 0;
    }

    public List<SalesDto> getList() {
        List<SalesDto> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                SELECT sales_id, branch, TO_CHAR(created_at, 'YYYY-MM-DD') AS created_at, totalamount
                FROM sales
                ORDER BY sales_id DESC
                """;
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                SalesDto dto = new SalesDto();
                dto.setSalesId(rs.getInt("sales_id"));
                dto.setBranch(rs.getString("branch"));
                dto.setCreatedAt(rs.getString("created_at"));
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

    public SalesDto getData(int salesId) {
        SalesDto dto = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                SELECT sales_id, branch, TO_CHAR(created_at, 'YYYY-MM-DD') AS created_at, totalamount
                FROM sales
                WHERE sales_id = ?
                """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, salesId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                dto = new SalesDto();
                dto.setSalesId(rs.getInt("sales_id"));
                dto.setBranch(rs.getString("branch"));
                dto.setCreatedAt(rs.getString("created_at"));
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

    public boolean update(SalesDto dto) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int flag = 0;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                UPDATE sales
                SET branch = ?,
                    created_at = TO_DATE(?, 'YYYY-MM-DD'),
                    totalamount = ?
                WHERE sales_id = ?
                """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dto.getBranch());
            pstmt.setString(2, dto.getCreatedAt());
            pstmt.setInt(3, dto.getTotalAmount());
            pstmt.setInt(4, dto.getSalesId());
            flag = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {}
        }
        return flag > 0;
    }

    public boolean delete(int salesId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int flag = 0;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                DELETE FROM sales
                WHERE sales_id = ?
                """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, salesId);
            flag = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {}
        }
        return flag > 0;
    }

    public List<SalesSummaryDto> getBranchSalesSummary() {
        List<SalesSummaryDto> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                SELECT branch, SUM(totalamount) AS totalamount
                FROM sales
                GROUP BY branch
                ORDER BY branch ASC
                """;
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                SalesSummaryDto dto = new SalesSummaryDto();
                dto.setBranch(rs.getString("branch"));
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

    public List<SalesDto> getSalesByBranch(String branch) {
        List<SalesDto> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                SELECT sales_id, branch, TO_CHAR(created_at, 'YYYY-MM-DD') AS created_at, totalamount
                FROM sales
                WHERE branch = ?
                ORDER BY created_at DESC
                """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, branch);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                SalesDto dto = new SalesDto();
                dto.setSalesId(rs.getInt("sales_id"));
                dto.setBranch(rs.getString("branch"));
                dto.setCreatedAt(rs.getString("created_at"));
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
    // 이번 주 매출 합계
    public int getWeeklySales() {
        int total = 0;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                SELECT NVL(SUM(totalamount), 0) AS total
                FROM sales
                WHERE created_at >= TRUNC(SYSDATE, 'IW')
            """;
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (rs.next()) total = rs.getInt("total");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); if (pstmt != null) pstmt.close(); if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return total;
    }

    // 이번 달 매출 합계
    public int getMonthlySales() {
        int total = 0;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                SELECT NVL(SUM(totalamount), 0) AS total
                FROM sales
                WHERE created_at >= TRUNC(SYSDATE, 'MM')
            """;
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (rs.next()) total = rs.getInt("total");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); if (pstmt != null) pstmt.close(); if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return total;
    }
}

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

    /* ----------------------
       1. 매출 CRUD
    ---------------------- */

    // 매출 등록
    public boolean insert(SalesDto dto) {
        boolean isSuccess = false;
        String sql = """
            INSERT INTO sales (sales_id, branch_id, created_at, totalamount)
            VALUES (sales_seq.NEXTVAL, ?, SYSDATE, ?)
        """;
        try (Connection conn = new DbcpBean().getConn();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, dto.getBranchId());
            pstmt.setInt(2, dto.getTotalAmount());
            isSuccess = pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return isSuccess;
    }

    // 지점별 매출 목록
    public List<SalesDto> getList(String branchId) {
        List<SalesDto> list = new ArrayList<>();
        String sql = """
            SELECT sales_id, branch_id,
                   TO_CHAR(created_at, 'YYYY-MM-DD') AS created_at,
                   totalamount
            FROM sales
            WHERE branch_id = ?
            ORDER BY sales_id DESC
        """;
        try (Connection conn = new DbcpBean().getConn();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, branchId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    SalesDto dto = new SalesDto();
                    dto.setSalesId(rs.getInt("sales_id"));
                    dto.setBranchId(rs.getString("branch_id"));
                    dto.setCreated_at(rs.getString("created_at"));
                    dto.setTotalAmount(rs.getInt("totalamount"));
                    list.add(dto);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 매출 상세 조회
    public SalesDto getById(int salesId, String branchId) {
        SalesDto dto = null;
        String sql = """
            SELECT sales_id, branch_id,
                   TO_CHAR(created_at, 'YYYY-MM-DD') AS created_at,
                   totalamount
            FROM sales
            WHERE sales_id = ? AND branch_id = ?
        """;
        try (Connection conn = new DbcpBean().getConn();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, salesId);
            pstmt.setString(2, branchId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    dto = new SalesDto();
                    dto.setSalesId(rs.getInt("sales_id"));
                    dto.setBranchId(rs.getString("branch_id"));
                    dto.setCreated_at(rs.getString("created_at"));
                    dto.setTotalAmount(rs.getInt("totalamount"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return dto;
    }

    // 매출 수정
    public boolean update(SalesDto dto) {
        boolean isSuccess = false;
        String sql = """
            UPDATE sales
            SET totalamount = ?
            WHERE sales_id = ? AND branch_id = ?
        """;
        try (Connection conn = new DbcpBean().getConn();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, dto.getTotalAmount());
            pstmt.setInt(2, dto.getSalesId());
            pstmt.setString(3, dto.getBranchId());
            isSuccess = pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return isSuccess;
    }

    // 매출 삭제
    public boolean delete(int salesId, String branchId) {
        boolean isSuccess = false;
        String sql = "DELETE FROM sales WHERE sales_id = ? AND branch_id = ?";
        try (Connection conn = new DbcpBean().getConn();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, salesId);
            pstmt.setString(2, branchId);
            isSuccess = pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return isSuccess;
    }

    /* ----------------------
       2. 지점별 일자별 매출 요약
    ---------------------- */

    public List<SalesSummaryDto> getDailySummaryByBranch(String branchId) {
        List<SalesSummaryDto> list = new ArrayList<>();
        String sql = """
            SELECT TO_CHAR(created_at, 'YYYY-MM-DD') AS salesDate,
                   SUM(totalamount) AS totalAmount
            FROM sales
            WHERE branch_id = ?
            GROUP BY TO_CHAR(created_at, 'YYYY-MM-DD')
            ORDER BY salesDate DESC
        """;
        try (Connection conn = new DbcpBean().getConn();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, branchId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    SalesSummaryDto dto = new SalesSummaryDto();
                    dto.setSalesDate(rs.getString("salesDate"));
                    dto.setBranch(branchId);
                    dto.setTotalAmount(rs.getInt("totalAmount"));
                    list.add(dto);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}

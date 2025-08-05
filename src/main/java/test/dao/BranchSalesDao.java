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

    // 싱글톤 패턴 적용
    private static BranchSalesDao dao;
    static {
        dao = new BranchSalesDao();
    }
    private BranchSalesDao() {}
    public static BranchSalesDao getInstance() {
        return dao;
    }

    /**
     * 매출 등록
     * @param dto 지점ID, 매출금액 포함된 DTO
     * @return 성공 여부
     */
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
            pstmt.setString(1, dto.getBranchId());
            pstmt.setInt(2, dto.getTotalAmount());

            rowCount = pstmt.executeUpdate(); // insert 실행
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if(pstmt != null) pstmt.close();
                if(conn != null) conn.close();
            } catch(Exception e) {}
        }

        return rowCount > 0;
    }

    /**
     * 매출 상세 조회
     * @param salesId 매출 번호
     * @return BranchSalesDto (없으면 null)
     */
    public BranchSalesDto getData(int salesId) {
        BranchSalesDto dto = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = new DbcpBean().getConn();
            String sql = """
                SELECT *
                FROM sales
                WHERE sales_id=?
            """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, salesId);

            rs = pstmt.executeQuery();
            if(rs.next()) {
                dto = new BranchSalesDto();
                dto.setSalesId(rs.getInt("sales_id"));
                dto.setBranchId(rs.getString("branch_id"));
                dto.setCreated_at(rs.getString("created_at"));
                dto.setTotalAmount(rs.getInt("totalamount"));
            }
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
                if(conn != null) conn.close();
            } catch(Exception e) {}
        }
        return dto;
    }

    /**
     * 매출 수정
     * @param dto salesId, branchId, totalAmount 필요
     * @return 성공 여부
     */
    public boolean update(BranchSalesDto dto) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int rowCount = 0;

        try {
            conn = new DbcpBean().getConn();
            String sql = """
                UPDATE sales
                SET totalamount=?
                WHERE sales_id=? AND branch_id=?
            """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, dto.getTotalAmount());
            pstmt.setInt(2, dto.getSalesId());
            pstmt.setString(3, dto.getBranchId());

            rowCount = pstmt.executeUpdate();
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if(pstmt != null) pstmt.close();
                if(conn != null) conn.close();
            } catch(Exception e) {}
        }
        return rowCount > 0;
    }

    /**
     * 매출 삭제
     * @param salesId 매출번호
     * @return 성공 여부
     */
    public boolean delete(int salesId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int rowCount = 0;

        try {
            conn = new DbcpBean().getConn();
            String sql = """
                DELETE FROM sales
                WHERE sales_id=?
            """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, salesId);

            rowCount = pstmt.executeUpdate();
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if(pstmt != null) pstmt.close();
                if(conn != null) conn.close();
            } catch(Exception e) {}
        }
        return rowCount > 0;
    }

    /**
     * 지점 전체 매출 목록
     */
    public List<BranchSalesDto> getListByBranch(String branchId) {
        List<BranchSalesDto> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = new DbcpBean().getConn();
            String sql = """
                SELECT *
                FROM sales
                WHERE branch_id=?
                ORDER BY sales_id DESC
            """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, branchId);

            rs = pstmt.executeQuery();
            while(rs.next()) {
                BranchSalesDto dto = new BranchSalesDto();
                dto.setSalesId(rs.getInt("sales_id"));
                dto.setBranchId(rs.getString("branch_id"));
                dto.setCreated_at(rs.getString("created_at"));
                dto.setTotalAmount(rs.getInt("totalamount"));
                list.add(dto);
            }
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
                if(conn != null) conn.close();
            } catch(Exception e) {}
        }
        return list;
    }

    /**
     * 지점 기간별 매출 목록
     */
    public List<BranchSalesDto> getListByBranchAndPeriod(String branchId, String startDate, String endDate) {
        List<BranchSalesDto> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = new DbcpBean().getConn();
            StringBuilder sql = new StringBuilder("""
                SELECT *
                FROM sales
                WHERE branch_id=?
            """);
            if(startDate != null && !startDate.isEmpty()) sql.append(" AND created_at >= ? ");
            if(endDate != null && !endDate.isEmpty()) sql.append(" AND created_at <= ? ");
            sql.append(" ORDER BY sales_id DESC");

            pstmt = conn.prepareStatement(sql.toString());
            int idx = 1;
            pstmt.setString(idx++, branchId);
            if(startDate!=null && !startDate.isEmpty()) pstmt.setString(idx++, startDate);
            if(endDate!=null && !endDate.isEmpty()) pstmt.setString(idx++, endDate);

            rs = pstmt.executeQuery();
            while(rs.next()) {
                BranchSalesDto dto = new BranchSalesDto();
                dto.setSalesId(rs.getInt("sales_id"));
                dto.setBranchId(rs.getString("branch_id"));
                dto.setCreated_at(rs.getString("created_at"));
                dto.setTotalAmount(rs.getInt("totalamount"));
                list.add(dto);
            }
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
                if(conn != null) conn.close();
            } catch(Exception e) {}
        }
        return list;
    }

    /**
     * 지점 일별 매출 합계
     */
    public List<BranchSalesSummaryDto> getDailySalesByBranch(String branchId, String startDate, String endDate) {
        List<BranchSalesSummaryDto> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = new DbcpBean().getConn();
            StringBuilder sql = new StringBuilder("""
                SELECT created_at, SUM(totalamount) AS daily_total
                FROM sales
                WHERE branch_id=?
            """);
            if(startDate != null && !startDate.isEmpty()) sql.append(" AND created_at >= ? ");
            if(endDate != null && !endDate.isEmpty()) sql.append(" AND created_at <= ? ");
            sql.append(" GROUP BY created_at ORDER BY created_at DESC");

            pstmt = conn.prepareStatement(sql.toString());
            int idx = 1;
            pstmt.setString(idx++, branchId);
            if(startDate!=null && !startDate.isEmpty()) pstmt.setString(idx++, startDate);
            if(endDate!=null && !endDate.isEmpty()) pstmt.setString(idx++, endDate);

            rs = pstmt.executeQuery();
            while(rs.next()) {
                BranchSalesSummaryDto dto = new BranchSalesSummaryDto();
                dto.setSalesDate(rs.getString("created_at"));
                dto.setTotalAmount(rs.getInt("daily_total"));
                list.add(dto);
            }
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
                if(conn != null) conn.close();
            } catch(Exception e) {}
        }
        return list;
    }
}
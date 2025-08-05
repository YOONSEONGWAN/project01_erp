package dao.stock;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import dto.stock.OutboundOrdersDto;
import util.DbcpBean;

public class OutboundOrdersDao {
	
	private static OutboundOrdersDao dao;
	
	static {
		dao=new OutboundOrdersDao();
	}
	
	private OutboundOrdersDao() {}
	

	public static OutboundOrdersDao getInstance() {
		return dao;
	}
	
	// 전체 목록 조회
    public List<OutboundOrdersDto> selectAll() {
        List<OutboundOrdersDto> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = "SELECT order_id, branch_id, approval, out_date, manager FROM outbound_orders ORDER BY out_date DESC";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while(rs.next()) {
                OutboundOrdersDto dto = new OutboundOrdersDto();
                dto.setOrder_id(rs.getInt("order_id"));
                dto.setBranch_id(rs.getString("branch_id"));
                dto.setApproval(rs.getString("approval"));
                dto.setOut_date(rs.getString("out_date"));
                dto.setManager(rs.getString("manager"));
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

    // 최근 N건 조회
    public List<OutboundOrdersDto> selectLatest(int limit) {
        List<OutboundOrdersDto> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = "SELECT * FROM (SELECT order_id, branch_id, approval, out_date, manager FROM outbound_orders ORDER BY out_date DESC) WHERE ROWNUM <= ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, limit);
            rs = pstmt.executeQuery();
            while(rs.next()) {
                OutboundOrdersDto dto = new OutboundOrdersDto();
                dto.setOrder_id(rs.getInt("order_id"));
                dto.setBranch_id(rs.getString("branch_id"));
                dto.setApproval(rs.getString("approval"));
                dto.setOut_date(rs.getString("out_date"));
                dto.setManager(rs.getString("manager"));
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
    
    public List<OutboundOrdersDto> selectByApproval(String approval) {
        List<OutboundOrdersDto> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = "SELECT * FROM outbound_orders WHERE approval = ? ORDER BY out_date DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, approval);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                OutboundOrdersDto dto = new OutboundOrdersDto();
                dto.setOrder_id(rs.getInt("order_id"));
                dto.setBranch_id(rs.getString("branch_id"));
                dto.setApproval(rs.getString("approval"));
                dto.setOut_date(rs.getString("out_date"));
                dto.setManager(rs.getString("manager"));
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); if (pstmt != null) pstmt.close(); if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return list;
    }
    
    public List<OutboundOrdersDto> selectApprovedOrRejected(int limit) {
        List<OutboundOrdersDto> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = "SELECT * FROM outbound_orders WHERE approval IN ('승인', '반려') ORDER BY out_date DESC FETCH FIRST ? ROWS ONLY";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, limit);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                OutboundOrdersDto dto = new OutboundOrdersDto();
                dto.setOrder_id(rs.getInt("order_id"));
                dto.setBranch_id(rs.getString("branch_id"));
                dto.setApproval(rs.getString("approval"));
                dto.setOut_date(rs.getString("out_date"));
                dto.setManager(rs.getString("manager"));
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); if (pstmt != null) pstmt.close(); if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return list;
    }
    
 // 승인 or 반려된 출고 목록 (최근 N건)
    public List<OutboundOrdersDto> selectProcessed(int limit) {
        List<OutboundOrdersDto> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                    SELECT * FROM (
                        SELECT * FROM outbound_orders
                        WHERE approval IN ('승인', '반려')
                        ORDER BY out_date DESC
                    )
                    WHERE ROWNUM <= ?
                """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, limit);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                OutboundOrdersDto dto = new OutboundOrdersDto();
                dto.setOrder_id(rs.getInt("order_id"));
                dto.setBranch_id(rs.getString("branch_id"));
                dto.setApproval(rs.getString("approval"));
                dto.setOut_date(rs.getString("out_date"));
                dto.setManager(rs.getString("manager"));
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
    
    public boolean updateApproval(int orderId, String approval) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int flag = 0;
        try {
            conn = new DbcpBean().getConn();
            String sql = "UPDATE outbound_orders SET approval = ? WHERE branch_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, approval);
            pstmt.setInt(2, orderId);
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
    public OutboundOrdersDto select(int orderId) {
        OutboundOrdersDto dto = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = "SELECT * FROM outbound_orders WHERE branch_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, orderId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                dto = new OutboundOrdersDto();
                dto.setOrder_id(rs.getInt("order_id"));
                dto.setBranch_id(rs.getString("branch_id"));
                dto.setOut_date(rs.getString("out_date"));
                dto.setApproval(rs.getString("approval"));
                dto.setManager(rs.getString("manager"));
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
    public List<OutboundOrdersDto> selectProcessedWithKeyword(int limit) {
        List<OutboundOrdersDto> list = new ArrayList<>();
        String sql = """
            SELECT * FROM (
                SELECT order_id, branch_id, approval, TO_CHAR(out_date, 'YYYY-MM-DD') AS out_date, manager
                FROM outbound_orders
                WHERE approval IN ('승인', '완료')
                ORDER BY out_date DESC
            )
            WHERE ROWNUM <= ?
        """;

        try (Connection conn = new DbcpBean().getConn();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, limit);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    OutboundOrdersDto dto = new OutboundOrdersDto();
                    dto.setOrder_id(rs.getInt("order_id"));
                    dto.setBranch_id(rs.getString("branch_id"));
                    dto.setApproval(rs.getString("approval"));
                    dto.setOut_date(rs.getString("out_date"));
                    dto.setManager(rs.getString("manager"));
                    list.add(dto);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    public List<OutboundOrdersDto> selectByManagerWithPaging(String managerKeyword, int currentPage, int pageSize) {
        List<OutboundOrdersDto> list = new ArrayList<>();

        int start = (currentPage - 1) * pageSize + 1; // 시작 rownum
        int end = currentPage * pageSize;             // 끝 rownum

        String sql = """
            SELECT * FROM (
                SELECT inner_query.*, ROWNUM rnum FROM (
                    SELECT order_id, branch_id, approval, out_date, manager
                    FROM outbound_orders
                    WHERE manager LIKE ?
                    ORDER BY out_date DESC
                ) inner_query
                WHERE ROWNUM <= ?
            )
            WHERE rnum >= ?
            """;

        try (Connection conn = new DbcpBean().getConn();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, "%" + managerKeyword + "%");
            pstmt.setInt(2, end);   // ROWNUM <= ?
            pstmt.setInt(3, start); // rnum >= ?

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                OutboundOrdersDto dto = new OutboundOrdersDto();
                dto.setOrder_id(rs.getInt("order_id"));
                dto.setBranch_id(rs.getString("branch_id"));
                dto.setApproval(rs.getString("approval"));
                dto.setOut_date(rs.getString("out_date"));
                dto.setManager(rs.getString("manager"));

                list.add(dto);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    public int countByManager(String managerKeyword) {
        int count = 0;

        String sql = """
            SELECT COUNT(*)
            FROM outbound_orders
            WHERE manager LIKE ?
            """;

        try (Connection conn = new DbcpBean().getConn();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, "%" + managerKeyword + "%");

            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                count = rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return count;
    }
    
    public boolean insert(int orderId, String branchId, String approval, String outDate, String manager) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int flag = 0;
        try {
            conn = new DbcpBean().getConn();
            String sql = "INSERT INTO outbound_orders (order_id, branch_id, approval, out_date, manager) VALUES (?, ?, ?, TO_DATE(?, 'YYYY-MM-DD HH24:MI:SS'), ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, orderId);
            pstmt.setString(2, branchId);
            pstmt.setString(3, approval);
            pstmt.setString(4, outDate);
            pstmt.setString(5, manager);
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
}


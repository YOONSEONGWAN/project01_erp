package dao.stock;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import dto.stock.InboundOrdersDto;
import util.DbcpBean;

public class InboundOrdersDao {
	
	private static InboundOrdersDao dao;
	
	static {
		dao=new InboundOrdersDao();
	}
	
	private InboundOrdersDao() {}
	

	public static InboundOrdersDao getInstance() {
		return dao;
	}
	
	 // 전체 목록 조회
    public List<InboundOrdersDto> selectAll() {
        List<InboundOrdersDto> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = "SELECT order_id, branch_id, approval, in_date, manager FROM inbound_orders ORDER BY in_date DESC";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                InboundOrdersDto dto = new InboundOrdersDto();
                dto.setOrder_id(rs.getInt("order_id"));
                dto.setBranch_id(rs.getInt("branch_id"));
                dto.setApproval(rs.getString("approval"));
                dto.setIn_date(rs.getString("in_date"));
                dto.setManager(rs.getString("manager"));
                list.add(dto);
            }
        } catch (Exception e) {
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
    public List<InboundOrdersDto> selectLatest(int limit) {
        List<InboundOrdersDto> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = "SELECT * FROM (SELECT order_id, branch_id, approval, in_date, manager FROM inbound_orders ORDER BY in_date DESC) WHERE ROWNUM <= ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, limit);
            rs = pstmt.executeQuery();
            while(rs.next()) {
                InboundOrdersDto dto = new InboundOrdersDto();
                dto.setOrder_id(rs.getInt("order_id"));
                dto.setBranch_id(rs.getInt("branch_id"));
                dto.setApproval(rs.getString("approval"));
                dto.setIn_date(rs.getString("in_date"));
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
    
    public List<InboundOrdersDto> selectByApproval(String approval) {
        List<InboundOrdersDto> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = "SELECT * FROM inbound_orders WHERE approval = ? ORDER BY in_date DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, approval);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                InboundOrdersDto dto = new InboundOrdersDto();
                dto.setOrder_id(rs.getInt("order_id"));
                dto.setBranch_id(rs.getInt("branch_id"));
                dto.setApproval(rs.getString("approval"));
                dto.setIn_date(rs.getString("in_date"));
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
    
    public List<InboundOrdersDto> selectApprovedOrRejected(int limit) {
        List<InboundOrdersDto> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = "SELECT * FROM inbound_orders WHERE approval IN ('승인', '반려') ORDER BY in_date DESC FETCH FIRST ? ROWS ONLY";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, limit);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                InboundOrdersDto dto = new InboundOrdersDto();
                dto.setOrder_id(rs.getInt("order_id"));
                dto.setBranch_id(rs.getInt("branch_id"));
                dto.setApproval(rs.getString("approval"));
                dto.setIn_date(rs.getString("in_date"));
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
 // 승인 or 반려된 입고 목록 (최근 N건)
    public List<InboundOrdersDto> selectProcessed(int limit) {
        List<InboundOrdersDto> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                    SELECT * FROM (
                        SELECT * FROM inbound_orders
                        WHERE approval IN ('승인', '반려')
                        ORDER BY in_date DESC
                    )
                    WHERE ROWNUM <= ?
                """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, limit);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                InboundOrdersDto dto = new InboundOrdersDto();
                dto.setOrder_id(rs.getInt("order_id"));
                dto.setBranch_id(rs.getInt("branch_id"));
                dto.setApproval(rs.getString("approval"));
                dto.setIn_date(rs.getString("in_date"));
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
            String sql = "UPDATE inbound_orders SET approval = ? WHERE order_id = ?";
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
    public InboundOrdersDto select(int orderId) {
        InboundOrdersDto dto = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = "SELECT * FROM inbound_orders WHERE order_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, orderId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                dto = new InboundOrdersDto();
                dto.setOrder_id(rs.getInt("order_id"));
                dto.setBranch_id(rs.getInt("branch_id"));
                dto.setIn_date(rs.getString("in_date"));
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
    
    public void insert(int orderId, int branchId, String approval, String inDate, String manager) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = "INSERT INTO inbound_orders (order_id, branch_id, approval, in_date, manager) VALUES (?, ?, ?, TO_DATE(?, 'YYYY-MM-DD HH24:MI:SS'), ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, orderId);
            pstmt.setInt(2, branchId);
            pstmt.setString(3, approval);
            pstmt.setString(4, inDate);
            pstmt.setString(5, manager);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if(pstmt != null) pstmt.close();
                if(conn != null) conn.close();
            } catch(Exception e) {}
        }
    
    }


}
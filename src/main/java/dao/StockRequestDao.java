package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import dto.StockRequestDto;
import util.DbcpBean;

public class StockRequestDao {
    // 1. INSERT
    public boolean insertRequest(StockRequestDto dto) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int rowCount = 0;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                INSERT INTO stock_request 
                (order_id, branch_num, branch_id, inventory_id, product, current_quantity,
                 request_quantity, status, requestedat, updatedat, isPlaceOrder, Field)
                VALUES (stock_request_seq.NEXTVAL, ?, ?, ?, ?, ?, ?, ?, SYSDATE, SYSDATE, ?, ?)
            """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, dto.getBranchNum());           // FK (branch_stock의 PK)
            pstmt.setString(2, dto.getBranchId());
            pstmt.setInt(3, dto.getInventoryId());
            pstmt.setString(4, dto.getProduct());
            pstmt.setInt(5, dto.getCurrentQuantity());
            pstmt.setInt(6, dto.getRequestQuantity());
            pstmt.setString(7, dto.getStatus());
            pstmt.setString(8, dto.getIsPlaceOrder());
            pstmt.setString(9, dto.getField());
            rowCount = pstmt.executeUpdate();
        } catch(Exception e) { e.printStackTrace(); }
        finally {
            try { if(pstmt!=null) pstmt.close(); } catch(Exception e){}
            try { if(conn!=null) conn.close(); } catch(Exception e){}
        }
        return rowCount > 0;
    }

    // 2. 단일건 SELECT (order_id로)
    public StockRequestDto selectByOrderId(int orderId) {
        StockRequestDto dto = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = "SELECT * FROM stock_request WHERE order_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, orderId);
            rs = pstmt.executeQuery();
            if(rs.next()) {
                dto = new StockRequestDto();
                dto.setOrderId(rs.getInt("order_id"));
                dto.setBranchNum(rs.getInt("branch_num"));
                dto.setBranchId(rs.getString("branch_id"));
                dto.setInventoryId(rs.getInt("inventory_id"));
                dto.setProduct(rs.getString("product"));
                dto.setCurrentQuantity(rs.getInt("current_quantity"));
                dto.setRequestQuantity(rs.getInt("request_quantity"));
                dto.setStatus(rs.getString("status"));
                dto.setRequestedAt(rs.getDate("requestedat"));
                dto.setUpdatedAt(rs.getDate("updatedat"));
                dto.setIsPlaceOrder(rs.getString("isPlaceOrder"));
                dto.setField(rs.getString("field"));
            }
        } catch(Exception e) { e.printStackTrace(); }
        finally {
            try { if(rs!=null) rs.close(); } catch(Exception e){}
            try { if(pstmt!=null) pstmt.close(); } catch(Exception e){}
            try { if(conn!=null) conn.close(); } catch(Exception e){}
        }
        return dto;
    }

    // 3. 전체/지점별 SELECT
    public List<StockRequestDto> selectAllByBranch(String branchId) {
        List<StockRequestDto> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                SELECT * FROM stock_request
                WHERE branch_id = ?
                ORDER BY requestedat DESC
            """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, branchId);
            rs = pstmt.executeQuery();
            while(rs.next()) {
                StockRequestDto dto = new StockRequestDto();
                dto.setOrderId(rs.getInt("order_id"));
                dto.setBranchNum(rs.getInt("branch_num"));
                dto.setBranchId(rs.getString("branch_id"));
                dto.setInventoryId(rs.getInt("inventory_id"));
                dto.setProduct(rs.getString("product"));
                dto.setCurrentQuantity(rs.getInt("current_quantity"));
                dto.setRequestQuantity(rs.getInt("request_quantity"));
                dto.setStatus(rs.getString("status"));
                dto.setRequestedAt(rs.getDate("requestedat"));
                dto.setUpdatedAt(rs.getDate("updatedat"));
                dto.setIsPlaceOrder(rs.getString("isPlaceOrder"));
                dto.setField(rs.getString("field"));
                list.add(dto);
            }
        } catch(Exception e) { e.printStackTrace(); }
        finally {
            try { if(rs!=null) rs.close(); } catch(Exception e){}
            try { if(pstmt!=null) pstmt.close(); } catch(Exception e){}
            try { if(conn!=null) conn.close(); } catch(Exception e){}
        }
        return list;
    }

    // 4. UPDATE (주로 요청수량, 상품명만 바꿈. 필요시 파라미터/필드 더 추가 가능)
    public boolean updateRequest(int orderId, String product, int requestQuantity) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int rowCount = 0;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                UPDATE stock_request 
                   SET product=?, request_quantity=?, updatedat=SYSDATE 
                 WHERE order_id=?
            """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, product);
            pstmt.setInt(2, requestQuantity);
            pstmt.setInt(3, orderId);
            rowCount = pstmt.executeUpdate();
        } catch(Exception e) { e.printStackTrace(); }
        finally {
            try { if(pstmt!=null) pstmt.close(); } catch(Exception e){}
            try { if(conn!=null) conn.close(); } catch(Exception e){}
        }
        return rowCount > 0;
    }

    // 5. DELETE
    public boolean deleteRequest(int orderId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int rowCount = 0;
        try {
            conn = new DbcpBean().getConn();
            String sql = "DELETE FROM stock_request WHERE order_id=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, orderId);
            rowCount = pstmt.executeUpdate();
        } catch(Exception e) { e.printStackTrace(); }
        finally {
            try { if(pstmt!=null) pstmt.close(); } catch(Exception e){}
            try { if(conn!=null) conn.close(); } catch(Exception e){}
        }
        return rowCount > 0;
    }
}

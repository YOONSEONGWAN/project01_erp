package dao.stock;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import dto.stock.PlaceOrderHeadDto;
import util.DbcpBean;

public class PlaceOrderHeadDao {

    private static PlaceOrderHeadDao dao;

    static {
        dao = new PlaceOrderHeadDao();
    }

    private PlaceOrderHeadDao() {}

    public static PlaceOrderHeadDao getInstance() {
        return dao;
    }

    public int insert(String manager, int inventoryNum) {
        int orderId = 0;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = new DbcpBean().getConn();

            // 1. 시퀀스로 order_id 생성
            String seqSql = "SELECT placeOrder_head_seq.NEXTVAL AS order_id FROM dual";
            pstmt = conn.prepareStatement(seqSql);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                orderId = rs.getInt("order_id");
            }
            rs.close();
            pstmt.close();

            // 2. INSERT 수행
            String insertSql = """
                INSERT INTO placeOrder_head (order_id, inventory_num, order_date, manager)
                VALUES (?, ?, SYSDATE, ?)
            """;
            pstmt = conn.prepareStatement(insertSql);
            pstmt.setInt(1, orderId);
            pstmt.setInt(2, inventoryNum);
            pstmt.setString(3, manager);
            pstmt.executeUpdate();

        } catch (Exception e) {
            System.err.println("PlaceOrderHeadDao.insert() 오류 발생");
            e.printStackTrace();
            orderId = 0;  // 실패 시 0 반환
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {}
        }

        return orderId;
    }

    // 최근 10개 발주 내역
    public List<PlaceOrderHeadDto> getRecentOrders() {
        List<PlaceOrderHeadDto> list = new ArrayList<>();
        String sql = """
            SELECT * FROM (
                SELECT * FROM placeOrder_head ORDER BY order_date DESC
            ) WHERE ROWNUM <= 10
        """;
        try (
            Connection conn = new DbcpBean().getConn();
            PreparedStatement pstmt = conn.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery()
        ) {
            while (rs.next()) {
                PlaceOrderHeadDto dto = new PlaceOrderHeadDto();
                dto.setOrder_id(rs.getInt("order_id"));
                dto.setInventory_num(rs.getInt("inventory_num"));
                dto.setOrder_date(rs.getString("order_date"));
                dto.setManager(rs.getString("manager"));
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 전체 발주 내역
    public List<PlaceOrderHeadDto> getAllOrders() {
        List<PlaceOrderHeadDto> list = new ArrayList<>();
        String sql = "SELECT * FROM placeOrder_head ORDER BY order_date DESC";
        try (
            Connection conn = new DbcpBean().getConn();
            PreparedStatement pstmt = conn.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery()
        ) {
            while (rs.next()) {
                PlaceOrderHeadDto dto = new PlaceOrderHeadDto();
                dto.setOrder_id(rs.getInt("order_id"));
                dto.setInventory_num(rs.getInt("inventory_num"));
                dto.setOrder_date(rs.getString("order_date"));
                dto.setManager(rs.getString("manager"));
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // order_id 기준으로 발주일 조회
    public String getOrderDateByOrderId(int orderId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String orderDateStr = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = "SELECT TO_CHAR(order_date, 'YYYY-MM-DD HH24:MI:SS') AS order_date_str FROM placeOrder_head WHERE order_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, orderId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                orderDateStr = rs.getString("order_date_str");
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
        return orderDateStr;
    }
    
    public int countByManager(String manager) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int count = 0;

        try {
            conn = new DbcpBean().getConn();
            String sql = """
                SELECT COUNT(*) 
                FROM placeorder_head
                WHERE manager LIKE '%' || ? || '%'
            """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, manager);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }

        return count;
    }
    public List<PlaceOrderHeadDto> selectByManagerWithPaging(String manager, int startRow, int endRow) {
        List<PlaceOrderHeadDto> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = new DbcpBean().getConn();
            String sql = """
                SELECT * FROM (
                    SELECT inner_result.*, ROWNUM AS rnum
                    FROM (
                        SELECT order_id, order_date, manager
                        FROM placeorder_head
                        WHERE manager LIKE '%' || ? || '%'
                        ORDER BY order_id DESC
                    ) inner_result
                    WHERE ROWNUM <= ?
                )
                WHERE rnum >= ?
            """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, manager);
            pstmt.setInt(2, endRow);
            pstmt.setInt(3, startRow);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                PlaceOrderHeadDto dto = new PlaceOrderHeadDto();
                dto.setOrder_id(rs.getInt("order_id"));
                dto.setOrder_date(rs.getString("order_date"));
                dto.setManager(rs.getString("manager"));
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
	

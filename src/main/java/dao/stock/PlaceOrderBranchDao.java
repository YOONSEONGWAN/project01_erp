package dao.stock;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import dto.stock.PlaceOrderBranchDto;
import util.DbcpBean;

public class PlaceOrderBranchDao {
	
	private static PlaceOrderBranchDao dao;
	
	static {
		dao=new PlaceOrderBranchDao();
	}
	
	private PlaceOrderBranchDao() {}
	

	public static PlaceOrderBranchDao getInstance() {
		return dao;
	}
	
	public List<PlaceOrderBranchDto> getRecentOrders() {
	    List<PlaceOrderBranchDto> list = new ArrayList<>();
	    String sql = """
	        SELECT * FROM (
	            SELECT * FROM placeOrder_branch
	            ORDER BY order_id DESC
	        ) t
	        WHERE ROWNUM <= 10
	    """;

	    try (
	        Connection conn = new DbcpBean().getConn();
	        PreparedStatement pstmt = conn.prepareStatement(sql);
	        ResultSet rs = pstmt.executeQuery();
	    ) {
	        while (rs.next()) {
	            PlaceOrderBranchDto dto = new PlaceOrderBranchDto();
	            dto.setOrder_id(rs.getInt("order_id"));
	            dto.setDate(rs.getString("order_date"));  
	            dto.setManager(rs.getString("manager"));
	            list.add(dto);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}
	
	public List<PlaceOrderBranchDto> getAllOrders() {
	    List<PlaceOrderBranchDto> list = new ArrayList<>();
	    String sql = "SELECT * FROM placeOrder_branch ORDER BY order_date DESC";

	    try (
	        Connection conn = new DbcpBean().getConn();
	        PreparedStatement pstmt = conn.prepareStatement(sql);
	        ResultSet rs = pstmt.executeQuery();
	    ) {
	        while (rs.next()) {
	            PlaceOrderBranchDto dto = new PlaceOrderBranchDto();
	            dto.setOrder_id(rs.getInt("order_id"));
	            dto.setDate(rs.getString("order_date"));  
	            dto.setManager(rs.getString("manager"));
	            list.add(dto);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}
	
	public int insert(String manager) {
	    int orderId = 0;
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = new DbcpBean().getConn();

	        // 1단계: 시퀀스에서 NEXTVAL로 새 order_id 먼저 얻기
	        String seqSql = "SELECT placeOrder_branch_seq.NEXTVAL AS order_id FROM dual";
	        pstmt = conn.prepareStatement(seqSql);
	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            orderId = rs.getInt("order_id");
	        }
	        rs.close();
	        pstmt.close();

	        // 2단계: 위에서 얻은 orderId로 INSERT 실행
	        String insertSql = """
	            INSERT INTO placeOrder_branch (order_id, order_date, manager)
	            VALUES (?, SYSDATE, ?)
	        """;
	        pstmt = conn.prepareStatement(insertSql);
	        pstmt.setInt(1, orderId);
	        pstmt.setString(2, manager);
	        pstmt.executeUpdate();

	        

	    } catch (Exception e) {
	        e.printStackTrace();
	        try {
	            if (conn != null) conn.rollback();  // 예외 시 롤백
	        } catch (Exception e2) {
	            e2.printStackTrace();
	        }
	    } finally {
	        try {
	            if (rs != null) rs.close();
	            if (pstmt != null) pstmt.close();
	            if (conn != null) conn.close();
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }

	    return orderId;
	}
	
	public String getOrderDateByOrderId(int orderId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String orderDateStr = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = "SELECT TO_CHAR(order_date, 'YYYY-MM-DD HH24:MI:SS') AS order_date_str FROM placeOrder_branch WHERE order_id = ?";
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
	
	public int countByManager(String managerKeyword) {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    int count = 0;
	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
	            SELECT COUNT(*) FROM placeorder_branch
	            WHERE manager LIKE '%' || ? || '%'
	            """;
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, managerKeyword);
	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            count = rs.getInt(1);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        try { if (rs != null) rs.close(); } catch(Exception ign){}
	        try { if (pstmt != null) pstmt.close(); } catch(Exception ign){}
	        try { if (conn != null) conn.close(); } catch(Exception ign){}
	    }
	    return count;
	}

	public List<PlaceOrderBranchDto> selectByManagerWithPaging(String managerKeyword, int startRow, int endRow) {
	    List<PlaceOrderBranchDto> list = new ArrayList<>();
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    try {
	        conn = new DbcpBean().getConn();

	        String sql = """
	            SELECT * FROM (
	                SELECT tmp.*, ROWNUM rnum FROM (
	                    SELECT order_id, order_date, manager
	                    FROM placeorder_branch
	                    WHERE manager LIKE ?
	                    ORDER BY order_id DESC
	                ) tmp WHERE ROWNUM <= ?
	            ) WHERE rnum >= ?
	            """;

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, "%" + managerKeyword + "%");
	        pstmt.setInt(2, endRow);
	        pstmt.setInt(3, startRow);
	        
	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            PlaceOrderBranchDto dto = new PlaceOrderBranchDto();
	            dto.setOrder_id(rs.getInt("order_id"));
	            dto.setDate(rs.getString("order_date"));  // 필드명 order_date로 맞춤
	            dto.setManager(rs.getString("manager"));
	            list.add(dto);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        try { if (rs != null) rs.close(); } catch (Exception ign) {}
	        try { if (pstmt != null) pstmt.close(); } catch (Exception ign) {}
	        try { if (conn != null) conn.close(); } catch (Exception ign) {}
	    }
	    return list;
	}
}

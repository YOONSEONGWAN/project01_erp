package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import dto.StockRequestDto;
import util.DbcpBean;

public class StockRequestDao {
	
	
	private static StockRequestDao dao;
	
	static {
		dao=new StockRequestDao();
	}
	
	private StockRequestDao(){};
	
	public static StockRequestDao getInstance() {
		return dao;
	}
	
	public boolean batchInsertRequest(List<StockRequestDto> requests) {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    boolean isSuccess = true;
	    try {
	        conn = new DbcpBean().getConn();
	       
	        String sql = """
	            INSERT INTO stock_request 
	            (order_id, branch_num, branch_id, inventory_id, product, current_quantity,
	             request_quantity, status, requestedat, updatedat, isPlaceOrder)
	            VALUES (stock_request_seq.NEXTVAL, ?, ?, ?, ?, ?, ?, ?, SYSDATE, SYSDATE, ?)
	        """;
	        pstmt = conn.prepareStatement(sql);
	        for(StockRequestDto dto : requests) {
	            pstmt.setInt(1, dto.getBranchNum());
	            pstmt.setString(2, dto.getBranchId());
	            pstmt.setInt(3, dto.getInventoryId());
	            pstmt.setString(4, dto.getProduct());
	            pstmt.setInt(5, dto.getCurrentQuantity());
	            pstmt.setInt(6, dto.getRequestQuantity());
	            pstmt.setString(7, dto.getStatus());
	            pstmt.setString(8, dto.getIsPlaceOrder());
	            int result = pstmt.executeUpdate();
	            if(result == 0) {
	                isSuccess = false;
	                break;
	            }
	        }
	       
	    } catch(Exception e) {
	        e.printStackTrace();
	        isSuccess = false;
	        try { if(conn!=null) conn.rollback(); } catch(Exception ex) {}
	    } finally {
	        try { if(pstmt!=null) pstmt.close(); } catch(Exception e) {}
	        try { if(conn!=null) conn.close(); } catch(Exception e) {}
	    }
	    return isSuccess;
	}
	
	
	
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
	             request_quantity, status, requestedat, updatedat, isPlaceOrder)
	            VALUES (stock_request_seq.NEXTVAL, ?, ?, ?, ?, ?, ?, ?, SYSDATE, SYSDATE, ?)
	        """;
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, dto.getBranchNum());
	        pstmt.setString(2, dto.getBranchId());
	        pstmt.setInt(3, dto.getInventoryId());
	        pstmt.setString(4, dto.getProduct());
	        pstmt.setInt(5, dto.getCurrentQuantity());
	        pstmt.setInt(6, dto.getRequestQuantity());
	        pstmt.setString(7, dto.getStatus());
	        pstmt.setString(8, dto.getIsPlaceOrder());
	        
	        rowCount = pstmt.executeUpdate();
	    } catch(Exception e) { 
	        e.printStackTrace(); 
	    } finally {
	        try { if(pstmt != null) pstmt.close(); } catch(Exception e) {}
	        try { if(conn != null) conn.close(); } catch(Exception e) {}
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
                SELECT 
                    r.order_id,
                    r.branch_num,
                    r.branch_id,
                    r.inventory_id,
                    b.product,                 
                    b.current_quantity,        
                    r.request_quantity,
                    r.status,
                    r.requestedat,
                    r.updatedat,
                    r.isPlaceOrder

                FROM stock_request r
                JOIN branch_stock b ON r.branch_num = b.branch_num
                WHERE r.branch_id = ?
                ORDER BY r.requestedat DESC
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
                dto.setProduct(rs.getString("product")); // branch_stock 기준!
                dto.setCurrentQuantity(rs.getInt("current_quantity")); // branch_stock 기준!
                dto.setRequestQuantity(rs.getInt("request_quantity"));
                dto.setStatus(rs.getString("status"));
                dto.setRequestedAt(rs.getDate("requestedat"));
                dto.setUpdatedAt(rs.getDate("updatedat"));
                dto.setIsPlaceOrder(rs.getString("isPlaceOrder"));
                
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
    

    public List<StockRequestDto> selectAll() {
        List<StockRequestDto> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = new DbcpBean().getConn();

            String sql = """
                SELECT order_id, branch_num, branch_id, inventory_id, 
                    product, current_quantity, request_quantity, status, 
                    requestedat, updatedat, isPlaceOrder
                FROM stock_request
                ORDER BY order_id DESC
                """;

            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
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
    
    public String getProductByNum(int orderId) {
        String product = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                SELECT product
                  FROM stock_request
                 WHERE order_id = ?
            """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, orderId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                product = rs.getString("product");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return product;
    }

    public int getQuantityByNum(int num) {
        int result = 0;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                SELECT request_quantity
                  FROM stock_request
                 WHERE order_id = ?
            """;
            ps = conn.prepareStatement(sql);
            ps.setInt(1, num);
            rs = ps.executeQuery();
            if (rs.next()) result = rs.getInt("request_quantity");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return result;
    }

    public String getBranchIdByNum(int num) {
        String branchId = null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                SELECT branch_id
                  FROM stock_request
                 WHERE order_id = ?
            """;
            ps = conn.prepareStatement(sql);
            ps.setInt(1, num);
            rs = ps.executeQuery();
            if (rs.next()) branchId = rs.getString("branch_id");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return branchId;
    }

    public int getInventoryIdByNum(int num) {
        int inventoryId = 0;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                SELECT inventory_id
                  FROM stock_request
                 WHERE order_id = ?
            """;
            ps = conn.prepareStatement(sql);
            ps.setInt(1, num);
            rs = ps.executeQuery();
            if (rs.next()) inventoryId = rs.getInt("inventory_id");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return inventoryId;
    }

    public void updateApproval(int num, String status) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                UPDATE stock_request
                   SET approval = ?
                 WHERE order_id = ?
            """;
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, num);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }

    public void updatePlaceOrder(int num, boolean isPlaceOrder) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                UPDATE stock_request
                   SET is_placeorder = ?
                 WHERE order_id = ?
            """;
            ps = conn.prepareStatement(sql);
            ps.setString(1, isPlaceOrder ? "승인" : "대기");
            ps.setInt(2, num);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }

    public void updateDate(int num) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                UPDATE stock_request
                   SET updatedAt = SYSDATE
                 WHERE order_id = ?
            """;
            ps = conn.prepareStatement(sql);
            ps.setInt(1, num);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }

    public void update(int num, String isPlaceOrder) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                UPDATE stock_request
                   SET is_placeorder = ?
                 WHERE order_id = ?
            """;
            ps = conn.prepareStatement(sql);
            ps.setString(1, isPlaceOrder);
            ps.setInt(2, num);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }

    public void updateStatus(int num, String status) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                UPDATE stock_request
                   SET status = ?, updatedAt = SYSDATE
                 WHERE order_id = ?
            """;
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, num);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
    
    public void updateIsPlaceOrder(int num, String value) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                UPDATE stock_request
                   SET isplaceorder = ?
                 WHERE order_id = ?
            """;
            ps = conn.prepareStatement(sql);
            ps.setString(1, value);
            ps.setInt(2, num);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
    
    public int getNumByDetailId(int detailId) {
        int result = -1;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                SELECT request_num
                  FROM stock_request
                 WHERE detail_id = ?
            """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, detailId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                result = rs.getInt("request_num");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return result;
    }

    /**
     * 승인 수량 감소 (예: 반려 처리 시 기존 승인 수량 복원)
     */
    public void decreaseCurrentQuantity(int requestNum, int qty) {
        updateCurrentQuantity(requestNum, -qty);
    }

    

    /**
     * 승인 수량 조정 (예: 승인 상태에서 수량 변경 시)
     */
    public void adjustCurrentQuantity(int requestNum, int diffQty) {
        updateCurrentQuantity(requestNum, diffQty);
    }

    /**
     * 내부 메소드: current_quantity 값 ±변경
     */
    private void updateCurrentQuantity(int requestNum, int qtyDiff) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                UPDATE stock_request
                   SET current_quantity = current_quantity + ?
                 WHERE request_num = ?
            """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, qtyDiff);
            pstmt.setInt(2, requestNum);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
    
 // product 가져오기
    public String getProductByOrderId(int orderId) throws SQLException {
        String sql = "SELECT product FROM stock_request WHERE order_id = ?";
        try (Connection conn = new DbcpBean().getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("product");
            }
            return null;
        }
    }

    // current_quantity 가져오기
    public int getQuantityByOrderId(int orderId) throws SQLException {
        String sql = "SELECT current_quantity FROM stock_request WHERE order_id = ?";
        try (Connection conn = new DbcpBean().getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("current_quantity");
            }
            return 0;
        }
    }

    // branch_id 가져오기
    public String getBranchIdByOrderId(int orderId) throws SQLException {
        String sql = "SELECT branch_id FROM stock_request WHERE order_id = ?";
        try (Connection conn = new DbcpBean().getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("branch_id");
            }
            return null;
        }
    
    
    }
    
    public int getRequestQuantityByOrderId(int orderId) {
        String sql = "SELECT request_quantity FROM stock_request WHERE order_id = ?";
        int qty = 0;

        try (Connection conn = new DbcpBean().getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    qty = rs.getInt("request_quantity");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return qty;
    }
    
    public boolean increaseCurrentQuantity(int requestNum, int quantity) {
        boolean isSuccess = false;
        String sql = """
            UPDATE inventory
            SET quantity = quantity + ?
            WHERE num = (SELECT inventory_id FROM stock_request WHERE order_id = ?)
        """;

        try (Connection conn = new DbcpBean().getConn();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, quantity);
            pstmt.setInt(2, requestNum);

            int result = pstmt.executeUpdate();
            if (result > 0) {
                isSuccess = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return isSuccess;
    }
    
}
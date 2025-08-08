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
   
   // 1. selectAllByBranch
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
           try { if (rs != null) rs.close(); } catch (Exception e) {}
           try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
           try { if (conn != null) conn.close(); } catch (Exception e) {}
       }
       
       return list;
   }

   // 2. batchInsertRequest
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

           for (StockRequestDto dto : requests) {
               pstmt.setInt(1, dto.getBranchNum());
               pstmt.setString(2, dto.getBranchId());
               pstmt.setInt(3, dto.getInventoryId());
               pstmt.setString(4, dto.getProduct());
               pstmt.setInt(5, dto.getCurrentQuantity());
               pstmt.setInt(6, dto.getRequestQuantity());
               pstmt.setString(7, dto.getStatus());
               pstmt.setString(8, dto.getIsPlaceOrder());
               int result = pstmt.executeUpdate();
               if (result == 0) {
                   isSuccess = false;
                   break;
               }
           }
       } catch (Exception e) {
           e.printStackTrace();
           isSuccess = false;
       } finally {
           try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
           try { if (conn != null) conn.close(); } catch (Exception e) {}
       }

       return isSuccess;
   }

   // 3. selectByOrderId
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

           if (rs.next()) {
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
       } catch (Exception e) {
           e.printStackTrace();
       } finally {
           try { if (rs != null) rs.close(); } catch (Exception e) {}
           try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
           try { if (conn != null) conn.close(); } catch (Exception e) {}
       }

       return dto;
   }

   // 4. updateRequest
   public boolean updateRequest(int orderId, String product, int requestQuantity) {
       Connection conn = null;
       PreparedStatement pstmt = null;
       int rowCount = 0;

       try {
           conn = new DbcpBean().getConn();
           String sql = """
               UPDATE stock_request 
               SET product = ?, request_quantity = ?, updatedat = SYSDATE 
               WHERE order_id = ?
           """;
           pstmt = conn.prepareStatement(sql);
           pstmt.setString(1, product);
           pstmt.setInt(2, requestQuantity);
           pstmt.setInt(3, orderId);
           rowCount = pstmt.executeUpdate();
       } catch (Exception e) {
           e.printStackTrace();
       } finally {
           try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
           try { if (conn != null) conn.close(); } catch (Exception e) {}
       }

       return rowCount > 0;
   }

   // 5. deleteRequest
   public boolean deleteRequest(int orderId) {
       Connection conn = null;
       PreparedStatement pstmt = null;
       int rowCount = 0;

       try {
           conn = new DbcpBean().getConn();
           String sql = "DELETE FROM stock_request WHERE order_id = ?";
           pstmt = conn.prepareStatement(sql);
           pstmt.setInt(1, orderId);
           rowCount = pstmt.executeUpdate();
       } catch (Exception e) {
           e.printStackTrace();
       } finally {
           try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
           try { if (conn != null) conn.close(); } catch (Exception e) {}
       }

       return rowCount > 0;
   }

   // 6. getRequestQuantityByOrderId
   public int getRequestQuantityByOrderId(int orderId) {
       int qty = 0;
       Connection conn = null;
       PreparedStatement pstmt = null;
       ResultSet rs = null;

       try {
           conn = new DbcpBean().getConn();
           String sql = "SELECT request_quantity FROM stock_request WHERE order_id = ?";
           pstmt = conn.prepareStatement(sql);
           pstmt.setInt(1, orderId);
           rs = pstmt.executeQuery();
           if (rs.next()) {
               qty = rs.getInt("request_quantity");
           }
       } catch (Exception e) {
           e.printStackTrace();
       } finally {
           try { if (rs != null) rs.close(); } catch (Exception e) {}
           try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
           try { if (conn != null) conn.close(); } catch (Exception e) {}
       }

       return qty;
   }

   // 7. getProductByOrderId
   public String getProductByOrderId(int orderId) {
       String product = null;
       Connection conn = null;
       PreparedStatement pstmt = null;
       ResultSet rs = null;

       try {
           conn = new DbcpBean().getConn();
           String sql = "SELECT product FROM stock_request WHERE order_id = ?";
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
   // 8. getBranchIdByOrderId
   public String getBranchIdByOrderId(int orderId) {
       String branchId = null;
       Connection conn = null;
       PreparedStatement pstmt = null;
       ResultSet rs = null;

       try {
           conn = new DbcpBean().getConn();
           String sql = "SELECT branch_id FROM stock_request WHERE order_id = ?";
           pstmt = conn.prepareStatement(sql);
           pstmt.setInt(1, orderId);
           rs = pstmt.executeQuery();
           if (rs.next()) {
               branchId = rs.getString("branch_id");
           }
       } catch (Exception e) {
           e.printStackTrace();
       } finally {
           try { if (rs != null) rs.close(); } catch (Exception e) {}
           try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
           try { if (conn != null) conn.close(); } catch (Exception e) {}
       }

       return branchId;
   }

   // 9. getBranchNumByOrderId
   public int getBranchNumByOrderId(int orderId) {
       int branchNum = 0;
       Connection conn = null;
       PreparedStatement pstmt = null;
       ResultSet rs = null;

       try {
           conn = new DbcpBean().getConn();
           String sql = "SELECT branch_num FROM stock_request WHERE order_id = ?";
           pstmt = conn.prepareStatement(sql);
           pstmt.setInt(1, orderId);
           rs = pstmt.executeQuery();
           if (rs.next()) {
               branchNum = rs.getInt("branch_num");
           }
       } catch (Exception e) {
           e.printStackTrace();
       } finally {
           try { if (rs != null) rs.close(); } catch (Exception e) {}
           try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
           try { if (conn != null) conn.close(); } catch (Exception e) {}
       }

       return branchNum;
   }

   // 10. updateStatusAndPlaceOrder
   public boolean updateStatusAndPlaceOrder(int orderId, String status, String isPlaceOrder) {
       int rowCount = 0;
       Connection conn = null;
       PreparedStatement pstmt = null;

       try {
           conn = new DbcpBean().getConn();
           String sql = """
               UPDATE stock_request 
               SET status = ?, isPlaceOrder = ?, updatedat = SYSDATE 
               WHERE order_id = ?
           """;
           pstmt = conn.prepareStatement(sql);
           pstmt.setString(1, status);
           pstmt.setString(2, isPlaceOrder);
           pstmt.setInt(3, orderId);
           rowCount = pstmt.executeUpdate();
       } catch (Exception e) {
           e.printStackTrace();
       } finally {
           try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
           try { if (conn != null) conn.close(); } catch (Exception e) {}
       }

       return rowCount > 0;
   }

   // 11. getStatusByOrderId
   public String getStatusByOrderId(int orderId) {
       String status = null;
       Connection conn = null;
       PreparedStatement pstmt = null;
       ResultSet rs = null;

       try {
           conn = new DbcpBean().getConn();
           String sql = "SELECT status FROM stock_request WHERE order_id = ?";
           pstmt = conn.prepareStatement(sql);
           pstmt.setInt(1, orderId);
           rs = pstmt.executeQuery();
           if (rs.next()) {
               status = rs.getString("status");
           }
       } catch (Exception e) {
           e.printStackTrace();
       } finally {
           try { if (rs != null) rs.close(); } catch (Exception e) {}
           try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
           try { if (conn != null) conn.close(); } catch (Exception e) {}
       }

       return status;
   }

   // 12. getRequestIdByOrderId
   public int getRequestIdByOrderId(int orderId) {
       int requestId = 0;
       Connection conn = null;
       PreparedStatement pstmt = null;
       ResultSet rs = null;

       try {
           conn = new DbcpBean().getConn();
           String sql = "SELECT order_id FROM stock_request WHERE order_id = ?";
           pstmt = conn.prepareStatement(sql);
           pstmt.setInt(1, orderId);
           rs = pstmt.executeQuery();
           if (rs.next()) {
               requestId = rs.getInt("order_id");
           }
       } catch (Exception e) {
           e.printStackTrace();
       } finally {
           try { if (rs != null) rs.close(); } catch (Exception e) {}
           try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
           try { if (conn != null) conn.close(); } catch (Exception e) {}
       }

       return requestId;
   }

   // 13. getIsPlaceOrderByOrderId
   public String getIsPlaceOrderByOrderId(int orderId) {
       String result = null;
       Connection conn = null;
       PreparedStatement pstmt = null;
       ResultSet rs = null;

       try {
           conn = new DbcpBean().getConn();
           String sql = "SELECT isPlaceOrder FROM stock_request WHERE order_id = ?";
           pstmt = conn.prepareStatement(sql);
           pstmt.setInt(1, orderId);
           rs = pstmt.executeQuery();
           if (rs.next()) {
               result = rs.getString("isPlaceOrder");
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

   // 14. updateStatusOnly
   public boolean updateStatusOnly(int orderId, String status) {
       int rowCount = 0;
       Connection conn = null;
       PreparedStatement pstmt = null;

       try {
           conn = new DbcpBean().getConn();
           String sql = """
               UPDATE stock_request 
               SET status = ?, updatedat = SYSDATE 
               WHERE order_id = ?
           """;
           pstmt = conn.prepareStatement(sql);
           pstmt.setString(1, status);
           pstmt.setInt(2, orderId);
           rowCount = pstmt.executeUpdate();
       } catch (Exception e) {
           e.printStackTrace();
       } finally {
           try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
           try { if (conn != null) conn.close(); } catch (Exception e) {}
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
   public boolean updateStatusByOrderId(int orderId, String newStatus) {
       Connection conn = null;
       PreparedStatement pstmt = null;
       boolean result = false;

       String sql = """
           UPDATE stock_request
           SET status = ?
           WHERE order_id = ?
       """;

       try {
           conn = new DbcpBean().getConn();
           pstmt = conn.prepareStatement(sql);

           pstmt.setString(1, newStatus);
           pstmt.setInt(2, orderId);

           int updated = pstmt.executeUpdate();
           

           result = updated > 0;

       } catch (Exception e) {
           e.printStackTrace();
       } finally {
           try {
               if (pstmt != null) pstmt.close();
               if (conn != null) conn.close();
           } catch (Exception e) {}
       }

       return result;
   }
   
   public int getQuantityByOrderId(int orderId) {
       int currentQty = 0;

       Connection conn = null;
       PreparedStatement pstmt = null;
       ResultSet rs = null;

       try {
          conn = new DbcpBean().getConn();
           String sql = "SELECT current_quantity FROM stock_request WHERE order_id = ?";
           pstmt = conn.prepareStatement(sql);
           pstmt.setInt(1, orderId);
           rs = pstmt.executeQuery();

           if (rs.next()) {
               currentQty = rs.getInt("current_quantity");
           }

       } catch (Exception e) {
           e.printStackTrace();
       } finally {
           try {
               if (rs != null) rs.close();
               if (pstmt != null) pstmt.close();
               if (conn != null) conn.close();
           } catch (Exception e) {
               
           }
       }

       return currentQty;
   }
   public int getInventoryIdByOrderId(int orderId) {
	    String sql = "SELECT inventory_id FROM stock_request WHERE order_id = ?";
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    int inventoryId = 0;

	    try {
	        conn = new DbcpBean().getConn();
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, orderId);
	        rs = pstmt.executeQuery();

	        if (rs.next()) {
	            inventoryId = rs.getInt("inventory_id");
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        try {
	            if (rs != null) rs.close();
	            if (pstmt != null) pstmt.close();
	            if (conn != null) conn.close();
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }

	    return inventoryId;
	}
   public void updateStatus(int num, String status) {
       Connection conn = null;
       PreparedStatement ps = null;
        String sql = """
               UPDATE stock_request
                  SET status = ?, updatedAt = SYSDATE
                WHERE order_id = ?
           """;
       try {
           conn = new DbcpBean().getConn();
          
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
   public void updateDate(int num) {
       Connection conn = null;
       PreparedStatement ps = null;
       String sql = """
               UPDATE stock_request
                  SET updatedAt = SYSDATE
                WHERE order_id = ?
           """;
       try {
           conn = new DbcpBean().getConn();
           
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
   public void updateIsPlaceOrder(int num, String value) {
       Connection conn = null;
       PreparedStatement ps = null;
       String sql = """
               UPDATE stock_request
                  SET isplaceorder = ?
                WHERE order_id = ?
           """;
       try {
           conn = new DbcpBean().getConn();
           
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
}
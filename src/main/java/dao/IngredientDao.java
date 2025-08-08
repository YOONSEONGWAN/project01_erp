package dao;

import java.sql.*;
import java.util.*;
import dto.IngredientDto;
import dto.StockRequestDto;
import util.DbcpBean;

public class IngredientDao {
	
	private static IngredientDao dao;
	
	static {
		dao=new IngredientDao();
	}
	
	private IngredientDao() {};
	
	public static IngredientDao getInstance() {
		return dao;
	}
	

	public List<IngredientDto> selectAllProducts() {
	    List<IngredientDto> list = new ArrayList<>();
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String sql = """
        		
    			SELECT DISTINCT product, branch_num, branch_id, inventory_id, current_quantity 
    		     FROM branch_stock ORDER BY product""";
	    try {
	        conn = new DbcpBean().getConn();
	        
	        pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();
	        while(rs.next()) {
	            IngredientDto dto = new IngredientDto();
	            dto.setProduct(rs.getString("product"));
	            dto.setBranchNum(rs.getInt("branch_num"));
	            dto.setBranchId(rs.getString("branch_id"));
	            dto.setInventoryId(rs.getInt("inventory_id"));
	            dto.setCurrentQuantity(rs.getInt("current_quantity"));
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
	
	
	
	
	
	  // 여러건 한번에 발주 요청 등록 (트랜잭션 적용)
    public boolean requestStock(List<StockRequestDto> requests) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean isSuccess = true;
        String sql = """
                INSERT INTO stock_request 
                (order_id, branch_num, branch_id, inventory_id, product, current_quantity,
                 request_quantity, status, requestedat, updatedat, isPlaceOrder)
                VALUES (stock_request_seq.NEXTVAL, ?, ?, ?, ?, ?, ?, ?, SYSDATE, SYSDATE, ?)
            """;
        try {
            conn = new DbcpBean().getConn();
            conn.setAutoCommit(false); // 트랜잭션 시작

            
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

            if(isSuccess) {
                conn.commit();
            } else {
                conn.rollback();
            }
        } catch(Exception e) {
            e.printStackTrace();
            isSuccess = false;
            try { if(conn != null) conn.rollback(); } catch(Exception ex) {}
        } finally {
            try { if(pstmt != null) pstmt.close(); } catch(Exception e) {}
            try { if(conn != null) conn.close(); } catch(Exception e) {}
        }
        return isSuccess;
    }

	
	
    public List<IngredientDto> selectAll(String branchId) {
        List<IngredientDto> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = """ 
                SELECT branch_num, inventory_id, product, current_quantity, updatedat
                  FROM branch_stock
                 WHERE branch_id = ?
                 ORDER BY product
            """;
        try {
            conn = new DbcpBean().getConn();
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, branchId);
            rs = pstmt.executeQuery();
            while(rs.next()) {
                IngredientDto dto = new IngredientDto();
                dto.setBranchNum(rs.getInt("branch_num"));           // 추가
                dto.setInventoryId(rs.getInt("inventory_id"));
                dto.setProduct(rs.getString("product"));
                dto.setCurrentQuantity(rs.getInt("current_quantity"));
                dto.setBranchId(branchId);
                dto.setUpdatedAt(rs.getDate("updatedat"));           // 추가
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
    public boolean increaseQuantity(String branchId, int inventoryId, int quantity) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        String sql = "UPDATE branch_stock SET current_quantity = current_quantity + ? WHERE branch_id = ? AND inventory_id = ?";
        try {
            conn = new DbcpBean().getConn();
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, quantity);
            pstmt.setString(2, branchId);
            pstmt.setInt(3, inventoryId);
            int updated = pstmt.executeUpdate();

           

            return updated > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return false;
    }

    public int getNumByProduct(String product) {
        int num = -1;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT num FROM ingredient WHERE product = ?";
        try {
            conn = new DbcpBean().getConn();
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, product);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                num = rs.getInt("num");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return num;
    }

    public boolean updateQuantityByApproval(int productNum, int oldQty, int newQty, String oldStatus, String newStatus, int currentQty) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        String sql = "UPDATE branch_stock SET current_quantity = current_quantity + ? WHERE product_num = ?";
        boolean isSuccess = false;
        try {
            conn = new DbcpBean().getConn();

            int diffQty = 0;

            if ("승인".equals(oldStatus) && "승인".equals(newStatus)) {
                diffQty = newQty - oldQty;
            } else if ("승인".equals(oldStatus) && !"승인".equals(newStatus)) {
                diffQty = -oldQty;
            } else if (!"승인".equals(oldStatus) && "승인".equals(newStatus)) {
                diffQty = newQty;
            } else {
                diffQty = 0;
            }

            if (diffQty != 0) {
                
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, diffQty * -1);
                pstmt.setInt(2, productNum);
                int affected = pstmt.executeUpdate();
                if (affected == 0) {
                    return false;
                }
            }
            isSuccess = true;

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return isSuccess;
    }

    public boolean decreaseQuantity(String branchId, int inventoryId, int quantity) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        String sql = "UPDATE branch_stock SET current_quantity = current_quantity - ? WHERE branch_id = ? AND inventory_id = ?";
        try {
            conn = new DbcpBean().getConn();
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, quantity);
            pstmt.setString(2, branchId);
            pstmt.setInt(3, inventoryId);
            int updated = pstmt.executeUpdate();

            return updated > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return false;
    }


    public void adjustQuantity(String branchId, int inventoryId, int diff) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        String sql = """
                UPDATE branch_stock
                   SET current_quantity = current_quantity + ?
                 WHERE branch_id = ?
                   AND inventory_id = ?
            """;
        try {
            conn = new DbcpBean().getConn();
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, diff);
            pstmt.setString(2, branchId);
            pstmt.setInt(3, inventoryId);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            throw e;  // SQLException 던짐 유지
        } finally {
            try {
                if (pstmt != null) pstmt.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
            try {
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

	public boolean increaseCurrentQuantity2(String branchId, int inventoryId, int qty) {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    boolean result = false;
	
	    String sql = """
	        UPDATE branch_stock 
	        SET current_quantity = current_quantity + ? 
	        WHERE branch_id = ? AND inventory_id = ?
	        """;
	
	    try {
	        conn = new DbcpBean().getConn();
	        
	
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, qty);
	        pstmt.setString(2, branchId);
	        pstmt.setInt(3, inventoryId);
	
	        
	        
	        int affected = pstmt.executeUpdate();
	        
	
	        result = affected > 0;
	
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
	
	public boolean decreaseCurrentQuantity2(String branchId, int inventoryId, int qty) {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    boolean result = false;
	
	    String sql = """
	        UPDATE branch_stock 
	        SET current_quantity = current_quantity - ? 
	        WHERE branch_id = ? AND inventory_id = ? AND current_quantity >= ?
	        """;
	
	    try {
	        conn = new DbcpBean().getConn();
	        
	
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, qty);
	        pstmt.setString(2, branchId);
	        pstmt.setInt(3, inventoryId);
	        pstmt.setInt(4, qty);
	
	        
	
	        int affected = pstmt.executeUpdate();
	        
	
	        result = affected > 0;
	
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
}


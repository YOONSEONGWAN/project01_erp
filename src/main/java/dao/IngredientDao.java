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
	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
	        		
	        			SELECT DISTINCT product, branch_num, branch_id, inventory_id, current_quantity 
	        		     FROM branch_stock ORDER BY product""";
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
	
	
	
	
	//추가됨 
	  // 여러건 한번에 발주 요청 등록 (트랜잭션 적용)
    public boolean requestStock(List<StockRequestDto> requests) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean isSuccess = true;
        try {
            conn = new DbcpBean().getConn();
            conn.setAutoCommit(false); // 트랜잭션 시작

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
        try {
            conn = new DbcpBean().getConn();
            String sql = """ 
                SELECT branch_num, inventory_id, product, current_quantity, updatedat
                  FROM branch_stock
                 WHERE branch_id = ?
                 ORDER BY product
            """;
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
    public void increaseQuantity(String branchId, int inventoryId, int amount) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                UPDATE branch_stock
                SET current_quantity = current_quantity + ?
                WHERE branch_id = ? AND inventory_id = ?
            """;
            ps = conn.prepareStatement(sql);
            ps.setInt(1, amount);
            ps.setString(2, branchId);
            ps.setInt(3, inventoryId);
            ps.executeUpdate();
        } catch(Exception e) {
            e.printStackTrace();
            // 필요하면 throw e; 추가
        } finally {
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(conn != null) conn.close(); } catch(Exception e) {}
        }
    }
    
    public int getNumByProduct(String product) {
        int num = -1;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = "SELECT num FROM ingredient WHERE product = ?";
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
        boolean isSuccess = false;
        try {
            conn = new DbcpBean().getConn();
            // conn.setAutoCommit(false); // 오토커밋 제거

            int diffQty = 0;

            // 승인에서 승인: 수량 차이만큼 조정
            if ("승인".equals(oldStatus) && "승인".equals(newStatus)) {
                diffQty = newQty - oldQty;
            }
            // 승인 -> 반려: 승인 수량만큼 재고 감소분 복구 (재고 증가)
            else if ("승인".equals(oldStatus) && !"승인".equals(newStatus)) {
                diffQty = -oldQty;
            }
            // 반려 -> 승인: 승인 수량만큼 재고 차감
            else if (!"승인".equals(oldStatus) && "승인".equals(newStatus)) {
                diffQty = newQty;
            }
            // 반려 -> 반려: 재고 변동 없음
            else {
                diffQty = 0;
            }

            if (diffQty != 0) {
                String sql = """
                        UPDATE branch_stock
                        SET current_quantity = current_quantity + ?
                      WHERE product_num = ?
                 """;
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, diffQty * -1); // 재고가 줄어들면 -diffQty, 늘면 +diffQty (필요시 반대로)
                pstmt.setInt(2, productNum);
                int affected = pstmt.executeUpdate();
                if (affected == 0) {
                    // conn.rollback(); // 오토커밋이니 롤백 불필요
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
    
    public void increaseQuantity2(String branchId, int inventoryId, int amount) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                UPDATE branch_stock
                   SET current_quantity = current_quantity + ?
                 WHERE branch_id = ?
                   AND inventory_id = ?
            """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, amount);
            pstmt.setString(2, branchId);
            pstmt.setInt(3, inventoryId);
            pstmt.executeUpdate();
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
    public void decreaseQuantity(String branchId, int inventoryId, int amount) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = """
                UPDATE branch_stock
                   SET current_quantity = current_quantity - ?
                 WHERE branch_id = ?
                   AND inventory_id = ?
            """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, amount);
            pstmt.setString(2, branchId);
            pstmt.setInt(3, inventoryId);
            pstmt.executeUpdate();
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }


public void adjustQuantity(String branchId, int inventoryId, int diff) throws SQLException {
    Connection conn = null;
    PreparedStatement pstmt = null;
    try {
        conn = new DbcpBean().getConn();
        String sql = """
            UPDATE branch_stock
               SET current_quantity = current_quantity + ?
             WHERE branch_id = ?
               AND inventory_id = ?
        """;
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, diff);
        pstmt.setString(2, branchId);
        pstmt.setInt(3, inventoryId);
        pstmt.executeUpdate();
    } finally {
        try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
}
}

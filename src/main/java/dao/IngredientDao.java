package dao;

import java.sql.*;
import java.util.*;
import dto.IngredientDto;
import dto.StockRequestDto;
import util.DbcpBean;

public class IngredientDao {
	
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
        String sql = """
            UPDATE branch_stock
            SET current_quantity = current_quantity + ?
            WHERE branch_id = ? AND inventory_id = ?
        """;
        try (Connection conn = new DbcpBean().getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, amount);
            ps.setString(2, branchId);
            ps.setInt(3, inventoryId);
            ps.executeUpdate();
        }
    }
    
    public int getNumByProduct(String product) {
        int num = -1;
        String sql = "SELECT num FROM ingredient WHERE product = ?";
        try (Connection conn = new DbcpBean().getConn();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, product);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    num = rs.getInt("num");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return num;
    }
    public boolean updateQuantityByApproval(int productNum, int oldQty, int newQty, String oldStatus, String newStatus, int currentQty) {
        // 승인 상태 변경에 따라 재고 수량 조정
        // 예: 승인 -> 반려, 반려 -> 승인, 수량 변경 등 여러 경우 처리
        try (Connection conn = new DbcpBean().getConn()) {
            conn.setAutoCommit(false);

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
                // 재고 update 예시: 현재 재고 + (-diffQty)
                // 재고 테이블 컬럼, 로직에 맞게 수정 필요
                String sql = "UPDATE branch_stock SET current_quantity = current_quantity + ? WHERE product_num = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    pstmt.setInt(1, diffQty * -1); // 재고가 줄어들면 -diffQty, 늘면 +diffQty (필요시 반대로)
                    pstmt.setInt(2, productNum);
                    int affected = pstmt.executeUpdate();
                    if (affected == 0) {
                        conn.rollback();
                        return false;
                    }
                }
            }

            conn.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public void increaseQuantity2(String branchId, int inventoryId, int amount) throws SQLException {
        String sql = "UPDATE branch_stock SET current_quantity = current_quantity + ? WHERE branch_id = ? AND inventory_id = ?";
        try (Connection conn = new DbcpBean().getConn();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, amount);
            pstmt.setString(2, branchId);
            pstmt.setInt(3, inventoryId);
            pstmt.executeUpdate();
        }
    }

    public void decreaseQuantity(String branchId, int inventoryId, int amount) throws SQLException {
        String sql = "UPDATE branch_stock SET current_quantity = current_quantity - ? WHERE branch_id = ? AND inventory_id = ?";
        try (Connection conn = new DbcpBean().getConn();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, amount);
            pstmt.setString(2, branchId);
            pstmt.setInt(3, inventoryId);
            pstmt.executeUpdate();
        }
    }

    public void adjustQuantity(String branchId, int inventoryId, int diff) throws SQLException {
        String sql = "UPDATE branch_stock SET current_quantity = current_quantity + ? WHERE branch_id = ? AND inventory_id = ?";
        try (Connection conn = new DbcpBean().getConn();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, diff);
            pstmt.setString(2, branchId);
            pstmt.setInt(3, inventoryId);
            pstmt.executeUpdate();
        }
    }
}

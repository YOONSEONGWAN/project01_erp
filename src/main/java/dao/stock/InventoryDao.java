package dao.stock;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import dto.stock.InventoryDto;

import util.DbcpBean;

public class InventoryDao {
   
   private static InventoryDao dao;
   
   static {
      dao=new InventoryDao();
   }
   
   private InventoryDao() {}
   

   public static InventoryDao getInstance() {
      return dao;
   }
   
   public List<InventoryDto> selectAll() {
        List<InventoryDto> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = """
                SELECT num, branch_id, product, quantity,
                       isDisposal, isPlaceOrder, is_approval
                FROM Inventory
                ORDER BY branch_id ASC, product ASC
            """;

        try {
            conn = new DbcpBean().getConn();
            
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                InventoryDto dto = new InventoryDto();
                dto.setNum(rs.getInt("num"));
                dto.setBranch_id(rs.getInt("branch_id"));
                dto.setProduct(rs.getString("product"));
                dto.setQuantity(rs.getInt("quantity"));
                dto.setDisposal(rs.getBoolean("isDisposal"));
                dto.setPlaceOrder(rs.getBoolean("isPlaceOrder"));
                dto.setIsApproval(rs.getString("is_approval"));
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

    public List<InventoryDto> selectByInventoryId() {
        List<InventoryDto> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = """
                SELECT num, branch_id, product, quantity,
                       isDisposal, isPlaceOrder, is_approval
                FROM Inventory
                WHERE branch_id = 1
                ORDER BY product ASC
            """;
        try {
            conn = new DbcpBean().getConn();
            
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                InventoryDto dto = new InventoryDto();
                dto.setNum(rs.getInt("num"));
                dto.setBranch_id(rs.getInt("branch_id"));
                dto.setProduct(rs.getString("product"));
                dto.setQuantity(rs.getInt("quantity"));
                dto.setDisposal(rs.getBoolean("isDisposal"));
                dto.setPlaceOrder(rs.getBoolean("isPlaceOrder"));
                dto.setIsApproval(rs.getString("is_approval"));
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

    public boolean updateDisposal(int num, boolean disposal) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int rowCount = 0;
        String sql = """
                UPDATE Inventory 
                SET isDisposal = ? 
                WHERE num = ?
            """;
        try {
            conn = new DbcpBean().getConn();
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setBoolean(1, disposal);
            pstmt.setInt(2, num);
            rowCount = pstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }

        return rowCount > 0;
    }

    public boolean updateOrder(int num, boolean isPlaceOrder) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int rowCount = 0;
        String sql = """
                UPDATE Inventory
                SET isPlaceOrder = ?
                WHERE num = ?
            """;
        try {
            conn = new DbcpBean().getConn();
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setBoolean(1, isPlaceOrder);
            pstmt.setInt(2, num);
            rowCount = pstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }

        return rowCount > 0;
    }

    public boolean increaseQuantity(int num, int amount) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int updated = 0;
        String sql = "UPDATE Inventory SET quantity = quantity + ? WHERE num = ?";
        try {
            conn = new DbcpBean().getConn();
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, amount);
            pstmt.setInt(2, num);
            updated = pstmt.executeUpdate();

            

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }

        return updated > 0;
    }

    public boolean updateApproval(int num, String approvalStatus) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int count = 0;
        String sql = """
                UPDATE Inventory
                SET is_approval = ?, isPlaceOrder = 0
                WHERE num = ?
            """;
        try {
            conn = new DbcpBean().getConn();
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, approvalStatus); // "승인", "반려" 등
            pstmt.setInt(2, num);
            count = pstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }

        return count > 0;
    }


    public void setZeroQuantity(int num) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        String sql = """
                UPDATE Inventory
                SET quantity = 0
                WHERE num = ?
            """;
        try {
            conn = new DbcpBean().getConn();
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, num);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }

    public List<InventoryDto> selectPlaceOrderList() {
        List<InventoryDto> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = """
                SELECT num, branch_id, product, quantity, isDisposal, isPlaceOrder, is_approval
                FROM Inventory
                WHERE isPlaceOrder = 1 AND is_approval = '대기'
                ORDER BY num DESC
            """;
        try {
            conn = new DbcpBean().getConn();
            
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                InventoryDto dto = new InventoryDto();
                dto.setNum(rs.getInt("num"));
                dto.setBranch_id(rs.getInt("branch_id"));
                dto.setProduct(rs.getString("product"));
                dto.setQuantity(rs.getInt("quantity"));
                dto.setDisposal(rs.getBoolean("isDisposal"));
                dto.setPlaceOrder(rs.getBoolean("isPlaceOrder"));
                dto.setIsApproval(rs.getString("is_approval"));
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

    public InventoryDto getByNum(int num) {
        InventoryDto dto = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = """
                SELECT num, product, quantity
                FROM Inventory
                WHERE num = ?
            """;
        try {
            conn = new DbcpBean().getConn();
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, num);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                dto = new InventoryDto();
                dto.setNum(num);
                dto.setProduct(rs.getString("product"));
                dto.setQuantity(rs.getInt("quantity"));
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

    public String getProductByNum(int num) {
        String product = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT product FROM Inventory WHERE num = ?";
        try {
            conn = new DbcpBean().getConn();
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, num);
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
        int quantity = 0;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT quantity FROM Inventory WHERE num = ?";
        try {
            conn = new DbcpBean().getConn();
           
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, num);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                quantity = rs.getInt("quantity");
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }

        return quantity;
    }

    public boolean updatePlaceOrder(int num, boolean placeOrder) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        String sql = """
                UPDATE Inventory
                SET isPlaceOrder = ?, is_approval = ?
                WHERE num = ?
            """;
        try {
            conn = new DbcpBean().getConn();
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, placeOrder ? 1 : 0);
            pstmt.setString(2, placeOrder ? "대기" : null);
            pstmt.setInt(3, num);
            int count = pstmt.executeUpdate();
            return count > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }

    public int getNumByProduct(String product) {
        int num = -1;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT num FROM Inventory WHERE product = ?";
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
   
   
   
   
    public boolean updateQuantityByApproval(int num, int oldRequestQty, int newRequestQty, 
            String oldApprovalStatus, String newApprovalStatus,
            int currentQuantity) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean result = false;
        String selectSql = "SELECT quantity FROM Inventory WHERE num = ?";
        String updateSql = "UPDATE Inventory SET quantity = ?, is_approval = ?, isPlaceOrder = ? WHERE num = ?";
        try {
            conn = new DbcpBean().getConn();
            conn.setAutoCommit(false);

            
            pstmt = conn.prepareStatement(selectSql);
            pstmt.setInt(1, num);
            rs = pstmt.executeQuery();

            int currentQty = 0;
            if (rs.next()) {
                currentQty = rs.getInt("quantity");
            } else {
                conn.rollback();
                return false;
            }
            rs.close();
            pstmt.close();

            int adjustedQty = currentQty;
            if ("승인".equals(oldApprovalStatus) && "반려".equals(newApprovalStatus)) {
                adjustedQty = currentQuantity;
            } else if ("승인".equals(oldApprovalStatus)) {
                adjustedQty = currentQty + (newRequestQty - oldRequestQty);
            } else if ("승인".equals(newApprovalStatus) && !"승인".equals(oldApprovalStatus)) {
                adjustedQty = currentQty + newRequestQty;
            }
            if (adjustedQty < 0) adjustedQty = 0;

            
            pstmt = conn.prepareStatement(updateSql);
            pstmt.setInt(1, adjustedQty);
            pstmt.setString(2, "대기");
            pstmt.setInt(3, 0);
            pstmt.setInt(4, num);

            int updateCount = pstmt.executeUpdate();
            if (updateCount == 1) {
                conn.commit();
                result = true;
            } else {
                conn.rollback();
                result = false;
            }

        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (conn != null) conn.rollback();
            } catch (Exception ex) {}
            result = false;
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {}
        }
        return result;
    }

    public boolean decreaseQuantity(int num, int amount) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        String sql = "UPDATE Inventory SET quantity = quantity - ? WHERE num = ?";
        try {
            conn = new DbcpBean().getConn();
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, amount);
            pstmt.setInt(2, num);

            int updated = pstmt.executeUpdate();
            success = updated > 0;

            

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {}
        }
        return success;
    }

    public int getCountByKeyword(String keyword) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int count = 0;
        String sql = "SELECT COUNT(*) AS count FROM Inventory WHERE product LIKE ?";
        try {
            conn = new DbcpBean().getConn();
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, "%" + keyword + "%");
            rs = pstmt.executeQuery();

            if (rs.next()) {
                count = rs.getInt("count");
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
        return count;
    }

    public List<InventoryDto> selectByKeywordWithPaging(String keyword, int startRow, int itemsPerPage) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<InventoryDto> list = new ArrayList<>();
        String sql = """
                SELECT * FROM (
                    SELECT a.*, ROWNUM rnum FROM (
                        SELECT num, branch_id, product, quantity, isDisposal, isPlaceOrder, is_approval
                        FROM Inventory
                        WHERE product LIKE ?
                        ORDER BY num
                    ) a
                    WHERE ROWNUM <= ?
                )
                WHERE rnum >= ?
            """;

        try {
            conn = new DbcpBean().getConn();
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, "%" + keyword + "%");
            pstmt.setInt(2, startRow + itemsPerPage - 1);
            pstmt.setInt(3, startRow);

            rs = pstmt.executeQuery();
            while (rs.next()) {
                InventoryDto dto = new InventoryDto();
                dto.setNum(rs.getInt("num"));
                dto.setBranch_id(rs.getInt("branch_id"));
                dto.setProduct(rs.getString("product"));
                dto.setQuantity(rs.getInt("quantity"));

                dto.setDisposal("YES".equalsIgnoreCase(rs.getString("isDisposal")));
                dto.setPlaceOrder("YES".equalsIgnoreCase(rs.getString("isPlaceOrder")));
                dto.setIsApproval(rs.getString("is_approval"));

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

    public boolean increaseQuantity2(int inventoryId, int qty) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean result = false;
        String selectSql = "SELECT quantity FROM inventory WHERE num = ?";
        String updateSql = "UPDATE inventory SET quantity = ? WHERE num = ?";

        try {
            conn = new DbcpBean().getConn();
            
            pstmt = conn.prepareStatement(selectSql);
            pstmt.setInt(1, inventoryId);
            rs = pstmt.executeQuery();

            if (!rs.next()) {
                return false;
            }
            int currentQty = rs.getInt("quantity");
            rs.close();
            pstmt.close();

            int newQty = currentQty + qty;

            
            pstmt = conn.prepareStatement(updateSql);
            pstmt.setInt(1, newQty);
            pstmt.setInt(2, inventoryId);

            int updateCount = pstmt.executeUpdate();
            result = (updateCount == 1);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {}
        }
        return result;
    }

    public boolean decreaseQuantity2(int inventoryId, int qty) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean result = false;
        String selectSql = "SELECT quantity FROM inventory WHERE num = ?";
        String updateSql = "UPDATE inventory SET quantity = ? WHERE num = ?";
        try {
            conn = new DbcpBean().getConn();
            
            pstmt = conn.prepareStatement(selectSql);
            pstmt.setInt(1, inventoryId);
            rs = pstmt.executeQuery();

            if (!rs.next()) {
                return false;
            }
            int currentQty = rs.getInt("quantity");
            if (currentQty < qty) {
                return false;
            }
            rs.close();
            pstmt.close();

            int newQty = currentQty - qty;

            
            pstmt = conn.prepareStatement(updateSql);
            pstmt.setInt(1, newQty);
            pstmt.setInt(2, inventoryId);

            int updateCount = pstmt.executeUpdate();
            result = (updateCount == 1);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {}
        }
        return result;
    }
}
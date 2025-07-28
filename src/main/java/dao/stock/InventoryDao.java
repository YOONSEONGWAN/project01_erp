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

	    try {
	        conn = new DbcpBean().getConn();

	        String sql = """
	            SELECT num ,inventory_id, product, quantity, expirationDate,
	                   isDisposal, isPlaceOrder, is_approval
	            FROM Inventory
	            ORDER BY inventory_id ASC, product ASC
	        """;

	        pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            InventoryDto dto = new InventoryDto();
	            
	            dto.setNum(rs.getInt("num"));
	            dto.setInventory_id(rs.getInt("inventory_id"));
	            dto.setProduct(rs.getString("product"));
	            dto.setQuantity(rs.getInt("quantity"));
	            dto.setExpirationDate(rs.getString("expirationDate"));
	            dto.setDisposal(rs.getBoolean("isDisposal"));
	            dto.setPlaceOrder(rs.getBoolean("isPlaceOrder"));
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
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }

	    return list;
	}
	
	public List<InventoryDto> selectByInventoryId() {
	    List<InventoryDto> list = new ArrayList<>();

	    
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = new DbcpBean().getConn();

	        String sql = """
	            SELECT num ,inventory_id, product, quantity, TO_CHAR(expirationDate, 'YYYY-MM-DD') AS expirationDate, 
	                   isDisposal, isPlaceOrder, is_approval
	            FROM Inventory
	            WHERE inventory_id = 1
	            ORDER BY product ASC
	        """;

	        pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            InventoryDto dto = new InventoryDto();
	            
	            dto.setNum(rs.getInt("num"));
	            dto.setInventory_id(rs.getInt("inventory_id"));
	            dto.setProduct(rs.getString("product"));
	            dto.setQuantity(rs.getInt("quantity"));
	            dto.setExpirationDate(rs.getString("expirationDate"));
	            dto.setDisposal(rs.getBoolean("isDisposal"));
	            dto.setPlaceOrder(rs.getBoolean("isPlaceOrder"));
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
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }

	    return list;
	}
	
	public boolean updateDisposal(int num, boolean disposal) {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    int rowCount = 0;
	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
	        		UPDATE Inventory 
	        		SET isDisposal=? 
	        		WHERE num=?
	        		""";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setBoolean(1, disposal);
	        pstmt.setInt(2, num);
	        rowCount = pstmt.executeUpdate();
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        try {
	            if (pstmt != null) pstmt.close();
	            if (conn != null) conn.close();
	        } catch (Exception e) {}
	    }
	    return rowCount > 0;
	}
	
	public boolean updateOrder(int num, boolean isPlaceOrder) {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    int rowCount = 0;

	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
	            UPDATE Inventory
	            SET isPlaceOrder=?
	            WHERE num=?
	        """;
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setBoolean(1, isPlaceOrder);
	        pstmt.setInt(2, num);

	        rowCount = pstmt.executeUpdate();
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        try {
	            if (pstmt != null) pstmt.close();
	            if (conn != null) conn.close();
	        } catch (Exception e) {}
	    }

	    return rowCount > 0;
	}
	
	public boolean increaseQuantity(int num, int amount) {
        String sql = "UPDATE Inventory SET quantity = quantity + ? WHERE num = ?";
        try (Connection conn = new DbcpBean().getConn();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, amount);
            pstmt.setInt(2, num);
            int count = pstmt.executeUpdate();
            return count > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
	
	public boolean updateApproval(int num, boolean isApproved) {
        String sql = "UPDATE Inventory SET is_approval = ? WHERE num = ?";
        try (Connection conn = new DbcpBean().getConn();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, isApproved ? "YES" : "NO");
            pstmt.setInt(2, num);
            int count = pstmt.executeUpdate();
            return count > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }


    
    public boolean updateExpirationDate(int num, LocalDate newDate) {
        String sql = "UPDATE Inventory SET expirationDate = ? WHERE num = ?";
        try (Connection conn = new DbcpBean().getConn();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setDate(1, Date.valueOf(newDate));
            pstmt.setInt(2, num);
            int count = pstmt.executeUpdate();
            return count > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
	
	public void setZeroQuantity(int num) {
	    Connection conn = null;
	    PreparedStatement pstmt = null;

	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
	            UPDATE inventory
	            SET quantity = 0
	            WHERE num = ?
	        """;

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, num);
	        pstmt.executeUpdate();

	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        try {
	            if (pstmt != null) pstmt.close();
	            if (conn != null) conn.close();
	        } catch (Exception e) {}
	    }
	}
	
	public List<InventoryDto> selectPlaceOrderList() {
	    List<InventoryDto> list = new ArrayList<>();
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
	            SELECT num, inventory_id, product, quantity, expirationDate, isDisposal, isPlaceOrder, is_approval
				FROM inventory
				WHERE isPlaceOrder = '1'
				ORDER BY num DESC
	        """;
	        pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            InventoryDto dto = new InventoryDto();
	            dto.setNum(rs.getInt("num"));
	            dto.setInventory_id(rs.getInt("inventory_id"));
	            dto.setProduct(rs.getString("product"));
	            dto.setQuantity(rs.getInt("quantity"));
	            dto.setExpirationDate(rs.getString("expirationDate"));
	            dto.setDisposal(rs.getBoolean("isDisposal"));
	            dto.setPlaceOrder(rs.getBoolean("isPlaceOrder"));
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
	
	public void updatePlaceOrder(int num, boolean isOrder) {
	    Connection conn = null;
	    PreparedStatement pstmt = null;

	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
	        		
	        		UPDATE inventory 
	        		SET is_placeorder = ? 
	        		WHERE num = ?
	        		""";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setBoolean(1, isOrder);
	        pstmt.setInt(2, num);
	        pstmt.executeUpdate();
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        try {
	            if (pstmt != null) pstmt.close();
	            if (conn != null) conn.close();
	        } catch (Exception e) {}
	    }
	}
	
}
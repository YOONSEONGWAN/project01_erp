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
	            SELECT num ,branch_id, product, quantity,
	                   isDisposal, isPlaceOrder, is_approval
	            FROM Inventory
	            ORDER BY branch_id ASC, product ASC
	        """;

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
	            SELECT num ,branch_id, product, quantity,
	                   isDisposal, isPlaceOrder, is_approval
	            FROM Inventory
	            WHERE branch_id = 1
	            ORDER BY product ASC
	        """;

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
	
	public boolean updateApproval(int num, String approvalStatus) {
	    String sql = "UPDATE Inventory SET is_approval = ?, isPlaceOrder = ? WHERE num = ?";
	    try (Connection conn = new DbcpBean().getConn();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {
	        pstmt.setString(1, approvalStatus);  // "승인", "반려" 등
	        pstmt.setInt(2, 0);  // 승인/반려 처리 후 발주신청 해제
	        pstmt.setInt(3, num);
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
	            SELECT num, branch_id, product, quantity, isDisposal, isPlaceOrder, is_approval
				FROM inventory
				WHERE isPlaceOrder = '1'
				AND is_approval = '대기'
				ORDER BY num DESC
	        """;
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
	        try {
	            if (rs != null) rs.close();
	            if (pstmt != null) pstmt.close();
	            if (conn != null) conn.close();
	        } catch (Exception e) {}
	    }

	    return list;
	}
	
	
	
	public InventoryDto getByNum(int num) {
	    // InventoryDto 객체의 참조값을 담을 지역변수를 미리 만든다.
	    InventoryDto dto = null;

	    // 필요한 객체를 담을 지역변수를 미리 만든다
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = new DbcpBean().getConn();
	        // 실행할 SQL문
	        String sql = """
	            SELECT num, product, quantity
	            FROM Inventory
	            WHERE num = ?
	        """;
	        pstmt = conn.prepareStatement(sql);
	        // ? 에 값 바인딩
	        pstmt.setInt(1, num);
	        // SELECT 문 실행하고 결과를 ResultSet 으로 받아온다
	        rs = pstmt.executeQuery();
	        // 만일 select된 row가 있다면
	        if (rs.next()) {
	            // 객체 생성 후
	            dto = new InventoryDto();
	            // 한 개의 재고 정보를 dto에 담는다
	            dto.setNum(num); // 번호는 매개변수에서 그대로 사용
	            dto.setProduct(rs.getString("product"));
	            dto.setQuantity(rs.getInt("quantity"));
	            
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

	    return dto;
	}
	
	public String getProductByNum(int num) {
	    String product = null;
	    String sql = "SELECT product FROM inventory WHERE num = ?";
	    try (
	        Connection conn = new DbcpBean().getConn();
	        PreparedStatement pstmt = conn.prepareStatement(sql);
	    ) {
	        pstmt.setInt(1, num);
	        try (ResultSet rs = pstmt.executeQuery()) {
	            if (rs.next()) {
	                product = rs.getString("product");
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return product;
	}

	public int getQuantityByNum(int num) {
	    int quantity = 0;
	    String sql = "SELECT quantity FROM inventory WHERE num = ?";
	    try (
	        Connection conn = new DbcpBean().getConn();
	        PreparedStatement pstmt = conn.prepareStatement(sql);
	    ) {
	        pstmt.setInt(1, num);
	        try (ResultSet rs = pstmt.executeQuery()) {
	            if (rs.next()) {
	                quantity = rs.getInt("quantity");
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return quantity;
	}
	
	public boolean updatePlaceOrder(int num, boolean placeOrder) {
	    String sql = "UPDATE Inventory SET isPlaceOrder = ?, is_approval = ? WHERE num = ?";
	    try (Connection conn = new DbcpBean().getConn();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {
	        pstmt.setInt(1, placeOrder ? 1 : 0);
	        pstmt.setString(2, placeOrder ? "대기" : null);  // 신청 시 대기 상태로 초기화
	        pstmt.setInt(3, num);
	        int count = pstmt.executeUpdate();
	        return count > 0;
	    } catch (SQLException e) {
	        e.printStackTrace();
	        return false;
	    }
	}
	
	public int getNumByProduct(String product) {
	    String sql = "SELECT num FROM Inventory WHERE product = ?";
	    try (Connection conn = new DbcpBean().getConn();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {
	        pstmt.setString(1, product);
	        try (ResultSet rs = pstmt.executeQuery()) {
	            if (rs.next()) {
	                return rs.getInt("num");
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return -1;
	}
	
	
	public boolean updateQuantityByApproval(int num, int oldRequestQty, int newRequestQty, 
	        String oldApprovalStatus, String newApprovalStatus,
	        int currentQuantity) {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = new DbcpBean().getConn();
	        conn.setAutoCommit(false);  // 트랜잭션 처리 시작

	        // 1. 현재 재고 수량 조회
	        String selectSql = "SELECT quantity FROM Inventory WHERE num = ?";
	        pstmt = conn.prepareStatement(selectSql);
	        pstmt.setInt(1, num);
	        rs = pstmt.executeQuery();

	        int currentQty = 0;
	        if (rs.next()) {
	            currentQty = rs.getInt("quantity");
	        }
	        rs.close();
	        pstmt.close();

	        int adjustedQty = currentQty;

	        // 2. 승인 상태에 따라 재고 수량 계산
	        if ("승인".equals(oldApprovalStatus) && "반려".equals(newApprovalStatus)) {
	            // 승인 → 반려: quantity를 placeorder_head_detail.current_quantity 로 무조건 맞춤
	            adjustedQty = currentQuantity;
	        } else if ("승인".equals(oldApprovalStatus)) {
	            // 기존 승인 상태였으므로 변경 수량만큼 차감하거나 증가
	            adjustedQty = currentQty + (newRequestQty - oldRequestQty);
	        } else if ("승인".equals(newApprovalStatus) && !"승인".equals(oldApprovalStatus)) {
	            // 반려 → 승인: 새 요청 수량 만큼 증가
	            adjustedQty = currentQty + newRequestQty;
	        }
	        if (adjustedQty < 0) adjustedQty = 0; // 음수 재고 방지

	        // 3. 재고, 승인 상태, 발주 신청 상태 모두 업데이트
	        String updateSql = "UPDATE Inventory SET quantity = ?, is_approval = ?, isPlaceOrder = ? WHERE num = ?";
	        pstmt = conn.prepareStatement(updateSql);
	        pstmt.setInt(1, adjustedQty);
	        pstmt.setString(2, "대기");  // 여기서 무조건 '대기'로 설정
	        pstmt.setInt(3, 0); // 발주 신청 해제
	        pstmt.setInt(4, num);

	        int updateCount = pstmt.executeUpdate();

	        if (updateCount == 1) {
	            conn.commit();
	            return true;
	        } else {
	            conn.rollback();
	            return false;
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	        try { if (conn != null) conn.rollback(); } catch (Exception ignored) {}
	        return false;
	    } finally {
	        try {
	            if (rs != null) rs.close();
	            if (pstmt != null) pstmt.close();
	            if (conn != null) conn.close();
	        } catch (Exception ignored) {}
	    }
	}
	public boolean decreaseQuantity(int inventoryId, int amount) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        String sql = """
            UPDATE inventory
            SET quantity = quantity - ?
            WHERE num = ? AND quantity >= ?
        """;
        try {
            conn = new DbcpBean().getConn();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, amount);
            pstmt.setInt(2, inventoryId);
            pstmt.setInt(3, amount);
            int updated = pstmt.executeUpdate();
            return updated > 0; // 성공적으로 감소됐으면 true
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try { if(pstmt != null) pstmt.close(); } catch(Exception e) {}
            try { if(conn != null) conn.close(); } catch(Exception e) {}
        }
    }
	public int getCountByKeyword(String keyword) {
	    int count = 0;
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    try {
	        conn = new DbcpBean().getConn();
	        String sql = """
	            SELECT COUNT(*) AS count
	            FROM Inventory
	            WHERE product LIKE ?
	            """;
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, "%" + keyword + "%");
	        rs = pstmt.executeQuery();
	        if(rs.next()) {
	            count = rs.getInt("count");
	        }
	    } catch(Exception e) {
	        e.printStackTrace();
	    } finally {
	        try {
	            if(rs != null) rs.close();
	            if(pstmt != null) pstmt.close();
	            if(conn != null) conn.close();
	        } catch(Exception e) {
	            e.printStackTrace();
	        }
	    }
	    return count;
	}
	public List<InventoryDto> selectByKeywordWithPaging(String keyword, int startRow, int itemsPerPage) {
	    List<InventoryDto> list = new ArrayList<>();
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    try {
	        conn = new DbcpBean().getConn();
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
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, "%" + keyword + "%");
	        pstmt.setInt(2, startRow + itemsPerPage - 1);  // endRow
	        pstmt.setInt(3, startRow);

	        rs = pstmt.executeQuery();
	        while(rs.next()) {
	            InventoryDto dto = new InventoryDto();
	            dto.setNum(rs.getInt("num"));
	            dto.setBranch_id(rs.getInt("branch_id"));
	            dto.setProduct(rs.getString("product"));
	            dto.setQuantity(rs.getInt("quantity"));
	            
	            // 문자열 값을 boolean으로 변환
	            String disposalStr = rs.getString("isDisposal");
	            dto.setDisposal("YES".equalsIgnoreCase(disposalStr));
	            
	            String placeOrderStr = rs.getString("isPlaceOrder");
	            dto.setPlaceOrder("YES".equalsIgnoreCase(placeOrderStr));
	            
	            dto.setIsApproval(rs.getString("is_approval"));

	            list.add(dto);
	        }
	    } catch(Exception e) {
	        e.printStackTrace();
	    } finally {
	        try {
	            if(rs != null) rs.close();
	            if(pstmt != null) pstmt.close();
	            if(conn != null) conn.close();
	        } catch(Exception e) {
	            e.printStackTrace();
	        }
	    }
	    return list;
	}
}
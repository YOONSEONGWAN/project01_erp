package dao.stock;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import dto.stock.PlaceOrderBranchDetailDto;
import dto.stock.PlaceOrderHeadDetailDto;
import util.DbcpBean;

public class PlaceOrderBranchDetailDao {
	
	private static PlaceOrderBranchDetailDao dao;
	
	static {
		dao=new PlaceOrderBranchDetailDao();
	}
	
	private PlaceOrderBranchDetailDao() {}
	

	public static PlaceOrderBranchDetailDao getInstance() {
		return dao;
	}
	
	public PlaceOrderBranchDetailDto getDetailById(int detailId) {
	    PlaceOrderBranchDetailDto dto = null;
	    String sql = """
	    		SELECT detail_id, order_id, inventory_id, product, current_quantity, request_quantity, approval_status, manager, branch_id
	    		FROM placeOrder_branch_detail
	    		WHERE detail_id = ?
	    """;

	    try (
	        Connection conn = new DbcpBean().getConn();
	        PreparedStatement pstmt = conn.prepareStatement(sql)
	    ) {
	        pstmt.setInt(1, detailId);
	        try (ResultSet rs = pstmt.executeQuery()) {
	            if (rs.next()) {
	                dto = new PlaceOrderBranchDetailDto();
	                dto.setDetail_id(rs.getInt("detail_id"));
	                dto.setOrder_id(rs.getInt("order_id"));
	                dto.setProduct(rs.getString("product"));
	                dto.setCurrent_quantity(rs.getInt("current_quantity"));
	                dto.setRequest_quantity(rs.getInt("request_quantity"));
	                dto.setApproval_status(rs.getString("approval_status"));
	                dto.setManager(rs.getString("manager"));
	                dto.setInventory_id(rs.getInt("inventory_id"));
	                dto.setBranch_id(rs.getString("branch_id"));
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return dto;
	}
	
	
	
	public boolean insert(PlaceOrderBranchDetailDto dto) {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    String sql = """
	        INSERT INTO placeOrder_branch_detail
	        (detail_id, order_id, branch_id, inventory_id, product, current_quantity, request_quantity, approval_status, manager)
	        VALUES (placeOrder_branch_detail_seq.NEXTVAL, ?, ?, ?, ?, ?, ?, ?, ?)
	    """;
	    boolean isInserted = false;  // 결과 저장용 변수

	    try {
	        conn = new DbcpBean().getConn();
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, dto.getOrder_id());
	        pstmt.setString(2, dto.getBranch_id());
	        pstmt.setInt(3, dto.getInventory_id());
	        pstmt.setString(4, dto.getProduct());
	        pstmt.setInt(5, dto.getCurrent_quantity());
	        pstmt.setInt(6, dto.getRequest_quantity());
	        pstmt.setString(7, dto.getApproval_status());
	        pstmt.setString(8, dto.getManager());

	        int inserted = pstmt.executeUpdate();
	        isInserted = inserted > 0;  // 변수에 결과 저장

	    } catch (SQLException e) {
	        e.printStackTrace();
	        isInserted = false;
	    } finally {
	        try { if(pstmt != null) pstmt.close(); } catch(Exception e) {}
	        try { if(conn != null) conn.close(); } catch(Exception e) {}
	    }

	    return isInserted;
	}
	 
	 public PlaceOrderBranchDetailDto getByDetailId(int detailId) {
		    PlaceOrderBranchDetailDto dto = null;
		    String sql = "SELECT * FROM placeOrder_branch_detail WHERE detail_id = ?";
		    try (Connection conn = new DbcpBean().getConn();
		         PreparedStatement pstmt = conn.prepareStatement(sql)) {
		        pstmt.setInt(1, detailId);
		        try (ResultSet rs = pstmt.executeQuery()) {
		            if (rs.next()) {
		                dto = new PlaceOrderBranchDetailDto();
		                dto.setDetail_id(rs.getInt("detail_id"));
		                dto.setOrder_id(rs.getInt("order_id"));
		                dto.setBranch_id(rs.getString("branch_id"));
		                dto.setInventory_id(rs.getInt("inventory_id"));
		                dto.setProduct(rs.getString("product"));
		                dto.setCurrent_quantity(rs.getInt("current_quantity"));
		                dto.setRequest_quantity(rs.getInt("request_quantity"));
		                dto.setApproval_status(rs.getString("approval_status"));
		                dto.setManager(rs.getString("manager"));
		                // 필요한 다른 컬럼도 세팅
		            }
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		    }
		    return dto;
		}
	 public boolean update(int detailId, int newRequestQty, String newApprovalStatus) {
		    String sql = "UPDATE placeOrder_branch_detail SET request_quantity = ?, approval_status = ? WHERE detail_id = ?";
		    try (Connection conn = new DbcpBean().getConn();
		         PreparedStatement pstmt = conn.prepareStatement(sql)) {
		        pstmt.setInt(1, newRequestQty);
		        pstmt.setString(2, newApprovalStatus);
		        pstmt.setInt(3, detailId);

		        int affected = pstmt.executeUpdate();
		        return affected > 0;
		    } catch (Exception e) {
		        e.printStackTrace();
		    }
		    return false;
		}
	 
	 public List<PlaceOrderBranchDetailDto> getDetailListByOrderId(int orderId) {
		    List<PlaceOrderBranchDetailDto> list = new ArrayList<>();

		    Connection conn = null;
		    PreparedStatement pstmt = null;
		    ResultSet rs = null;

		    try {
		        conn = new DbcpBean().getConn();

		        String sql = "SELECT detail_id, order_id, branch_id, inventory_id, product, current_quantity, "
		                   + "request_quantity, approval_status, manager "
		                   + "FROM placeOrder_branch_detail "
		                   + "WHERE order_id = ? "
		                   + "ORDER BY detail_id ASC";

		        pstmt = conn.prepareStatement(sql);
		        pstmt.setInt(1, orderId);

		        rs = pstmt.executeQuery();

		        while (rs.next()) {
		            PlaceOrderBranchDetailDto dto = new PlaceOrderBranchDetailDto();

		            dto.setDetail_id(rs.getInt("detail_id"));
		            dto.setOrder_id(rs.getInt("order_id"));
		            dto.setBranch_id(rs.getString("branch_id"));
		            dto.setInventory_id(rs.getInt("inventory_id"));
		            dto.setProduct(rs.getString("product"));
		            dto.setCurrent_quantity(rs.getInt("current_quantity"));
		            dto.setRequest_quantity(rs.getInt("request_quantity"));
		            dto.setApproval_status(rs.getString("approval_status"));
		            dto.setManager(rs.getString("manager"));

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
	 public List<PlaceOrderBranchDetailDto> getDetailsByOrderId(int orderId) {
	        List<PlaceOrderBranchDetailDto> list = new ArrayList<>();
	        String sql = "SELECT detail_id, branch_id, product, current_quantity, request_quantity, approval_status, manager, order_id "
	                   + "FROM placeOrder_branch_detail WHERE order_id = ?";

	        try (Connection conn = new DbcpBean().getConn();
	             PreparedStatement pstmt = conn.prepareStatement(sql)) {

	            pstmt.setInt(1, orderId);

	            try (ResultSet rs = pstmt.executeQuery()) {
	                while (rs.next()) {
	                    PlaceOrderBranchDetailDto dto = new PlaceOrderBranchDetailDto();
	                    dto.setDetail_id(rs.getInt("detail_id"));
	                    dto.setBranch_id(rs.getString("branch_id"));
	                    dto.setProduct(rs.getString("product"));
	                    dto.setCurrent_quantity(rs.getInt("current_quantity"));
	                    dto.setRequest_quantity(rs.getInt("request_quantity"));
	                    dto.setApproval_status(rs.getString("approval_status"));
	                    dto.setManager(rs.getString("manager"));
	                    dto.setOrder_id(rs.getInt("order_id"));

	                    list.add(dto);
	                }
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	            // 필요시 로깅하거나 예외 던지기
	        }

	        return list;
	    }
	 public boolean updateApprovalStatus(int detailId, int requestQty, String newApprovalStatus) {
		    Connection conn = null;
		    PreparedStatement pstmt = null;
		    int result = 0;
		    String sql = "UPDATE placeorder_branch_detail SET approval_status = ?, request_quantity = ? WHERE detail_id = ?";
		    try {
		        conn = new DbcpBean().getConn();
		        pstmt = conn.prepareStatement(sql);
		        pstmt.setString(1, newApprovalStatus);
		        pstmt.setInt(2, requestQty);
		        pstmt.setInt(3, detailId);
		        result = pstmt.executeUpdate();
		    } catch (Exception e) {
		        e.printStackTrace();
		    } finally {
		        try {
		            if (pstmt != null) pstmt.close();
		            if (conn != null) conn.close();
		        } catch (Exception e) {}
		    }
		    return result > 0;
		}
	}
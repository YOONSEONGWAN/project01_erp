package dao.stock;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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
	        SELECT detail_id, order_id, product, current_quantity, request_quantity, approval_status, manager
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
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return dto;
	}
	
	public List<PlaceOrderBranchDetailDto> getDetailListByOrderId(int orderId) {
	    // 발주 상세 내역 누적시킬 리스트 객체 준비
	    List<PlaceOrderBranchDetailDto> list = new ArrayList<>();

	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = new DbcpBean().getConn();

	        // 실행할 SQL문 작성
	        String sql = "SELECT detail_id, order_id, product, current_quantity, request_quantity, approval_status, manager "
	                   + "FROM placeorder_branch_detail "
	                   + "WHERE order_id = ? "
	                   + "ORDER BY detail_id ASC";

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, orderId);

	        // select 문 실행 후 결과를 ResultSet으로 받음
	        rs = pstmt.executeQuery();

	        // ResultSet 반복문 돌면서 데이터 추출해 DTO에 담고 리스트에 누적
	        while (rs.next()) {
	            PlaceOrderBranchDetailDto dto = new PlaceOrderBranchDetailDto();

	            dto.setDetail_id(rs.getInt("detail_id"));
	            dto.setOrder_id(rs.getInt("order_id"));
	            dto.setProduct(rs.getString("product"));
	            dto.setCurrent_quantity(rs.getInt("current_quantity"));
	            dto.setRequest_quantity(rs.getInt("request_quantity"));
	            dto.setApproval_status(rs.getString("approval_status"));
	            dto.setManager(rs.getString("manager"));

	            // 리스트에 누적
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
	
}

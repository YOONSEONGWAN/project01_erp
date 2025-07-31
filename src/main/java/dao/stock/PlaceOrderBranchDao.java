package dao.stock;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import dto.stock.PlaceOrderBranchDto;
import util.DbcpBean;

public class PlaceOrderBranchDao {
	
	private static PlaceOrderBranchDao dao;
	
	static {
		dao=new PlaceOrderBranchDao();
	}
	
	private PlaceOrderBranchDao() {}
	

	public static PlaceOrderBranchDao getInstance() {
		return dao;
	}
	
	public List<PlaceOrderBranchDto> getRecentOrders() {
	    List<PlaceOrderBranchDto> list = new ArrayList<>();
	    String sql = """
	        SELECT * FROM (
	            SELECT * FROM placeOrder_branch
	            ORDER BY order_date DESC
	        ) t
	        WHERE ROWNUM <= 10
	    """;

	    try (
	        Connection conn = new DbcpBean().getConn();
	        PreparedStatement pstmt = conn.prepareStatement(sql);
	        ResultSet rs = pstmt.executeQuery();
	    ) {
	        while (rs.next()) {
	            PlaceOrderBranchDto dto = new PlaceOrderBranchDto();
	            dto.setOrder_id(rs.getInt("order_id"));
	            dto.setDate(rs.getString("order_date"));  
	            dto.setManager(rs.getString("manager"));
	            list.add(dto);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}
	
	public List<PlaceOrderBranchDto> getAllOrders() {
	    List<PlaceOrderBranchDto> list = new ArrayList<>();
	    String sql = "SELECT * FROM placeOrder_branch ORDER BY order_date DESC";

	    try (
	        Connection conn = new DbcpBean().getConn();
	        PreparedStatement pstmt = conn.prepareStatement(sql);
	        ResultSet rs = pstmt.executeQuery();
	    ) {
	        while (rs.next()) {
	            PlaceOrderBranchDto dto = new PlaceOrderBranchDto();
	            dto.setOrder_id(rs.getInt("order_id"));
	            dto.setDate(rs.getString("order_date"));  
	            dto.setManager(rs.getString("manager"));
	            list.add(dto);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}
	
}

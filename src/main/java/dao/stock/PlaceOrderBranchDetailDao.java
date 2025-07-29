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
	
	public List<PlaceOrderBranchDetailDto> getDetailsByOrderId(int orderId) {
        List<PlaceOrderBranchDetailDto> list = new ArrayList<>();
        String sql = """
            SELECT detail_id, order_id, product, current_quantity, request_quantity, approval_status, manager
            FROM placeOrder_branch_detail
            WHERE order_id = ?
            
        """;

        try (
            Connection conn = new DbcpBean().getConn();
            PreparedStatement pstmt = conn.prepareStatement(sql);
        ) {
            pstmt.setInt(1, orderId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    PlaceOrderBranchDetailDto dto = new PlaceOrderBranchDetailDto();
                    dto.setDetail_id(rs.getInt("detail_id"));
                    dto.setOrder_id(rs.getInt("order_id"));
                    dto.setProduct(rs.getString("product"));
                    dto.setCurrent_quantity(rs.getInt("current_quantity"));
                    dto.setRequest_quantity(rs.getInt("request_quantity"));
                    dto.setApproval_status(rs.getString("approval_status"));
                    dto.setManager(rs.getString("manager"));

                    list.add(dto);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
	
	
}

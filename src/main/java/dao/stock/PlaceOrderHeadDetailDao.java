package dao.stock;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import dto.stock.PlaceOrderBranchDetailDto;
import dto.stock.PlaceOrderHeadDetailDto;
import util.DbcpBean;

public class PlaceOrderHeadDetailDao {
	
	private static PlaceOrderHeadDetailDao dao;
	
	static {
		dao=new PlaceOrderHeadDetailDao();
	}
	
	private PlaceOrderHeadDetailDao() {}
	

	public static PlaceOrderHeadDetailDao getInstance() {
		return dao;
	}
	
	 // 상세 발주 내역 추가
    public boolean insert(PlaceOrderHeadDetailDto dto) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int rowCount = 0;
        String sql = """
            INSERT INTO placeOrder_head_detail
            (detail_id, order_id, product, current_quantity, request_quantity, approval_status, manager)
            VALUES(placeOrder_head_detail_seq.NEXTVAL, ?, ?, ?, ?, ?, ?)
        """;

        try {
            conn = new DbcpBean().getConn();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, dto.getOrder_id());
            pstmt.setString(2, dto.getProduct());
            pstmt.setInt(3, dto.getCurrent_quantity());
            pstmt.setInt(4, dto.getRequest_quantity());
            pstmt.setString(5, dto.getApproval_status());
            pstmt.setString(6, dto.getManager());

            rowCount = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
            }
        }
        return rowCount > 0;
    }

    // 특정 발주 번호(order_id)에 해당하는 상세 내역 전체 조회
    public List<PlaceOrderHeadDetailDto> getDetailsByOrderId(int orderId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<PlaceOrderHeadDetailDto> list = new ArrayList<>();
        String sql = """
            SELECT detail_id, order_id, product, current_quantity, request_quantity, approval_status, manager
            FROM placeOrder_head_detail
            WHERE order_id = ?
        """;

        try {
            conn = new DbcpBean().getConn();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, orderId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                PlaceOrderHeadDetailDto dto = new PlaceOrderHeadDetailDto();
                dto.setDetail_id(rs.getInt("detail_id"));
                dto.setOrder_id(rs.getInt("order_id"));
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
            } catch (Exception e) {
            }
        }
        return list;
    }

    // 발주 상세 수정
    public boolean update(int detailId, int requestQty, String approvalStatus) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int count = 0;
        String sql = """
            UPDATE placeOrder_head_detail
            SET request_quantity = ?, approval_status = ?
            WHERE detail_id = ?
        """;

        try {
            conn = new DbcpBean().getConn();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, requestQty);
            pstmt.setString(2, approvalStatus);
            pstmt.setInt(3, detailId);

            count = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
            }
        }
        return count > 0;
    }

    // detail_id로 상세 내역 조회
    public PlaceOrderHeadDetailDto getByDetailId(int detailId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        PlaceOrderHeadDetailDto dto = null;
        String sql = "SELECT * FROM placeOrder_head_detail WHERE detail_id = ?";

        try {
            conn = new DbcpBean().getConn();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, detailId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                dto = new PlaceOrderHeadDetailDto();
                dto.setDetail_id(rs.getInt("detail_id"));
                dto.setOrder_id(rs.getInt("order_id"));
                dto.setProduct(rs.getString("product"));
                dto.setCurrent_quantity(rs.getInt("current_quantity"));
                dto.setRequest_quantity(rs.getInt("request_quantity"));
                dto.setApproval_status(rs.getString("approval_status"));
                dto.setManager(rs.getString("manager"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
            }
        }
        return dto;
    }

    // detail_id로 요청 수량 조회
    public int getCurrentQuantityByDetailId(int detailId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int currentQuantity = 0;
        String sql = "SELECT request_quantity FROM placeOrder_head_detail WHERE detail_id = ?";

        try {
            conn = new DbcpBean().getConn();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, detailId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                currentQuantity = rs.getInt("request_quantity");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
            }
        }
        return currentQuantity;
    }
}
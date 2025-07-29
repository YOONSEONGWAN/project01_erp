package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import dto.StockRequestDto;
import util.DbcpBean;

public class StockRequestDao {
	private static StockRequestDao dao;
	static {
		dao = new StockRequestDao();
	}
	
	private StockRequestDao() {}
	
	public static StockRequestDao getInstance() {
		return dao;
	}
	
	// insert 발주 요청 저장
	public boolean insert(StockRequestDto dto) {
		Connection conn = null;
		PreparedStatement psmt = null;
		int rowCount = 0;

		try {
			conn = new DbcpBean().getConn();
			String sql = """
					INSERT INTO stock_request
					(request_id, branch_id, ingredient_id, quantity, status, requested_at)
					VALUES (stock_request_seq.NEXTVAL, ?, ?, ?, 'REQUESTED', SYSDATE)
					""";
			psmt = conn.prepareStatement(sql);
			psmt.setString(1, dto.getBranchId());
			psmt.setInt(2, dto.getIngredientId());
			psmt.setInt(3, dto.getQuantity());
			rowCount = psmt.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (psmt != null) psmt.close();
				if (conn != null) conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		if (rowCount > 0) {
			return true; // 작업 성공이라는 의미에서 true 리턴하기
		} else {
			return false; // 작업 실패라는 의미에서 false 리턴하기
		}
	}
	 // 2. select 지점별 발주 목록
    public List<StockRequestDto> selectByBranch(String branchId) {
        List<StockRequestDto> list = new ArrayList<>();
        Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;

		try {
			conn = new DbcpBean().getConn();
			String sql = """
	                SELECT r.request_id, r.ingredient_id, i.name AS ingredient_name, r.quantity, r.status, r.requested_at, r.updated_at
	                FROM stock_request r
	                JOIN ingredient i ON r.ingredient_id = i.ingredient_id
	                WHERE r.branch_id = ?
	                ORDER BY r.requested_at DESC
					""";
			psmt = conn.prepareStatement(sql);
			psmt.setString(1, branchId);
			rs = psmt.executeQuery();
			while (rs.next()) {
                StockRequestDto dto = new StockRequestDto();
                dto.setRequestId(rs.getInt("request_id"));
                dto.setIngredientId(rs.getInt("ingredient_id"));
                dto.setIngredientName(rs.getString("ingredient_name"));
                dto.setQuantity(rs.getInt("quantity"));
                dto.setStatus(rs.getString("status"));
                dto.setRequestedAt(rs.getString("requested_at"));
                dto.setUpdatedAt(rs.getString("updated_at"));
                list.add(dto);
            }
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null) rs.close();
				if (psmt != null) psmt.close();
				if (conn != null) conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return list;
    }
}

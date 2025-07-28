package dao.stock;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import dto.stock.InAndOutDto;
import util.DbcpBean;

public class InAndOutDao {

	private static InAndOutDao dao;
    
    static {
        dao = new InAndOutDao();
    }
    
    private InAndOutDao() {}
    
    public static InAndOutDao getInstance() {
        return dao;
    }
    
    public List<InAndOutDto> selectAll() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<InAndOutDto> list = new ArrayList<>();
        try {
            conn = new DbcpBean().getConn();
            String sql = """
            		SELECT order_id, inventory_id, is_in_order, is_out_order,
			        in_approval, out_approval, in_date, out_date, manager
            		FROM inandout
            		ORDER BY order_id DESC
            		
            		""";
            pstmt = conn.prepareStatement(sql);
            
            rs = pstmt.executeQuery();
            while (rs.next()) {
                InAndOutDto dto = new InAndOutDto();
                dto.setOrderId(rs.getInt("order_id"));
                dto.setInOrder(rs.getBoolean("is_in_order"));
                dto.setInApproval(rs.getString("in_approval"));
                dto.setOutApproval(rs.getString("out_approval"));
                dto.setIn_date(rs.getString("in_date"));
                dto.setOut_date(rs.getString("out_date"));
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
    
    public boolean updateInApproval(InAndOutDto dto) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int rowCount = 0;
        try {
            conn = new DbcpBean().getConn();  
            String sql = """
                UPDATE inandout
                SET in_approval = ?,  manager = ?
                WHERE order_id = ?
                
            """;
            pstmt = conn.prepareStatement(sql);
            
            pstmt.setString(1, dto.getInApproval());
            pstmt.setString(2, dto.getManager());
            pstmt.setInt(3, dto.getOrderId());
            rowCount = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return rowCount > 0;
    }
    
    public boolean updateOutApproval(InAndOutDto dto) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int rowCount = 0;
        try {
            conn = new DbcpBean().getConn();  
            String sql = """
                UPDATE inandout
                SET out_approval = ?, manager=?
                WHERE order_id = ?
                
            """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dto.getOutApproval());
            pstmt.setString(2, dto.getManager());
            pstmt.setInt(3, dto.getOrderId());
            rowCount = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return rowCount > 0;
    }
    
}	

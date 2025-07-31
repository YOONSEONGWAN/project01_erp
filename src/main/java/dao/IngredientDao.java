package dao;

import java.sql.*;
import java.util.*;
import dto.IngredientDto;
import util.DbcpBean;

public class IngredientDao {
    public List<IngredientDto> selectAll(String branchId) {
        List<IngredientDto> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = new DbcpBean().getConn();
            String sql = """ 
                SELECT branch_num, inventory_id, product, current_quantity, updatedat
                  FROM branch_stock
                 WHERE branch_id = ?
                 ORDER BY product
            """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, branchId);
            rs = pstmt.executeQuery();
            while(rs.next()) {
                IngredientDto dto = new IngredientDto();
                dto.setBranchNum(rs.getInt("branch_num"));           // 추가
                dto.setInventoryId(rs.getInt("inventory_id"));
                dto.setProduct(rs.getString("product"));
                dto.setCurrentQuantity(rs.getInt("current_quantity"));
                dto.setBranchId(branchId);
                dto.setUpdatedAt(rs.getDate("updatedat"));           // 추가
                list.add(dto);
            }
        } catch(Exception e) { e.printStackTrace(); }
        finally {
            try { if(rs!=null) rs.close(); } catch(Exception e){}
            try { if(pstmt!=null) pstmt.close(); } catch(Exception e){}
            try { if(conn!=null) conn.close(); } catch(Exception e){}
        }
        return list;
    }
}
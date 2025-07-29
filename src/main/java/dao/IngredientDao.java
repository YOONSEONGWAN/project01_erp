package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import dto.IngredientDto;
import util.DbcpBean;

public class IngredientDao {
    private static IngredientDao dao;
    static {
        dao = new IngredientDao();
    }

    private IngredientDao() {}

    public static IngredientDao getInstance() {
        return dao;
    }

    public List<IngredientDto> selectAll() {
        List<IngredientDto> list = new ArrayList<>();
        Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;

		try {
			conn = new DbcpBean().getConn();
			String sql = """
	            SELECT ingredient_id, name, unit, unit_price
                FROM ingredient
                ORDER BY name ASC
					""";
			psmt = conn.prepareStatement(sql);
			rs = psmt.executeQuery();
			while (rs.next()) {
                IngredientDto dto = new IngredientDto();
                dto.setIngredientId(rs.getInt("ingredient_id"));
                dto.setName(rs.getString("name"));
                dto.setUnit(rs.getString("unit"));
                dto.setUnitPrice(rs.getDouble("unit_price"));
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
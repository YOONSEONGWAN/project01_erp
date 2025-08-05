package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import dto.HrmDto;
import util.DbcpBean;

public class HrmDao {

    // 본사 직원 리스트 키워드 + 페이징 (role IN ('king','admin')) 오라클용 페이징 적용
    public List<HrmDto> selectHeadOfficeByKeywordWithPaging(String keyword, int start, int pageSize) {
        List<HrmDto> list = new ArrayList<>();
        String sql = "SELECT * FROM ( " +
                     "  SELECT a.*, ROWNUM rnum FROM ( " +
                     "    SELECT num, user_name, role FROM users_p " +
                     "    WHERE role IN ('king', 'admin') AND (user_name LIKE ? OR role LIKE ?) " +
                     "    ORDER BY role DESC, num ASC " +
                     "  ) a WHERE ROWNUM <= ? " +
                     ") WHERE rnum > ?";
        try (Connection conn = new DbcpBean().getConn();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            String like = "%" + keyword + "%";
            pstmt.setString(1, like);
            pstmt.setString(2, like);
            pstmt.setInt(3, start + pageSize);
            pstmt.setInt(4, start);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    HrmDto dto = new HrmDto();
                    dto.setNum(rs.getInt("num"));
                    dto.setName(rs.getString("user_name"));
                    dto.setRole(rs.getString("role"));
                    list.add(dto);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 본사 직원 총 개수
    public int getHeadOfficeCountByKeyword(String keyword) {
        int count = 0;
        String sql = "SELECT COUNT(*) AS cnt FROM users_p " +
                     "WHERE role IN ('king', 'admin') AND (user_name LIKE ? OR role LIKE ?)";
        try (Connection conn = new DbcpBean().getConn();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            String like = "%" + keyword + "%";
            pstmt.setString(1, like);
            pstmt.setString(2, like);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) count = rs.getInt("cnt");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    // 지점 직원 리스트 키워드 + 페이징 (role IN ('manager','clerk')) 오라클용 페이징 적용
    public List<HrmDto> selectBranchByKeywordWithPaging(String keyword, int start, int pageSize) {
        List<HrmDto> list = new ArrayList<>();
        String sql = "SELECT * FROM ( " +
                     "  SELECT a.*, ROWNUM rnum FROM ( " +
                     "    SELECT u.num, u.user_name, u.role, b.name AS branch_name " +
                     "    FROM users_p u JOIN branches b ON u.branch_id = b.branch_id " +
                     "    WHERE u.role IN ('manager', 'clerk') AND (u.user_name LIKE ? OR b.name LIKE ?) " +
                     "    ORDER BY branch_name ASC, u.role DESC, u.num ASC " +
                     "  ) a WHERE ROWNUM <= ? " +
                     ") WHERE rnum > ?";
        try (Connection conn = new DbcpBean().getConn();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            String like = "%" + keyword + "%";
            pstmt.setString(1, like);
            pstmt.setString(2, like);
            pstmt.setInt(3, start + pageSize);
            pstmt.setInt(4, start);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    HrmDto dto = new HrmDto();
                    dto.setNum(rs.getInt("num"));
                    dto.setName(rs.getString("user_name"));
                    dto.setRole(rs.getString("role"));
                    dto.setBranchName(rs.getString("branch_name"));
                    list.add(dto);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 지점 직원 총 개수
    public int getBranchCountByKeyword(String keyword) {
        int count = 0;
        String sql = "SELECT COUNT(*) AS cnt " +
                     "FROM users_p u JOIN branches b ON u.branch_id = b.branch_id " +
                     "WHERE u.role IN ('manager', 'clerk') AND (u.user_name LIKE ? OR b.name LIKE ?)";
        try (Connection conn = new DbcpBean().getConn();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            String like = "%" + keyword + "%";
            pstmt.setString(1, like);
            pstmt.setString(2, like);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) count = rs.getInt("cnt");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    // 직원 삭제
    public boolean deleteByNum(int num) {
        int rowCount = 0;
        try (Connection conn = new DbcpBean().getConn();
             PreparedStatement pstmt = conn.prepareStatement("DELETE FROM users_p WHERE num=?")) {

            pstmt.setInt(1, num);
            rowCount = pstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return rowCount > 0;
    }

    // 직원 상세 조회
    public HrmDto getByNum(int num) {
        HrmDto dto = null;
        String sql = "SELECT u.user_name, u.role, u.profile_image, b.name AS branchName, u.phone, u.location " +
                     "FROM users_p u LEFT JOIN branches b ON u.branch_id = b.branch_id " +
                     "WHERE u.num = ?";
        try (Connection conn = new DbcpBean().getConn();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, num);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    dto = new HrmDto();
                    dto.setNum(num);
                    dto.setName(rs.getString("user_name"));
                    dto.setRole(rs.getString("role"));
                    dto.setProfileImage(rs.getString("profile_image"));
                    dto.setBranchName(rs.getString("branchName"));
                    dto.setPhone(rs.getString("phone"));
                    dto.setLocation(rs.getString("location"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return dto;
    }


//이미지 업로드 전용 메서드
	public boolean updateProfileImage(int num, String profileImage) {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    int rowCount = 0;
	    
	    try {
	        conn = new DbcpBean().getConn();
	        String sql = "UPDATE users_p SET profile_image=? WHERE num=?";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, profileImage);
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
	
}

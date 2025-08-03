package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import dto.GalleryDto;
import dto.GalleryImageDto;
import util.DbcpBean;

public class GalleryDao {

    private static GalleryDao dao;

    private GalleryDao() {}

    public static GalleryDao getInstance() {
        if (dao == null) {
            dao = new GalleryDao();
        }
        return dao;
    }

    // 이미지 목록도 포함하여 gallery 목록 반환
    public List<GalleryDto> getListWithImages() {
        List<GalleryDto> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = """
            SELECT num, title, writer, TO_CHAR(createdAt, 'YYYY-MM-DD HH24:MI:SS') AS createdAt
            FROM gallery
            ORDER BY num DESC
        """;

        try {
            conn = new DbcpBean().getConn();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                GalleryDto dto = new GalleryDto();
                int galleryNum = rs.getInt("num");
                dto.setNum(galleryNum);
                dto.setTitle(rs.getString("title"));
                dto.setWriter(rs.getString("writer"));
                dto.setCreatedAt(rs.getString("createdAt")); // String 처리

                // 이미지 목록도 dao 호출로 포함
                List<GalleryImageDto> imageList = getImageList(galleryNum);
                dto.setImageList(imageList);

                list.add(dto);
            }

        } catch (SQLException e) {
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
    
    // 게시글 저장
    public boolean insert(GalleryDto dto) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean isSuccess = false;
        String sql = """
            INSERT INTO gallery (num, title, writer, content)
            VALUES (?, ?, ?, ?)
            """;

        try {
            conn = new DbcpBean().getConn();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, dto.getNum()); // 시퀀스를 dto에 미리 넣어서 전달
            pstmt.setString(2, dto.getTitle());
            pstmt.setString(3, dto.getWriter());
            pstmt.setString(4, dto.getContent());

            int rowCount = pstmt.executeUpdate();
            isSuccess = rowCount > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {}
        }

        return isSuccess;
    }

    // 이미지 저장
    public boolean insertImage(GalleryImageDto dto) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean isSuccess = false;
        String sql = """
            INSERT INTO gallery_image (num, galleryNum, saveFileName)
            VALUES (gallery_image_seq.NEXTVAL, ?, ?)
            """;

        try {
            conn = new DbcpBean().getConn();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, dto.getGalleryNum());
            pstmt.setString(2, dto.getSaveFileName());

            int rowCount = pstmt.executeUpdate();
            isSuccess = rowCount > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {}
        }

        return isSuccess;
    }

    // 게시글 목록
    public List<GalleryDto> getList() {
        List<GalleryDto> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = """
            SELECT num, title, writer, TO_CHAR(createdAt, 'YYYY-MM-DD HH24:MI:SS') AS createdAt
            FROM gallery
            ORDER BY num DESC
            """;

        try {
            conn = new DbcpBean().getConn();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                GalleryDto dto = new GalleryDto();
                dto.setNum(rs.getInt("num"));
                dto.setTitle(rs.getString("title"));
                dto.setWriter(rs.getString("writer"));
                dto.setCreatedAt(rs.getString("createdAt"));  // string 처리
                list.add(dto);
            }

        } catch (SQLException e) {
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

    // 상세보기
    public GalleryDto getData(int num) {
        GalleryDto dto = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = """
            SELECT num, title, writer, content, TO_CHAR(createdAt, 'YYYY-MM-DD HH24:MI:SS') AS createdAt
            FROM gallery
            WHERE num = ?
            """;

        try {
            conn = new DbcpBean().getConn();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, num);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                dto = new GalleryDto();
                dto.setNum(rs.getInt("num"));
                dto.setTitle(rs.getString("title"));
                dto.setWriter(rs.getString("writer"));
                dto.setContent(rs.getString("content"));
                dto.setCreatedAt(rs.getString("createdAt")); // string 처리
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {}
        }

        return dto;
    }

    // 이미지 목록
    public List<GalleryImageDto> getImageList(int galleryNum) {
        List<GalleryImageDto> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = """
            SELECT num, saveFileName, TO_CHAR(createdAt, 'YYYY-MM-DD HH24:MI:SS') AS createdAt
            FROM gallery_image
            WHERE galleryNum = ?
            ORDER BY num ASC
            """;

        try {
            conn = new DbcpBean().getConn();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, galleryNum);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                GalleryImageDto dto = new GalleryImageDto();
                dto.setNum(rs.getInt("num"));
                dto.setGalleryNum(galleryNum);
                dto.setSaveFileName(rs.getString("saveFileName"));
                dto.setCreatedAt(rs.getString("createdAt")); // string 처리
                list.add(dto);
            }

        } catch (SQLException e) {
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
    
	//저장할 글번호를 리턴해주는 메소드
	public int getSequence() {
		int num=0;
		//필요한 객체를 담을 지역변수를 미리 만든다 
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = new DbcpBean().getConn();
			//실행할 sql문
			String sql = """
				SELECT board_seq.NEXTVAL AS num FROM dual
			""";
			pstmt = conn.prepareStatement(sql);
			//? 에 값 바인딩
			// select 문 실행하고 결과를 ResultSet 으로 받아온다
			rs = pstmt.executeQuery();
			if (rs.next()) {
				num=rs.getInt("num");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception e) {
			}
		}
		
		return num;
	}
}
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import dao.HqBoardDao;
import dto.HqBoardDto;
import dto.HqBoardFileDto;
import util.DbcpBean;

public class HqBoardDao {

	public static HqBoardDao dao;
	
	// static 초기화 작업
	static{
		dao=new HqBoardDao();
	}
	
	// 외부에서 UserDao 객체를 생성하지 못하도록 생성자를 private 로 막는다.
	private HqBoardDao(){} 
	
	// UserDao 객체의 참조값을 리턴해주는 public static 메소드 제공
	public static HqBoardDao getInstance() {
		return dao;
	}
	
	
	/* ************************************************** */
	// 검색 키워드와 맞는 글의 갯수를 리턴 
	//public int getCountByKeyword(String keyword){}
	public int getCountByKeyword(String keyword){
		int count=0;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = new DbcpBean().getConn();
			String sql = """
				SELECT MAX(ROWNUM) AS count
				FROM hqBoard
				WHERE title LIKE '%'||?||'%' OR content LIKE '%'||?||'%' 
			""";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, keyword);
			pstmt.setString(2, keyword);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				count=rs.getInt("count");
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null);
				pstmt.close();
				if(conn!=null);
				conn.close();
				
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		return count;
	}
	
	/* ************************************************** */
	// 조회수 증가 메소드
	//public boolean addViewCount(int num) {}
	public boolean addViewCount(int num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int rowCount = 0;
		try {
			conn = new DbcpBean().getConn();
			String sql = """
				UPDATE hqBoard
				SET view_count = view_count+1
				WHERE num=?
			""";
			pstmt = conn.prepareStatement(sql);
			// ? 에 순서대로 필요한 값 바인딩 
			// 예시 pstmt.setString(1, dto.getName());
			pstmt.setInt(1, num);

			rowCount = pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					;
				conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}

		}
		if (rowCount > 0) {
			return true; //
		} else {
			return false;
		}
	}

	
	/* ************************************************** */
	// 글 번호가 될 값만 미리 얻어내서 시퀀스값을 받는 메소드->글번호에 저장
	//public int getSequence() {}
	public int getSequence() {
		// 글 번호를 저장할 지역변수 미리 만들기
		int num=0;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = new DbcpBean().getConn();
			String sql = """
					SELECT hqboard_seq.NEXTVAL AS num FROM DUAL
						""";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				num=rs.getInt("num");
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null);
				pstmt.close();
				if(conn!=null);
				conn.close();
				
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		return num;
	}	
	/* ************************************************** */
	// page 에 담길 글의 row 만 select 해서 리턴 ex.1~5번 글 리턴
	//public List<HqBoardDto> selectPage(HqBoardDto dto){}
	public List<HqBoardDto> selectPage(HqBoardDto dto){
		
		List<HqBoardDto> list=new ArrayList<>();
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = new DbcpBean().getConn();
			String sql = """
				SELECT *
				FROM
					(SELECT result1.*, ROWNUM AS rnum
					FROM
						(SELECT num, writer, title, content, view_count, created_at
						FROM hqBoard
						ORDER BY num DESC) result1)
				WHERE rnum BETWEEN ? AND ?
			""";
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setInt(1, dto.getStartRowNum());
			pstmt.setInt(2, dto.getEndRowNum());
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				dto=new HqBoardDto();
				dto.setNum(rs.getInt("NUM"));
				dto.setWriter(rs.getString("writer"));
				dto.setTitle(rs.getString("title"));
				dto.setViewCount(rs.getInt("view_count"));
				dto.setCreatedAt(rs.getString("created_at"));
				list.add(dto);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null);
				pstmt.close();
				if(conn!=null);
				conn.close();
				
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		return list;
	}	
	
	/* ************************************************** */
	// 특정 키워드에 해당하는 row select 하여 페이지에 리턴 (페이지구성)
	/*public List<HqBoardDto> selectPageByKeyword(HqBoardDto dto){
	List<HqBoardDto> list=new ArrayList<>();
	return list;
	}*/
	public List<HqBoardDto> selectPageByKeyword(HqBoardDto dto){
		
		List<HqBoardDto> list=new ArrayList<>();
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = new DbcpBean().getConn();
			String sql = """
				SELECT *
				FROM
					(SELECT result1.*, ROWNUM AS rnum
					FROM
						(SELECT num, writer, title, content, view_count, created_at
						FROM hqboard
						WHERE title LIKE '%'||?||'%' OR content LIKE '%'||?||'%' 
						ORDER BY num DESC) result1)
				WHERE rnum BETWEEN ? AND ?
			""";
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, dto.getKeyword());
			pstmt.setString(2, dto.getKeyword());
			pstmt.setInt(3, dto.getStartRowNum());
			pstmt.setInt(4, dto.getEndRowNum());
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				dto=new HqBoardDto();
				dto.setNum(rs.getInt("NUM"));
				dto.setWriter(rs.getString("writer"));
				dto.setTitle(rs.getString("title"));
				dto.setViewCount(rs.getInt("view_count"));
				dto.setCreatedAt(rs.getString("created_at"));
				list.add(dto);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
				pstmt.close();
				if(conn!=null)
				conn.close();
				
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		return list;
	}
	
	/* ************************************************** */
	// 글 전체를 배열에 담아 리턴하는 메소드
	//public List<BoardDto> selectAll(){}
	public List<HqBoardDto> selectAll(){
		
		List<HqBoardDto> list=new ArrayList<>();
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = new DbcpBean().getConn();
			String sql = """
				SELECT num, writer, title, view_count, created_at
				FROM hqBoard
				ORDER BY NUM DESC
			""";
			pstmt = conn.prepareStatement(sql);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				HqBoardDto dto=new HqBoardDto();
				dto.setNum(rs.getInt("NUM"));
				dto.setWriter(rs.getString("writer"));
				dto.setTitle(rs.getString("title"));
				dto.setViewCount(rs.getInt("view_count"));
				dto.setCreatedAt(rs.getString("created_at"));
				list.add(dto);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null);
				pstmt.close();
				if(conn!=null);
				conn.close();
				
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		return list;
	}

	
	/* ************************************************** */
	// 전체 글의 개수를 리턴하는 메소드 
	//public int getCount(){}
	public int getCount(){
		int count=0;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = new DbcpBean().getConn();
			String sql = """
				SELECT MAX(ROWNUM) AS count
				FROM hqboard
			""";
			pstmt = conn.prepareStatement(sql);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				count=rs.getInt("count");
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null);
				pstmt.close();
				if(conn!=null);
				conn.close();
				
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		return count;
	}
	
	/* ************************************************** */
	// 글 하나의 정보를 리턴 	
	//public BoardDto getByNum(int num) {}
	public HqBoardDto getByNum(int num) {
	    HqBoardDto dto = null;
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    try {
	        conn = new DbcpBean().getConn();
	        // 실행할 sql
	        String sql = """
	            SELECT *
	            FROM	
	                (SELECT b.num, writer, title, content, view_count, 
	                    TO_CHAR(b.created_at, 'YY"년" MM"월" DD"일" HH24:MI') AS created_at, 
	                    profileImage,
	                    LAG(b.num, 1, 0) OVER (ORDER BY b.num DESC) AS prevNum,
	                    LEAD(b.num, 1, 0) OVER (ORDER BY b.num DESC) AS nextNum
	                FROM hqboard b
	                INNER JOIN users2 u ON b.writer = u.name) 
	            WHERE num=?
	        """;
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, num);
	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            dto = new HqBoardDto();
	            dto.setNum(num);
	            dto.setWriter(rs.getString("writer"));
	            dto.setTitle(rs.getString("title"));
	            dto.setContent(rs.getString("content"));
	            dto.setViewCount(rs.getInt("view_count"));
	            dto.setCreatedAt(rs.getString("created_at"));
	            dto.setProfileImage(rs.getString("profileImage"));
	            dto.setPrevNum(rs.getInt("prevNum"));
	            dto.setNextNum(rs.getInt("nextNum"));

	            // === 첨부파일 리스트 추가 ===
	            PreparedStatement fpstmt = null;
	            ResultSet frs = null;
	            try {
	                String fsql = "SELECT * FROM hqboard_file WHERE board_num=? ORDER BY num";
	                fpstmt = conn.prepareStatement(fsql);
	                fpstmt.setInt(1, num);
	                frs = fpstmt.executeQuery();
	                java.util.List<HqBoardFileDto> fileList = new java.util.ArrayList<>();
	                while (frs.next()) {
	                    HqBoardFileDto fileDto = new HqBoardFileDto();
	                    fileDto.setNum(frs.getInt("num"));
	                    fileDto.setBoardNum(frs.getInt("board_num"));
	                    fileDto.setOrgFileName(frs.getString("org_file_name"));
	                    fileDto.setSaveFileName(frs.getString("save_file_name"));
	                    fileDto.setFileSize(frs.getLong("file_size"));
	                    fileDto.setCreatedAt(frs.getString("created_at"));
	                    fileList.add(fileDto);
	                }
	                dto.setFileList(fileList);
	            } catch (Exception e) {
	                e.printStackTrace();
	            } finally {
	                try {
	                    if (frs != null) frs.close();
	                    if (fpstmt != null) fpstmt.close();
	                } catch (Exception e) {
	                    e.printStackTrace();
	                }
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        try {
	            if (rs != null) rs.close();
	            if (pstmt != null) pstmt.close();
	            if (conn != null) conn.close();
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
	    return dto;
	}

	
	/* ************************************************** */
	// 업데이트 메소드
	public boolean update(HqBoardDto dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int rowCount = 0;
		try {
			conn = new DbcpBean().getConn();
			String sql = """
				UPDATE hqBoard
				SET title=?, content=?
				WHERE num=?
					""";
			pstmt = conn.prepareStatement(sql);
			// ? 에 순서대로 필요한 값 바인딩 
			// 예시 pstmt.setString(1, dto.getName());
			pstmt.setString(1, dto.getTitle());
			pstmt.setString(2, dto.getContent());
			pstmt.setInt(3, dto.getNum());

			rowCount = pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					;
				conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}

		}
		if (rowCount > 0) {
			return true; //
		} else {
			return false;
		}
	}

	
	/* ************************************************** */
	// 삭제 메소드
	public boolean deleteByNum(int num) {
		Connection conn = null;
		PreparedStatement pstmt = null;

		int rowCount = 0;
		try {
			conn = new DbcpBean().getConn();
			String sql = """
					DELETE FROM hqBoard
					WHERE NUM = ?
					""";
			pstmt = conn.prepareStatement(sql);
			// 바인딩 작성 예시: pstmt.setInt(1, num);
			pstmt.setInt(1, num);
			rowCount = pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (pstmt != null)
					;
				pstmt.close();
				if (conn != null)
					;
				conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		if (rowCount > 0) {
			return true;
		} else {
			return false;
		}
	}

	
	/* ************************************************** */
	// 글 작성을 위한 인서트 메소드
	public boolean insert(HqBoardDto dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int rowCount = 0;
		try {
			conn = new DbcpBean().getConn();
			String sql = """
					INSERT INTO hqboard
					(num, writer, title, content)
					VALUES(?, ?, ?, ?)
					""";
			pstmt = conn.prepareStatement(sql);
			// ? 에 들어갈 바인딩
			// 예시: pstmt.setString(1, dto.getName());
			pstmt.setInt(1, dto.getNum());
			pstmt.setString(2, dto.getWriter());
			pstmt.setString(3, dto.getTitle());
			pstmt.setString(4, dto.getContent());
			// sql 문 실행하고 변화된(추가된, 수정된, 삭제된) row 의 갯수 리턴받기 -> 아래에서 사용
			rowCount = pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					;
				conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}

		}
		if (rowCount > 0) {
			return true; // row 가 생겼으면 트루 반환 (boolean type 메소드)
		} else {
			return false;
		}
	}
}
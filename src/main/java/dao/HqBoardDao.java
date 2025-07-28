package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import dao.HqBoardDao;
import dto.HqBoardDto;
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
				SET viewCount = viewCount+1
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
						(SELECT num, writer, title, content, viewCount, createdAt
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
				dto.setViewCount(rs.getInt("viewCount"));
				dto.setCreatedAt(rs.getString("createdAt"));
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
						(SELECT num, writer, title, content, viewCount, createdAt
						FROM board
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
				dto.setViewCount(rs.getInt("viewCount"));
				dto.setCreatedAt(rs.getString("createdAt"));
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
				SELECT num, writer, title, viewCount, createdAt
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
				dto.setViewCount(rs.getInt("viewCount"));
				dto.setCreatedAt(rs.getString("createdAt"));
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
				FROM board
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
			// 실행 할 sql 
			String sql = """
				SELECT *
				FROM	
					(SELECT b.num, writer, title, content, viewCount, 
						TO_CHAR(b.createdAt, 'YY"년" MM"월" DD"일" HH24:MI') AS createdAt, 
						profileImage,
						LAG(b.num, 1, 0) OVER (ORDER BY b.num DESC) AS prevNum,
						LEAD(b.num, 1, 0) OVER (ORDER BY b.num DESC) AS nextNum
					FROM board b
					INNER JOIN users u ON b.writer = u.userName) 
				WHERE num=?
			""";
			pstmt = conn.prepareStatement(sql);
			// 바인딩 예시: pstmt.setInt(1, num);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			while (rs.next()) { // 업데이트 요소 작성 
				/*dto = new BookDto();
				dto.setNum(num);
				dto.setName(rs.getString("name"));
				dto.setAuthor(rs.getString("author"));
				dto.setPublisher(rs.getString("publisher"));*/

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
					INSERT INTO board
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
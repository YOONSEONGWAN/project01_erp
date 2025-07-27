package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
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
	// 키워드에 맞는 글의 개수를 리턴
	//public int getCountByKeyword(String keyword){}
	
	/* ************************************************** */
	// 검색 키워드와 맞는 글의 갯수를 리턴 
	//public int getCountByKeyword(String keyword){}
	
	/* ************************************************** */
	// 조회수 증가 메소드
	//public boolean addViewCount(int num) {}
	
	/* ************************************************** */
	// 글 번호가 될 값만 미리 얻어내서 시퀀스값을 받는 메소드->글번호에 저장
	//public int getSequence() {}
	
	/* ************************************************** */
	// page 에 담길 글의 row 만 select 해서 리턴 ex.1~5번 글 리턴
	//public List<HqBoardDto> selectPage(HqBoardDto dto){}
		
	
	/* ************************************************** */
	// 특정 페이지에 해당하는 row select 하여 리턴 (페이지구성)
	/*public List<HqBoardDto> selectPageByKeyword(HqBoardDto dto){
	List<HqBoardDto> list=new ArrayList<>();
	return list;
	}*/
	
	/* ************************************************** */
	// 글 전체를 배열에 담아 리턴하는 메소드
	//public List<BoardDto> selectAll(){}
	
	/* ************************************************** */
	// 전체 글의 개수를 리턴하는 메소드 
	//public int getCount(){}
	
	/* ************************************************** */
	// 글 하나의 정보를 리턴 	
	//public BoardDto getByNum(int num) {}
	
	/* ************************************************** */
	// 업데이트 메소드
	//public boolean update(BoardDto dto) {}
	
	/* ************************************************** */
	// 삭제 메소드
	//public boolean deleteByNum(int num) {}
	
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
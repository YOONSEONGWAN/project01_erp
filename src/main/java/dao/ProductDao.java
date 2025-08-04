package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import dto.ProductDto;
import util.DbcpBean;


public class ProductDao {
	// 선택된 상품 여러 개 삭제하는 메서드
	public int deleteMultiple(List<Integer> nums) {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    int deletedCount = 0;

	    if (nums == null || nums.isEmpty()) return deletedCount;

	    try {
	        conn = new DbcpBean().getConn();
	        
	        StringBuilder sqlBuilder = new StringBuilder("DELETE FROM product WHERE num IN (");
	        for (int i = 0; i < nums.size(); i++) {
	            sqlBuilder.append("?");
	            if (i < nums.size() - 1) {
	                sqlBuilder.append(", ");
	            }
	        }
	        sqlBuilder.append(")");

	        pstmt = conn.prepareStatement(sqlBuilder.toString());
	        for (int i = 0; i < nums.size(); i++) {
	            pstmt.setInt(i + 1, nums.get(i));
	        }

	        deletedCount = pstmt.executeUpdate();
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        try {
	            if (pstmt != null) pstmt.close();
	            if (conn != null) conn.close();
	        } catch (Exception e) {}
	    }
	    return deletedCount;
	}


	
	// 검색어로 필터링 + 페이징 처리 메서드
	public List<ProductDto> selectByPageAndKeyword(int startRowNum, int endRowNum, String keyword) {
	    List<ProductDto> list = new ArrayList<>();
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = new DbcpBean().getConn();

	        String sql = """
	            SELECT * FROM (
	                SELECT a.*, ROWNUM rnum FROM (
	                    SELECT * FROM product
	                    WHERE (name LIKE ? OR description LIKE ?)
	                    ORDER BY num DESC
	                ) a WHERE ROWNUM <= ?
	            ) WHERE rnum >= ?
	        """;

	        pstmt = conn.prepareStatement(sql);
	        String likeKeyword = "%" + keyword + "%";
	        pstmt.setString(1, likeKeyword);
	        pstmt.setString(2, likeKeyword);
	        pstmt.setInt(3, endRowNum);
	        pstmt.setInt(4, startRowNum);

	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            ProductDto dto = new ProductDto();
	            dto.setNum(rs.getInt("num"));
	            dto.setName(rs.getString("name"));
	            dto.setDescription(rs.getString("description"));
	            dto.setPrice(rs.getInt("price"));
	            dto.setStatus(rs.getString("status"));
	            dto.setImagePath(rs.getString("imagepath"));
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

	// 검색어 포함된 게시글 개수 리턴
	public int getCountByKeyword(String keyword) {
	    int count = 0;
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = new DbcpBean().getConn();
	        String sql = "SELECT COUNT(*) AS cnt FROM product WHERE name LIKE ? OR description LIKE ?";
	        pstmt = conn.prepareStatement(sql);
	        String likeKeyword = "%" + keyword + "%";
	        pstmt.setString(1, likeKeyword);
	        pstmt.setString(2, likeKeyword);
	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            count = rs.getInt("cnt");
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
	    return count;
	}





	
	//이미지 업로드
	public int insert1(ProductDto dto) {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    int generatedNum = 0;
	    try {
	        conn = new DbcpBean().getConn();
	        String sql = "INSERT INTO product(num, name, description, price, status, imagepath) VALUES(product_seq.NEXTVAL, ?, ?, ?, ?, ?)";
	        pstmt = conn.prepareStatement(sql, new String[] {"num"});
	        pstmt.setString(1, dto.getName());
	        pstmt.setString(2, dto.getDescription());
	        pstmt.setInt(3, dto.getPrice());
	        pstmt.setString(4, dto.getStatus());
	        pstmt.setString(5, dto.getImagePath());

	        int rowCount = pstmt.executeUpdate();

	        if (rowCount > 0) {
	            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
	                if (generatedKeys.next()) {
	                    generatedNum = generatedKeys.getInt(1);
	                    dto.setNum(generatedNum);
	                }
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        try {
	            if (pstmt != null) pstmt.close();
	            if (conn != null) conn.close();
	        } catch (Exception e) {}
	    }
	    return generatedNum;
	}
	
	// 상품 정보 수정
	public boolean update(ProductDto dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		// 변화된 row 의 갯수를 담을 변수 선언하고 0으로 초기화
		int rowCount = 0;
		try {
			conn = new DbcpBean().getConn();
			String sql = """
					UPDATE product
					SET name=?, description=?, price=?, status=?, imagepath=?
					WHERE num=?
					""";
			pstmt = conn.prepareStatement(sql);
			// ? 에 순서대로 필요한 값 바인딩
			pstmt.setString(1, dto.getName());
			pstmt.setString(2, dto.getDescription());
			pstmt.setInt(3, dto.getPrice());
			pstmt.setString(4, dto.getStatus());
			pstmt.setString(5, dto.getImagePath());
			pstmt.setInt(6, dto.getNum());
			// sql 문 실행하고 변화된(추가된, 수정된, 삭제된) row 의 갯수 리턴받기
			rowCount = pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				// null 일 경우 흐름을 건너뛰고 catch 로 넘어가기 때문에 if 문 으로 null 을 감지한다
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception e) {
			} // 작업 사항이 없으므로 {}는 그냥 닫는다

		}
		// 변화된 rowCount 값을 조사해서 작업의 성공 여부를 알아낼 수 있다.
		if (rowCount > 0) {
			return true; // 작업 성공이라는 의미에서 true 리턴하기
		} else {
			return false; // 작업 실패라는 의미에서 false 리턴하기
		}
	}
	
	// 상품 정보 삭제
		public boolean deleteByNum(int num) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			// 변화된 row 의 갯수를 담을 변수 선언하고 0으로 초기화
			int rowCount = 0;
			try {
				conn = new DbcpBean().getConn();
				String sql = """
						DELETE FROM product
						WHERE num=?
						""";
				pstmt = conn.prepareStatement(sql);
				// ? 에 순서대로 필요한 값 바인딩
				pstmt.setInt(1, num);
				// sql 문 실행하고 변화된(추가된, 수정된, 삭제된) row 의 갯수 리턴받기
				rowCount = pstmt.executeUpdate();

			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				try {
					// null 일 경우 흐름을 건너뛰고 catch 로 넘어가기 때문에 if 문 으로 null 을 감지한다
					if (pstmt != null)
						pstmt.close();
					if (conn != null)
						conn.close();
				} catch (Exception e) {
				} // 작업 사항이 없으므로 {}는 그냥 닫는다

			}
			// 변화된 rowCount 값을 조사해서 작업의 성공 여부를 알아낼 수 있다.
			if (rowCount > 0) {
				return true; // 작업 성공이라는 의미에서 true 리턴하기
			} else {
				return false; // 작업 실패라는 의미에서 false 리턴하기
			}
		}
	

	// 상품 정보 추가
	public boolean insert(ProductDto dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		// 변화된 row 의 갯수를 담을 변수 선언하고 0으로 초기화
		int rowCount = 0;
		try {
			conn = new DbcpBean().getConn();
			String sql = """
				    INSERT INTO product(num, name, description, price, status, imagepath)
				    VALUES(product_seq.NEXTVAL, ?, ?, ?, ?, ?)
				    """;
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, dto.getName());
				pstmt.setString(2, dto.getDescription());
				pstmt.setInt(3, dto.getPrice());
				pstmt.setString(4, dto.getStatus());
				pstmt.setString(5, dto.getImagePath());
			// sql 문 실행하고 변화된(추가된, 수정된, 삭제된) row 의 갯수 리턴받기
			rowCount = pstmt.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				// null 일 경우 흐름을 건너뛰고 catch 로 넘어가기 때문에 if 문 으로 null 을 감지한다
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception e) {
			} // 작업 사항이 없으므로 {}는 그냥 닫는다

		}
		// 변화된 rowCount 값을 조사해서 작업의 성공 여부를 알아낼 수 있다.
		if (rowCount > 0) {
			return true; // 작업 성공이라는 의미에서 true 리턴하기
		} else {
			return false; // 작업 실패라는 의미에서 false 리턴하기
		}
		
	}

	// 상품 하나의 정보 리턴
	public ProductDto getByNum(int num) {
		ProductDto dto = null;
		// 필요한 객체를 담을 지역변수를 미리 만든다.
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = new DbcpBean().getConn();
			// 실행할 sql 문
			String sql = """
					SELECT name, description, price, status, imagepath
					FROM product
					WHERE num=?
					""";
			pstmt = conn.prepareStatement(sql);
			// ? 에 값 바인딩
			pstmt.setInt(1, num);
			// Select 문 실행하고 결과를 ResultSet 으로 받아온다
			rs = pstmt.executeQuery();
			// 만일 select 된 row가 있다면
			if (rs.next()) {
				// BookDto 객체를 생성해서 책 정보를 담는다
				dto=new ProductDto();
				dto.setNum(num);
				dto.setName(rs.getString("name"));
				dto.setDescription(rs.getString("description"));
				dto.setPrice(rs.getInt("price"));
				dto.setStatus(rs.getString("status"));
				dto.setImagePath(rs.getString("imagepath"));
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
		return dto;
	}
	
	
	//상품 리스트 조회
	
	
		public List<ProductDto> selectAll(){
			// select 한 상품 목록을 담을 객체 생성
			List<ProductDto> list = new ArrayList<>();
			// 필요한 객체를 담을 지역변수를 미리 만든다.
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				conn = new DbcpBean().getConn();
				// 실행할 sql 문
				String sql = """
						SELECT num, name, description, price, status
						FROM product
						ORDER BY num DESC
						""";
				pstmt = conn.prepareStatement(sql);
				// ? 에 값 바인딩
				
				// Select 문 실행하고 결과를 ResultSet 으로 받아온다
				rs = pstmt.executeQuery();
				// 반복문 돌면서 ResultSet 에 담긴 데이터를 추출해서 어떤 객체에 담는다
				while (rs.next()) {
					//
					ProductDto dto = new ProductDto();
					dto.setNum(rs.getInt("num"));
					dto.setName(rs.getString("name"));
					dto.setDescription(rs.getString("description"));
					dto.setPrice(rs.getInt("price"));
					dto.setStatus(rs.getString("status"));
					list.add(dto);
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
			return list;
		}
	}
	


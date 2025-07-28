package dto;

public class BoardDto {
	private int num;
	private String title;
	private String writer;
	private String content;
	private int viewCount;
	private String createdAt;
	
	// 페이징 처리를 위한 필드
	private int startRowNum;
	private int endRowNum;
		
	// 프로필 이미지 출력을 위한 필드 
	private String profileImage;
		
	// 이전글, 다음글 처리를 위한 필드
	private int prevNum;
	private int nextNum;
		
	// 검색 키워드를 담기 위한 필드
	private String keyword;
	
	// 게시판 유형(공지사항/문의사항)정보 필드
	private String boardType;
	
	// default 생성자는 만들지 않아도 있는 것으로 간주됨
	
	
	
	// setter, getter
	public int getNum() {
		return num;
	}
	public void setNum(int num) {
		this.num = num;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getWriter() {
		return writer;
	}
	public void setWriter(String writer) {
		this.writer = writer;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public int getViewCount() {
		return viewCount;
	}
	public void setViewCount(int viewCount) {
		this.viewCount = viewCount;
	}
	public String getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(String createdAt) {
		this.createdAt = createdAt;
	}
	public String getBoardType() {
		return boardType;
	}
	public void setBoardType(String boardType) {
		this.boardType = boardType;
	}
	
}

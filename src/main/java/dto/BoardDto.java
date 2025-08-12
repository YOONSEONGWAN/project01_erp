package dto;

public class BoardDto {
	private int num;
	private String writer;
	private String title;
	private String content;
	private int view_count;
	private String created_at;
	private String board_type;
    private String user_id;
	private int boardNum;
	
	
	
    // 페이징 처리를 위한 필드
 	private int startRowNum;
 	private int endRowNum;
 	
 	// 프로필 이미지 출력을 위한 필드 
 	private String profile_image;
 	
 	// 이전글, 다음글 처리를 위한 필드
 	private int prevNum;
 	private int nextNum;
 	
 	// 검색 키워드를 담기 위한 필드
 	private String keyword;
 	
 	// 지점 회원코드를 공유하기 위한 필드
 	private String branch_id;
 	
 	
 	public void setBoardNum(int boardNum) {
		this.boardNum = boardNum;
	}
	public int getBoardNum() {
		return boardNum;
	}
 	public String getBranch_id() {
 	    return branch_id;
 	}

 	public void setBranch_id(String branch_id) {
 	    this.branch_id = branch_id;
 	}
 	
	public int getNum() {
		return num;
	}

	public void setNum(int num) {
		this.num = num;
	}

	public String getWriter() {
		return writer;
	}

	public void setWriter(String writer) {
		this.writer = writer;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public int getView_count() {
		return view_count;
	}

	public void setView_count(int view_count) {
		this.view_count = view_count;
	}

	public String getCreated_at() {
		return created_at;
	}

	public void setCreated_at(String created_at) {
		this.created_at = created_at;
	}

	public String getBoard_type() {
		return board_type;
	}

	public void setBoard_type(String board_type) {
		this.board_type = board_type;
	}
	public String getUser_id() {
		return user_id;
	}

	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}

	public int getStartRowNum() {
		return startRowNum;
	}

	public void setStartRowNum(int startRowNum) {
		this.startRowNum = startRowNum;
	}

	public int getEndRowNum() {
		return endRowNum;
	}

	public void setEndRowNum(int endRowNum) {
		this.endRowNum = endRowNum;
	}

	public String getProfile_image() {
		return profile_image;
	}

	public void setProfile_image(String profile_image) {
		this.profile_image = profile_image;
	}

	public int getPrevNum() {
		return prevNum;
	}

	public void setPrevNum(int prevNum) {
		this.prevNum = prevNum;
	}

	public int getNextNum() {
		return nextNum;
	}

	public void setNextNum(int nextNum) {
		this.nextNum = nextNum;
	}

	public String getKeyword() {
		return keyword;
	}

	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}
    
 	
}

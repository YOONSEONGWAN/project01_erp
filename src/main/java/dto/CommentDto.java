package dto;

public class CommentDto {
	
	private int num;
	private String writer;
	private String content;
	private String targetUserId;
	private int groupNum;
	private int parentNum;
	private String deleted;
	private String createdAt;
	private String profileImage; // 프로필이미지를 출력하기 위한 필드 
	private String board_type;
	private int boardNum;
	
	// setter, getter
	public int getBoardNum() {
	    return boardNum;
	}
	public void setBoardNum(int boardNum) {
	    this.boardNum = boardNum;
	}

	public void setBoard_type(String board_type) {
		this.board_type = board_type;
	}
	public String getBoard_type() {
		return board_type;
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
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getTargetUserId() {
	    return targetUserId;
	}
	public void setTargetUserId(String targetUserId) {
	    this.targetUserId = targetUserId;
	}
	
	public int getGroupNum() {
		return groupNum;
	}
	public void setGroupNum(int groupNum) {
		this.groupNum = groupNum;
	}
	public int getParentNum() {
		return parentNum;
	}
	public void setParentNum(int parentNum) {
		this.parentNum = parentNum;
	}
	public String getDeleted() {
		return deleted;
	}
	public void setDeleted(String deleted) {
		this.deleted = deleted;
	}
	public String getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(String createdAt) {
		this.createdAt = createdAt;
	}
	public String getProfileImage() {
		return profileImage;
	}
	public void setProfileImage(String profileImage) {
		this.profileImage = profileImage;
	}

}


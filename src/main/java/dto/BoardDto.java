package dto;

public class BoardDto {
	private int num;
	private String writer;
	private String title;
	private String content;
	private int view_count;
	private String created_at;
	private String board_type;
    private Long parent_num; // null 허용
    private String target_user_id;
    private String user_id;
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
	public Long getParent_num() {
		return parent_num;
	}
	public void setParent_num(Long parent_num) {
		this.parent_num = parent_num;
	}
	public String getTarget_user_id() {
		return target_user_id;
	}
	public void setTarget_user_id(String target_user_id) {
		this.target_user_id = target_user_id;
	}
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
    
    
}

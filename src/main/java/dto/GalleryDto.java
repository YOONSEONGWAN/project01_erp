package dto;

import java.util.List;

public class GalleryDto {
	private int num;
	private String title;
	private String writer;
	private String content;
	private String createdAt;
	
	private List<GalleryImageDto> imageList;
	
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
	public String getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(String createdAt) {
		this.createdAt = createdAt;
	}
	public List<GalleryImageDto> getImageList() {
		return imageList;
	}
	public void setImageList(List<GalleryImageDto> imageList) {
		this.imageList = imageList;
	}
	
	
	
	
}

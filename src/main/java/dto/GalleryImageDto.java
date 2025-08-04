package dto;

public class GalleryImageDto {
	private	int num;
	// gallery table 의 PK 참조 
	private int galleryNum;
	private String saveFileName;
	private String createdAt;
	
	
	public int getNum() {
		return num;
	}
	public void setNum(int num) {
		this.num = num;
	}
	public int getGalleryNum() {
		return galleryNum;
	}
	public void setGalleryNum(int galleryNum) {
		this.galleryNum = galleryNum;
	}
	public String getSaveFileName() {
		return saveFileName;
	}
	public void setSaveFileName(String saveFileName) {
		this.saveFileName = saveFileName;
	}
	public String getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(String createdAt) {
		this.createdAt = createdAt;
	}
	
	
}

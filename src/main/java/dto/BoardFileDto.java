package dto;

import java.util.Date;

public class BoardFileDto {
	 private int num;
	 private int boardNum;
	 private String boardType;
	 private String orgFileName;
	 private String saveFileName;
	 private long fileSize;
	 private Date createdAt;
	 public int getNum() {
		 return num;
	 }
	 public void setNum(int num) {
		 this.num = num;
	 }
	 public int getBoardNum() {
		 return boardNum;
	 }
	 public void setBoardNum(int boardNum) {
		 this.boardNum = boardNum;
	 }
	 public String getBoardType() {
		 return boardType;
	 }
	 public void setBoardType(String boardType) {
		 this.boardType = boardType;
	 }
	 public String getOrgFileName() {
		 return orgFileName;
	 }
	 public void setOrgFileName(String orgFileName) {
		 this.orgFileName = orgFileName;
	 }
	 public String getSaveFileName() {
		 return saveFileName;
	 }
	 public void setSaveFileName(String saveFileName) {
		 this.saveFileName = saveFileName;
	 }
	 public long getFileSize() {
		 return fileSize;
	 }
	 public void setFileSize(long fileSize) {
		 this.fileSize = fileSize;
	 }
	 public Date getCreatedAt() {
		 return createdAt;
	 }
	 public void setCreatedAt(Date createdAt) {
		 this.createdAt = createdAt;
	 }
	 
	 
}

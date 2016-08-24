package model;

/**
 * @author lw
 * 管理网盘信息的类
 */
public class MyDiskInfo {
	private Long id;
	private Long user_id;
	private long totalSize;
	private long usedSize;
	private int	 fileNumber;
	private int  shareNumber;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getUser_id() {
		return user_id;
	}
	public void setUser_id(Long userId) {
		user_id = userId;
	}
	public long getTotalSize() {
		return totalSize;
	}
	public void setTotalSize(long totalSize) {
		this.totalSize = totalSize;
	}
	public long getUsedSize() {
		return usedSize;
	}
	public void setUsedSize(long usedSize) {
		this.usedSize = usedSize;
	}
	public void setFileNumber(int fileNumber) {
		this.fileNumber = fileNumber;
	}
	public int getFileNumber() {
		return fileNumber;
	}
	public void setShareNumber(int shareNumber) {
		this.shareNumber = shareNumber;
	}
	public int getShareNumber() {
		return shareNumber;
	}
}

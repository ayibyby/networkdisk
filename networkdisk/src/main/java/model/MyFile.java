package model;

/**
 * @author me
 *
 */
public class MyFile {
	private Long 		id;
	private Long 		user_id;
	private Long		parent_id;
	private long		size;
	private String  	path;
	private String 		name;
	private String 		type;
	private String 		password;
	private int 		isLock;
	private int 		isShare;
	private int 		shareDownload;
	private String 		md5;
	private String 		description;
	private String 		location;
	private String 		shareUrl;
	private String 		createDate;
	
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
	public long getSize() {
		return size;
	}
	public void setSize(long size) {
		this.size = size;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getMd5() {
		return md5;
	}
	public void setMd5(String md5) {
		this.md5 = md5;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public void setParent_id(Long parent_id) {
		this.parent_id = parent_id;
	}
	public Long getParent_id() {
		return parent_id;
	}
	public void setPath(String path) {
		this.path = path;
	}
	public String getPath() {
		return path;
	}
	public void setLocation(String location) {
		this.location = location;
	}
	public String getLocation() {
		return location;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getPassword() {
		return password;
	}
	public void setIsLock(int isLock) {
		this.isLock = isLock;
	}
	public int getIsLock() {
		return isLock;
	}
	public void setIsShare(int isShare) {
		this.isShare = isShare;
	}
	public int getIsShare() {
		return isShare;
	}
	public void setShareDownload(int shareDownload) {
		this.shareDownload = shareDownload;
	}
	public int getShareDownload() {
		return shareDownload;
	}
	public void setShareUrl(String shareUrl) {
		this.shareUrl = shareUrl;
	}
	public String getShareUrl() {
		return shareUrl;
	}
	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}
	public String getCreateDate() {
		return createDate;
	}
}

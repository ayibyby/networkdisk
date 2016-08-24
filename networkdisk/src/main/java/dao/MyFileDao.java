package dao;

import java.util.List;

import model.MyFile;
import util.DaoSupport;

public class MyFileDao {
	
	/**
	 * 持久化myFile
	 * @param myFile
	 * @return
	 */
	public static long save(MyFile myFile){
		String sql = "insert into myfile(user_id,parent_id,name,path,location,description,size,md5,type) values(?,?,?,?,?,?,?,?,?)";
		Object params[] = {myFile.getUser_id(),myFile.getParent_id(),
				myFile.getName(),myFile.getPath(),myFile.getLocation(),myFile.getDescription(),myFile.getSize(),myFile.getMd5(),myFile.getType()};
	
		return DaoSupport.save(sql, params);
	}
	
	/**
	 * 返回某用户的根目录的id，该目录的目录名就是所属用户的id好号
	 * @param userId
	 * @return
	 */
	public static int getHomeId(long userId){
		String sql = "select id from myfile where name = '#" + userId + "'";
		return (Integer) DaoSupport.query(sql);
	}
	
	/**
	 * 返回指定的myfile
	 * @param id
	 * @return
	 */
	public static MyFile getMyFile(long id){
		String sql = "select * from myfile where id =" + id;
		return (MyFile) DaoSupport.queryOne(sql, null, MyFile.class);
	}
	
	/**
	 * 返回文件夹内的所有文件
	 * @param folderId
	 * @return
	 */
	public static List<MyFile> getFilesByFolderId(long folderId){
		String sql = "select id,user_id,name,size,type,islock,isshare from myfile where parent_id ="+ folderId +" order by type asc";
		return DaoSupport.query(sql,null,MyFile.class);
	}
	
	/**
	 * @param id
	 * @return
	 */
	public static String getPath(long id){
		String sql = "select path from myfile where id = " + id;
		return (String) DaoSupport.query(sql);
	}
	
	/**
	 * 返回指定id的fileName
	 * @param id
	 * @return
	 */
	public static String getFileName(long id){
		String sql = "select filename from myfile where id =" + id;
		return (String) DaoSupport.query(sql);
	}
	
	/**
	 * delete myfile by certain id
	 * @param id
	 */
	public static void deleteById(long id,long uId){
		String sql = "delete from myfile where id=" + id + " and user_id=" + uId;
		System.out.println(sql);
		DaoSupport.update(sql, null);
	}
	
	/**
	 * 重命名指定id的myfile
	 * @param fileId
	 * @param fileName
	 */
	public static void rename(long fileId,String fileName){
		String sql = "update myfile set name = '" + fileName + "' where id=" + fileId;
		DaoSupport.update(sql, null);
	}
	
	/**
	 * 分享指定的文件
	 * @param fileId
	 */
	public static void share(MyFile myFile){
		String sql = "update myfile set isshare = 1,shareurl = ? where id = ?";
		Object[] param = {myFile.getShareUrl(),myFile.getId()};
		DaoSupport.update(sql, param);
	}
	
	/**
	 * 取消分享
	 * @param fileId
	 */
	public static void cancelShare(long fileId){
		String sql = "update myfile set isshare = 0 where id =" + fileId;
		DaoSupport.update(sql, null);
	}
	
	
	/**
	 * 返回某用户的所有共享文件
	 * @param userId
	 * @return
	 */
	public static List<MyFile> loadAllShareByUser(long userId){
		String sql = "select * from myfile where isshare = 1 and user_id = " + userId;
		return DaoSupport.query(sql, null, MyFile.class);
	}
	
	/**
	 * 更新分享下载数
	 * @param fileId
	 */
	public static void updateShareDownload(long fileId){
		String sql = "update myfile set sharedownload = sharedownload + 1 where id =" + fileId;
		DaoSupport.update(sql, null);
	}
	/**
	 * 给文件指定密码
	 * @param fileIId
	 * @param pwd
	 */
	public static void addLock(long fileId,String pwd){
		String sql = "update myfile set password = ?,islock = 1 where id = ?";
		Object param[] = {pwd,fileId};
		DaoSupport.update(sql, param);
	}
	
	/**
	 * 为文件解锁
	 * @param fileId
	 */
	public static void deleteLock(long fileId){
		String sql = "update myfile set password = '',islock = 0 where id =" + fileId;
		DaoSupport.update(sql, null);
	}
}

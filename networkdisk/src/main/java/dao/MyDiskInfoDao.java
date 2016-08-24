package dao;

import model.MyDiskInfo;
import model.MyFile;
import util.DaoSupport;

public class MyDiskInfoDao {
	
	/**
	 * 获取对应用户的网盘使用情况
	 * @param userId
	 * @return
	 */
	public static MyDiskInfo load(Long userId){
		String sql = "select totalsize,usedsize,filenumber from mydiskinfo where user_id =" + userId;
		return (MyDiskInfo) DaoSupport.queryOne(sql, null, MyDiskInfo.class);
	}
	/**
	 * @param myFile
	 * 检查用户的网盘空间是否耗尽
	 */
	public static boolean isEnoughSpace(MyFile myFile){
		String sql = "select totalsize,usedsize from mydiskinfo where user_id = ?";
		Object param[] = {myFile.getUser_id()};
		
		MyDiskInfo dInfo = (MyDiskInfo) DaoSupport.queryOne(sql, param, MyDiskInfo.class);
		
		if(dInfo.getTotalSize() > (dInfo.getUsedSize()+myFile.getSize()) ){
			return true;
		}
		return false;
	}
}

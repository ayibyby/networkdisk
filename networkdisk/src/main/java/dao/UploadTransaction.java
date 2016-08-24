package dao;

import java.sql.Connection;
import java.sql.SQLException;

import model.MyFile;

import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.ScalarHandler;

import util.TransactionUtil;

public class UploadTransaction {
	/**
	 * 数据插入成功则返回一个myFIle，否则返回null
	 * @param myFile
	 * @return
	 */
	public static MyFile upload(MyFile myFile) {
		TransactionUtil.startTransaction();
		Connection conn = TransactionUtil.getConnection();
		QueryRunner runner = new QueryRunner();
		
		String sql0 = "insert into myfile(user_id,parent_id,name,path,location,description,size,md5,type)"
					+ "values(?,?,?,?,?,?,?,?,?)";
		String sql1 = "update mydiskinfo set usedsize = usedsize + ? where user_id = ?";
		String sql2 = "update mydiskinfo set filenumber = filenumber + 1 where user_id = ?";
		
		Object param0[] = { myFile.getUser_id(), myFile.getParent_id(),
				myFile.getName(), myFile.getPath(), myFile.getLocation(),
				myFile.getDescription(), myFile.getSize(), myFile.getMd5(),
				myFile.getType()};
		Object param1[] = {myFile.getSize(),myFile.getUser_id()};
		Object param2[] = {myFile.getUser_id()};
		
		Long file_id = null;
		try {
			runner.update(conn, sql1, param1);//修改个人网盘信息（已用容量）
			runner.update(conn, sql0, param0);//插入上传文件记录
			file_id = Long.valueOf(runner.query(conn, "select LAST_INSERT_ID()", new ScalarHandler<Object>())+"");
			runner.update(conn, sql2, param2);
			
			TransactionUtil.commit();
			
			myFile.setId(file_id);
		} catch (SQLException e) {
			TransactionUtil.rollback();
			e.printStackTrace();
			throw new RuntimeException();
		} finally {
			TransactionUtil.close();
		}

		return myFile;
	}
}

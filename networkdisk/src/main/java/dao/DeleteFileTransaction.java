package dao;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

import model.MyFile;

import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.BeanListHandler;

import util.TransactionUtil;

public class DeleteFileTransaction {
	/**
	 * 删除文件夹
	 * @param folder
	 * @return
	 */
	public static List<MyFile> deleteFolder(MyFile folder) {
		
		TransactionUtil.startTransaction();
		Connection conn = TransactionUtil.getConnection();
		QueryRunner runner = new QueryRunner();
		
		String concat = "concat((select path from myfile where id =" + folder.getId() + "),'" + folder.getId() + "/%')";
		
		String sql0 = "select location,id,user_id from myfile where path like " + concat +
					"and type!='adir' order by id desc";
		
		String sql1 = "delete from myfile where id = ? and user_id = ?"; //防止user_id为空。文件夹已经设置了级联删除
		String sql2 = "update mydiskinfo set filenumber = (select count(*) from myfile where user_id = ? and type !='adir')";
		String sql3 = "update mydiskinfo set usedsize = (select sum(size) from myfile where user_id = ?) where user_id = ?";
		
		Object param1[] = {folder.getId(),folder.getUser_id()};
		Object param2[] = {folder.getUser_id()};
		Object param3[] = {folder.getUser_id(),folder.getUser_id()};
		
		List<MyFile> myFiles = null;
		try {
			/* 
			 * 返回已经被删除的myFile，以便根据
			 * 他们的loaction从磁盘上把对应的文件删除
			 */
			myFiles = runner.query(conn, sql0, new BeanListHandler<MyFile>(MyFile.class));
			
			runner.update(conn, sql1, param1);//删除文件夹及其所有子目录和子文件
			runner.update(conn, sql2, param2);
			runner.update(conn, sql3, param3);//修改网盘容量
			
			TransactionUtil.commit();
		} catch (SQLException e) {
			TransactionUtil.rollback();
			e.printStackTrace();
			throw new RuntimeException();
		} finally {
			TransactionUtil.close();
		}
		
		return myFiles;
	}
	
	/**
	 * 删除单个文件（非文件夹）
	 * @param file
	 */
	public static void deleteFile(MyFile file){
		TransactionUtil.startTransaction();
		Connection conn = TransactionUtil.getConnection();
		QueryRunner runner = new QueryRunner();
		
		String sql0 = "delete from myfile where id = ? and user_id = ?";//防止user_id为空的情况
		String sql1 = "update mydiskinfo set usedsize = (select sum(size) from myfile where user_id = ?) where user_id = ?";
		String sql2 = "update mydiskinfo set filenumber = filenumber - 1 where user_id = ?";
		
		Object param0[] = {file.getId(),file.getUser_id()};
		Object param1[] = {file.getUser_id(),file.getUser_id()};
		Object param2[] = {file.getUser_id()};
		try {
			runner.update(conn, sql0, param0);//删除文件
			runner.update(conn, sql1, param1);//同步更新磁盘容量
			runner.update(conn, sql2, param2);
			
			TransactionUtil.commit();
		} catch (SQLException e) {
			TransactionUtil.rollback();
			e.printStackTrace();
			throw new RuntimeException();
		} finally {
			TransactionUtil.close();
		}
	}
}

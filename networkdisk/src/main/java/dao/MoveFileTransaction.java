package dao;

import java.sql.Connection;
import java.sql.SQLException;

import model.MyFile;

import org.apache.commons.dbutils.QueryRunner;

import util.TransactionUtil;

public class MoveFileTransaction {
	
	public static void moveFile(MyFile sourceFile,MyFile targetFile){
		TransactionUtil.startTransaction();
		Connection conn = TransactionUtil.getConnection();
		QueryRunner runner = new QueryRunner();
	
		try {
			if(sourceFile.getType().equals("adir")){
				String sql0 = "update myfile set path = replace(path,?,?) where path like ?";
				Object param0[] = {sourceFile.getPath(),targetFile.getPath() + targetFile.getId() + "/", sourceFile.getPath() + sourceFile.getId() + "/%"};
				runner.update(conn, sql0, param0);
			}
			
			String sql1 = "update myfile set parent_id=? , path = ? where id = ?";
			Object param1[] = {targetFile.getId(),targetFile.getPath()+targetFile.getId()+"/",sourceFile.getId()};
			runner.update(conn, sql1, param1);
			
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

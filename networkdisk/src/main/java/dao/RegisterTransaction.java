package dao;

import java.sql.Connection;
import java.sql.SQLException;

import model.User;

import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.ScalarHandler;

import util.TransactionUtil;

public class RegisterTransaction {
	
	/**
	 * 用户注册，初始化用户的一些默认信息（碗盘容量，教程文件）
	 * @param user
	 * @return
	 */
	public static User register(User user,long initSize) {
		TransactionUtil.startTransaction();
		Connection conn = TransactionUtil.getConnection();
		QueryRunner runner = new QueryRunner();
		String sql0 = "insert into user (email,username,password,joindate,gender,portrait) " +
					"values(?,?,md5(?),?,?,'portrait')";
		String sql1 = "insert into mydiskinfo values(?,?,?,0,?)";
		String sql2 = "insert into myfile (user_id,parent_id,name,path,type,size) values(?,?,?,?,'adir',0)";
	
		Object param0[] = {user.getEmail(),user.getUsername(),user.getPassword(),
							user.getJoindate(),user.getGender()};
		
		Long uID = null,homeID = null;
		try {
			runner.update(conn, sql0, param0);
			
			uID = Long.valueOf(runner.query(conn, "select LAST_INSERT_ID()", new ScalarHandler<Object>())+"");
			Object param1[] = {null,uID,initSize,0};//每个用户1M的初始空间
			Object param2[] = {uID,null,"#"+uID,"/"};
			
			runner.update(conn, sql1, param1);
			runner.update(conn, sql2 ,param2);
			
			homeID = Long.valueOf(runner.query(conn, "select LAST_INSERT_ID()", new ScalarHandler<Object>())+"");
			
			String path = "/" + homeID + "/";
			Object param3[][] = {
				{uID,homeID,"我的文档",path},
				{uID,homeID,"我的音乐",path},
				{uID,homeID,"我的相册",path},
				{uID,homeID,"我的图书",path}
			};
			for(Object pam[]:param3){
				runner.update(conn, sql2, pam);
			}
			
			user.setId(uID);
			user.setPortrait("portrait");
			TransactionUtil.commit();
		} catch (SQLException e) {
			TransactionUtil.rollback();
			e.printStackTrace();
			throw new RuntimeException();
		} finally{
			TransactionUtil.close();
		}
		
		return user;
	}
}

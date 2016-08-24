package dao;

import util.DaoSupport;
import model.Message;

public class MessageDao {
	public static void save(Message message){
		String sql  = "insert into message values(null,?,?,?,?,?)";
		Object[] param = {message.getUser_id(),message.getEmail(),message.getUsername(),message.getTitle(),message.getContent()};
		DaoSupport.update(sql, param);
	}
}
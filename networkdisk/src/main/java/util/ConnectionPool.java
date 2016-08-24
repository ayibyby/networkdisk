package util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;
import javax.sql.DataSource;
import com.mysql.jdbc.jdbc2.optional.MysqlConnectionPoolDataSource;

public class ConnectionPool {
	private static MiniConnectionPool miniConnectionPool;
	private static MysqlConnectionPoolDataSource dataSource;
	
	static{
		InputStream input 	= ConnectionPool.class.getClassLoader().getResourceAsStream("database.properties");
		Properties 	prop	= new Properties();
		try {
			prop.load(input);
		} catch (IOException e) {
			e.printStackTrace();
		}
		dataSource = new MysqlConnectionPoolDataSource();
		dataSource.setUser(prop.getProperty("user"));
		dataSource.setPassword(prop.getProperty("password"));
		dataSource.setServerName(prop.getProperty("host"));
		dataSource.setPort(Integer.parseInt(prop.getProperty("port")));
		dataSource.setDatabaseName(prop.getProperty("database"));
		dataSource.setCharacterEncoding(prop.getProperty("charactereEncoding"));
		dataSource.setNoAccessToProcedureBodies(true);
		miniConnectionPool = new MiniConnectionPool(dataSource,20,120);
	}
	public static Connection getConnection() throws SQLException{
		return miniConnectionPool.getConnection();
	}	
	public static DataSource getDataSource(){
		return (DataSource)dataSource;
	}
}

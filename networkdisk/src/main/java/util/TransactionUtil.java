package util;

import java.sql.Connection;
import java.sql.SQLException;

public class TransactionUtil {
	private static ThreadLocal<Connection> container = new ThreadLocal<Connection>();
	/**
	 * 获取当前线程上的连接 开启事务
	 */
	public static void startTransaction() {
		Connection conn = container.get();// 首先获取当前线程的连接
		if (conn == null) {
			conn = getConn();
			container.set(conn);
		}
		try {
			conn.setAutoCommit(false);
		} catch (SQLException e) {
			throw new RuntimeException(e.getMessage(), e);
		}
	}

	/**
	 * 提交事务
	 */
	public static void commit() {
		Connection conn = container.get();// 从当前线程上获取连接
		if (conn != null) {
			try {
				conn.commit();
			} catch (SQLException e) {
				throw new RuntimeException(e.getMessage(), e);
			}
		}
	}

	/**
	 *回滚事务
	 */
	public static void rollback() {
		Connection conn = container.get();// 检查当前线程是否存在连接
		if (conn != null) {
			try {
				conn.rollback();
			} catch (SQLException e) {
				throw new RuntimeException(e.getMessage(), e);
			}
		}
	}

	/**
	 * 关闭连接
	 */
	public static void close() {
		Connection conn = container.get();
		if (conn != null) {
			try {
				conn.close();
			} catch (SQLException e) {
				throw new RuntimeException(e.getMessage(), e);
			} finally {
				container.remove();
			}
		}
	}
	
	/**
	 * @return
	 */
	public static Connection getConnection(){
		return container.get();
	}
	/**
	 * 获取数据库连接
	 * @return 数据库连接 连接方式
	 */
	private static Connection getConn() {
		try {
			return ConnectionPool.getConnection();
		} catch (Exception e) {
			throw new RuntimeException();
		}
	}
}

package util;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.BeanHandler;
import org.apache.commons.dbutils.handlers.BeanListHandler;
import org.apache.commons.dbutils.handlers.ScalarHandler;


public class DaoSupport {
	private static Connection 	conn 	= null;
	private static QueryRunner 	runner 	= new QueryRunner();
	/*初始化connection，用于runner的查询*/
	private static void initConn(){
		try {
			conn = ConnectionPool.getConnection();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	/*关闭connection资源*/
	private static void closeConn(){
		if(conn != null){
			try {
				conn.close();
				conn = null;
			} catch (SQLException e) {
				e.printStackTrace();
			}	
		}
	}
	/**
	 * 保存一个对象。所有写了getters的属性都会被保存。
	 * @param bean
	 * @return
	 */
	public static long save(Object bean){
		DBParams DBP = VirtualORM.save(bean);
		String sql = DBP.getSql();
		Object[] params = DBP.getParams();
		long id = 0;
		try {
			DaoSupport.initConn();
			runner.update(conn, sql, params);
			id = Long.valueOf(runner.query(conn, "SELECT LAST_INSERT_ID()", new ScalarHandler<Object>())+"");
		} catch (SQLException e) {
			e.printStackTrace();
			throw new RuntimeException();
		}finally{
			DaoSupport.closeConn();
		}
		return id;
	}
	/**
	 * 保存一个对象，并返回该对象的id
	 * @param sql update语句
	 * @param param sql 用到的参数
	 * @return
	 */
	public static long save(String sql,Object[] params){
		initConn();
		long id = 0;
		try {
			runner.update(conn, sql, params);
			id = Long.valueOf(runner.query(conn, "SELECT LAST_INSERT_ID()", new ScalarHandler<Object>())+"");
		} catch (SQLException e) {
			e.printStackTrace();
			throw new RuntimeException();
		}finally{
			closeConn();
		}
		return id;
	}
	/**
	 * 更新一条记录。
	 * @param bean 要更新的持久化对象
	 * @param columns 要更新的列
	 * @param whereSql 更新的条件
	 */
	public static void update(Object bean,String[] columns,String whereSql){
		DBParams DBP = VirtualORM.update(bean, columns, whereSql);
		String sql = DBP.getSql();
		Object[] params = DBP.getParams();
		
		try {
			DaoSupport.initConn();
			runner.update(conn, sql, params);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new RuntimeException();
		}finally{
			DaoSupport.closeConn();
		}
	}
	/**
	 * 执行一条update语句，没有返回值
	 * @param sql
	 * @param param
	 */
	public static void update(String sql,Object param[]){
		initConn();
		try {
			runner.update(conn, sql, param);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new RuntimeException();
		}finally{
			closeConn();
		}
	}
	
	/**
	 * 执行一条select语句，返回一个对象的list。
	 * 查询的结果中将不包含exceptColumns中声明的字段
	 * @param <T>
	 * @param exceptColumns
	 * @param whereSql
	 * @param beanClass
	 * @return
	 */
	public static <T> List<T> queryExcept(Class<T> beanClass,String exceptColumns[],Object param[],String whereSql){
		initConn();
		List<T> result = null;
		String sql  = VirtualORM.selectExcept(beanClass, exceptColumns, whereSql);
		
		try {	
			result = (List<T>) runner.query(conn, sql,new BeanListHandler<T>(beanClass),param);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new RuntimeException();
		}finally{
			closeConn();
		}
		
		/*长度为0的元素没有意义，所以在此过滤掉，返回null*/
		if(result == null || result.size() == 0){
			result = null;
		}
		return result;
	}
	
	/**
	 * 执行一条select语句，返回一个对象的list。
	 * 查询的结果中将包含columns中声明的字段
	 * @param <T>
	 * @param columns
	 * @param whereSql
	 * @param beanClass
	 * @return
	 */
	public static <T> List<T> query(Class<T> beanClass,String columns[],Object param[],String whereSql){
		initConn();
		List<T> result = null;
		String sql  = VirtualORM.select(beanClass.getName(),columns, whereSql);
		
		try {	
			result = (List<T>) runner.query(conn, sql,new BeanListHandler<T>(beanClass),param);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new RuntimeException();
		}finally{
			closeConn();
		}
		
		/*长度为0的元素没有意义，所以在此过滤掉，返回null*/
		if(result == null || result.size() == 0){
			result = null;
		}
		return result;
	}
	
	/**
	 * 执行一条select语句，返回一个对象的list
	 * @param sql
	 * @param param
	 * @param beanClass
	 * @return
	 */
	public static <T> List<T> query(String sql,Object param[],Class<T> beanClass){
		initConn();
		List<T> result = null;
		try {	
			result = (List<T>) runner.query(conn, sql,new BeanListHandler<T>(beanClass), param);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new RuntimeException();
		}finally{
			closeConn();
		}
		
		/*长度为0的元素没有意义，所以在此过滤掉，返回null*/
		if(result == null || result.size() == 0){
			result = null;
		}
		return result;
	}
	/**
	 * 执行一条select语句，该语句只返回一条记录
	 * @param <T>
	 * @param sql
	 * @param param
	 * @param beanClass
	 * @return 
	 * @return
	 */
	public static <T> Object queryOne(String sql,Object[] param,Class<T> beanClass){
		initConn();
		Object result = null;
		try {
			result = runner.query(conn,sql,new BeanHandler<T>(beanClass), param);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new RuntimeException();
		}finally{
			closeConn();
		}
		return result;
	}
	/**
	 * 执行一条select语句，将查询columns中指明的字段。该语句只返回一条记录
	 * @param <T>
	 * @param sql
	 * @param param
	 * @param beanClass
	 * @return 
	 * @return
	 */
	public static <T> Object queryOne(Class<T> beanClass,String columns[],Object param[],String whereSql){
		initConn();
		Object result = null;
		String sql  = VirtualORM.select(beanClass.getName(),columns, whereSql);
		
		try {	
			result = runner.query(conn, sql,new BeanHandler<T>(beanClass),param);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new RuntimeException();
		}finally{
			closeConn();
		}
		return result;
	}
	/**
	 * 执行一条select语句，将不查询exceptColumns中指明的字段。该语句只返回一条记录
	 * @param <T>
	 * @param exceptColumns
	 * @param whereSql
	 * @param beanClass
	 * @return
	 */
	public static <T> Object queryOntExcept(Class<T> beanClass,String exceptColumns[],Object param[],String whereSql){
		initConn();
		Object result = null;
		String sql  = VirtualORM.selectExcept(beanClass, exceptColumns, whereSql);
		
		try {	
			result = runner.query(conn, sql,new BeanHandler<T>(beanClass),param);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new RuntimeException();
		}finally{
			closeConn();
		}
		return result;
	}
	
	/**
	 * 用于查询单列数据。例如执行"select count() from"这样的sql语句
	 * @param <T>
	 * @param sql
	 * @return
	 */
	public static <T> Object query(String sql){
		initConn();
		Object result = null;
		try {
			result = runner.query(conn,sql,new ScalarHandler<T>());
		} catch (SQLException e) {
			e.printStackTrace();
			throw new RuntimeException();
		}finally{
			closeConn();
		}
		return result;
	}
	/**
	 * 执行一条delete语句，没有返回值
	 * @param sql
	 * @param param
	 */
	public static void delete(String sql,Object[] param){
		initConn();
		try {
			runner.update(conn, sql, param);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new RuntimeException();
		}finally{
			closeConn();
		}
	}
}

package util;

/**
 * 
 * @author lw
 */
public class DBParams {
	private String sql = "";
	private Object[] params;
	
	public String getSql() {
		return sql.toLowerCase();
	}
	public void setSql(String sql) {
		this.sql = sql;
	}
	public Object[] getParams() {
		return params;
	}
	public void setParams(Object[] params) {
		this.params = params;
	}
}

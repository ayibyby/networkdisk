package util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * 读取storage.properties配置文件，获得上传文件的根目录。
 * 主要是为了存储位置的灵活配置。
 * @author lw
 */
public class FileStorage {
	/**
	 * 读取storage.properties配置文件，获得上传文件的根目录。
	 * @return
	 */
	public static String getFilePath(){
		return getProperties().getProperty("file_path");
	}
	
	/**
	 * 获取临时肖像图片路径
	 * @return
	 */
	public static String getTempPortraitPath(){
		return getProperties().getProperty("temp_portrait_path");
	}
	
	/**
	 * 获取肖像图片路径
	 * @return
	 */
	public static String getPortraitPath(){
		return getProperties().getProperty("portrait_path");
	}
	
	/**
	 * 获得配置
	 * @return
	 */
	private static Properties getProperties(){
		InputStream input 	= ConnectionPool.class.getClassLoader().getResourceAsStream("storage.properties");
		Properties 	prop	= new Properties();
		try {
			prop.load(input);
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return prop;
	}
}

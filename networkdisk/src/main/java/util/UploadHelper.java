package util;

import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

public class UploadHelper {
	/**
	 * 从request中取得批量上传的文件
	 * @param request
	 * @return
	 */
	public List<MultipartFile> getFiles(HttpServletRequest request) {
		MultipartHttpServletRequest req = (MultipartHttpServletRequest) request;
		Map<String, MultipartFile> map = req.getFileMap();
		List<MultipartFile> fileList = new ArrayList<MultipartFile>();
		for (Object obj : map.values()) {
			MultipartFile file = (MultipartFile) obj;
			fileList.add(file);
		}
		return fileList;
	}
	
	/**
	 * 从request中取得特定的文件
	 * @param request
	 * @param fileName
	 * @return
	 */
	public MultipartFile getFile(HttpServletRequest request,String fileName){
		MultipartHttpServletRequest req = (MultipartHttpServletRequest) request;
		return req.getFile(fileName);
	}
	
	public void upload(List<MultipartFile> files){
		
	}
	
	public void upload(MultipartFile file,String path) throws IOException{
		FileOutputStream out = new FileOutputStream(path);
		FileCopyUtils.copy(file.getBytes(), out);
	}
}

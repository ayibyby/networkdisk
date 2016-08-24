package util;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import javax.servlet.http.HttpServletResponse;

import model.MyFile;

/**
 * @author lw
 */
public class DownloadSupport {
	public static void download(HttpServletResponse response,MyFile myFile){
		String fileName = "unknown";
		try {
			fileName = URLEncoder.encode(myFile.getName(), "UTF-8").replace("+", "%20");
		} catch (UnsupportedEncodingException e1) {
			e1.printStackTrace();
		}
		
		response.reset();
        response.setContentType("APPLICATION/OCTET-STREAM");
        response.setHeader("Content-Length", myFile.getSize()+"");
        response.setHeader("Content-Disposition", "attachment;filename=\"" + 
        					myFile.getName() + "\";filename*=utf-8''"+fileName);
        
        PrintWriter out = null;
        FileInputStream in = null;
		try {
			in = new FileInputStream(myFile.getLocation());
			out = response.getWriter();
			int b;
			while ((b = in.read()) != -1) {
				out.write(b);
			}
			out.flush();
		} catch (IOException e) {
			e.printStackTrace();
		}finally{
			if(out!=null){
				out.close();
			}
			if(in!=null){
				try {
					in.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}
}

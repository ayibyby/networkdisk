package controller;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;

import model.User;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import util.ImgTool;
import util.UploadHelper;
import dao.UserDao;

@Controller
@RequestMapping("/u")
public class UserSettingController extends Support{
	private static final String UPLOADPATH = "/user/temp_portrait/";
	private static final String PORTRAITPATH = "/user/portrait/";
	
	/**
	 * 更改用户名
	 * @param username
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/change_username",method=RequestMethod.POST)
	public String changeUsername(String username){
		User user = (User)session.getAttribute("user");		
		
		if(user != null){
			user.setUsername(username);
			UserDao.updateUsername(user);
			return "1";
		}
		return "0";
	}
	
	/**
	 * 更改email
	 * @param password
	 * @param email
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/change_email",method=RequestMethod.POST)
	public String changeEmail(String password,String email){
		User user = (User)session.getAttribute("user");
		
		user.setPassword(password);

		if(UserDao.confirm(user)!=null){
			user.setEmail(email);
			UserDao.updateEmail(user);
			System.out.println(((User)session.getAttribute("user")).getEmail());
			return "1";
		}
		
		return "0";
	}
	
	/**
	 * 更改密码
	 * @param oldPwd
	 * @param newPwd
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/change_pwd",method=RequestMethod.POST)
	public String changePassword(String oldPwd,String newPwd){
		User user = (User)session.getAttribute("user");
		user.setPassword(oldPwd);
		if(UserDao.confirm(user)!=null){
			user.setPassword(newPwd);
			UserDao.updatePassword(user);
			return "1";
		}
		return "0";
	}
	
	@ResponseBody
	@RequestMapping(value="/change_portrait",method=RequestMethod.POST)
	public String changePortrait(int x,int y,int width,int height,String imgName){
		User user = (User) session.getAttribute("user");
		
		if(imgName.trim().equals("")) return "";
		
		String realPath = session.getServletContext().getRealPath("/");
		ImgTool imgT = new ImgTool();
		
		imgT.cut(realPath+UPLOADPATH+imgName, x, y, width, height);
		imgT.save("jpg", user.getId()+".jpg", realPath+PORTRAITPATH, 120, 120);
		
		if(user.getPortrait().equals("portrait")){
			UserDao.updatePortrait(user.getId());
			user.setPortrait(user.getId()+"");
		}
		
		return user.getId()+".jpg";
	}
	
	@ResponseBody
	@RequestMapping(value="/upload_portrait",method=RequestMethod.POST)
	public String uploadPortrait(HttpServletRequest request){
		UploadHelper upload = new UploadHelper();
		MultipartFile file = upload.getFiles(request).get(0);
		User user = (User) session.getAttribute("user");
		
		String realPath = session.getServletContext().getRealPath(UPLOADPATH);
		String fileName = file.getOriginalFilename();
		String suffix = fileName.substring(fileName.lastIndexOf(".")+1).toLowerCase();
		String imgName = user.getId()+"."+suffix;
		try {
			upload.upload(file, realPath+"/"+imgName);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return imgName;
	}
	
	@RequestMapping("/setting")
	public String userSetting(){
		return "user_setting";
	}
}

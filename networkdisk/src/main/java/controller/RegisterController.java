package controller;

import java.text.SimpleDateFormat;
import java.util.Date;

import model.User;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import dao.MyDiskInfoDao;
import dao.MyFileDao;
import dao.RegisterTransaction;
import dao.UserDao;

@Controller
@RequestMapping("/register")
public class RegisterController extends Support{
	
	/*网盘的初始容量*/
	private static final long DEFAULT_TOTAL_SIZE = 1024*1024*5;
	
	/**
	 * 用户注册
	 * @param user
	 * @return
	 */
	@RequestMapping("/welcome")
	public String register(User user){
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月dd日(E)");
		
		user.setJoindate(sdf.format(new Date()));		
		user = RegisterTransaction.register(user,DEFAULT_TOTAL_SIZE);
		
		session.setAttribute("diskInfo", MyDiskInfoDao.load(user.getId()));
		session.setAttribute("homeId", MyFileDao.getHomeId(user.getId()));
		session.setAttribute("user", user);
		
		return "redirect:/home/disk";
	}
	
	/**
	 * 注册时验证邮箱
	 * @param email
	 * @return
	 */
	@RequestMapping(value="/confirm_email",method=RequestMethod.POST)
	@ResponseBody
	public String confirmEmail(String email){
		return UserDao.confirmEmail(email);
	}
	
	/**
	 * 注册时验证用户名
	 * @param username
	 * @return
	 */
	@RequestMapping(value = "/confirm_username",method=RequestMethod.POST)
	@ResponseBody
	public String confirmName(String username){
		return UserDao.confirmUsername(username);
	}
}
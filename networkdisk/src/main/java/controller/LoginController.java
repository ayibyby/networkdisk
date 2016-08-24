package controller;

import model.User;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import dao.MyDiskInfoDao;
import dao.MyFileDao;
import dao.UserDao;

@Controller
@RequestMapping("/login")
public class LoginController extends Support{
	/**
	 * 用户登录
	 * @param user
	 * @return
	 */
	@RequestMapping("/welcome")
	public String login(User user){
		User u = UserDao.load(user);
		if(u != null){
			session.setAttribute("user", u);
			session.setAttribute("diskInfo", MyDiskInfoDao.load(u.getId()));
			session.setAttribute("homeId",MyFileDao.getHomeId(u.getId()));
		
			return "redirect:/home/disk";
		}
		return "redirect:/";
	}
	
	/**
	 * 登录验证
	 * @param user
	 * @return
	 */
	@RequestMapping( value="/login_confirm", method=RequestMethod.POST)
	@ResponseBody
	public String loginConfirm(User user){
		User u = UserDao.confirm(user);
		String result;
		if(u != null){
			result = "1";
			session.setAttribute("user",u);
		}else{
			result = "0";
		}
		return result;
	}
	

	@RequestMapping("/logout")
	public String logout(User user){
		session.invalidate();
	
		return "redirect:/";
	}
}
package controller;

import java.util.List;

import javax.servlet.http.HttpServletResponse;

import model.MyDiskInfo;
import model.MyFile;
import model.User;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import util.DownloadSupport;
import dao.MyDiskInfoDao;
import dao.MyFileDao;
import dao.UserDao;

@Controller
@RequestMapping("/share")
public class ShareController {
	
	/**
	 * 某用户的所有分享
	 * @param username
	 * @return
	 */
	@RequestMapping(value="/u/{uId}")
	public String shareOfUser(@PathVariable long uId,Model model){
		User owner = UserDao.loadById(uId);
		MyDiskInfo ownerDisk = MyDiskInfoDao.load(owner.getId()); 
		List<MyFile> shareFiles = MyFileDao.loadAllShareByUser(owner.getId());
		
		model.addAttribute("owner", owner);
		model.addAttribute("ownerDisk", ownerDisk);
		model.addAttribute("shareFiles", shareFiles);
		
		return "usershare";
	}
	
	/**
	 * 
	 * @param username
	 * @return
	 */
	@RequestMapping(value="/{fileId}")
	public String shareDetail(@PathVariable long fileId,Model model){
		MyFile shareFile = MyFileDao.getMyFile(fileId);
		if(shareFile.getIsShare() == 1){
			User owner = UserDao.loadById(shareFile.getUser_id());
			MyDiskInfo	ownerDisk = MyDiskInfoDao.load(shareFile.getUser_id());
			
			model.addAttribute("owner", owner);
			model.addAttribute("ownerDisk", ownerDisk);
			model.addAttribute("shareFile", shareFile);
		}
		return "share";
	}
	
	/**
	 * 分享下载
	 * @param response
	 * @param shareId
	 */
	@RequestMapping(value="/download/{shareId}")
	public void download(HttpServletResponse response,@PathVariable long shareId){
		MyFile myFile = MyFileDao.getMyFile(shareId);
		
		if(myFile.getIsShare()==1){
			DownloadSupport.download(response, myFile);
			MyFileDao.updateShareDownload(shareId);
		}
	}	
}

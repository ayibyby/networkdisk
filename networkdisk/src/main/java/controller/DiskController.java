package controller;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Message;
import model.MyDiskInfo;
import model.MyFile;
import model.User;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import util.DaoSupport;
import util.DownloadSupport;
import util.FileStorage;
import util.UploadHelper;

import com.alibaba.fastjson.JSON;

import dao.DeleteFileTransaction;
import dao.MessageDao;
import dao.MoveFileTransaction;
import dao.MyDiskInfoDao;
import dao.MyFileDao;
import dao.UploadTransaction;

@Controller
@RequestMapping("/home")
public class DiskController extends Support{
	private static final String FILEBASEPATH = FileStorage.getFilePath();
	
	/**
	 * 列出文件夹的内的所有子文件
	 * @param id
	 * @return
	 */
	@RequestMapping("/list_myfile")
	@ResponseBody
	public  String listFiles(long id,String pwd){
		MyFile folder = MyFileDao.getMyFile(id);
		List<MyFile> myFiles = null;
		
		if(folder.getIsLock() == 1){
			if(folder.getPassword().equals(pwd)){
				myFiles = MyFileDao.getFilesByFolderId(id);
			}else{
				return "fail";
			}
		}else{
			myFiles = MyFileDao.getFilesByFolderId(id);
		}
		return JSON.toJSONString(myFiles);
	}
	
	/**
	 * 上传文件
	 * @param request
	 * @param folderid
	 * @return
	 */
	@RequestMapping("/upload/{folderid}")
	@ResponseBody
	public String upload(HttpServletRequest request,@PathVariable long folderid){
		UploadHelper upload = new UploadHelper();
		MultipartFile file = upload.getFiles(request).get(0);
		
		String result = "fail";
		String fileName = file.getOriginalFilename();
		String suffix = fileName.substring(fileName.lastIndexOf(".")+1);
	
		User user = (User) session.getAttribute("user");
		
		MyFile myFile = new MyFile();
		myFile.setUser_id(user.getId());
		myFile.setSize(file.getSize());

		if(MyDiskInfoDao.isEnoughSpace(myFile)){
			String filePath = FILEBASEPATH + new Date().getTime() + "." + suffix;
			
			//String filePath = session.getServletContext().getRealPath("FILE") +"/"+ new Date().getTime() + "." + suffix;
			try {
				upload.upload(file, filePath);//文件没有成功保存返回失败信息
				
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				
				myFile.setCreateDate(sdf.format(new Date()));
				myFile.setName(fileName);
				myFile.setParent_id(folderid);
				myFile.setType(suffix.toLowerCase());
				myFile.setPath(MyFileDao.getPath(folderid)+folderid+"/");
				myFile.setLocation(filePath);
				myFile.setIsShare(0);
				myFile.setDescription("");
				
				
				myFile = UploadTransaction.upload(myFile);
				/*同步网盘信息*/
				MyDiskInfo diskInfo = MyDiskInfoDao.load(user.getId());
				session.setAttribute("diskInfo",diskInfo);
				
				Map<String,Object> data = new HashMap<String,Object>();
				data.put("file", myFile);
				data.put("usedSize", diskInfo.getUsedSize());
				
				result = JSON.toJSONString(data);
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return result;
	}
	/**
	 * 下载文件
	 * @param fileId
	 * @param response
	 */
	@RequestMapping("/download/{fileId}")
    public void download(@PathVariable long fileId,HttpServletResponse response){
		MyFile myFile = MyFileDao.getMyFile(fileId);
		DownloadSupport.download(response, myFile);
    }
	/**
	 * 新建文件夹
	 * @param folderId
	 * @return
	 */
	@RequestMapping("/mkdir/{folderId}")
	@ResponseBody
	public String mkdir(@PathVariable long folderId,String folderName){
		MyFile dir = new MyFile();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		dir.setCreateDate(sdf.format(new Date()));
		dir.setParent_id(folderId);
		dir.setName(folderName);
		dir.setPath(MyFileDao.getPath(folderId)+folderId+"/");
		dir.setType("adir");
		dir.setDescription("");
		dir.setUser_id(((User)session.getAttribute("user")).getId());
		dir.setSize(0);
		dir.setId(MyFileDao.save(dir));
		
		return JSON.toJSONString(dir);
	}

	/**
	 * 重命名
	 * @param fileId
	 * @param fileName
	 * @return
	 */
	@RequestMapping("/rename/{fileId}")
	@ResponseBody
	public String rename(@PathVariable long fileId,String fileName,String pwd){
		MyFile myFile = MyFileDao.getMyFile(fileId);
		String result = "fail";

		if(myFile.getIsLock() == 1){
			if(myFile.getPassword() == null && pwd == "" || myFile.getPassword().equals(pwd)){
				MyFileDao.rename(fileId, fileName);
				result = "success";
			}else{
				result = "fail";
			}
		}else{
			MyFileDao.rename(fileId, fileName);
			result = "success";
		}
		
		return result;
	}
	
	/**
	 * 分享文件
	 * @param fileId
	 * @return
	 */
	@RequestMapping("/share")
	@ResponseBody
	public String share(HttpServletRequest request,long fileId){
		MyFile myFile = MyFileDao.getMyFile(fileId);
		String result = "fail";
		
		if(myFile != null){
			String url = (request.getRequestURL() + "").replace(request.getRequestURI(), "");
			myFile.setShareUrl(url+"/share/download/"+myFile.getId());
			MyFileDao.share(myFile);
			
			result = url+"/share/"+myFile.getId();
		}
		
		return result;
	}
	
	/**
	 * 取消分享
	 * @param fileId
	 * @return
	 */
	@RequestMapping("/cancelshare")
	@ResponseBody
	public String cancelShare(long fileId){
		MyFileDao.cancelShare(fileId);
		return "success";
	}
	
	/**
	 * 文件的移动
	 * @param sourceId
	 * @param targetId
	 * @return
	 */
	@RequestMapping("/movefile")
	@ResponseBody
	public String moveFile(long sourceId,long targetId){
		MyFile 	sourceFile = MyFileDao.getMyFile(sourceId),
				targetFile = MyFileDao.getMyFile(targetId);
		
		MoveFileTransaction.moveFile(sourceFile, targetFile);
		
		return "success";
	}
	
	/**
	 * 给文件上密码
	 * @param fileId
	 * @param oldPwd
	 * @param newPwd
	 * @return
	 */
	@RequestMapping("/addlock/{fileId}")
	@ResponseBody
	public String addLock(@PathVariable long fileId,String pwd){
		MyFile myFile = MyFileDao.getMyFile(fileId);
		if(myFile.getIsLock() != 1){
			MyFileDao.addLock(fileId, pwd);
		}	
		return "success";
	}
	
	/**
	 * 给加锁文件夹更换密码
	 * @param fileId
	 * @param oldPwd
	 * @param newPwd
	 * @return
	 */
	@RequestMapping("/changefilepwd/{fileId}")
	@ResponseBody
	public String changeFilePwd(@PathVariable long fileId,String oldPwd,String newPwd){
		MyFile myFile = MyFileDao.getMyFile(fileId);

		String result = "fail";
		if(myFile.getPassword()==null && oldPwd == "" || myFile.getPassword().equals(oldPwd)){
			MyFileDao.addLock(fileId, newPwd);
			result = "success";
		}	
		return result;
	}
	
	/**
	 * 给文件解锁
	 * @param fileId
	 * @param pwd
	 * @return
	 */
	@RequestMapping("/deletelock/{fileId}")
	@ResponseBody
	public String deleteLock(@PathVariable long fileId,String pwd){
		MyFile myFile = MyFileDao.getMyFile(fileId);
		String result = "fail";
		
		if(myFile.getPassword().equals(pwd)){
			MyFileDao.deleteLock(fileId);
			result = "success";
		}
		
		return result;
	}
	
	/**
	 * 删除文件（或文件夹），返回删除文件后的网盘容量
	 * @param fileId
	 * @return
	 */
	@RequestMapping("/delete/{fileId}")
	@ResponseBody
	public String delete(@PathVariable long fileId,String pwd){
		MyFile myFile = MyFileDao.getMyFile(fileId);
		String result = "fail";
		
		if(myFile.getPassword() == null && pwd == "" || myFile.getPassword().equals(pwd)){
			long uId = ((User)session.getAttribute("user")).getId();
			if(!myFile.getType().equals("adir")){
				/*文件则直接删除*/
				DeleteFileTransaction.deleteFile(myFile);
				new File(myFile.getLocation()).delete();
			}else{
				List<MyFile> myFiles = DeleteFileTransaction.deleteFolder(myFile);
				/*是文件夹就直接删除数据库记录，是文件就要把文件删除后才删除数据库记录*/
				if(myFiles != null){
					for(MyFile myF:myFiles){
						System.out.println("删除文件："+myF.getLocation());
						new File(myF.getLocation()).delete();
					}
				}
			}
			MyDiskInfo diskInfo = MyDiskInfoDao.load(uId);
			session.setAttribute("diskInfo",diskInfo);
			result = diskInfo.getUsedSize()+"";
		}
		return result;
	}
	
	
	/**
	 * 用户留言
	 * @param message
	 * @return
	 */
	@RequestMapping(value="/leavemessage")
	@ResponseBody
	public String leaveMessage(Message message){
		User user = (User) session.getAttribute("user");
		
		message.setUser_id(user.getId());
		message.setUsername(user.getUsername());
		message.setEmail(user.getEmail());
		MessageDao.save(message);
		
		return "1";
	}
	
	/**
	 * 简单查看用户留言
	 * @param message
	 * @return
	 */
	@RequestMapping(value="/msgme")
	@ResponseBody
	public String returnMessage(){
		String sql = "select * from message";
		List<Message> messages = DaoSupport.query(sql, null,Message.class);
		
		return JSON.toJSONString(messages);
	}
	
	/**
	 * 以"/disk"路径访问网盘
	 * @return
	 */
	@RequestMapping("/disk")
	public String index(){
		return "disk";
	}
	/**
	 * 以"/"路径访问网盘
	 * @return
	 */
	@RequestMapping("/")
	public String index1(){
		return "redirect:/home/disk";
	}
	/**
	 * 以""路径访问网盘
	 * @return
	 */
	@RequestMapping("")
	public String index2(){
		return "redirect:/home/disk";
	}
	/**
	 * 在线预览文件
	 * @return
	 */
	@RequestMapping("/view/{fileId}")
	public String view(@PathVariable long fileId){
		MyFile myFile = MyFileDao.getMyFile(fileId);
		String fileUrl = myFile.getLocation().replace("D:/opt", "http://aibyb.wicp.net");
		session.setAttribute("fileUrl", fileUrl);
		return "file_view";
	}
}

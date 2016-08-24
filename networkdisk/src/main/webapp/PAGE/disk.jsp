<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>${user.username }的网盘</title>
		<meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<link rel="stylesheet" href="/resource/css/base.css"/>
		<link rel="stylesheet" href="/resource/zTree/css/zTreeStyle/zTreeStyle.css" type="text/css">
		<link rel="stylesheet" href="/resource/css/disk.css"/>
		<link rel="stylesheet" href="/resource/css/file.css"/>
		<link rel="stylesheet" href="/resource/contextmenu/theme/contextmenu.css"/>
		<link rel="stylesheet" href="/resource/checkInput.v2/skin.css"/>
		<script type="text/javascript" src="/resource/js/jquery-1.9.1.min.js"></script>
		<script type="text/javascript" src="/resource/zTree/js/jquery.ztree.core-3.5.min.js"></script>
		<script type="text/javascript" src="/resource/zTree/js/jquery.ztree.exedit-3.5.min.js"></script>
		<script type="text/javascript" src="/resource/contextmenu/jquery.contextmenu.js"></script>
		<script type="text/javascript" src="/resource/js/progressBar.js"></script>
		<script type="text/javascript" src="/resource/checkInput.v2/checkInput.js"></script>
		<style>
			#upload{position:relative;}
			#upload_button{
				position:absolute;
				top:0px;
				left:0px;
				border:none!important;
				padding:0!important;
				margin:0!important;
				text-align:left;
				opacity:0;
			}
			input{vertical-align:text-top;}
			.pretty_file_input {position: relative;}
			.pretty_file_input .fake{width:170px;disabled:disabled;position: absolute;}
			.pretty_file_input .browse{top:0px;left:180px;position: absolute;}
			.pretty_file_input .file{opacity:0;width:170px;position: absolute;}
			#space_bar{
				margin:20px 0 0 8px;
				padding:0 3px;
				display:block;
			}
			.progress_bar{margin:9px 0;}
			.total_progress,.current_progress,.bar_data{display:block;}
			.total_progress,.bar_data{ padding:2px; text-align:center;}
			.total_progress{background:#FFF;font-size:12px;}
			.current_progress{ background:#A9D5F4;float:left;color:black;font-weight:800;}
			
	        .active{
	        	background-color:#ADD5FF!important;
	        	border-color:#4D90FE!important;
	        	box-shadow: 0 0 20px rgba(77, 144, 254, 0.7);
	            transition: all 0.5s ease 0s;
	        }
	        .on{
	        	transform:scale(0.5);
	        	-webkit-transform:scale(0.5);
	        	opacity:0.8!important;
	        	transition: transform 0.3s ease 0s;
	        	-webkit-transition: transform 0.3s ease 0s;
	        }
	        #folder .draggable_ghost{border:1px solid #4D90FE!important;}
	        
	        form dl{width:360px;margin:0;}
			form dt{width:90px;float:left;text-align:right;font-size:18px;}
			form dt,form dd{padding:3px 3px;}
	        #dialog textarea{height:60px;resize:none;}
			#dialog textarea,#dialog input{
				width:250px;
				font-size:16px;
				padding:3px 4px;
				padding-right:27px;
				background-position:right 100px;
				background-repeat:no-repeat;
				transition: all 0.3s ease 0s;
				 -webkit-transition: all 0.7s ease-in-out 0s;
				background-image:url(/resource/checkInput.v2/tip.png);
			}
		</style>
	</head>
	<body>
		<div id="wrap">
    		<div id="sky">
    			<a id="logo" href="/home/disk" title="我的网盘"><img src="/resource/img/logo.png"/></a>
    			<div id="cloud">
	    			<span>${user.username}</span>|
	    			<span><a href="/login/logout" style="color:white;">[退出]</a></span>
    			</div>
    		</div>
	        <div id="main">
	        	<div id="left">
	        		<div id="user_info">
	        			<div id="portrait"><img src="/user/portrait/${user.portrait}.jpg" title="${user.username}"/></div>
	        			<div id="user_detail">
	        				<h4 id="name">${user.username}</h4>
	        				<span id="gender gender_${user.gender}"></span>
	        				<span>资源(${diskInfo.fileNumber})</span>
	        			</div>
	        		</div>
	        		<a id="setting" href="/u/setting"><span>个人信息设置</span></a>
	        		<a id="other" href="javascript:message();"><span>给梁威留个言？</span></a>
	        		<div id="netdisk"><span id="space_bar">空间概览</span></div>
	        		<div id="dir_tree"><ul id="my_file_tree" class="ztree"></ul></div>
	        	</div>
	        	<div id="right">
	        		<div id="file_path">
	        			<div id="path_wrap">
		        			<div id="root"><span>我的网盘</span>:</div>
		        			<div id="children_path"></div>
	        			</div>
	        		</div>
	        		<div id="tools_bar">
	        			<span id="mkdir">新建文件夹</span>
	        			<span id="upload">上传<span id="upload_button"></span></span>
	        			<a href="/share/u/${user.id }" id="share">我的分享主页</a>
	        		</div>
	        		<div id="folder">
	        			<ul>
						</ul>
	        		</div>
	        	</div>
	        </div>
    	</div>
    	<div id="upload_queue"></div>
    	<div id="dialog"></div>
	</body>
	<link rel="stylesheet" href="/resource/promptBox/style.css"/>
	<link rel="stylesheet" href="/resource/uploadify/uploadify.css"/>
	<link rel="stylesheet" href="/resource/dialog/css/skin.css"/>
	<link rel="stylesheet" href="/resource/css/skin.css"/>
	<script type="text/javascript" src="/resource/promptBox/jquery.pop.js"></script>
	<script type="text/javascript" src="/resource/uploadify/jquery.uploadify.min.js"></script>
	<script type="text/javascript" src="/resource/dialog/dialog.js"></script>
	<script type="text/javascript" src="/resource/drop/droppable.js"></script>
	<script type="text/javascript" src="/resource/drop/draggable.js"></script>
	<script type="text/javascript" src="/resource/media/jquery.media.js"></script>
	<SCRIPT type="text/javascript">
		var file_template = 
			"<li class='file'>" +
				"<span class='file_icon'>"+
					"<span class='lock'></span>"+
					"<span class='share'></span>"+
				"</span>" +
				"<span class='file_name' title='双击重命名'></span>" +
			"</li>";

		var zTree;      	
       	/*zTree处理异步加载返回得的数据*/
   		dataFilter = function(tId, pNode, myFiles){
   			if(myFiles){
   				var myFile;
   				for(var i=0;i<myFiles.length;i++){
   					myFile = myFiles[i];
   					if(myFile.type != "adir"){
   						myFile.icon = "/resource/filetype/" + myFile.type+".gif";
   					}else {
   						myFile.isParent = true;
   					}
   				}
   			}
   			return myFiles;
   		};
   		/*zTree的context*/
   		var setting = {
   				async : {
   					enable 		: true,
   					autoParam 	: ["id"],
   					url 		: "list_myfile",
   					dataFilter	: dataFilter
   				},
   				data:{keep:{parent:true}},
   				callback : {
   					beforeAsync : function(tId, tNode){
   						if(tNode.isLock == 1){
   							return false;
   						}
   						return true;
   					},
   					onAsyncSuccess : function(event, treeId, tNode, msg) {
   						if(tNode.isClick) {
   							listFiles(tNode);
   						}
   					},
   					/*双击目录树，显示文件夹内容*/
   					onClick : function(event, treeId, tNode){						
   						if(tNode.type != "adir"){
   							return;
   						}
   						if(tNode.isParent && tNode.isClick == null) {
   							tNode.isClick = true;
   						}
   						if(tNode.zAsync == false) {
   							zTree.reAsyncChildNodes(tNode,"refresh",true);
   						}else {
   							listFiles(tNode);
   						}
   					}
   				}
   			};

   		/*初始化的sTree*/
   		var zNodes = [{
   			isParent		: true,
   			name 			: "我的网盘",
   			open 			: true,
   			id 				: ${homeId},
   			type			: "adir"
   		}];
   		/*初始化zTree并加载根目录*/
   		$(document).ready(function() {
   			zTree = $.fn.zTree.init($("#my_file_tree"), setting, zNodes);
   			
   			var root = zTree.getNodeByTId("my_file_tree_1");
   			zTree.reAsyncChildNodes(root,"refresh",true);
   			$("#root span").data("node_id","my_file_tree_1").data("file_id",${homeId});
   			root.isClick = true;
   		});
   		
		var dialog = dialog({
				height : 'auto',
				width :"400",
				speed:200,
				appendTo:"#dialog"
			});
		/*获得字符串实际长度，中文2，英文1，要获得长度的字符串 */
		getRealStrLen = function(str) {
			var realLen = 0, len = str.length, charCode = -1;
			for (var i = 0; i < len; i++) {
				charCode = str.charCodeAt(i);
				if (charCode >= 0 && charCode <= 128){
					realLen += 1;
				}else{
					realLen += 2;
				}
			}
			return realLen;
		};
		/*限制字符串的长度，超过长度后面用省略号覆盖*/
		strLimit = function(str,len){
			if(str.length > 20){
				return str.substr(0,18)+"..."; 
			}else{
				return str;
			}
		}
		/*取得某个树节点的路径*/
		createPath = function(tNode){
			var tempNode = tNode;
			var cPath = $("#children_path");
			cPath.html("");
			
			while(tempNode.getParentNode() != null){
				cPath.prepend($("<span/>").
						data("file_id",tempNode.id).
						data("node_id",tempNode.tId).
						addClass("lock_"+tempNode.isLock).
						html(tempNode.name));
				cPath.prepend("》");
				tempNode = tempNode.getParentNode();
			} 
		}
		
		/*把文件夹的内容展示在右边窗口里*/
		listFiles = function(tNode){
			$("#folder").data("folder_id",tNode.id).data("node_id",tNode.tId);
			createPath(tNode);
			
			var files = tNode.children;
			var file,folder = $("#folder ul");
			folder.html("");
			for(var i=0;i<files.length;i++){
				file = $(file_template);
				if(files[i].type == "adir"){
					file.addClass("folder");
				}
				file.find(".file_icon").
					addClass(files[i].type + " lock_" + files[i].isLock + " share_" + files[i].isShare).
					data("file_id",files[i].id).
					data("node_id",files[i].tId).
					attr("title",files[i].name);
			
				file.find(".file_name").html(strLimit(files[i].name,20));
				folder.append(file);
			}
		}
		/*上传或新建文件夹时更新界面*/
		addFile = function(data){
			if(data.type == "adir"){
				data.isParent = true;
			}else{
				data.icon = "/resource/filetype/" + data.type+".gif";
			}
			
			var tarNode = zTree.getNodeByTId($("#folder").data("node_id")),
    			file = $(file_template),
    			newNode = zTree.addNodes(tarNode,data,true);
			if(data.type == "adir"){
				file.addClass("folder");
			}
    		file.find(".file_icon").
	    		data("file_id",data.id).
	    		data("node_id",newNode[0].tId).
	    		addClass(data.type + " lock_"+data.isLock + " share_0").
	    		attr("title",data.name);

			file.find(".file_name").html(strLimit(data.name,20));
			$("#folder ul").append(file);
		}
		/*打开文件*/
		openFile = function(f){
			var tNode = zTree.getNodeByTId(f.data("node_id"));
			if(f.hasClass("lock_1") && !f.find("#input_pwd")[0]){
				unlockFile(f);
			}else if(tNode.zAsync == false){
				zTree.reAsyncChildNodes(tNode,"refresh",true);
				tNode.isClick = true;
			}else{
				listFiles(tNode);
			}
		}
		/*文件分享*/
		share = function(f){
			var url = "/home/share",
				data = "fileId="+f.data("file_id");
				
			$.post(url,data,function(data){
				if(data != "fail"){
					var tNode = zTree.getNodeByTId(f.data("node_id"));
					tNode.isShare = 1;
					zTree.updateNode(tNode);
					f.removeClass("share_0").addClass("share_1");
					dialog.show($("<span>资源主页 : </span>").
									append($("<input/>").css({"width":320,"vertical-align":"middle"}).val(data)).append("<a href='"+data+"'>去资源主页看看</a>"),"分享成功，请记下链接");
				};
			}); 
		}
		/*取消分享*/
		cancelShare = function(f){
			var url = "/home/cancelshare",
				data = "fileId="+f.data("file_id");

			$.post(url,data,function(data){
				if(data != "fail"){
					var tNode = zTree.getNodeByTId(f.data("node_id"));
					tNode.isShare = 0;
					zTree.updateNode(tNode);
					f.removeClass("share_1").addClass("share_0");
				}
			}); 	
		}
		/*重命名文件*/
		rename = function(f){
			var text = $("<textarea type='text' style='text-align:center;resize:none;width:91px;height:34px;font-size:11px;'></textarea>");

			gotoEdit = function(){
				text.blur(function(){
					var url = "rename/"+f.data("file_id");
					var data = "fileName="+text.val()+"&pwd=" + text.data("pwd");
					$.post(url,data,function(data){
						var tNode = zTree.getNodeByTId(f.data("node_id"));
						if(data == "success"){
							tNode.name = text.val();
							zTree.updateNode(tNode);
							f.attr("title",text.val());
							text.parent().html(strLimit(tNode.name,20));
						}else {
							if(data == "fail"){alert("密码错误");}else{alert("网络不佳");}
							text.parent().html(strLimit(tNode.name,20));
						}
						text.remove();
					});
				});
				text.val(f.attr("title"));
				f.next().html(text);
				text.focus().select();
			}
			/*如果是加密文件，需要输入密码后才能重命名*/
			if(f.hasClass("lock_1") || f.hasClass("lock_2")){
				var input = inputPwd(f);
				input.find("#unlock").click(function(){
					text.data("pwd",$("#unlock_pwd").val());
					gotoEdit();
					input.close();
				});
			}else{gotoEdit();}
		}
	   	/*删除文件*/
		deleteFile = function(f){
			url = "delete/"+$(f).data("file_id"),
			data = "";
			post = function(url,data){
				$.post(url,data,function(data){
					if(!isNaN(data)){
						var tNode = zTree.getNodeByTId(f.data("node_id"));
						zTree.removeNode(tNode);
						f.parent(".file").remove();
						var newSize = Number(data/(1024)).toFixed(0);
						pBar.setProgress(newSize);
					}else if(data=="fail"){
						alert("密码错误");
					}
				});
			};
			
			if(f.hasClass("lock_1") || f.hasClass("lock_2")){
				var input = inputPwd(f);
				input.find("#unlock").click(function(){
					post(url,"pwd="+$("#unlock_pwd").val());
					input.close();
				});
			}else{post(url,"pwd=");}
		}
		/*文件解密、删除文件、重命名、删除文件密码时弹出输入框*/
		inputPwd = function(f){
			$("#input_pwd").slideUp(300,function(){$(this).remove();});
			var input = $("<div id='input_pwd' style='display:none;' onblur='$(\"#input_pwd\").fadeOut(\"slow\",function(){$(this).remove();});'>"+
							"<h4>请输入密码</h4>"+
							"<input id='unlock_pwd' name='pwd' placeholder='解密密码' type='password'/>"+
							"<button type='button' onclick='$(\"#input_pwd\").slideUp(300,function(){$(this).remove();});'>取消</button>"+
							"<button type='button' id='unlock'>确定</button>"+
						"</div>");
			input.close = function(){this.slideUp(300,function(){$(this).remove();});}
			f.parent(".file").append(input);
			input.find(".input_pwd").focus();
			input.slideDown(300);
			return input;
		}
		
		/*文件夹解密*/
		unlockFile = function(f){
			inputPwd(f).find("#unlock").click(function(){
				var pwd = $("#unlock_pwd");
				var url = "list_myfile";
				var data = "pwd="+pwd.val()+"&id="+f.data("file_id");

				$.post(url,data,function(data){
					var tNode = zTree.getNodeByTId(f.data("node_id"));
					
					if(data != "fail"){
						if(data == 'null'){data = "[]";}
						files = dataFilter(null,null,JSON.parse(data));
						zTree.addNodes(tNode,files,true);
						tNode.zAsync = true;
						tNode.isLock = 2;
						listFiles(tNode);
					}else{
						alert("密码错误");
					}
				});
			});
		}

		/*文件夹加密*/
		addLock = function(f){
			$("#input_pwd").slideUp(300,function(){$(this).remove();});
			var input = $("<form class='add_pwd'><dl>"+
				    		"<dt>密码：</dt><dd><input name='pwd' id='pwd' type='password'/></dd>"+
				    		"<dt>确认：</dt><dd><input name='pwd2' id='password2' type='password'/></dd>"+
				    		"<dt></dt><dd>"+
				    			"<button type='button' onclick='dialog.close();'>取消</button>"+
				    			"<button type='submit'>加密</button>"+
				    		"</dd>"+
				    	"</dl></form>");
			dialog.show(input,"请输入密码并牢记");
			input.data("file",f);
		}
		/*更换文件密码*/
		changeFilePwd = function(f){
			var input = $("<form class='change_pwd'><dl>"+
							"<dt>旧密码：</dt><dd><input name='oldPwd' id='old_pwd' type='password'/></dd>"+
				    		"<dt>新密码：</dt><dd><input name='newPwd' id='new_pwd' type='password'/></dd>"+
				    		"<dt>确认：</dt><dd><input name='pwd1' id='password2' type='password'/></dd>"+
				    		"<dt></dt><dd>"+
				    			"<button type='button' onclick='dialog.close();'>取消</button>"+
				    			"<button type='submit' id='change_lock'>更换</button>"+
				    		"</dd>"+
				    	"</dl></form>");
				    	
			dialog.show(input,"请务必牢记更换后的密码");
			input.data("file",f);
		}

		/*删除密码*/
		deleteLock = function(f){
			var input = inputPwd(f);
			input.find("#unlock").click(function(){
				var pwd = $("#unlock_pwd");
				var url = "deletelock/"+f.data("file_id");
				var data = "pwd="+pwd.val();

				$.post(url,data,function(data){
					var tNode = zTree.getNodeByTId(f.data("node_id"));
					if(data == "success"){
						tNode.isLock=0;
						f.addClass("lock_0").removeClass("lock_2 lock_1");
						if(tNode.children == null){
							tNode.zAsync = false;
						}
						input.close();
					}else if(data == "fail"){
						alert("密码错误");
					}
				});
			});
		}
		$("#folder").delegate(".file_name","dblclick",function(){
			rename($(this).prev(".file_icon"));
		});


		//文件右键
		var fileItems = [{
			text:"下载",
			icon:"/resource/img/download.png",
			action:function(tar){
				window.location.href = "download/" + $(tar).data("file_id");
			}
		},{
			text:"分享",
			icon:"/resource/img/share.png",
			action:function(tar){share($(tar));}
		},{},{
			text:"重命名",
			icon:"/resource/img/edit.png",
			action:function(tar){rename($(tar));}
		},{
			text:"删除",
			icon:"/resource/img/delete.png",
			action:function(tar){
				if(confirm("删除的文件不能恢复，您确认是否删除该文件")){					
					deleteFile($(tar));
				}
			}
		}];
		
		var folderItems = [{
				text : "打开",
				icon : "/resource/img/open.png",
				action: function(tar) {openFile($(tar));}
			},{
				text : "重命名",
				icon : "/resource/img/edit.png",
				action: function(tar){rename($(tar));}
			},{
				text : "加密",
				icon : "/resource/img/lock.png",
				action : function(tar){
					addLock($(tar));
				}
			},{},{type:"aplit"},{
				text : "删除",
				icon : "/resource/img/delete.png",
				action: function(tar){
					if(confirm("文件夹可能涉及多个文件，请谨慎操作。")){					
						deleteFile($(tar));
					}
				}
			}];
		/*文件的右键菜单*/
		$(".share_0:not(.adir)").contextmenu({
			items : fileItems
		});
		$(".share_1").contextmenu({
			items : function(){
				fileItems[1] = {
					text:"取消分享",
					icon:"/resource/img/cancel_share.png",
					action:function(tar){cancelShare($(tar));}
				};
				fileItems[2] = {
					text:"资源主页",
					action:function(tar){window.location.href = "/share/" + $(tar).data("file_id");}
				};
				return fileItems;
			}()
		});
		/*文件夹右键菜单*/
		$(".adir:not(.lock_1):not(lock_2)").contextmenu({
			items : folderItems
		});
		$(".adir:not(.lock_0)").contextmenu({
			items : function(){
				folderItems[3] = {
					text : "删除密码",
					icon : "/resource/img/unlock.png",
					action : function(tar){
						deleteLock($(tar));
					}
				};
				folderItems[2] = {
					text : "更换密码",
					icon : "resource/img/lock.png",
					action : function(tar){
						changeFilePwd($(tar));
					}
				};
				return folderItems;
			}()
		});
		/*双击右边文件夹，显示文件夹的内容*/
		$("#folder ul").delegate(".adir","dblclick",function(){
			openFile($(this));
		});
		/*双击下载文件*/
		$("#folder ul").delegate(".file_icon:not(.adir)","dblclick",function(e){
			//window.location.href = "download/" + $(e.target).data("file_id");
			//window.location.href = "view/" + $(e.target).data("file_id");
			window.open("view/" + $(e.target).data("file_id"));
		});
		/* $("#folder ul").delegate(".file_icon:not(.adir)","click",function(e){
			//window.location.href = "download/" + $(e.target).data("file_id");
			console.log('>>>>>>>>>>>>>>>>>>'+$(e.target).data("file_id"));
			//$(e.target).media({width:800, height:600}); 
		}); */
		
		/*点击路径列出目录的内容*/
		$("#file_path").delegate("#children_path span","click",function(){
			listFiles(zTree.getNodeByTId($(this).data("node_id")));
		});
		$("#root").click(function(){
			listFiles(zTree.getNodeByTId("my_file_tree_1"));
		});
       
    	$("#mkdir").click(function(){
    		 var fMkdir = "<form class='mkdir'><dl>"+
							"<dt>文件名：</dt><dd><input name='folderName' type='text'/></dd>"+
							"<dt></dt><dd><button type='submit'>确定</button></dd>"+
						"</dl></form>";
        	dialog.show(fMkdir,'新建文件夹');
    	});
    	/*进度条*/
    	$("#space_bar").progressBar({
			width:265,
	        height:15,
	        unit:"KB",
	        totalProgress:Number(${diskInfo.totalSize}/(1024)).toFixed(0),
	        currentProgress:0
		});
    	var pBar = $("#space_bar").getProgressBar();
    	pBar.setProgress(Number(${diskInfo.usedSize}/(1024)).toFixed(0));
 
    	var pop = popbox({
			width:400,
			height:240,
			title:"文件上传",
			auto:false,
			content:$("#upload_queue")
		});
		
		$("#upload_button").uploadify({
			height      : 22,
			width       : 64,
			swf        	: '/resource/uploadify/uploadify.swf',
			auto 		: false,
			//queueSizeLimit : 3,
			fileTypeExts :"*.*",
			fileSizeLimit	: 1024+"KB",
			queueID		: 'upload_queue',
			onSelect : function(file){
				var newSize = file.size/(1024)+ parseInt(pBar.getCurrent());
				if(newSize > pBar.getTotal()){
					alert("您的空间不够");
					return false;
				}else{
					file.uploadUrl = "/home/upload/"+$("#folder").data("folder_id")+";jsessionid="+'${pageContext.session.id}';
					pop.show();
					return true;
				}
			},
			onUploadStart:function(file){
				var newSize = file.size/(1024)+ parseInt(pBar.getCurrent());
				if(newSize > pBar.getTotal()){
					alert("您的空间不够");
					return false;
				}else{
					return true;
				}
			},
			onUploadSuccess : function(file, data, response) {
				if(data == "fail"){
					alert("您剩余的空间已经无法容下这个文件了");
				}else{
					var temp = JSON.parse(data);
					addFile(temp.file);
					var newSize = Number(temp.usedSize/(1024)).toFixed(0);
					pBar.setProgress(newSize);
				}
			},
			onQueueComplete :function(){
				//setTimeout(function(){pop.close()},3000);
			},
			onUploadError : function(file, errorCode, errorMsg, errorString) {}
		});

		$(".file").dragble({handler:".file_icon:not(.lock_1):not(.lock_2)"});
        
        $(".folder,#file_path span").droppable({
            accept:".file",
            activeClass:"active",
            onClass : "on",
            onDrop:function(drag,drop){
            	var tarF = drop.hasClass("file")? drop.find(".file_icon"): drop;
            	var souF = drag.find(".file_icon");
            	
            	if($("#folder").data("folder_id") != tarF.data("file_id")){
            		var url = "movefile/";
    				var data = "targetId="+tarF.data("file_id")+"&sourceId="+souF.data("file_id");

    				$.post(url,data,function(dat){
    					if(dat == "success"){
    						var tarN = zTree.getNodeByTId(tarF.data("node_id")),
    						souN = zTree.getNodeByTId(souF.data("node_id"));
	    					drag.remove();
	    					if(tarF.hasClass("lock_1") || !tarN.zAsync){
	    						zTree.removeNode(souN);
	    					}else if(tarN.zAsync){
	    						zTree.moveNode(tarN,souN,"inner",true);
	    					}
    					}
    				});
            	}
            }
        });

        message = function(){
	       var form = "<form class='leave_message'><dl>"+
							"<dt>标题：</dt><dd><input name='title' type='text' value=''/></dd>"+
				    		"<dt>内容：</dt><dd><textarea name='content'/></dd>"+
				    		"<dt></dt><dd>"+
				    			"<button type='button' onclick='dialog.close();'>取消</button>"+
				    			"<button type='submit'>提交</button>"+
				    		"</dd>"+
				    	"</dl></form>";
            
            dialog.show(form,"提交留言和意见");
        }

        
		var rules = {
				"len4"		: [/^\s*[\s\S]{4,50}\s*$/,"密码需要超过4位"],
				"content"	: [/^\s*[\s\S]{1,100}\s*$/,"不能为空，不超过100字符"],
				"title"		: [/^\s*[\s\S]{1,20}\s*$/,"不能为空，不超过20字符"],
				"fileName"	: [/^\s*[^#][\s\S]{1,20}\s*$/,"不超过20字符，不以符号开头"]
			};
        var items = [{
            	name:"title",
            	type:"title"
            },{
                name:"content",
                type:"content"
            },{
            	name:"folderName",
            	type:"fileName",
            	errorMsg:"len4"
            },{
            	name:"pwd",
            	type:"len4",
            	errorMsg:""
            },{
            	name:"pwd2",
            	type:"eq",
            	eqto:"pwd",
            	errorMsg:"两次密码不匹配"
            },{
            	name:"oldPwd",
            	type:"len4",
            	errorMsg:""
            },{
            	name:"newPwd",
            	type:"len4",
            	errorMsg:""
            },{
            	name:"pwd1",
            	type:"eq",
            	eqto:"newPwd",
            	errorMsg:"两次密码不匹配"
            }];
        
        /*我喜欢海瑛*/
        $("#dialog").checkInput({
            items:items,
            rules:rules,
            beforeSubmit:function(e,result,form){
            	e.preventDefault();
     			if(result){
     				var url = null,data = null;
                	if(form.hasClass("mkdir")){
                		url = "mkdir/"+$("#folder").data("folder_id");
                    	data = form.serialize();
    					$.post(url,data,function(d){
    						addFile(d);
    						dialog.
    							updateTitle("新建文件成功").
    							updateContent("<center><h1>新建文件成功</h1></center>");
    						setTimeout("dialog.close()",1000);
    					},"json");
                    }else if(form.hasClass("add_pwd") && form.data("file")){
						var f = form.data("file");

                    	url = "addlock/"+f.data("file_id");
        				data = form.serialize();

        				$.post(url,data,function(d){
        					if(d == "success"){
        						var tNode = zTree.getNodeByTId(f.data("node_id"));
        						zTree.removeChildNodes(tNode);
        						tNode.isLock = 1;
        						tNode.zAsync = false;
        						f.addClass("lock_1").removeClass("lock_0");
        						dialog.
        							updateTitle("文件加密成功").
	    							updateContent("<center><h1>请牢记密码</h1></center>");
	    						setTimeout("dialog.close()",2500);
        					}
        				});
                	}else if(form.hasClass("change_pwd") && form.data("file")){
                		var f = form.data("file");
                		url = "changefilepwd/"+f.data("file_id");
        				data = form.serialize();

        				$.post(url,data,function(d){
        					if(d == "success"){
        						var tNode = zTree.getNodeByTId(f.data("node_id"));
        						zTree.removeChildNodes(tNode);
        						tNode.isLock = 1;
        						tNode.zAsync = false;
        						f.addClass("lock_1").removeClass("lock_2");
        						dialog.
        							updateTitle("密码修改成功").
        							updateContent("<center><h1>请牢记新密码</h1></center>");
        						setTimeout("dialog.close()",2500);
        					}else{
            					alert("旧密码不对");
        					}
        					
        				});
                	}else if(form.hasClass("leave_message")){
                    	url = "/home/leavemessage";
                    	data = form.serialize();

                    	$.post(url,data,function(d){
        					if(d == "1"){
        						dialog.
        							updateTitle(":)留言成功").
        							updateContent("<center><img src='/resource/img/rose.gif'/><h1 style='color:green;'>have beautiful mind!</h1></center>");
        						setTimeout("dialog.close()",2500);
        					}
        				});
                	}
         		}
        	}
        });
	</SCRIPT>
</html>

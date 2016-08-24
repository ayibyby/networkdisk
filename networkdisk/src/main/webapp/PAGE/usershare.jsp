<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>${owner.username }的共享主页</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="greentea资源主页">
		<link rel="stylesheet" href="/resource/css/disk.css"/>
		<link rel="stylesheet" href="/resource/css/base.css"/>
		<link rel="stylesheet" href="/resource/css/skin.css"/>
		<style>
			body{background:#DDD;}
			
			#owner{
				width:500px;
				height:130px;
				margin:20px;
			}
			#owner img{padding:2px; background:white;border: 1px #38A3DB solid;}
			#owner_portrait{width:126px;}
			#owner_detail,#owner_portrait{
				height:126px;
				float:left;
				margin:0 10px;
			}
			#share_files li{
				list-style:none;
				padding:10px 0;
			}
			.file_name{
				width:250px;
				display:inline-block;
				overflow:hidden;
    			white-space: nowrap; 
    			text-overflow: ellipsis;
    		}
			.file span{padding:0 10px;}
			#option a{
				border:#C6E4DB solid 1px;
				letter-spacing:1px;
				margin-right:18px;
				padding:0 4px;
				padding-left:25px;
				color:#3975CD;
				text-decoration:none;
				background:url(/resource/img/download.png) no-repeat 3px center;
			}
			#option a:hover{
				box-shadow: 0 0 9px rgba(200, 200, 200, 0.6);
				border-color:#4D90FE;
			}
			
			.file_icon{background:url(/resource/file_icon/unknown.png)}
			.exe{background:url(/resource/file_icon/exe.png)}
			.apk{background:url(/resource/file_icon/apk.png);}
			.mp3{background:url(/resource/file_icon/mp3.png) no-repeat;}
			.ppt{background:url(/resource/file_icon/ppt.png) no-repeat;}
			.avi{background:url(/resource/file_icon/video.png) no-repeat;}
			.adir{background:url(/resource/file_icon/adir.png) no-repeat;}
			.txt{background:url(/resource/file_icon/txt.png) no-repeat;}
			.pdf{background:url(/resource/file_icon/pdf.png) no-repeat;}
			.doc{background:url(/resource/file_icon/doc.png) no-repeat;}
			.html,.htm{background:url(/resource/file_icon/html.png) no-repeat;}
			.js{background:url(/resource/file_icon/js.png) no-repeat;}
			.png,.jpg,.gif{background:url(/resource/file_icon/img.png) no-repeat;}
			.zip,.rar{background:url(/resource/file_icon/zip.png) no-repeat;}
		</style>
	</head>
	<body>
		<div id="wrap">
    		<div id="sky">
    			<a id="logo" href="/home/disk" title="绿茶网盘"><img src="/resource/img/logo.png"/></a>
    			<div id="cloud">
	    			<span>${user.username}</span>
	    			<span><a href="/login/logout">[退出]</a></span>
    			</div>
    		</div>
	        <div id="main">
	        	<div id="share_file">
	        		<div id="owner">
	        			<div id="owner_portrait"><img src="/user/portrait/${owner.portrait}.jpg"/></div>
	        			<div id="owner_detail">
	        				<span id="owner_name">资源主人：${owner.username }</span><br/>
	        				<span>资源数目：${ownerDisk.fileNumber }</span><br/>
	        				<span>网盘大小：${ownerDisk.totalSize/1024 }KB</span>
	        			</div>
	        		</div>
	        		<hr/>
	        		<ul id="share_files">
        			<c:forEach items="${shareFiles }" var="file">
        				<li class="file">
        					<span class="file_name" title="${file.name }">${file.name }</span>
        					<span><a href="/share/download/${file.id }">下载</a></span>
        					<span><a href="/share/${file.id }">资源主页</a></span>
        					<span>${file.createDate }</span>
        					<span>${file.shareDownload } 下载</span>
        					<span>${file.size/1024 }KB</span>
        				</li>
        			</c:forEach>
	        		</ul>
	        	</div>
	        </div>
    	</div>
	</body>
</html>
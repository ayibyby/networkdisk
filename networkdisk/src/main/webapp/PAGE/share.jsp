<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>资源主页</title>
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
			#share_file{
				position:absolute;
				top:50%;
				left:50%;
				margin-left:-200px;
				margin-top:100px;
				height:500px;
				width:500px;
				background:#FFF;
				padding:2px;
			}
			#owner img{padding:2px; background:white;border: 1px #38A3DB solid;}
			#owner{
				width:400px;
				height:130px;
				margin:20px;
			}
			#owner_detail,#owner_portrait{
				width:126px;
				height:126px;
				float:left;
				margin:0 10px;
			}
			
			#file{
				width:91px;
				background:white;
				margin: 40px auto;
				border:#DDD 1px solid;
				padding:7px;
			}
			#file_icon{
				height:91px;
				margin:5px 0;
				cursor:pointer;
			}
			#file_name,#owner_name{
				text-align:center;
				font-size:12px;
				word-wrap:break-word;
				overflow:hidden;
			}
			#option{
				margin:0 auto;
				text-align:center;
			}
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
			#option input{width:260px;}
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
	        				<span><a href="/share/u/${owner.id }">${owner.username }的分享</a></span>
	        			</div>
	        		</div>
	        		<hr/>
	        		<div id="file">
	        			<div id="file_icon" class="${shareFile.type }" title="${shareFile.name }"></div>
	        			<div id="file_name">${shareFile.name }</div>
	        		</div>
	        		<div id="option">
	        			<a href="${shareFile.shareUrl }">下载</a>
	        			URL : <input value="${shareFile.shareUrl }" readonly="readonly"/>
	        		</div>
	        	</div>
	        </div>
    	</div>
	</body>
</html>

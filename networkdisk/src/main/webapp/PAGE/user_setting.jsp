<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>${user.username }的后院</title>
		<meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<link rel="stylesheet" href="/resource/css/base.css"/>
		<link rel="stylesheet" href="/resource/css/disk.css"/>
		<link rel="stylesheet" href="/resource/css/skin.css"/>
		<link rel="stylesheet" href="/resource/imgareaselect/imgareaselect-animated.css">
		<script type="text/javascript" src="/resource/js/jquery-1.9.1.min.js"></script>
		<script type="text/javascript" src="/resource/contextmenu/jquery.contextmenu.js"></script>
		<style>
			.form{width:500px;margin:0;}
			.form dt{width:90px;float:left;text-align:right;}
			.form dt,.form dd{padding:3px 3px;}
			input{vertical-align:bottom;width:260px;}
			textarea{resize:none;width:260px;height:120px;}
			
			#right{padding:0px 15px;}
			#chg_base_info,#chg_portrait,#chg_email,#chg_pwd,#back_to_disk{
				margin-bottom:4px;
				background-color:#38A3DB!important;
				float:left;
				width:212px;
				padding-left:80px;
				cursor:pointer;
				color:white;
				text-decoration:none;
			}
			#chg_base_info{background:url("/resource/img/update_u.png") 15px 10px no-repeat;}
			#chg_portrait{background:url("/resource/img/update_u.png") 15px -59px no-repeat;}
			#chg_email{background:url("/resource/img/update_u.png") 15px -120px no-repeat;}
			#chg_pwd{background:url("/resource/img/update_u.png") 15px -186px no-repeat;}
			#back_to_disk{background:url("/resource/img/update_u.png") 15px -253px no-repeat;}
			
			#upload_area{
				height:100px;
				padding:10px 0;
			}
			#upload_portrait{
				color:#3975CD;
				margin:10px 0;
				position:relative;
				display:inline-block;
				margin:0 1px;
				cursor:pointer;
				border:#C6E4DB solid 1px;
				letter-spacing:1px;
				padding:0 4px;
				padding-left:25px;
				background:url(/resource/img/upload.png) no-repeat 0 center;
				transition: all 0.3s ease 0s;
			}
			#upload_portrait:hover{
				box-shadow: 0 1px 3px rgba(200, 200, 200, 0.6);
				background-color:#EAF4FE;
				border-color:#4D90FE;
			}
			#upload_button{
				position:absolute;
				top:0px;
				left:0px;
			}
			
			#preview{
				width:120px;
				height:120px;
				margin:2px 100px 5px 0;
				overflow:hidden;
				background:white;
				display:inline-block;
			}
			#temp_portrait{
				background:white;
				max-width:400px;
				max-height:400px;
			}
			#preview_portrait{width:120px;height:120px;}
			#portrait_form input{width:50px;}
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
	        	<div id="left">
	        		<div id="user_info">
	        			<div id="portrait">
	        				<img src="/user/portrait/${user.portrait }.jpg" title="${user.username}"/>
	        			</div>
	        			<div id="user_detail">
	        				<h4 id="name">${user.username}</h4>
	        				<span id="gender gender_${user.gender}"></span>
	        				<span>资源(${diskInfo.fileNumber})</span>
	        			</div>
	        		</div>
	        		<div id="chg_base_info" tar="base_info_form"><h3>修改基本信息</h3></div>
	        		<div id="chg_portrait" tar="portrait_form"><h3>更改头像</h3></div>
	        		<div id="chg_email" tar="email_form"><h3>修改电子邮箱</h3></div>
	        		<div id="chg_pwd" tar="pwd_form"><h3>修改密码</h3></div>
	        		<a id="back_to_disk" href="/home/disk"><h3>回到网盘</h3></a>
	        	</div>
	        	<div id="right">
	        		<div id="base_info_form">
		        		<h2>修改基本信息</h2><hr/>
		    			<form class="form" method="POST" target="_blank">
			    			<dl>
			    				<dt>加入时间：</dt><dd><input type="text" value="${user.joindate}" readonly="readonly" disabled="disabled"/></dd>
			    				<dt>电子邮件：</dt><dd><input type="text" value="${user.email}" disabled="disabled" disabled="disabled"/></dd>
			    				<dt>用户昵称：</dt><dd><input name="username" type="text" value="${user.username}"/></dd>
			    				<dt>性&nbsp;&nbsp;别：</dt>
			    				<dd>
			    					<select name="gender">
				    					<option value="1">男</option>
				    					<option value="0">女</option>
				    				</select>
			    				</dd>
			    				<dt></dt><dd><button id="base_button" type="button">修改</button></dd>
			    			</dl>
		    			</form>
	    			</div>
	    			<div id="portrait_form" style="display:none;">
	    				<h2>更改头像</h2><hr/>
	    				<div id="upload_area">
	    					<span id="upload_portrait">上传头像<span id="upload_button"></span></span>
	    					<span id="upload_queue"></span>
	    				</div>
	    				
	   					<div id="preview">
		   					<img id="preview_portrait" src=""/>
	   					</div>
	   					<img id="temp_portrait" src=""/>
	   					<form style="display:none;">
	   						<input type="hidden" name="imgName" value="" id="imgName"/>
		   				左：<input type="text" name="x" value="0" readonly="readonly"/>
		   				上：<input type="text" name="y" value="0" readonly="readonly"/><br/>
		   				宽：<input type="text" name="width" value="0" readonly="readonly"/>
		   				高：<input type="text" name="height" value="0" readonly="readonly"/><br/><br/>
		   					<button type="button" id="portrait_button">保存</button>
	   					</form>
	   				</div>
	    			<div id="email_form" style="display:none;">
		    			<h2>修改Email</h2><hr/>
		    			<form class="form">
			    			<dl>
			    				<dt>旧 Email：</dt><dd><input type="text" value="${user.email}" readonly="readonly" disabled="disabled"/></dd>
			    				<dt>新 Emali：</dt><dd><input name="email" type="text" value="${user.email}"/></dd>
			    				<dt>账户密码：</dt><dd><input name="password" type="password"  value="${user.username}"/></dd>
			    				<dt></dt><dd><button type="button" id="email_button">修改</button></dd>
			    			</dl>
		    			</form>
	    			</div>
	    			<div id="pwd_form" style="display:none;">
		    			<h2>修改密码</h2><hr/>
		    			<form class="form">
			    			<dl>
			    				<dt>旧密码：</dt><dd><input type="password" name="oldPwd" value="${user.joindate}"/></dd>
			    				<dt>新密码：</dt><dd><input type="password" name="newPwd" value="${user.email}"/></dd>
			    				<dt>确认密码：</dt><dd><input type="password" name="cfPwd" value="${user.username}"/></dd>
			    				<dt></dt><dd><button type="button" id="pwd_button">修改</button></dd>
			    			</dl>
		    			</form>
	    			</div>
	        	</div>
	        </div>
    	</div>
	</body>
	<link rel="stylesheet" href="/resource/checkInput/skin.css">
	<link rel="stylesheet" href="/resource/uploadify/uploadify.css"/>
	<script type="text/javascript" src="/resource/imgareaselect/imgareaselect.pack.js"></script>
	<script type="text/javascript" src="/resource/js/tabs.js"></script>
	<script type="text/javascript" src="/resource/checkInput/checkInput.js"></script>
	<script type="text/javascript" src="/resource/uploadify/jquery.uploadify.min.js"></script>
	<SCRIPT type="text/javascript">
		$(document).ready(function(){
			tab("#chg_base_info,#chg_portrait,#chg_email,#chg_pwd","active_option");

			$("#base_info_form form").checkInput({
	            items:[{ 
					name:"username",	
					type:"username",
					focusMsg:'输入您昵称',	
					rightMsg:"填写正确" , 
					ajax:{
						url:"/register/confirm_username",
						errorMsg:"用户已存在",
						successMsg:"用户名可用！"
					}
				}],
				rules:{
					"len4":[/^\s*[\s\S]{4,50}\s*$/,"密码需要超过4位"],
					"len1":[/^\s*[\s\S]{1,20}\s*$/,"不能为空，不能超过20字符"]
				},
				button:"#base_button",
				onButtonClick:function(but,form,result){
					if(result){
						$.post("/u/change_username",form.serialize(),function(data){
							data == 1 ? alert("成功"):alert("失败");
						});
					}
				}
	       	});

			$("#email_form form").checkInput({
	            items:[{ 
					name:"email",	
					type:"email",
					focusMsg:'输入常用Email地址',	
					rightMsg:"填写正确" , 
					ajax:{
						url:"/register/confirm_email",
						errorMsg:"这个邮箱已被注册",
						successMsg:"这个邮箱可以注册！"
					}
				},{
					name:"password",
					type:"len4",
					focusMsg:'输入登录密码'
				}],
				button:"#email_button",
				onButtonClick:function(but,form,result){
					if(result){
						$.post("/u/change_email",form.serialize(),function(data){
							data == 1 ? alert("成功"):alert("密码错误");
						});
					}
				}
	       	});
			
			$("#pwd_form form").checkInput({
	            items:[{ 
					name:"newPwd",
					type:"len4",	
					focusMsg:'输入新密码（大于或等于6位）',
					errorMsg:"",	
					rightMsg:"请务必牢记新密码"
				},{
					name:"cfPwd",
					type:"eq",
					eqto:"newPwd",
					errorMsg:"两次输入密码不匹配",
					focusMsg:'再次输入新密码'
				}],
				button:"#pwd_button",
				onButtonClick:function(but,form,result){
					if(result){
						$.post("/u/change_pwd",form.serialize(),function(data){
							data == 1 ? window.location.href="/":alert("密码错误");
						});
					}
				}
	       	});

			$("#upload_button").uploadify({
				height      : 22,
				width       : 98,
				uploader	: "/u/upload_portrait;jsessionid=${pageContext.session.id}",
				swf        	: '/resource/uploadify/uploadify.swf',
				auto 		: false,
				queueSizeLimit : 1,
				fileTypeExts :"*.png;*.gif;*.jpg;*.jpeg",
				fileSizeLimit	: 5000+"KB",
				queueID		: 'upload_queue',
				onUploadSuccess : function(file, data, response) {
					$("#portrait_form form").css("display","block");
					$("#imgName").val(data);
					data = data + "?" + new Date().getTime();
					var realH,realW,imgH,imgW,scaleX,scaleY;
					
					$("#preview_portrait").attr("src","/user/temp_portrait/"+data);
					$("<img/>").attr("src","/user/temp_portrait/"+data).load(function() {
				 		realW = this.width;
				 		realH = this.height;
				    });
					$("#temp_portrait").attr("src","/user/temp_portrait/"+data).load(function(){
						imgH = this.height;
						imgW = this.width;
					});
			
					var startX 	= $("input[name='x']"),
						startY 	= $("input[name='y']"),
						width 	= $("input[name='width']"),
						height 	= $("input[name='height']"),
						preview = $('#preview_portrait');
					
					$("#temp_portrait").imgAreaSelect({
				        handles	: true,
				        aspectRatio	: "1:1",
				        /*图片预览*/
				        onSelectChange: function(img, selec){
							if (!selec.width || !selec.height){return;}
							
							scaleX = 120 / selec.width;
							scaleY = 120 / selec.height;
							
						    preview.css({
						        "width": Math.round(scaleX * imgW),
						        "height": Math.round(scaleY * imgH),
						        "margin-left": -Math.round(scaleX * selec.x1),
						        "margin-top": -Math.round(scaleY * selec.y1)
						    }); 
						    startX.val(Math.floor(selec.x1*realW/imgW));
						    startY.val(Math.floor(selec.y1*realH/imgH));
						    width.val(Math.floor(selec.width*realW/imgW));
						    height.val(Math.floor(selec.height*realH/imgH));
						}
					});
				},
			});

			$("#portrait_button").click(function(){
				$.post("/u/change_portrait",$(this).parent("form").serialize(),function(data){
					$("#portrait img").attr("src","/user/portrait/"+data+"?"+new Date().getTime());
				});
			});
		});
	</SCRIPT>
</html>

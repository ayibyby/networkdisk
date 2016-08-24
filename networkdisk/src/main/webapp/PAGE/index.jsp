<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>登录或注册</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<link rel="stylesheet" href="/resource/css/disk.css"/>
		<link rel="stylesheet" href="/resource/css/base.css"/>
		<link rel="stylesheet" href="/resource/css/skin.css"/>
		<link rel="stylesheet" href="/resource/checkInput/skin.css"/>
		<script type="text/javascript" src="/resource/js/jquery-1.9.1.min.js"></script>
		<script type="text/javascript" src="/resource/checkInput/checkInput.js"></script>
		<script type="text/javascript" src="/resource/js/tabs.js"></script>
		<style>
			body{background:white;}
			input{width:200px;padding:2px 3px;font-size:20px;}
			form dt{width:80px;float:left;font-size:18px;text-align:right;}
			form dt,form dd{padding:8px 3px;}
			
			#vip{
				width:1000px;
				border-bottom:#DDD 1px solid;
				padding-bottom:300px;
				height:400px;
				margin:0 auto;
			}
			#example{padding-right:40px;}
			#login_register,#example{float:left;margin-top:60px;}
			#panel{height:300px;width:400px;padding:20px 6px;border:1px solid #44a0fe;border-top:none;}
			#tab{
				background:#44a0fe;width:392px;height:30px;margin:0;
				padding:0 10px;position:relative;border:1px solid #44a0fe;
				padding-top:5px;
			}
			#tab li{
				text-align:center;
				position:relative;
				padding:0 10px;
				list-style:none;
				float:left;
				width:60px;
				height:30px;
				line-height:30px;
				bottom:0px;
				border:1px #44a0fe solid;
				border-bottom:none;
				cursor:pointer;
			}
			.tab_selected{background:white!important;}
		</style>
	</head>
	<body>
		<div id="wrap">
    		<div id="sky">
    			<a id="logo" href="/home/disk" title="绿茶网盘"><img src="/resource/img/logo.png"/></a>
			</div>
	        <div id="main">
	        	<div id="vip">
	        		<div id="example">
		        		<img src="/resource/img/me.png"/>
		        	</div>
	        		<div id="login_register">
		        		<ul id="tab">
		        			<li tar="login_form" class="tab_selected">登 录</li>
		        			<li tar="register_form">注 册</li>
		        		</ul>
		        		<div id="panel">
			        		<form id="login_form" action="/login/welcome" method="POST">
				        		<dl>
				        			<dt>Email：</dt><dd><input name="email" type="text"/></dd>
				        			<dt>密码：</dt><dd><input name="password" type="password"/></dd>
				        			<dt></dt><dd><button type="submit" id="login">登录</button></dd>
				        		</dl>
				        	</form>
				        	<form id="register_form" action="/register/welcome" method="POST" style="display:none;">
					        	<dl>
					        		<dt>Email：</dt><dd><input name="email"/></dd>
					        		<dt>户名：</dt><dd><input name="username"/></dd>
					        		<dt>密码：</dt><dd><input name="password" type="password"/></dd>
					        		<dt>确认：</dt><dd><input name="password2" type="password"/></dd>
					        		<dt>性别：</dt><dd><select name="gender"><option value="0">女</option><option value="1">男</option></select></dd>
					        		<dt></dt><dd><button id="register">注册</button></dd>
					        	</dl>
				        	</form>		  
		        		</div> 	
	        		</div>
	        	</div>
	        </div>
    	</div>
	</body>
	<script type="text/javascript">
		$(function(){
			tab("#tab li","tab_selected");

			var rules = {
					"len4" : [/^\s*[\s\S]{4,50}\s*$/,"多于或等于4位"],
					"len1" : [/^\s*[\s\S]{1,20}\s*$/,"不能为空"],
				};
			var tips1 = [{
					rightMsg:"",
					focusMsg:"登录邮箱",
					name : "email",
					type:"email"
				},{
					focusMsg:"登录密码",
					name:"password",
					type:"len4",
					errorMsg:"不能为空"
				}];

			var tips2 = [{
					name:"email",
					focusMsg:"登录邮箱",
					type:"email",
					ajax:{
						successMsg:"邮箱可注册",
						errorMsg:"邮箱已注册",
						url:"/register/confirm_email"
					}
				},{
					name:"username",
					focusMsg:"您的昵称",
					type:"username",
					ajax:{
						successMsg:"用户名可用",
						errorMsg:"用户名已用",
						url:"/register/confirm_username"
					}
				},{
					name:"password",
					type:"len4",
					focusMsg:"多于或等于4位",
					errorMsg:"多于或等于4位",
				},{
					name:"password2",
					type:"eq",
					focusMsg:"再输入密码",
					errorMsg:"密码不匹配",
					eqto:"password"
				}];

			$("#login_form").checkInput({
					items : tips1,
					rules : rules,
					beforeSubmit:function(e,result,form){
						var check = false;
						if(!result) {e.preventDefault();return;}

						$.ajax({
							url:"/login/login_confirm",
							data:form.serialize(),
							type:"post",
							dataType:"text",
							async:false,
							success:function(data){data == 1 ? check = true:check = false;},
							error:function(){check = false;}
						});
						if(!check){
							e.preventDefault();
							alert("用户不存在");	
						}
					}
			});
			$("#register_form").checkInput({
				items : tips2,
				beforeSubmit:function(e,result,form){
					if(!result) {e.preventDefault();return;}
				}
			});
		});
	</script>
</html>

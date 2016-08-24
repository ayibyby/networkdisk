(function($){
	var rules = {
			"email"    	: [/^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+((\.[a-zA-Z0-9_-]{2,3}){1,2})$/,"格式不对"],
			"eng"	   	: [/^[A-Za-z]+$/,"只能输入英文"],
			"chn" 		: [/^[\u0391-\uFFE5]+$/,"只能输入汉字"],
			"username"	: [/^[A-Za-z0-9\u0391-\uFFE5]{1,30}$/,"只能是文字"]
		};
		
	tipStatu = function(type,inp,msg){
    	inp.data("tip").
    		removeClass("focus_tip right_tip error_tip ajax_checking_tip").
    		addClass(type+"_tip").
    		html(msg?msg:"").
    		css({
        		"position" 	: "absolute",
        		"top"		: inp.position().top,
        		"left"		: inp.position().left + inp.width() + 18
        	});
    };
	/*相等匹配*/
	checkEq = function(set,inp,thiz){
		if(set.type=="eq" && set.eqto){
			if((inp.val() == inp.parents("form").find("[name='"+set.eqto +"']").val())){
    			tipStatu("right",inp,set.rightMsg);
    			return true;
    		}else{
    			tipStatu("error",inp,set.errorMsg);
    			return false;
    		}
		}else{return true;}
	};
	/*between检查*/
	checkBet = function(set,inp){
		if(set.between){
			if(inp.val()>=set.between[0] && inp.val() <=set.between[1]){
				tipStatu("right",inp,set.rightMsg);
				return true;
			}else{
    			tipStatu("error",inp,set.errorMsg);
    			return false;
			}
		}else{return true;}
	};
	/*正则匹配*/
	checkReg = function(set,inp){		
		if(rules[set.type]){
			var reg = rules[set.type];
			if(reg[0].test(inp.val())){
				tipStatu("right",inp,set.rightMsg);
				return true;
			}else{
				tipStatu("error",inp,reg[1]);
				return false;
			}
		}else{return true;}
	};
	/*ajax checking*/
	ajaxCheck = function(set,inp){
		if(set.ajax){
			var ajax = set.ajax,result = false;
			$.ajax({
				url:ajax.url,
				type:"post",
				data:inp.attr("name")+"="+inp.val(),
				dataType:"text",
				timeout:5000,
				async:false,
				before:function(){tipStatu("ajax_check",inp);},
				success:function(d){
					if(d == 1){
						tipStatu("right",inp,ajax.successMsg);
						result = true;
					}else if(d == 0){
						tipStatu("error",inp,ajax.errorMsg);
						result = false;
					}else{result = false;}
				},
				error:function(){
					tipStatu("error",inp,"网络出错");
					result = false;
				}
			});
			return result;
		}else{return true;}
	};
	/*初始化（每个input的）验证环境*/
	initContext = function(inp,it){
    	if(!inp.data("tip") && inp.attr("name") && it[inp.attr("name")]){
    		var tip = $("<span class='input_tip'></span>");
    		inp.data("tip",tip).data("set",it[inp.attr("name")]);
    		inp.after(tip);
    	}
	};
	/*检查输入*/
	checkIn = function(inp,form){
		if(inp.data("tip")){
			var set = inp.data("set");
    		return (checkReg(set,inp) && checkEq(set,inp,form) && checkBet(set,inp) && ajaxCheck(set,inp));
		}else{
			return true;
		}
	};
	
	
	$.fn.checkInput = function(settings){
		var dfs={
            items:[],
            rules:{},
            button:"",
            onButtonClick:$.noop,
            beforeSubmit:$.noop,
            checkAll:$.noop
        };
		
        var sets = $.extend(true,dfs,settings);
        var it = {};
    	$.each(sets.items,function(i,n){it[n.name] = n;});
    	
    	rules = $.extend(true,rules,sets.rules);
        var thiz = $(this);
       /*失焦提示*/
        this.delegate("input,textarea","blur",function(){
        	checkIn($(this),thiz);
        });  
        
        /*聚焦提示*/
        this.delegate("input,textarea","focus",function(){
        	initContext($(this),it);
        	var set = $(this).data("set");
        	if($(this).data("tip") && set.focusMsg){
        		tipStatu("focus",$(this),set.focusMsg);
        	}
        });
        /*提交表单*/
        this.submit(function(e){
        	var result = true;
        	var form = $(e.target);
        	$.each(form.find("input,texteare"),function(i,n){
        		initContext($(n),it);
            	result = (checkIn($(n),thiz) && result);
        	});
        	sets.beforeSubmit(e,result,form);
        }); 
        /*如果指定了一个响应事件的元素，则在该元素被点击时执行此方法*/
        if(sets.button){
        	this.delegate(sets.button,"click",function(e){
        		var result = true;
        		$.each(thiz.find("input,texteare"),function(i,n){
        			initContext($(n),it);
                	result = (checkIn($(n),thiz) && result);
        		});
        		sets.onButtonClick($(this),thiz,result);
        	});
        }
       
        return this;
	};
})(jQuery);
popbox = function(options) {
	var dfs = {
	    width 	: 200,        //鼠标在X轴偏移量
	    height 	: 150,        //鼠标在Y轴偏移量
	    title	: '',
	    content	: '',
	    auto	: true
	};
	var opt = $.extend(true, dfs, options);
	var popbox = $("<div class='tiny_prompt_box'>"+
		    		"<div class='tiny_prompt_box_head'>"+
		    			"<span class='title' style='padding-left:7px;'></span>"+
		    			"<span class='option'>"+
		    				"<span class='max' onclick='max_min(this);'></span>"+
		    				"<span class='close' onclick='clo();'></span>"+
		    			"</span>"+
		    		"</div>"+
		    		"<div class='tiny_prompt_box_content'> </div>"+
		    	"</div>");
		 
		clo = function(){
			popbox.remove();
		};
		
		max_min = function(t){
			var thiz = $(t);
			if(thiz.attr("class")=="max"){
				popbox.close();
			}else if(thiz.attr("class")=="min"){
				popbox.show();
			}
		};
		popbox.updateTitle = function(t){
			$(this).find(".title").html(t);
		};
		popbox.updateContent = function(c){
			$(this).find(".tiny_prompt_box_content").html(c);
		};
		popbox.remove = function(){
			$(this).remove();
		};
		popbox.close = function(){
			$(this).find(".tiny_prompt_box_content").slideUp("fast",function(){
				popbox.find(".max").attr("class","min");
			});
		};
		popbox.show = function(){
			$(this).find(".tiny_prompt_box_content").slideDown("fast",function(){
				popbox.find(".min").attr("class","max");
			});
		};
		popbox.css("width",opt.width);
		popbox.find(".tiny_prompt_box_content").css("height",opt.height - 30);
		popbox.find(".tiny_prompt_box_content").html(opt.content);
		popbox.find(".title").html(opt.title);
		
		
		$("body").append(popbox);
		if(opt.auto){
			popbox.show();
		}else{
			popbox.find(".max").attr("class","min");
		}
	    return popbox;
	};
(function($) {
	dialog = function(options){
		var dfs = {
			speed:200,
			title:"标题",
			content:"内容",	
			width:400,
			height:300,
			appendTo:null,
			showOn:"click"
		};
		var opt = $.extend(true, dfs, options);
		
		updateContent = function(content){ dia.find(".dia_content").html(content); return this;};
		updateTitle = function(title){ dia.find(".dia_title").html(title); return this;};
		close = function(){	
			var dia = this;
			dia.slideUp(dia.opt.speed,function(){
				dia.remove();
			});
		};
		
		show = function(content,title,height,width){
			$("#dia").remove();
			
			var dia = this,
			opt = dia.opt;
		
			if(content){dia.find(".dia_content").html(content);}
			if(title){dia.find(".dia_title").html(title);}
			if(height){opt.height = height;}
			if(width){opt.width = width;}
			
			dia.find(".dia_close").click(function(){dia.close();});
			opt.appendTo ? $(opt.appendTo).append(dia):$("body").append(dia);				
		
			dia.css({
				'height':opt.height,
				'width':opt.width,
				'left':'50%',
				'top':'50%'	
			}).css({
				'margin-top':-dia.height()/2,
				'margin-left':-dia.width()/2
			});
			
			dia.slideDown(opt.speed);
			
			return this;
		};
		
		var dia = $("<div id='dia' style='display:none;'>"+
						"<div class='dia_head'>"+
							"<div class='dia_title'>"+opt.title+"</div>"+
							"<div class='dia_close'></div>"+
						"</div>"+
						"<div class='dia_content'>"+opt.content+"</div>"+
					 "</div>");
						
		dia.show = show;
		dia.close = close;
		dia.updateTitle = updateTitle;
		dia.updateContent = updateContent;
		dia.opt = opt;
		
		return dia;
	};
})(jQuery);

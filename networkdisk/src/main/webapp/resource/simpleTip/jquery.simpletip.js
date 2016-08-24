$.fn.simpleTip = function(options){
	var defs = {
		speed	: 100,
		position:"top",
		offset	:6,
		content :"",
		enableClose:false
	};
	var opt = $.extend(defs, options);
	setSpeed = function(s){
		this.option.speed = s;	
	};
	setPosition = function(p){
		this.option.position = p;
	};
	setOffset = function(o){
		this.option.offset = o;	
	};
	setEnableClose = function(e){
		var disp = e ? "block":"none";
		this.find(".tip_close").css("display",disp);
		this.option.enableClose = e;
	};
	/*更新tip的内容*/
	update = function(content){
		this.option.content = content;
		this.inner.html(content);
	};
	close = function(){
		if(this.isOpen){
			var tip = this;
			tip.fadeOut(this.option.speed,function(){
				tip.removeClass(tip.data("pre_posi"));
				clear(tip.find("tip_arrow_border"),tip.find("tip_arrow"));
				tip.remove();
			});	
		}
	};
	clear = function(ab,a){
		ab.css({
			"bottom"	:"",
			"left"		:"",
			"top"		:"",
			"right"		:""
		});
		a.css({
			"bottom"	:"",
			"left"		:"",
			"top"		:"",
			"right"		:""
		});
	};
	/*显示tip,最发杂,最关键的代码,大部分是方向的判断,是有规律的（重复的）*/
	show = function(){
		var tip = this,
			opt = tip.option,
			target = $(tip.target);
		
		tip.inner.html(tip.option.content);
		tip.addClass("tip_"+opt.position);
		tip.data("pre_posi","tip_"+opt.position);
		tip.css({"width":opt.width+"px","height":opt.height+"px"});
		
		$("body").append(tip);
		var arrow = tip.find(".tip_arrow"),
			arrowBorder = tip.find(".tip_arrow_border"),
			tHei = tip.outerHeight(),
			tWid = tip.outerWidth();
		
		if(opt.enableClose){
			tip.find(".tip_close").css("display","block");
			tip.find(".tip_close").click(function(){
				tip.fadeOut(opt.speed,function(){
					tip.removeClass(tip.data("pre_posi"));
					clear(arrowBorder,arrow);
					tip.remove();
				});
			});
		}
		
		if(opt.position == "top"){
			arrowBorder.css({
				"borderStyle"	:"solid dashed dashed dashed",
				"bottom"		:"-16px",
				"left"			:opt.offset
			});
			arrow.css({
				"borderStyle"	:"solid dashed dashed dashed",
				"bottom"		:"-15px",
				"left"			:opt.offset
			});
			
			tip.css("top",target.offset().top - tHei - 8);
			tip.css("left",target.offset().left + target.outerWidth()/2 - opt.offset - 8);
		}else if(opt.position == "right"){
			arrowBorder.css({
				"borderStyle"	:"dashed solid dashed dashed",
				"left"			:"-16px",
				"top"			:opt.offset
			});
			arrow.css({
				"borderStyle":"dashed solid dashed dashed",
				"left":"-15px",
				"top":opt.offset
			});
			tip.css("top",target.offset().top + target.outerHeight()/2 - opt.offset -8);
			tip.css("left",target.offset().left + target.outerWidth() + 8);
		}else if(opt.position == "bottom"){
			arrowBorder.css({
				"borderStyle"	:"dashed dashed solid dashed",
				"top"			:"-16px",
				"left"			:opt.offset
			});
			arrow.css({
				"borderStyle"	:"dashed dashed solid dashed",
				"top"			:"-15px",
				"left"			:opt.offset
			});
			tip.css("top",target.offset().top + target.outerHeight() + 8);
			tip.css("left",target.offset().left + target.outerWidth()/2 - opt.offset - 8);
		}else{
			arrowBorder.css({
				"borderStyle"	:"dashed dashed dashed solid",
				"right"			:"-16px",
				"top" 			:opt.offset
				
			});
			arrow.css({
				"borderStyle"	:"dashed dashed dashed solid",
				"right"			:"-15px",
				"top"			:opt.offset
			});
			tip.css("top",target.offset().top + target.outerHeight()/2 - opt.offset - 8);
			tip.css("left",target.offset().left - tWid - 8);
		}
		tip.fadeIn(opt.speed);
		tip.isOpen = true;
	};
	
	var thiz = this;
	$("body").delegate(thiz.selector,opt.showOn,function(e) {
		e.target.tip.show();
	});		
	$.each(this,function(i,item){
		var tTip = 
			"<div class='mini_tip' style='display:none;'>" +
				"<div class='tip_close' title='close'></div>" +
				"<div class='tip_content'></div>" +
				"<div class='tip_arrow_border'></div>"+
				"<div class='tip_arrow'></div>"+
			"</div>";
		var tip 		= $(tTip);
		tip.close 			= close;
		tip.show 			= show;
		tip.update 			= update;
		tip.setSpeed		= setSpeed;
		tip.setPosition 	= setPosition;
		tip.setOffset 		= setOffset;
		tip.setEnableClose 	= setEnableClose;
		tip.inner 			= tip.find(".tip_content");
		tip.target			= item;
		tip.option 			= {};
		tip.option.showOn 	= opt.showOn;
		tip.option.offset 	= opt.offset;
		tip.option.position = opt.position;
		tip.option.speed 	= opt.speed;
		tip.option.content 	= opt.content;
		tip.option.heigh	= opt.height;
		tip.option.width	= opt.width;
		tip.option.enableClose = opt.enableClose;
		item.tip 	= tip;
	});
};

$.fn.getTip = function(){
	return this[0].tip;
};

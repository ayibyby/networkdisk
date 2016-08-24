(function($){
    jQuery.fn.dragble = function(options){
        var df={
            axis:"",
            start:$.noop
        };
        var opt = $.extend(true,df,options);
        var dragging    = null,
        	ghost 		= null,
        	offset      = null,
        	startPosi  	= null,
        	axisX=axisY = 1;

		if(opt.axis){
            axis = opt.axis;
            if(axis == "X" || axis == "x"){ axisY = 0; }
			if(axis == "Y" || axis == "y"){ axisX = 0; }
        }
        
		$(document).delegate(this.selector,"mousedown",function(e){
        	if(ghost == null){
        		if(opt.handler && $(this).find(opt.handler)[0] == e.target || !opt.handler){
        			dragging = $(this);
		            startPosi = {
		            	x : e.pageX,
		            	y : e.pageY
		            };
		            offset = {
		                x : dragging.position().left,
		                y : dragging.position().top
		            };
					$(document).bind("mousemove",startDrag);
		            e.preventDefault();
        		}
        	}
        });
		
		$(document).on("mouseup",function(e){
			if(ghost){
	            $(document).unbind("mousemove",drag);
	            setTimeout(function(){
	            	if(dragging.parent()[0] == null){
	            		ghost.fadeOut(200,function(){
	            			$(this).remove();
	            			ghost = null;
	            			dragging = null; 
	            		});
	            	}else{ 
		            	ghost.animate({
			            		left: dragging.position().left,
								top	: dragging.position().top
							},
							150,
							function(){
								ghost.remove();
								dragging.css("visibility","visible");
								dragging.removeData("ghost");
								ghost = null;
			            		dragging = null; 
							}
						);
	            	}
	            },20); 
			}else{
				$(document).unbind("mousemove",startDrag);
			}
		});
		
		
        startDrag = function(e){
        	e.preventDefault();
            if(Math.abs(e.pageX - startPosi.x) > 3 || Math.abs(e.pageY - startPosi.y) > 3){
                ghost = dragging.clone().addClass("draggable_ghost");
                ghost.css({
                    "position"	:   "absolute",
                   	"z-index"  	:   99,
                   	"top"    	:   dragging.position().top,
                    "left"    	:   dragging.position().left
                });
               
               	dragging.before(ghost).css({
                    visibility:"hidden"
                }).data("ghost",ghost);
                
                if(opt.start!=null){
                    opt.start(dragging);
                }
                $(document).unbind("mousemove",startDrag).bind("mousemove",drag);
            }
        };
        
        
        drag = function(e){
        	e.preventDefault();
        	axisX==1 ? ghost.css({left : e.pageX - startPosi.x + offset.x}):"";
			axisY==1 ? ghost.css({top  : e.pageY - startPosi.y + offset.y}):"";
        };
    };
})(jQuery);

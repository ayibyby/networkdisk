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
	            dragging = $(this);
	            startPosi = {
	            	x : e.pageX,
	            	y : e.pageY
	            };
	            offset = {
	                x : e.pageX - dragging.offset().left + parseInt(dragging.css("marginLeft")),
	                y : e.pageY - dragging.offset().top + parseInt(dragging.css("marginTop"))
	            };
	            
				$(document).bind("mousemove",startDrag);
				
	            return false;
        	}
        });
		
		$(document).on("mouseup",function(e){
			if(ghost){
	            $(document).unbind("mousemove",drag);
	            setTimeout(function(){
	            	ghost.animate({
							left: dragging.offset().left - parseInt(dragging.css("marginLeft")),
							top	: dragging.offset().top  - parseInt(dragging.css("marginTop"))
						},
						150,
						function(){
							ghost.remove();
							dragging.css("visibility","visible");
							ghost = null;
							dragging.removeData("ghost");
		            		dragging = null; 
						}
					);
	            },5); 
			}else{
				$(document).unbind("mousemove",startDrag);
			}
		});
		
		
        startDrag = function(e){
            if(Math.abs(e.pageX - startPosi.x) > 3 || Math.abs(e.pageY - startPosi.y) > 3){
                ghost = dragging.clone().addClass("dragble-ghost");
                ghost.css({
                    "position"	:   "absolute",
                   	"z-index"  	:   99,
                    "top"    	:   dragging.offset().top-parseInt(dragging.css("marginTop")),
                    "left"    	:   dragging.offset().left-parseInt(dragging.css("marginLeft"))
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
        	axisX==1 ? ghost.css({left : e.pageX - offset.x}):"";
			axisY==1 ? ghost.css({top  : e.pageY - offset.y}):"";
        };
    };
})(jQuery);

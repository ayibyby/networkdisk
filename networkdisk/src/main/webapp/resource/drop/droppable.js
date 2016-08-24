(function($) {
    jQuery.fn.droppable = function(options) {
        var df={
            accept		: "",
            activeClass	: "",
            hoverClass  : "",
            onClass		: "",
            onDrop 		: $.noop
        };
        var opt = $.extend(true,df,options);
        
        var accept	= opt.accept,
            aCla	= opt.activeClass,
            hCla	= opt.hoverClass,
            onDrop  = opt.onDrop,
            isM   	= false,
            isD		= false;
            
        var drag=drop=offset=accepter=len=scopes=ghost=null,
        center = {x:0,y:0};
            
      	var thiz = this;
        $(document).delegate(accept,"mousedown",function(e){
            drag = $(this);
			isD = true;
            offset = {
            	x : e.pageX - drag.offset().left - drag.width()/2,
            	y : e.pageY - drag.offset().top - drag.height()/2
            };
            
            accepter = $(thiz.selector);
            len = accepter.length;
            scopes = $.map(accepter.toArray(),function(itm){
                var item = $(itm);
                return {
                    minX : item.offset().left,
                    maxX : item.offset().left + item[0].offsetWidth,
                    minY : item.offset().top,
                    maxY : item.offset().top + item[0].offsetHeight 
                };
            });
        });
        
        $(document).on("mouseup",function(){
        	if(isM){
        		isD = false;
	    		isM = false;
	    		
	            drop ? onDrop(drag,drop):"";
	            
	            accepter.removeClass(aCla);
	            accepter.removeClass(hCla);
	            
	            drag = null;
	            drop = null;
        	}
        });
        
        $(document).on("mousemove",function(e){
          	if(isM){
                center.x = e.pageX - offset.x;
                center.y = e.pageY - offset.y;
                
                $.each(scopes,function(i,scope){
                    /*
                     * 判断draging元素是否和droppable相交，并找出与之相交的droppable元素。
                     */
                    if(	center.x > scope.minX &&
                    	center.x < scope.maxX &&
                    	center.y > scope.minY &&
                    	center.y < scope.maxY &&
                    	accepter[i] != drag[0]){
                    		
                        drop = $(accepter[i]);
                        hCla ? drop.removeClass(aCla).addClass(hCla):"";
                        ghost.addClass(opt.onClass);
                        
                        return false;
                    }
                    if(i==len-1 && drop != null){
                        drop.addClass(aCla).removeClass(hCla);
                        ghost.removeClass(opt.onClass);
                        drop = null;
                    } 
                });
            }else if(isD){
            	if(drag.data("ghost")){
	            	ghost = drag.data("ghost");
	            	aCla ? accepter.addClass(aCla):"";
	                isM = true;
	            }
	       	}
        });
        
        return this;
    };
})(jQuery);
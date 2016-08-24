(function(menu) {
    jQuery.fn.contextmenu = function(options) {
        var defaults = {
            offsetX : 2,        //鼠标在X轴偏移量
            offsetY : 2,        //鼠标在Y轴偏移量
            items   : [],       //菜单项
            speed	: 200,		//弹出和淡出的速度
            width	: 100
        };
        var opt = $.extend(true, defaults, options);
        function create(e) {
            var m = $('<ul class="simple-contextmenu"></ul>').appendTo(document.body);
            m.css("width",opt.width);
            var row;
            $.each(opt.items, function(i, item) {
                if (item && item.text) {
                    if(item.type == "split"){ 
                    	$("<div class='m-split'></div>").appendTo(m);
                        return;
                    }
                    row  = $('<li><a href="javascript:;"><span></span></a></li>').appendTo(m);
                    item.icon ? $('<img src="' + item.icon + '">').insertBefore(row.find('span')) : '';
                    item.text ? row.find('span').text(item.text) : '';
                    
                    if (item.action) {
                        row.find('a').click(function() {
                            item.action(e.target);
                        });
                    }
                }
            });
            return m;
        }
        var thiz = this;
        $(document).delegate(thiz.selector,'contextmenu', function(e) {
			var m = create(e).fadeIn(opt.speed);
			var left = e.pageX + opt.offsetX, top = e.pageY + opt.offsetY, p = {
			    wh : $(window).height(),
			    ww : $(window).width(),
			    mh : m.height(),
			    mw : m.width()
			};
			//当菜单超出窗口边界时处理
			top  = (top + p.mh) >= p.wh ? (top -= p.mh) : top;
			left = (left + p.mw) >= p.ww ? (left -= p.mw) : left;
			m.css({
			    zIndex : 10000,
			    left : left,
			    top : top
			});
			$(document).on('mousedown', function() {
		        m.fadeOut(opt.speed,function(){
		            m.remove();
		        });        
		    });
		    return false;
		});
        return this;
    };
})(jQuery);

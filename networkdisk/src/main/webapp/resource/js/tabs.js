/**
 * 考虑到tab和pane有可能被动态的添加和删除，
 * 所以每次都废点时间去查找先前被激活的tab
 */
var tab = function(tab,activeClass){
	var tabs = $(tab);
	if($("."+activeClass).length == 0){
		var temp = tabs.length > 1 ? $(tabs[0]):tabs;
		temp.addClass(activeClass);
		$("#"+temp.attr("tar")).css("display","block");
	}
	
	$(document).delegate(tab+":not(."+activeClass+")","click",function(){
		$("#"+$("."+activeClass).attr("tar")).css("display","none");
		$("."+activeClass).removeClass(activeClass);
		$(this).addClass(activeClass);
		$("#"+$(this).attr("tar")).css("display","block");
	});
};
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Online View PDF</title>
<script type="text/javascript" src="/resource/js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="/resource/media/jquery.media.js"></script>
<script type="text/javascript">
	$(function() {
		$('a.media').media({
			width : 1024,
			height : 600
		});
	});
</script>
</head>

<body>
	<a class="media" href="${fileUrl}"></a>
</body>
</html>

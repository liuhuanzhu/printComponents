<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>打印测试</title>
<style>
	div{width:100px;height:30px;background-color:#eee;margin:20px auto;}
	div a{display:inline-block;width:100px;height:30px;line-height:30px;text-decoration:none;color:#444;text-align:center;}
</style>
</head>
<body>
	<div>
		<a href="#" id="singePage">单凭证打印</a>
	</div>
	<div>
		<a href="#" id="multiPage">连续打印</a>
	</div>
	<script type="text/javascript" src="js/jquery.js"></script>
	<script>
			$("#singePage").click(function(e){
				e=e||window.event;
				e.preventDefault();
				window.open("res/Print.html?printType=0");
			})
			$("#multiPage").click(function(e){
				e=e||window.event;
				e.preventDefault();
				window.open("res/Print.html?printType=1");
			})
	</script>
</body>
</html>
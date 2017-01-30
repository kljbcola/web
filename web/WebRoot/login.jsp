<%@ page contentType="text/html" language="java" import="java.util.*,Bean.UserBean" pageEncoding="utf-8" errorPage=""%>
<%
if(UserBean.checkSession(session)!=null)
	response.sendRedirect("index.jsp");

String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!doctype html>
<html>

<head>
	<base href="<%=basePath%>">
    <meta http-equiv="Content-Type" content="text/html" charset="utf-8"/>
	<title>登陆</title>
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<link href="http://cdn.bootcss.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet">
	<!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
	<!--[if lt IE 9]>
	<script src="http://ibootstrap-file.b0.upaiyun.com/www.layoutit.com/js/html5shiv.js"></script>
	<![endif]-->

</head>

<body>
	<jsp:include flush="true" page="head.jsp"></jsp:include>
	<div class="jumbotron well">
		<form method="post" action="loginCheck" 
		style="max-width: 300px;margin-left: auto;margin-right: auto;">
			<div class="input-group">
				<span class="input-group-addon">用户名：</span>
				<input type="text" class="form-control" placeholder="请输入" name="loginName">
			</div><br>
			<div class="input-group">
				<span class="input-group-addon">密　码：  </span>
				<input type="password" class="form-control" placeholder="请输入" name="loginPassword">
			</div><br>
			<button class="btn btn-block btn-default btn-primary" type="submit">登录</button>
		</form>
	</div>

	<script type="text/javascript" src="http://cdn.staticfile.org/jquery/2.0.0/jquery.min.js"></script>
	<!-- Include all compiled plugins (below), or include individual files as needed -->
	<script type="text/javascript" src="http://cdn.bootcss.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
</body>

</html>
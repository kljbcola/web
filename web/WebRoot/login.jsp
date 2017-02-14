<%@ page contentType="text/html" language="java" import="java.util.*,Bean.UserBean" pageEncoding="utf-8" errorPage=""%>
<%
if(UserBean.checkSession(session)!=null){
	response.sendRedirect("index.jsp");
	return;
}


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
	<link href="css/bootstrap.min.css" rel="stylesheet">
	<script type="text/javascript" src="js/jquery.min.js"></script>
	<script type="text/javascript" src="js/bootstrap.min.js"></script>

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

	
</body>

</html>
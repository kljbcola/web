<%@page import="Model.AlertHandle"%>
<%@page import="Bean.UserBean"%>

<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

UserBean user=UserBean.checkSession(session);
if(user==null){
	AlertHandle.AlertWarning(session, "警告！","请先登录！");
	response.sendRedirect("index.jsp");
	return;
}

%>

<!DOCTYPE HTML>
<html>
  <head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">
    <script src="js/jquery.min.js"></script>
	<link href="css/bootstrap.min.css" rel="stylesheet">
	<script src="js/bootstrap.min.js"></script>
    
    <title>修改密码</title>
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	<script type="text/javascript">
	function save(){
		if(document.getElementById("user_old_password").value.length==0)
	    {
	         alert('旧密码不能为空');
	         return false;
	    }
	    if(document.getElementById("user_new_password").value!=document.getElementById("user_new_password_again").value)
	    {
	        alert('确认密码不符');
	        return false;
	    }
	    if(confirm("确认提交吗?")){
	    	var temp = document.getElementById("user_pw");
		        temp.submit();
	    }
	}
	
    </script>
  </head>
  
  <body>
  <jsp:include flush="true" page="head.jsp"></jsp:include>
  <div class="container">
  <form id="user_pw" class="form-horizontal" action="UserProduce" method="post" role="form">
  		<input id="operation" name="operation" value="setpw" type="hidden">
  		<label for="user_old_password">旧密码</label>
		<input class="form-control" id="user_old_password" name="user_old_password" type="password">
		<label for="user_new_password">新密码</label>
		<input class="form-control" id="user_new_password" name="user_new_password" type="password">
		<label for="user_new_password_again">新密码确认</label>
		<input class="form-control" id="user_new_password_again" type="password">
		<br>
   </form>
   <button class="btn btn-block btn-primary" onclick="save()">保存</button>
   </div>
  </body>
</html>

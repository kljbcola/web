<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@page import="Bean.EquipInfoBean"%>
<%@page import="Model.EquipHandler"%>


<%
request.setCharacterEncoding("UTF-8");
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
String s = request.getParameter("select");
String c = request.getParameter("content");

String sql="";
if (s==null) sql="SELECT * from equip_message;";
else if (s.equals("设备编号")){
	sql="SELECT * from equip_message where equip_number =\""+c+"\";";
}else if (s.equals("设备名称")){
	sql="SELECT * from equip_message where equip_name =\""+c+"\";";
}else if (s.equals("设备院系编号")){
	sql="SELECT * from equip_message where faculty_number =\""+c+"\";";
}
if(s==null)s="设备编号";
if(c==null)c="";
%>

<!DOCTYPE HTML>
<html>
  <head>
    <base href="<%=basePath%>">
     <meta charset="UTF-8"/>
	<title>设备管理</title>
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scaequiple=no">
	<link href="http://cdn.bootcss.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet">

    <link href="http://cdn.bootcss.com/bootstrap-select/2.0.0-beta1/css/bootstrap-select.min.css" rel="stylesheet">
    <script src="http://cdn.bootcss.com/bootstrap-select/2.0.0-beta1/js/bootstrap-select.min.js"></script>

    <link href="http://cdn.bootcss.com/bootstrap-datetimepicker/4.17.45/css/bootstrap-datetimepicker.css" rel="stylesheet">
    <script src="http://cdnjs.cloudflare.com/ajax/libs/moment.js/2.9.0/moment-with-locales.js"></script>
    <script src="http://cdn.bootcss.com/bootstrap-datetimepicker/4.17.45/js/bootstrap-datetimepicker.min.js"></script>
	

	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	<script>
	
	$('#equip_type').selectpicker('val', '<%=s%>');
		function post(URL, PARAMS) {
		  var temp = document.createElement("form");
		  temp.action = URL;
		  temp.method = "post";
		  temp.style.display = "none";
		  for (var x in PARAMS) {
		    var opt = document.createElement("textarea");
		    opt.name = x;
		    opt.value = PARAMS[x];
		    // alert(opt.name)
		    temp.appendChild(opt);
		  }
		  document.body.appendChild(temp);
		  temp.submit();
		  return temp;
		}
		
		function del_equipmessage(num){
			if(confirm("是否删除该设备？")){
            	post("equipServelt", {equip_number:num,operation:'del'});
            	//post("UserProduce", {user_id:userid,operation:'del'});
            }
		}
	</script>
  </head>
  
  <body>
  
  	<jsp:include flush="true" page="head.jsp"></jsp:include>
  	
  	<sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver"
     url="jdbc:mysql://localhost:3306/db?useUnicode=true&characterEncoding=UTF-8&useSSL=false"
     user="datauser"  password="135798"/>

	<form class="container form-signin" method="post" role="search" action="equipManage.jsp">
		<div class="form-group">
			<select id="equip_type" name="select" class="selectpicker show-tick form-control">
			  <option>设备编号</option>
			  <option>设备名称</option>
			  <option>设备院系编号</option>
			</select>
			
		
			<input id="content" name="content" class="form-control" type="text" placeholder="搜索设备" value="<%=c%>"/>
		</div>
		<button class="btn btn-default" type="submit">搜索</button>
	</form>

  	<sql:query dataSource="${snapshot}" var="result">
		<%=sql%>
	</sql:query>
	
	<table class="table">
			<thead><tr>
			<th>设备编号</th>
			<th>设备名称</th>
			<th>设备地点</th>
			<th>权限</th>
			<th> 
              <a class="btn btn-xs btn-info" href="newequip.jsp">添加</a> 
            </tr></thead>
		<c:forEach var="row" items="${result.rows}">
		<tr>
		   <td><c:out value="${row.equip_number}"/></td>
		   <td><c:out value="${row.equip_name}"/></td>
		   <td><c:out value="${row.equip_location}"/></td>
		   <td><c:out value="${row.equip_permission}"/></td>
		   <td>
              <a class="btn btn-xs btn-info" href="equipInfo.jsp?equip_number=${row.equip_number}">详情</a>
           </td>
           <td>
              <button class="btn btn-xs btn-danger" onclick="del_equipmessage('${row.equip_number}')">删除</button>
           </td>
		</tr>
		</c:forEach>
	</table>
    
  </body>
</html>
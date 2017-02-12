<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
 <%@ page language="java" 
import="java.util.*,Bean.UserBean,Model.AdminHandler" 
pageEncoding="UTF-8"%>

<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
UserBean user=UserBean.checkSession(session);
String userID=user.userID;
%>

<!DOCTYPE HTML>
<html>
  <head>
    <base href="<%=basePath%>">
     <meta charset="utf-8"/>
	<title>卡内余额</title>
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<link href="http://cdn.bootcss.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet">

	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->

  </head>
  
  <body>
  
  	<jsp:include flush="true" page="head.jsp"></jsp:include>
  	
  	<sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver"
     url="jdbc:mysql://localhost:3306/db?useUnicode=true&characterEncoding=UTF-8&useSSL=false"
     user="datauser"  password="135798"/>
     
     
  	<sql:query dataSource="${snapshot}" var="result">
		SELECT * from card_message where user_id="<%=userID%>";
	</sql:query>
	
	<table class="table">
			<thead><tr>
			<th>卡号</th>
			<th>剩余金额</th>
			<th>消费总额</th>
			<th>状态</th>
            </tr></thead>
		<c:forEach var="row" items="${result.rows}">
		<tr>
		   <td><c:out value="${row.card_number}"/></td>
		   <td><c:out value="${row.remaining_sum}"/></td>
		   <td><c:out value="${row.consumption}"/></td>
		   <td><c:out value="${row.status}"/></td>
		</tr>
		</c:forEach>
	</table>
    
  </body>
</html>

<%@page import="Model.AlertHandle"%>
<%@page import="Data.DbPool"%>
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
if(user==null){
	AlertHandle.AlertWarning(session, "警告！","非法操作！");
	response.sendRedirect("index.jsp");
	return ;
}
%>

<!DOCTYPE HTML>
<html>
  <head>
    <base href="<%=basePath%>">
    <meta charset="utf-8"/>
	<title>卡内余额</title>
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<script src="js/jquery.min.js"></script>
	<link href="css/bootstrap.min.css" rel="stylesheet">
	<script src="js/bootstrap.min.js"></script>
    <link href="css/bootstrap-select.min.css" rel="stylesheet">
    <script src="js/bootstrap-select.min.js"></script>
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
		<script>
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
		
		function cardW(num){
			if(confirm("是否挂失？")){
	           	post("CardServlet", {card_number:num,operation:'cardW'});
	           }
		}
		function cardR(num){
			if(confirm("是否解除挂失？")){
	           	post("CardServlet", {card_number:num,operation:'cardR'});
	           }
		}
	</script>
  </head>
  
  <body>
  
  	<jsp:include flush="true" page="head.jsp"></jsp:include>
  	
  	<sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver"
		url="<%=DbPool.getConnectionUrl() %>"
		user="<%=DbPool.getDBuser() %>"  password="<%=DbPool.getDBpassword() %>"/>
     
     
  	<sql:query dataSource="${snapshot}" var="result">
		 select *from card_message where card_number=(select card_number from user_message s2 where user_id="<%=user.userID %>");
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
		   <td><c:if test="${row.status=='正常'}">
		   		 <button class="btn btn-xs btn-danger" onclick="cardW('${row.card_number}')">挂失</button>
		   </c:if>
		   <c:if test="${row.status=='异常'}">
		   		 <button class="btn btn-xs btn-danger" onclick="cardR('${row.card_number} %>')">解挂</button>
		   </c:if></td>
		</tr>
		</c:forEach>
	</table>
    
  </body>
</html>

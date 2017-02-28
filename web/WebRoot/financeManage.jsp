<%@page import="Model.AlertHandle"%>
<%@page import="Data.DbPool"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page import="Bean.CardInfoBean"%>
<%@page import="Bean.UserBean"%>
<%@page import="Bean.UserInfoBean"%>
<%@page import="Model.CardHandler"%>
<%@page import="Model.AdminHandler"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.ParseException"%>
<%@page import="java.util.Calendar"%>

<%
request.setCharacterEncoding("UTF-8");
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
UserBean userBean=UserBean.checkSession(session);
if(userBean==null || !userBean.userType.equals("管理员"))
{
	AlertHandle.AlertWarning(session, "警告！","非法操作！");
	response.sendRedirect("index.jsp");
	return;
}

String k = request.getParameter("select");
String s=null;
if(k!=null)
	s = new String(k.getBytes("iso8859-1"),"utf-8");
String c = request.getParameter("content");
int year=0,month=0;
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
Date dNow = new Date( );
if (!(s==null||c==null||c.equals(""))) {
	Calendar cal = Calendar.getInstance(); 
	Date dt = null; 
	try { 
		dt = sdf.parse(c); 
		cal.setTime(dt); 
	} catch (ParseException e) { 
		e.printStackTrace(); 
	} 
	year = cal.get(Calendar.YEAR); 
	month = cal.get(Calendar.MONTH) + 1; 
	System.out.println("year month: "+year+" "+month);
}

//String x = request.getParameter("curpage");
//int curpage;
//if (x==null) curpage=1;
//else curpage=Integer.valueOf(x);
String sql1="";
String sql2="";
String message="截止日期";
if (s==null||c==null||c.equals("")) {
	sql1="select sum(paid_amount) sum from paid_record where paid_reason='充值';";
	sql2="select sum(paid_amount) sum from paid_record where paid_reason!='充值';";
}else if (s.equals("年统计")){
	message="年统计";
	sql1="select sum(paid_amount) sum from paid_record where paid_reason='充值' and year(paid_time)="+String.valueOf(year)+";";
	sql2="select sum(paid_amount) sum from paid_record where paid_reason!='充值' and year(paid_time)="+String.valueOf(year)+";";
}else if (s.equals("月统计")){
	message="月统计";
	sql1="select sum(paid_amount) sum from paid_record where paid_reason='充值' and year(paid_time)="+String.valueOf(year)+" and month(paid_time)="+String.valueOf(month)+";";
	sql2="select sum(paid_amount) sum from paid_record where paid_reason!='充值' and year(paid_time)="+String.valueOf(year)+" and month(paid_time)="+String.valueOf(month)+";";
}else{
	sql1="select sum(paid_amount) sum from paid_record where paid_reason='充值';";
	sql2="select sum(paid_amount) sum from paid_record where paid_reason!='充值';";
}
//System.out.println(sql+"  "+curpage+" ~"+s);
if (c==null) c=sdf.format(dNow);



%>

<!DOCTYPE HTML>
<html>
  <head>
    <base href="<%=basePath%>">
     <meta charset="UTF-8"/>
	<title>财务统计</title>
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scacardle=no">
	<script src="js/jquery.min.js"></script>
	<link href="css/bootstrap.min.css" rel="stylesheet">
	<script src="js/bootstrap.min.js"></script>
    <link href="css/bootstrap-select.min.css" rel="stylesheet">
    <script src="js/bootstrap-select.min.js"></script>
    <link href="css/bootstrap-datetimepicker.min.css" rel="stylesheet">
    <script src="js/moment-with-locales.min.js"></script>
    <script src="js/bootstrap-datetimepicker.min.js"></script>
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	<script>
		<%if(s!=null&&(s.equals("账户")||s.equals("用户名称"))){ %>
		$(function(){
			$('#select').selectpicker('val', '<%=s%>');
		});
		<%}%>
	
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
		
		
	</script>
  </head>
  
  <body>
  
  	<jsp:include flush="true" page="head.jsp"></jsp:include>
  	
  
     
    <div class="container">
		<div class="row clearfix">
			<div class="col-md-12 column">
				<nav class="navbar navbar-default" role="navigation">
					<div class="navbar-header">
							<form class="navbar-form navbar-left" method="get" role="search" action="financeManage.jsp">
								<div class="form-group">
									<select id="select" name="select" class="selectpicker show-tick " style="width:120px;">
									  <option>年统计</option>
									  <option>月统计</option>
									</select>
									<input id="content" name="content" class="form-control" type="text" placeholder="搜索设备" />
									
									<button class="btn btn-default btn-primary" type="submit">查询</button>
								</div>
							</form>
					</div>
				</nav>


				
				
				<sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver"
				     url="<%=DbPool.getConnectionUrl()%>"
				     user="<%=DbPool.getDBuser() %>"  password="<%=DbPool.getDBpassword() %>"/>
				     
				<sql:query dataSource="${snapshot}" var="result1">
					<%=sql1%>
				</sql:query>
				<sql:query dataSource="${snapshot}" var="result2">
					<%=sql2%>
				</sql:query>
		
				<table  class="table table-hover">
						<thead><tr>
						<th><%=message %></th>
						<th>总充值金额</th>
						<th>总消费金额</th>
			            </tr></thead>
			            	<c:forEach var="row1" items="${result1.rows}">
			            	<c:forEach var="row2" items="${result2.rows}">
						<tr>
						   <td><%=c %></td>
							<fmt:formatNumber var="r" value="${row1.sum}" pattern="#.000" />
						   <td>
						   		<c:if test="${row1.sum<0.0001}">
						   			<c:out value="0"/>
						   		</c:if>
						   		<c:if test="${row1.sum>=0.0001}">
						   			<c:out value="${r}"/>
						   		</c:if>
						   </td>
						   <fmt:formatNumber var="c" value="${-row2.sum}" pattern="#.000" />
						   <td>
						   		<c:if test="${-row2.sum<0.0001}">
						   			<c:out value="0"/>
						   		</c:if>
						   		<c:if test="${-row2.sum>=0.0001}">
						   			<c:out value="${c}"/>
						   		</c:if>
						   </td>
						</tr>
						</c:forEach>
						</c:forEach>
				</table>
			</div>
		</div>
	</div>
  </body>
</html>

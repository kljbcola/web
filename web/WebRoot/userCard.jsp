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
String x = request.getParameter("curpage");
int curpage;
if (x==null) curpage=1;
else curpage=Integer.valueOf(x);
String to ="userCard.jsp?";
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
     
    <div class="container">
   		 <div class="row clearfix">
			<div class="col-md-12 column">
				<sql:query dataSource="${snapshot}" var="result">
					 select *from card_message where card_number=(select card_number from user_message s2 where user_id="<%=user.userID %>");
				</sql:query>
				<h3>
					卡内余额
				</h3>
				<table class="table"><thead><tr>
				<c:forEach var="row" items="${result.rows}">
				   <th><strong>卡号:<c:out value="${row.card_number}"/></strong></th>
				   <th><strong>剩余金额:<c:out value="${row.remaining_sum}"/></strong></th>
				   <th><strong>消费总额:<c:out value="${row.consumption}"/></strong></th>
				   <th><strong>状态:<c:out value="${row.status}"/></strong></th>
				   <th><c:if test="${row.status=='正常'}">
				   		 <button class="btn btn-xs btn-danger" onclick="cardW('${row.card_number}')">挂失</button>
				   </c:if>
				   <c:if test="${row.status=='异常'}">
				   		 <button class="btn btn-xs btn-danger" onclick="cardR('${row.card_number}')">解挂</button>
				   </c:if></th>
				  
				</c:forEach>
				</tr></thead></table>
						
			</div>
		</div>
    
    
		<div class="row clearfix">
			<div class="col-md-12 column">
				<h3>
					账单
				</h3>
				<sql:query dataSource="${snapshot}" var="result1">
					 select *from paid_record where card_number=(select card_number from user_message s2 where user_id="<%=user.userID %>");
				</sql:query>
				<%  int Pagesize=10;
					int Pagenum=0;
					int cur;
					
				 %>
			    <c:forEach var="row" items="${result.rows}">
			    	<% Pagenum=Pagenum+1; %>
			    </c:forEach>
			    
			    <%
			    	int sum=(Pagenum-1)/Pagesize+1;  //页数
			    	
			    	String a1,a2,a3,a4;
			    	a1=to+"curpage=1";
			    	if (curpage==1) a2=a1;
			    	else a2=to+"curpage="+(curpage-1);
			    	a4=to+"curpage="+sum;
			    	if (curpage==sum) a3=a4;
			    	else a3=to+"curpage="+(curpage+1);
			
			    	Pagenum=0;
			     %>
				<table class="table">
						<thead><tr>
						<th>时间</th>
						<th>金额</th>
						<th>原因</th>
						<th>预约编号</th>
			            </tr></thead>
					<c:forEach var="row" items="${result1.rows}">
					<%
						Pagenum=Pagenum+1;
						cur=(Pagenum-1)/Pagesize+1;
						if (cur==curpage){
					 %>
						 <% if (Pagenum%2==0) {%> 
						 	<tr class="success"> <%}else { %>
							<tr>
						 <%} %>
					   <td><c:out value="${row.paid_time}"/></td>
					   <td><c:out value="${row.paid_amount}"/></td>
					   <td><c:out value="${row.paid_reason}"/></td>
					   <td><c:if test="${row.order_record_id!=0}">
					   		 <c:out value="${row.order_record_id}"/>
					   </c:if></td>
					</tr>
					<%} %>
					</c:forEach>
				</table>
				<ul class="pagination">
					<li>
						 <a href="<%=a1%>"> 首页</a>
					</li>
					<li>
						 <a class="reactable-previous-page" href="<%=a2%>">上一页</a>
					</li>
					<li>
						 <a class="reactable-next-page" href="<%=a3%>">下一页</a>
					</li>
					<li>
						 <a href="<%=a4%>">尾页</a>
					</li>
					<li>
					 	第<input id="showPage" name="showPage" class="form-control" style="width:50px;display:inline-block;" 
							type="text" maxlength="5" value="<%=curpage%>"/>页/共<%=sum %>页
				     
						<button class="btn btn-info btn-sm " type="button" onclick="jump('<%=sum %>')"> 跳转</button>
					</li>
				</ul>
			</div>
		</div>
		
		
		
	</div>
     
  
    
  </body>
</html>

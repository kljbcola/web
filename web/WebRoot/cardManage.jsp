<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@page import="Bean.CardInfoBean"%>
<%@page import="Bean.UserBean"%>
<%@page import="Bean.UserInfoBean"%>
<%@page import="Model.CardHandler"%>
<%@page import="Model.AdminHandler"%>

<%
request.setCharacterEncoding("UTF-8");
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
UserBean userBean=UserBean.checkSession(session);

String k = request.getParameter("select");
String s=null;
if(k!=null)
	s = new String(k.getBytes("iso8859-1"),"utf-8");
String c = request.getParameter("content");
String x = request.getParameter("curpage");
int curpage;
if (x==null) curpage=1;
else curpage=Integer.valueOf(x);
String sql="";
if (s==null||c==null||c.equals("")) sql="SELECT * from card_message natural join user_message order by user_id;";
else if (s.equals("账户")){
	sql="SELECT * from card_message natural join user_message where user_name =\""+c+"\";";
}else if (s.equals("用户名称")){
	sql="SELECT * from card_message natural join user_message where name=\""+c+"\");";
}else{
	sql="SELECT * from card_message natural join user_message order by user_id;";
}
String to ="cardManage.jsp?";
if (s!=null)to+="select="+s+"&";
if (c!=null) to+="content="+c+"&";
//System.out.println(sql+"  "+curpage+" ~"+s);
if (c==null) c="";
%>

<!DOCTYPE HTML>
<html>
  <head>
    <base href="<%=basePath%>">
     <meta charset="UTF-8"/>
	<title>设备管理</title>
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
		<%if(s!=null&&(s.equals("设备编号")||s.equals("设备名称")||s.equals("设备院系"))){ %>
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
		
		
		function del_cardmessage(num){
			if(confirm("是否删除该IC卡？")){
            	post("CardServlet", {card_number:num,operation:'del'});
            	//post("UserProduce", {user_id:userid,operation:'del'});
            }
		}
		function jump(sum){
			var curpage=parseInt($("#showPage").val());
			if (curpage<1) curpage=1;
			if (curpage>sum) curpage=sum;
			 window.location.href="<%=to%>"+"curpage="+curpage;
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
							<form class="navbar-form navbar-left" method="get" role="search" action="cardManage.jsp">
								<div class="form-group">
									<select id="select" name="select" class="selectpicker show-tick " style="width:120px;">
									  <option>账户</option>
									  <option>用户名称</option>
									</select>
									<input id="content" name="content" class="form-control" type="text" placeholder="搜索设备" value="<%=c %>"/>
									
									<button class="btn btn-default btn-primary" type="submit">搜索</button>
									<a class="btn btn-default btn-success" href="newCard.jsp">发卡</a>
								</div>
							</form>
					</div>
				</nav>


				
				
				<sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver"
				     url="jdbc:mysql://localhost:3306/db?useUnicode=true&characterEncoding=UTF-8&useSSL=false"
				     user="datauser"  password="135798"/>
				     
				<sql:query dataSource="${snapshot}" var="result">
					<%=sql%>
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
				<table  class="table table-hover">
						<thead><tr>
						<th>账户</th>
						<th>用户名称</th>
						<th>剩余金额</th>
						<th>消费总额</th>
						<th>状态</th>
			            </tr></thead>
					<c:forEach var="row" items="${result.rows}">
					<%
						Pagenum=Pagenum+1;
						cur=(Pagenum-1)/Pagesize+1;
						if (cur==curpage){
					 %>
						 <% if (Pagenum%2==0) {%> 
						 	<tr class="success"> <%}else { %>
							<tr>
						 <%} %>
						   <td><c:out value="${row.user_name}"/></td>
						   <td><c:out value="${row.name}"/></td>
						   <td><c:out value="${row.remaining_sum}"/></td>
						   <td><c:out value="${row.consumption}"/></td>
						   <td><c:out value="${row.status}"/></td>
						   <td>
							   <a class="btn btn-xs btn-primary" href="#">详情</a>
						       <button class="btn btn-xs btn-danger" onclick="del_cardmessage('${row.card_number}')">删除</button>
							</td>
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

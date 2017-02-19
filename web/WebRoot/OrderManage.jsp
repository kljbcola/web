
<%@page import="Data.DbPool"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@page import="Model.AdminHandler"%>
<%@page import="Model.AlertHandle"%>
<%@ page contentType="text/html" language="java"
 import="java.util.*,Bean.UserBean,Model.AdminHandler" 
 pageEncoding="utf-8" errorPage=""%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

String x = request.getParameter("curpage");
int curpage;
if (x==null) curpage=1;
else curpage=Integer.valueOf(x);
String to ="OrderManage.jsp?";

UserBean user=UserBean.checkSession(session);
if(user==null){
	session=request.getSession(true);
	AlertHandle.AlertWarning(session, "警告！", "您尚未登录！");
	response.sendRedirect("index.jsp");
	return ;
}
String sql="SELECT * from order_record natural join equip_message where user_id=\""+user.userID+"\";";
System.out.println(sql);
%>
<!doctype html>
<html>

<head>
	<base href="<%=basePath%>">
    <meta http-equiv="Content-Type" content="text/html" charset="utf-8"/>
	<title>用户管理</title>
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<script src="js/jquery.min.js"></script>
	<link href="css/bootstrap.min.css" rel="stylesheet">
	<script src="js/bootstrap.min.js"></script>
    <link href="css/bootstrap-select.min.css" rel="stylesheet">
    <script src="js/bootstrap-select.min.js"></script>
	
    <script type="text/javascript">
	   
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
	
	   function del_usermessage(userid){
	           if(confirm("是否删除该用户？")){
	           	post("UserProduce", {user_id:userid,operation:'del'});
	           }
	       }
		function jump(sum){
			var curpage=parseInt($("#showPage").val());
			if (curpage<1) curpage=1;
			if (curpage>sum) curpage=sum;
			 window.location.href="<%=to%>"+"curpage="+curpage;
		}
		/*function getClassName(abc){
			if (!document.getElementsByClassName) {
				var list=document.getElementsByTagName('*');
				var arr=[];
				for (var i=0;i<list.length;i++) {
				if(list[i].className==abc){
				//在浏览器版本不支持该方法时使用className属性
				arr.push(list[i]);
				}
				}
				return arr;
			} else{
			return document.getElementsByClassName(abc);
			}
		}*/
		function formatNum(a){
			var b="0"+a;
			return b[b.length-2]+b[b.length-1];
		}
		$(document).ready(function(){
				var x,y,a;
				var s=document.getElementsByClassName("start_time"); 
				for (var i=0;i<s.length;i++)
				{ 
					a=s[i].innerHTML;
					x=Math.floor(a);
					a=(a-x)*60;
					y=Math.round(a);
				    s[i].innerHTML=formatNum(x)+":"+formatNum(y);
				}
				var e=document.getElementsByClassName("end_time"); 
				for (var i=0;i<s.length;i++)
				{ 
					a=e[i].innerHTML;
					x=Math.floor(a);
					a=(a-x)*60;
					y=Math.round(a);
				    e[i].innerHTML=formatNum(x)+":"+formatNum(y);
				}
		});
		
    </script>

</head>

<body>
	<jsp:include flush="true" page="head.jsp"></jsp:include>
	
	
	 <div class="container">
		<div class="row clearfix">
			<div class="col-md-12 column">
				
				<sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver"
				     url="<%=DbPool.getConnectionUrl() %>"
				     user="<%=DbPool.getDBuser() %>"  password="<%=DbPool.getDBpassword() %>"/>
				     
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
						<th>设备名称</th>
						<th>预约日期</th>
						<th>预约开始时间</th>
						<th>预约结束时间</th>
			            </tr></thead>
					<c:forEach var="row" items="${result.rows}">
					<%
						Pagenum=Pagenum+1;            //第几行
						cur=(Pagenum-1)/Pagesize+1;   //第几页
						if (cur==curpage)
					{
					 %>
						 <% if (Pagenum%2==0) {%> 
						 	<tr class="success"> <%}else { %>
							<tr>
						 <%} %>
						   <td><c:out value="${row.equip_name}"/></td>
						   <td><c:out value="${row.order_date}"/></td>
						   <td class="start_time"><c:out value="${row.start_time}"/></td>
						   <td class="end_time"><c:out value="${row.end_time}"/></td>
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

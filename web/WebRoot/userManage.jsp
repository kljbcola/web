<%@page import="Model.AdminHandler"%>
<%@ page contentType="text/html" language="java"
 import="java.util.*,Bean.UserBean,Model.AdminHandler" 
 pageEncoding="utf-8" errorPage=""%>
<%
UserBean userBean=UserBean.checkSession(session);
if(userBean==null || !userBean.userType.equals("管理员"))
	response.sendRedirect("index.jsp");

String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!doctype html>
<html>

<head>
	<base href="<%=basePath%>">
    <meta http-equiv="Content-Type" content="text/html" charset="utf-8"/>
	<title>用户管理</title>
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<link href="http://cdn.bootcss.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet">
	<!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
	<!--[if lt IE 9]>
	<script src="http://ibootstrap-file.b0.upaiyun.com/www.layoutit.com/js/html5shiv.js"></script>
	<![endif]-->

</head>

<body>
	<jsp:include flush="true" page="head.jsp"></jsp:include>
	<table class="table">
				<thead><tr>
					<th>编号</th>
					<th>账号</th>
					<th>用户名称</th>
					<th>用户类型</th>
					<th></th>
                </tr></thead>
                <%
                ArrayList<UserBean> userList=AdminHandler.getUserBeans();
                Iterator<UserBean> it = userList.iterator();
                while(it.hasNext())
                {
                	UserBean user=it.next();
                 %>
                <tbody>
                	<%
                	if(user.userType.equals("管理员"))	{
                	 %>
					<tr class="danger">
					<%}else if(user.userType.equals("校内用户")){ %>
					<tr class="info">
					<%}else{ %>
					<tr class="success">
					<%} %>
						<td>
							<%=user.userID %>
						</td>
						<td>
							<%=user.userAccount %>
						</td>
						<td>
							<%=user.userName %>
						</td>
						<td>
							<%=user.userType %>
						</td>
                        <td>
                        	<button class="btn btn-xs btn-info"
                        	onclick="post('userInfo.jsp',{userID:'<%=user.userID %>'})">详情</button>
                      </td>
					</tr>
					<%}	%>
     </table>
	<script type=text/javascript>
	function post(URL, PARAMS) {
	  var temp = document.createElement("form");
	  temp.action = URL;
	  temp.method = "post";
	  temp.style.display = "none";
	  for (var x in PARAMS) {
	    var opt = document.createElement("textarea");
	    opt.name = x;
	    opt.value = PARAMS[x];
	    temp.appendChild(opt);
	  }
	  document.body.appendChild(temp);
	  temp.submit();
	  return temp;
	}
	</script>


	<script type="text/javascript" src="http://cdn.staticfile.org/jquery/2.0.0/jquery.min.js"></script>
	<!-- Include all compiled plugins (below), or include individual files as needed -->
	<script type="text/javascript" src="http://cdn.bootcss.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
</body>

</html>
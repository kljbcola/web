<%@ page contentType="text/html" language="java" import="java.util.*,Model.LoginHandler,Bean.UserBean" pageEncoding="utf-8" errorPage=""%>
	<jsp:include flush="true" page="Notice.jsp"></jsp:include>
	<%	UserBean userBean=UserBean.checkSession(session); %>
	<nav class="navbar navbar-default" role="navigation">
		<div class="navbar-header">
			<button class="navbar-toggle" type="button" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"> <span class="sr-only">Toggle navigation</span><span class="icon-bar"></span><span class="icon-bar"></span><span class="icon-bar"></span></button>			<a class="navbar-brand" href="#">实验室预约系统</a>
		</div>

		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
                <li class="dropdown">
					<a class="dropdown-toggle" data-toggle="dropdown">
                      	预约系统
                        <strong class="caret"></strong></a>
                        
					<ul class="dropdown-menu">
						<li><a href="equipManage.jsp">设备查询</a></li>
						<li><a href="OrderManage.jsp">预约查询</a></li>
						
						<% if(userBean!=null && userBean.userType.equals("管理员")){ %>
						<li class="divider"><li>
						<li><a href="userManage.jsp">用户管理</a></li>
						<li><a href="cardManage.jsp">IC卡管理</a></li>
						<li><a href="financeManage.jsp">财务统计</a></li>
						<% } %>
						<li class="divider"/>
						<li>
							<a href="#">关于</a>
						</li>
					</ul>
				</li>
			</ul>
			<ul class="nav navbar-nav navbar-right">
			
			<% 
				if(userBean!=null){
			 %>
				<li class="dropdown">
					<a class="dropdown-toggle" data-toggle="dropdown">			
						<span class="glyphicon glyphicon-user"></span>
                       	 个人中心
                        <strong class="caret"></strong></a>
					<ul class="dropdown-menu">
						<li><a>你好：<%= userBean.userType %>:</a></li>
						<li><a><%= userBean.userName %></a></li>
						<li>
							<a href="OrderManage.jsp">预约记录查询</a>
						</li>
						<li>
							<a href="userCard.jsp">卡内余额查询</a>
						</li>
						<li>
							<a href="userInfo.jsp?userID=<%=userBean.userID %>">修改个人信息</a>
						</li>
						<li>
							<a href="userSetPW.jsp">修改密码</a>
						</li>
						<li class="divider"/>
						<li>
							<a href="Logout">退出登陆</a>
						</li>
					</ul>
				</li>
				<% }else{ %>
					<li>
							<a href="login.jsp">
							<span class="glyphicon glyphicon-log-in"></span>
							登录　　
							 </a>
						</li>
				<%} %>
			</ul>
		</div>
	</nav>

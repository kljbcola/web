<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@page import="Bean.EquipInfoBean"%>
<%@page import="Bean.UserBean"%>
<%@page import="Model.EquipHandler"%>
<%
request.setCharacterEncoding("UTF-8");
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
String equipnum=(String)request.getParameter("equip_number");
String bank="~~~~~~~";
if(equipnum==null)
	response.sendRedirect("index.jsp");
EquipInfoBean equipinfo=EquipHandler.getEquipInfoBean(equipnum);
if(equipinfo==null)
	response.sendRedirect("index.jsp");
equipinfo=EquipHandler.changeBank(equipinfo);

System.out.println(equipinfo.specification);
%>

<!DOCTYPE HTML>
<html>
  <head>
    <base href="<%=basePath%>">
     <meta charset="UTF-8"/>
	<title>设备展示</title>
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scaequiple=no">
	<script src="js/jquery.min.js"></script>
	<link href="css/bootstrap.min.css" rel="stylesheet">
	<script src="js/bootstrap.min.js"></script>
    <link href="css/bootstrap-select.min.css" rel="stylesheet">
    <script src="js/bootstrap-select.min.js"></script>


	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->

  </head>
  
  <body>
  		<jsp:include flush="true" page="head.jsp"></jsp:include>
  			
		<div class="container">
			<div class="row clearfix">
				<div class="col-md-12 col-xs-12">
					<div class="page-header">
						<h1>
							 <%=equipinfo.equip_name %><small>设备编号：<%=equipinfo.equip_number %></small>
						</h1>
					</div>
					<div class="row clearfix">
						<div class="col-md-4 col-xs-4">
							<img class="img-rounded" alt="140x140" src="http://ibootstrap-file.b0.upaiyun.com/lorempixel.com/140/140/default.jpg" />
						</div>
						<div class="col-md-4 col-xs-4">
							<dl>
								<dt>设备型号:</dt>
								<dd>
									<%=bank+equipinfo.equip_model %>
								</dd>
								<dt>当前状态:</dt>
								<dd>
									<%=bank+equipinfo.equip_status %>
								</dd>
								<dt>负责人:</dt>
								<dd>
									<%=bank+equipinfo.owner %>
								</dd>
								<dt>联系电话:</dt>
								<dd>
									<%=bank+equipinfo.phone %>
								</dd>
								<dt>电子邮件:</dt>
								<dd>
									<%=bank+equipinfo.Email %>
								</dd>
								
							</dl>
						</div>
						<div class="col-md-2 col-xs-2">
								<a class="btn btn-default btn-primary" href="equipOrder.jsp?equip_number=<%=equipinfo.equip_number %>">预约</a>
						</div>
						
					</div>
					
					
					
					
					<div class="tabbable" id="tabs-928077">
						<ul class="nav nav-tabs">
							<li class="active">
								 <a href="#panel-61100" data-toggle="tab">主要规格及技术指标</a>
							</li>
							<li>
								 <a href="#panel-609312" data-toggle="tab">主要功能及特色</a>
							</li>
							<li>
								 <a href="#panel-609313" data-toggle="tab">设备使用相关说明</a>
							</li>
							
						</ul>
						<div class="tab-content">
							<div class="tab-pane active" id="panel-61100">
								<p>
									<%=equipinfo.specification %>
								</p>
							</div>
							<div class="tab-pane" id="panel-609312">
								<p>
									<%=equipinfo.description %>
								</p>
							</div>
							<div class="tab-pane" id="panel-609313">
								<p>
									<%=equipinfo.attachment %>
								</p>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
  </body>
</html>

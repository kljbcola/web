<%@page import="Model.AlertHandle"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="Bean.EquipInfoBean"%>
<%@page import="Model.EquipHandler"%>
<%@page import="Bean.CardInfoBean"%>
<%@page import="Model.CardHandler"%>
<%@page import="Bean.UserBean"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
String equipnum=(String)request.getParameter("equip_number");
if(equipnum==null)
{
	AlertHandle.AlertDanger(session, "错误", "错误的操作！");
	response.sendRedirect("index.jsp");
	return ;
}
EquipInfoBean equipinfo=EquipHandler.getEquipInfoBean(equipnum);
if(equipinfo==null)
{
	AlertHandle.AlertWarning(session, "警告", "没有找到该设备！");
	response.sendRedirect("index.jsp");
	return ;
}
UserBean userBean=UserBean.checkSession(session);
if(userBean==null){
	AlertHandle.AlertWarning(session, "警告", "请登录！");
	response.sendRedirect("index.jsp");
	return ;
}
System.out.println(userBean.userName);
CardInfoBean cardinfo=CardHandler.getCardInfoBeanByUser(userBean.userAccount);
if (cardinfo==null)
{
	AlertHandle.AlertWarning(session, "警告", "没有找到可以使用的IC卡！");
	response.sendRedirect("index.jsp");
	return ;
}
%>

<!DOCTYPE HTML>
<html>
  <head>
    <base href="<%=basePath%>">
    <meta charset="utf-8"/>
    <title>设备预约</title>
    <script src="js/jquery.min.js"></script>
	<link href="css/bootstrap.min.css" rel="stylesheet">
	<script src="js/bootstrap.min.js"></script>
    <link href="css/bootstrap-select.min.css" rel="stylesheet">
    <script src="js/bootstrap-select.min.js"></script>
    <link href="css/bootstrap-datetimepicker.min.css" rel="stylesheet">
    <script src="js/moment-with-locales.min.js"></script>
    <script src="js/bootstrap-datetimepicker.min.js"></script>
	<style type="text/css">
	.progress {
	    height: 30px;
	    margin-bottom: 0px;
	    overflow: hidden;
	    background-color: #f5f5f5;
	    border-radius: 0px;
	    -webkit-box-shadow: inset 0 1px 2px rgba(0,0,0,.1);
	    box-shadow: inset 0 1px 2px rgba(0,0,0,.1);
	}
	.jslider {
	    display: block;
	    width: 100%;
	    height: 2em;
	    position: relative; 
	    font-family: Arial, sans-serif;
	}
	.jslider .jslider-scale { position: relative;top: 0px; }
	.jslider .jslider-scale span {
	    position: absolute;
	    height: 10px;
	    border-left: 1px solid;
	    font-size: 0;
	}
	.jslider .jslider-scale ins {
	    font-size: 15px;
	    text-decoration: none;
	    position: absolute;
	    left: 0px;
	    top: 10px;
	}
	.progress-bar.progress-bar-none{
		background-color:#a7a7a7;
	}
	.progress-bar.progress-bar-ordered{
		background-color:#dc6464;
	}
	.progress-bar.progress-bar-use{
		background-color:#5cb85c;
	}
    </style>
	<script type="text/javascript">
	var order_start_time=0;
	var order_end_time=0;
	var OrderDate;
	var minTime=<%=equipinfo.min_time.equals("")?0:equipinfo.min_time %>;
	var maxTime=<%=equipinfo.max_time.equals("")?24:equipinfo.max_time %>;
	var forbid_range=new Array();
	var v=<%=equipinfo.price %>;
	var m=<%=cardinfo.remaining_sum %>;
	var forbid_range=new Array();
	function checkTime(t1,t2){
		if(t2-t1<=0||t2-t1<minTime||t2-t1>maxTime)return false;
			for(var i=0;i<forbid_range.length;i++)
				if(!(t1>=forbid_range[i].end||t2<=forbid_range[i].start))
					return false;
		return true;
	}
	function getOrderMoney(){
		var price=<%=equipinfo.price %>;
		return (order_end_time-order_start_time)*price;
	}
	function checkM(){  //price, money
		var sum=v*(order_end_time-order_start_time);
		if (m>=0 && m>=sum/2) return true;
		return false;
	}
	 function updateForbid(str){
		forbid_range=new Array();
		var arr=str.split(";");
		for (var i = 0; i <arr.length; i++) {
			if(arr[i]){
				var nums=arr[i].split(",");
				var z=parseInt(nums[2]);
				var x=parseFloat(nums[0]);
				var y=parseFloat(nums[1]);
				if(z>1){
					x-=0.25;
					y+=0.25;
				}
				forbid_range.push({"start":x,"end":y,"type":z});
			}
		}
	}
	function getbar(type,width){
		if(type<=1)
			return "<div class=\"progress-bar progress-bar-none\" role=\"progressbar\" style=\"width:" +width+"%;\"> </div>";
		else if(type==2)
			return "<div class=\"progress-bar progress-bar-ordered\" role=\"progressbar\" style=\"width:" +width+"%;\"> </div>";
		else
			return "<div class=\"progress-bar progress-bar-use\" role=\"progressbar\" style=\"width:" +width+"%;\"> </div>";
	}
	function updateProgress(){
		var progress=[ document.getElementById("progress01"),
						document.getElementById("progress02"),
						document.getElementById("progress03"),
						document.getElementById("progress04")];
		var count=0;
		for(var i=0;i<progress.length;i++)
			progress[i].innerHTML="";
		var last=0.0;
		var end_time=6;
		var str="";
		for(var i=0;i<forbid_range.length;i++)
		{
			var width;
			if(forbid_range[i].start<last)forbid_range[i].start=last;
			if(forbid_range[i].end>24)forbid_range[i].end=24;
			if(last<forbid_range[i].start&&forbid_range[i].start<end_time){
				width=(forbid_range[i].start-last)/6.0*100;
				str=getbar(3,width);
				progress[count].innerHTML+=str;
				last=forbid_range[i].start;
			}
			if(forbid_range[i].end<end_time){
				width=(forbid_range[i].end-forbid_range[i].start)/6.0*100;
				str=getbar(forbid_range[i].type,width);
				progress[count].innerHTML+=str;
				last=forbid_range[i].end;
			}else if(forbid_range[i].end==end_time)
			{
				width=(forbid_range[i].end-forbid_range[i].start)/6.0*100;
				str=getbar(forbid_range[i].type,width);
				progress[count].innerHTML+=str;
				count++;
				last=forbid_range[i].end;
				end_time+=6;
			}else
			{
				if(forbid_range[i].start>=end_time){
					width=(end_time-last)/6.0*100;
					str=getbar(3,width);
					progress[count].innerHTML+=str;
					i--;count++;
					last=end_time;
					end_time+=6;

				}
				else{
					width=(end_time-forbid_range[i].start)/6.0*100;
					str=getbar(forbid_range[i].type,width);
					forbid_range[i].start=end_time;
					progress[count].innerHTML+=str;
					i--;count++;
					last=end_time;
					end_time+=6;
				}
				
			}
		}
		for(;last<24;end_time+=6,count++)
		{

			width=(end_time-last)/6.0*100;
			str=getbar(3,width);
			progress[count].innerHTML+=str;
			last=end_time;
		}
		
	}
	function formatNum(a){
		var b="0"+a;
		return b[b.length-2]+b[b.length-1];
	}
	function float2time(time){
		return formatNum(Math.floor(time))+":"+formatNum(Math.floor(time*60)%60);
	}
	function updateTime(){
		var h=parseInt($("#start_hour").val());
		var m=parseInt($("#start_minute").val());
		order_start_time=h+(m/60.0);
		h=parseInt($("#end_hour").val());
		m=parseInt($("#end_minute").val());
		order_end_time=h+(m/60.0);
	}
<% if(equipinfo.equip_status.equals("开放")){ %>
	function orderSubmit(){
		if (!checkM()) {alert("余额不足");return;}
		<%if(userBean.userType.equals("校外用户")&&equipinfo.equip_permission.equals("校内用户")){%>
			alert("权限不足!");
		 <% }
			else
			{%>
				updateTime();
				if(!checkTime(order_start_time,order_end_time))alert("所选时间无效！");
				else
				if(confirm("确认要预约吗？\n预约日期："+OrderDate+"\n预约时间："+
					float2time(order_start_time)+"--"+float2time(order_end_time)
					+"\n所需总金额"+getOrderMoney()
					+"\n预支付金额:"+getOrderMoney()/2))
					post('OrderProduce', {equip_number:<%=equipnum%>,op:'order',order_date:OrderDate,start_time:order_start_time,end_time:order_end_time});
				
			<%} %>
	}
<%}%>
	function refreshDate(e){
		OrderDate=e;
        var xmlhttp;
		var str;
		if (OrderDate.length==0)
		   return;
		if (window.XMLHttpRequest) {
		   // IE7+, Firefox, Chrome, Opera, Safari 浏览器执行代码
		   xmlhttp=new XMLHttpRequest();
		}
		else {
			// IE6, IE5 浏览器执行代码
			xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
		}
			  
		xmlhttp.onreadystatechange=function() {
			if (xmlhttp.readyState==4 && xmlhttp.status==200)
			{
				str=xmlhttp.responseText;
				updateForbid(str);
				updateProgress();
			}
		}
		xmlhttp.open("GET","FastQuery?op=order&order_date="+OrderDate+"&equipid="+<%=equipnum%>,true);
		xmlhttp.send();
	}
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
	$(function(){
		$('#order_date').datetimepicker({
				inline: true,
				sideBySide: true,
				minDate:moment(),
                locale: 'zh-CN',
                format: 'YYYY-MM-DD'});
        
        $('#order_date').on("dp.change",function(e){refreshDate(e.date.format('YYYY-MM-DD'));});
        refreshDate(moment().format('YYYY-MM-DD'));
	});
	
	</script>
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
									<%=equipinfo.equip_model %>
								</dd>
								<dt>当前状态:</dt>
								<dd>
									<%=equipinfo.equip_status %>
								</dd>
								<dt>负责人:</dt>
								<dd>
									<%=equipinfo.owner %>
								</dd>
								<dt>联系电话:</dt>
								<dd>
									<%=equipinfo.phone %>
								</dd>
								<dt>电子邮件:</dt>
								<dd>
									<%=equipinfo.Email %>
								</dd>
								
							</dl>
						</div>
					</div>
					<div class="navbar-header">
							<div class="col-md-12 col-xs-12 " style="min-width:500px">
							<div class="col-md-12 col-xs-12" >
							<div class="col-md-6 col-xs-6">
								<label>设备名称：<%=equipinfo.lab_name %></label><br>
								<label>设备型号：<%=equipinfo.equip_model %></label><br>
								<label>最短预约时间：<%=equipinfo.min_time.equals("")?"-":equipinfo.min_time %></label><br>
								<label>实验室地址：<%=equipinfo.lab_location %></label><br>
								<label>卡内余额:<%=cardinfo.remaining_sum %></label>
								
							</div>
							<div class="col-md-6 col-xs-6">
								<label>设备编号：<%=equipinfo.equip_number %></label><br>
								<label>设备状态：<%=equipinfo.equip_status %></label><br>
								<label>最长预约时间：<%=equipinfo.max_time.equals("")?"-":equipinfo.max_time %></label><br>
								<label>设备权限：<%=equipinfo.equip_permission%></label><br>
								<label>设备价格:<%=equipinfo.price %>元/小时</label>
							</div>
							</div>
							<div class="col-md-12 col-xs-12">
							<label for="order_date">请选择预约日期</label>
							<div id="order_date"></div>
							
							<table  class="col-md-12 col-xs-12">
								<tr>
									<td colspan="2">
									<div style="padding: 15px" >
											<div style="float: right;margin-right: 10px;">
												<div style="width: 30px;height: 20px;float:left;background: #a7a7a7"></div>
												<div style="float: right"><label>不开放时间</label></div>
											</div>
											<div style="float: right;margin-right: 10px;">
												<div style="width: 30px;height: 20px;float:left;background: #dc6464"></div>
												<div style="float: right"><label>被占用时间</label></div>
											</div>
											<div style="float: right;margin-right: 10px;">
												<div style="width: 30px;height: 20px;float:left;background: #5cb85c"></div>
												<div style="float: right"><label>可预约时间</label></div>
											</div>
										</div>
									</td>
								</tr>
								<tr>
									<td colspan="2">
										<div style="padding: 20px;min-width: 600px">
											<div class="progress" id="progress01">
											</div>
											<span class="jslider jslider-limitless">
														<div class="jslider-scale">
															<span style="left: 0%">	  <ins style="margin-left: -15.5px;">00:00</ins></span>
															<span style="left: 4.17%;height: 7px"></span>
															<span style="left: 8.33%;"><ins style="margin-left: -15.5px;">00:30</ins></span>
															<span style="left: 12.5%;height: 7px"></span>
															<span style="left: 16.67%"><ins style="margin-left: -15.5px;">01:00</ins></span>
															<span style="left: 20.83%;height: 7px"></span>
															<span style="left: 25.0%;"><ins style="margin-left: -15.5px;">01:30</ins></span>
															<span style="left: 29.17%;height: 7px"></span>
															<span style="left: 33.3%"><ins style="margin-left: -15.5px;">02:00</ins></span>
															<span style="left: 37.5%;height: 7px"></span>
															<span style="left: 41.67%;"><ins style="margin-left: -15.5px;">02:30</ins></span>
															<span style="left: 45.83%;height: 7px"></span>
															<span style="left: 50.0%"><ins style="margin-left: -15.5px;">03:00</ins></span>
															<span style="left: 54.17%;height: 7px"></span>
															<span style="left: 58.3%;"><ins style="margin-left: -15.5px;">03:30</ins></span>
															<span style="left: 62.5%;height: 7px"></span>
															<span style="left: 66.67%"><ins style="margin-left: -15.5px;">04:00</ins></span>
															<span style="left: 70.83%;height: 7px"></span>
															<span style="left: 75.0%;"><ins style="margin-left: -15.5px;">04:30</ins></span>
															<span style="left: 79.17%;height: 7px"></span>
															<span style="left: 83.3%"><ins style="margin-left: -15.5px;">05:00</ins></span>
															<span style="left: 87.5%;height: 7px"></span>
															<span style="left: 91.67%;"><ins style="margin-left: -15.5px;">05:30</ins></span>
															<span style="left: 95.83%;height: 7px"></span>
															<span style="left: 100%"><ins style="margin-left: -15.5px;">06:00</ins></span>
														</div>
											</span>
											<div class="progress" id="progress02">
											</div>
											<span class="jslider jslider-limitless">
														<div class="jslider-scale">
															<span style="left: 0%">	  <ins style="margin-left: -15.5px;">06:00</ins></span>
															<span style="left: 4.17%;height: 7px"></span>
															<span style="left: 8.33%;"><ins style="margin-left: -15.5px;">06:30</ins></span>
															<span style="left: 12.5%;height: 7px"></span>
															<span style="left: 16.7%"><ins style="margin-left: -15.5px;">07:00</ins></span>
															<span style="left: 20.83%;height: 7px"></span>
															<span style="left: 25.0%;"><ins style="margin-left: -15.5px;">07:30</ins></span>
															<span style="left: 29.17%;height: 7px"></span>
															<span style="left: 33.3%"><ins style="margin-left: -15.5px;">08:00</ins></span>
															<span style="left: 37.5%;height: 7px"></span>
															<span style="left: 41.67%;"><ins style="margin-left: -15.5px;">08:30</ins></span>
															<span style="left: 45.83%;height: 7px"></span>
															<span style="left: 50.0%"><ins style="margin-left: -15.5px;">09:00</ins></span>
															<span style="left: 54.17%;height: 7px"></span>
															<span style="left: 58.3%;"><ins style="margin-left: -15.5px;">09:30</ins></span>
															<span style="left: 62.5%;height: 7px"></span>
															<span style="left: 66.7%"><ins style="margin-left: -15.5px;">10:00</ins></span>
															<span style="left: 70.83%;height: 7px"></span>
															<span style="left: 75.0%;"><ins style="margin-left: -15.5px;">10:30</ins></span>
															<span style="left: 79.17%;height: 7px"></span>
															<span style="left: 83.3%"><ins style="margin-left: -15.5px;">11:00</ins></span>
															<span style="left: 87.5%;height: 7px"></span>
															<span style="left: 91.67%;"><ins style="margin-left: -15.5px;">11:30</ins></span>
															<span style="left: 95.83%;height: 7px"></span>
															<span style="left: 100%"><ins style="margin-left: -15.5px;">12:00</ins></span>
														</div>
											</span>
											<div class="progress" id="progress03">
											</div>
											<span class="jslider jslider-limitless">
														<div class="jslider-scale">
															<span style="left: 0%">	  <ins style="margin-left: -15.5px;">12:00</ins></span>
															<span style="left: 4.17%;height: 7px"></span>
															<span style="left: 8.33%;"><ins style="margin-left: -15.5px;">12:30</ins></span>
															<span style="left: 12.5%;height: 7px"></span>
															<span style="left: 16.7%"><ins style="margin-left: -15.5px;">13:00</ins></span>
															<span style="left: 20.83%;height: 7px"></span>
															<span style="left: 25.0%;"><ins style="margin-left: -15.5px;">13:30</ins></span>
															<span style="left: 29.17%;height: 7px"></span>
															<span style="left: 33.3%"><ins style="margin-left: -15.5px;">14:00</ins></span>
															<span style="left: 37.5%;height: 7px"></span>
															<span style="left: 41.67%;"><ins style="margin-left: -15.5px;">14:30</ins></span>
															<span style="left: 45.83%;height: 7px"></span>
															<span style="left: 50.0%"><ins style="margin-left: -15.5px;">15:00</ins></span>
															<span style="left: 54.17%;height: 7px"></span>
															<span style="left: 58.3%;"><ins style="margin-left: -15.5px;">15:30</ins></span>
															<span style="left: 62.5%;height: 7px"></span>
															<span style="left: 66.7%"><ins style="margin-left: -15.5px;">16:00</ins></span>
															<span style="left: 70.83%;height: 7px"></span>
															<span style="left: 75.0%;"><ins style="margin-left: -15.5px;">16:30</ins></span>
															<span style="left: 79.17%;height: 7px"></span>
															<span style="left: 83.3%"><ins style="margin-left: -15.5px;">17:00</ins></span>
															<span style="left: 87.5%;height: 7px"></span>
															<span style="left: 91.67%;"><ins style="margin-left: -15.5px;">17:30</ins></span>
															<span style="left: 95.83%;height: 7px"></span>
															<span style="left: 100%"><ins style="margin-left: -15.5px;">18:00</ins></span>
														</div>
											</span>
											<div class="progress" id="progress04">
											</div>
											<span class="jslider jslider-limitless">
														<div class="jslider-scale">
															<span style="left: 0%">	  <ins style="margin-left: -15.5px;">18:00</ins></span>	
															<span style="left: 4.17%;height: 7px"></span>
															<span style="left: 8.33%;"><ins style="margin-left: -15.5px;">18:30</ins></span>
															<span style="left: 12.5%;height: 7px"></span>
															<span style="left: 16.7%"><ins style="margin-left: -15.5px;">19:00</ins></span>
															<span style="left: 20.83%;height: 7px"></span>
															<span style="left: 25.0%;"><ins style="margin-left: -15.5px;">19:30</ins></span>
															<span style="left: 29.17%;height: 7px"></span>
															<span style="left: 33.3%"><ins style="margin-left: -15.5px;">20:00</ins></span>
															<span style="left: 37.5%;height: 7px"></span>
															<span style="left: 41.67%;"><ins style="margin-left: -15.5px;">20:30</ins></span>
															<span style="left: 45.83%;height: 7px"></span>
															<span style="left: 50.0%"><ins style="margin-left: -15.5px;">21:00</ins></span>
															<span style="left: 54.17%;height: 7px"></span>
															<span style="left: 58.3%;"><ins style="margin-left: -15.5px;">21:30</ins></span>
															<span style="left: 62.5%;height: 7px"></span>
															<span style="left: 66.7%"><ins style="margin-left: -15.5px;">22:00</ins></span>
															<span style="left: 70.83%;height: 7px"></span>
															<span style="left: 75.0%;"><ins style="margin-left: -15.5px;">22:30</ins></span>
															<span style="left: 79.17%;height: 7px"></span>
															<span style="left: 83.3%"><ins style="margin-left: -15.5px;">23:00</ins></span>
															<span style="left: 87.5%;height: 7px"></span>
															<span style="left: 91.67%;"><ins style="margin-left: -15.5px;">23:30</ins></span>
															<span style="left: 95.83%;height: 7px"></span>
															<span style="left: 100%"><ins style="margin-left: -15.5px;">24:00</ins></span>
														</div>
											</span>
										</div>
									</td>
								</tr>
								<tr>
									<td>
										<p>选择预约时间</p>
									</td>
								</tr>
								<tr>
										<td>
											<label for="start_hour">开始时间</label>
										</td>
										<td>
											<label for="start_hour">结束时间</label>
										</td>
									</tr>
								<tr>
									<td class="col-xs-6 col-md-6" style="min-width: 350px;">
												<div style="padding: 15px;" >
													<select id="start_hour" name="start_hour" class="selectpicker col-xs-4 col-md-4">
														<option>0</option>
														<option>1</option>
														<option>2</option>
														<option>3</option>
														<option>4</option>
														<option>5</option>
														<option>6</option>
														<option>7</option>
														<option>8</option>
														<option>9</option>
														<option>10</option>
														<option>11</option>
														<option>12</option>
														<option>13</option>
														<option>14</option>
														<option>15</option>
														<option>16</option>
														<option>17</option>
														<option>18</option>
														<option>19</option>
														<option>20</option>
														<option>21</option>
														<option>22</option>
														<option>23</option>
													</select>
													<label>时</label>
													<select id="start_minute" name="start_minute" class="selectpicker col-xs-4 col-md-4">
														<option>0</option>
														<option>15</option>
														<option>30</option>
														<option>45</option>
													</select>
													<label>分</label>
												</div>
											</td>
										<td class="col-xs-6 col-md-6" style="min-width: 350px;">
											<div style="padding: 15px;">
											<select id="end_hour" name="end_hour"  class="selectpicker col-xs-4 col-md-4">
												<option>0</option>
												<option>1</option>
												<option>2</option>
												<option>3</option>
												<option>4</option>
												<option>5</option>
												<option>6</option>
												<option>7</option>
												<option>8</option>
												<option>9</option>
												<option>10</option>
												<option>11</option>
												<option>12</option>
												<option>13</option>
												<option>14</option>
												<option>15</option>
												<option>16</option>
												<option>17</option>
												<option>18</option>
												<option>19</option>
												<option>20</option>
												<option>21</option>
												<option>22</option>
												<option>23</option>
											</select>
											<label>时</label>
											<select id="end_minute" name="end_minute" class="selectpicker col-xs-4 col-md-4">
												<option>0</option>
												<option>15</option>
												<option>30</option>
												<option>45</option>
											</select>
											<label>分</label>
											</div>
										</td>
								</tr>	
								<tr>
								<td colspan="2">
								<div style="float: right;">
												<% if(equipinfo.equip_status.equals("关闭")){ %>
													<label>该设备不可预约</label>
											 	<%}else { %>
											 		<button class="btn btn-primary" onclick="orderSubmit()">提交</button>
												<%} %>
										</div>
								</td></tr>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
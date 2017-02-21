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
System.out.println(userBean.userName);
CardInfoBean cardinfo=CardHandler.getCardInfoBeanByUser(userBean.userAccount);
if (cardinfo==null)
{
	AlertHandle.AlertWarning(session, "警告", "没有找到该卡！");
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
    <script src="js/bootstrap-slider.min.js"></script>
    <link rel="stylesheet" href="css/bootstrap-slider.min.css" />
	<style type="text/css">
		.graybg{
		background-color: #E0E0E0;
		}
	    #slider .slider-selection {
		background: #81bfde;
		}
	    #slider .slider-rangeHighlight {
		background: #f70616;
		}
    </style>
	<script type="text/javascript">
	var OpenTime=time2float("<%=equipinfo.open_hours.equals("")?"00:00":equipinfo.open_hours %>");
	var CloseTime=time2float("<%=equipinfo.close_hours.equals("")?"24:00":equipinfo.close_hours %>");
	var minTime=<%=equipinfo.min_time.equals("")?0:equipinfo.min_time %>;
	var maxTime=<%=equipinfo.max_time.equals("")?24:equipinfo.max_time %>;
	var sliderX=OpenTime;
	var sliderY=CloseTime;
	var OrderDate;
	var forbid_range=new Array();
	var v=<%=equipinfo.price %>;
	var m=<%=cardinfo.remaining_sum %>;
	function updateForbid(str){
		forbid_range=new Array();
		var arr=str.split(";");
		for (var i = 0; i <arr.length; i++) {
			if(arr[i]){
				var nums=arr[i].split(",");
				var x=parseFloat(nums[0])-0.25;
				var y=parseFloat(nums[1])+0.25;
				if(x<OpenTime)x=OpenTime;
				if(y>CloseTime)y=CloseTime;
				forbid_range.push({"start":x,"end":y});
				//$(".slider").slider("refresh");
			}
		}
		destorySlider();
		initSlider();
		SliderChange();
	}
	function destorySlider(){
		$(".slider").slider("destroy");
	}
	function initSlider(){
		$(".slider").slider({
			 		id: 'slider',
					min: OpenTime,
				    max: CloseTime,
				    step: 0.25,
				    value: [sliderX, sliderY],
					formatter: function(value) {
					var arr=(""+value).split(',');
					var t1=parseFloat(arr[0])*60;
					var t2=parseFloat(arr[1])*60;
					return "预约时间："+formatNum(Math.floor(t1/60))+":"+formatNum(t1%60)+"--"+formatNum(Math.floor(t2/60))+":"+formatNum(t2%60);
					},
					ticks_snap_bounds: 30,
					rangeHighlights: forbid_range});
		$(".slider").change(function(){
			SliderChange();
		});
	}
	function checkTime(t1,t2){
		if(t2-t1==0||t2-t1<minTime||t2-t1>maxTime)return false;
			for(var i=0;i<forbid_range.length;i++)
				if(!(t1>=forbid_range[i].end||t2<=forbid_range[i].start))
					return false;
		return true;
	}
	
	function SliderChange(){
			var str=$("#islider").val();
			var arr=str.split(',');
			var t1=parseFloat(arr[0]);
			var t2=parseFloat(arr[1]);
			$('#start_time').val(float2time(t1));
			$('#end_time').val(float2time(t2));
			sliderX=t1;
			sliderY=t2;
			if (checkTime(t1,t2)) {
				$("#feedback").attr("class","glyphicon glyphicon-ok form-control-feedback");
			}
			else{
				$("#feedback").attr("class","glyphicon glyphicon-remove form-control-feedback");
			}
	}
	function formatNum(a){
		var b="0"+a;
		return b[b.length-2]+b[b.length-1];
	}
	function time2float(time){
		var arr=time.split(':');
		return parseFloat(arr[0])+(parseFloat(arr[1])/60.0);
	}
	function float2time(time){
		return formatNum(Math.floor(time))+":"+formatNum(Math.floor(time*60)%60);
	}
	function checkM(){  //price, money
		var str=$("#islider").val();
		var arr=str.split(',');
		var t1=parseFloat(arr[0]);
		var t2=parseFloat(arr[1]);
		var sum=v*(t2-t1);
		if (m>0 && m>=sum/2) return true;
		return false;
	}
<% if(equipinfo.equip_status.equals("开放")){ %>
	function orderSubmit(){
		if (!checkM()) alert("余额不足");
		<% if(userBean==null){ %>
			alert("请先登录！");
		<% }else
		{
			if(userBean.userType.equals("校外用户")&&equipinfo.equip_permission.equals("校内用户")){%>
				alert("权限不足!");
		 <% }
			else
			{%>
				if(!checkTime(sliderX,sliderY))alert("所选时间无效！");
				else
				if(confirm("确认要预约吗？\n预约日期："+OrderDate+"\n预约时间："+
					$("#start_time").val()+"--"+$("#end_time").val())){
					post('OrderProduce', {equip_number:<%=equipnum%>,order_date:OrderDate,start_time:sliderX,end_time:sliderY});
				}
			<%} 
		}%>
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
			}
		}
		xmlhttp.open("GET","FastQuery?order_date="+OrderDate+"&equipid="+<%=equipnum%>,true);
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
		initSlider();
		SliderChange();
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
					
					<nav class="navbar navbar-default" role="navigation">
						<div class="navbar-header">
							<div class="col-md-6 col-xs-6 " style="min-width:500px">
							<div class="col-md-12 col-xs-12" >
							<div class="col-md-6 col-xs-6">
								<label>设备名称：<%=equipinfo.lab_name %></label><br>
								<label>设备型号：<%=equipinfo.equip_model %></label><br>
								<label>开放时间：<%=equipinfo.open_hours.equals("")?"00:00":equipinfo.open_hours %></label><br>
								<label>最短预约时间：<%=equipinfo.min_time.equals("")?"-":equipinfo.min_time %></label><br>
								<label>实验室地址：<%=equipinfo.lab_location %></label>
							</div>
							<div class="col-md-5 col-xs-5">
								<label>设备编号：<%=equipinfo.equip_number %></label><br>
								<label>设备状态：<%=equipinfo.equip_status %></label><br>
								<label>关闭时间：<%=equipinfo.close_hours.equals("")?"24:00":equipinfo.close_hours %></label><br>
								<label>最长预约时间：<%=equipinfo.max_time.equals("")?"-":equipinfo.max_time %></label><br>
								<label>设备权限：<%=equipinfo.equip_permission%></label>
							</div>
							</div>
							<div class="col-md-12 col-xs-12">
							<label for="order_date">请选择预约日期</label>
							</div>
							<div id="order_date"></div>
							<div class="col-xs-8 col-md-8">
								<label>请拖动滑动条选择预约时间</label>
							</div>
							<div class="col-xs-8 col-md-8">
								<label>红色区域为已被预约时间段</label>
							</div>
							<div class="col-xs-6 col-md-6">
								<label>卡内余额:<%=cardinfo.remaining_sum %></label>
							</div>
							<div class="col-xs-6 col-md-6">
								<label>设备价格:<%=equipinfo.price %>元/小时</label>
							</div>
							<div class="col-xs-12 col-md-12 " style="padding:30px 20px 20px 20px;">
							<div class="col-xs-10 col-md-10">
							<input id="islider" class="slider" style="width: 100%;" data-slider-id="slider" data-slider-step="0.25" data-slider-min="0" data-slider-max="24" data-slider-value="[0,24]"  data-slider-ticks-snap-bounds="30"/>
							</div>
							<div class="col-md-2 col-xs-2"><span id="feedback" class="glyphicon glyphicon-remove form-control-feedback"></span></div>
							</div>
							
							 
							<div class="col-md-5 col-xs-5">
							<div class="input-group">            
								<span class="input-group-addon">开始</span>
								<input id='start_time' class="form-control" style="min-width: 70px;max-width: 100px" type='text' name="start_time" readonly="readonly" />
							</div>
							</div>
							<div class="col-md-5 col-xs-5">
							<div class="input-group">            
								<span class="input-group-addon">结束</span>
								<input id='end_time' class="form-control" type='text' style="min-width: 70px;max-width: 100px" name="end_time" readonly="readonly" />
							</div>
							
							</div>
							<% if(equipinfo.equip_status.equals("关闭")){ %>
								<label>该设备不可预约</label>
						 	<%}else { %>
						 		<div class="col-md-2 col-xs-2"><button class="btn btn-primary" onclick="orderSubmit()">提交</button></div>
							<%}  %>
						</div>
					</div>
				</nav>
					
				
				</div>
			</div>
		</div>
</body>
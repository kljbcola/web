<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page import="Bean.EquipInfoBean"%>
<%@page import="Model.EquipHandler"%>
<%@page import="Bean.UserBean"%>
<%@page import="Model.AlertHandle"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

UserBean user=UserBean.checkSession(session);
if(user==null||!user.userType.equals("管理员")){
	AlertHandle.AlertWarning(session, "警告！","非法操作！");
	response.sendRedirect("index.jsp");
}
int row=3;
%>

<!DOCTYPE HTML>
<html>
  <head>
 	<meta charset="UTF-8">
    <base href="<%=basePath%>">
    
    <title>添加设备</title>
    
	<script src="http://cdn.bootcss.com/jquery/3.1.1/jquery.min.js"></script>
    <link href="http://netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.min.css" rel="stylesheet">
    <script src="http://netdna.bootstrapcdn.com/bootstrap/3.0.0/js/bootstrap.min.js"></script>


    <link href="http://cdn.bootcss.com/bootstrap-select/2.0.0-beta1/css/bootstrap-select.min.css" rel="stylesheet">
    <script src="http://cdn.bootcss.com/bootstrap-select/2.0.0-beta1/js/bootstrap-select.min.js"></script>

    <link href="http://cdn.bootcss.com/bootstrap-datetimepicker/4.17.45/css/bootstrap-datetimepicker.css" rel="stylesheet">
    <script src="http://cdnjs.cloudflare.com/ajax/libs/moment.js/2.9.0/moment-with-locales.js"></script>
    <script src="http://cdn.bootcss.com/bootstrap-datetimepicker/4.17.45/js/bootstrap-datetimepicker.min.js"></script>
	

	
	 <script type="text/javascript">
        $(function () {
        	$('#open_hours').datetimepicker({
                locale: 'zh-CN',
                format: 'hh:mm'
            });
            $('#close_hours').datetimepicker({
                locale: 'zh-CN',
                format: 'hh:mm'
            });

        });
        function reset(){
            if(confirm("是否重置？")){
                window.location.reload(true);
            }
        }
        
        var userflag=false;
        function showHint()
		{
		  var xmlhttp;
		  var str=$('#equip_number').val();
		  if (window.XMLHttpRequest) {
		    // IE7+, Firefox, Chrome, Opera, Safari 浏览器执行代码
		    xmlhttp=new XMLHttpRequest();
		  }
		  else {
		    // IE6, IE5 浏览器执行代码
		    xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
		  }
		  xmlhttp.onreadystatechange=function()
		  {
		    if (xmlhttp.readyState==4 && xmlhttp.status==200)
		    {
		    	if(xmlhttp.responseText=="true"){
		    		userflag=false;
		    		document.getElementById("equip_hint").innerHTML="设备编号*(当前编号已存在！)";
		    	}
		    	else{
		    		userflag=true;
		    		document.getElementById("equip_hint").innerHTML="设备编号*(当前编号可用！)";
		    	}
		    }
		  }
		  xmlhttp.open("GET","FastQuery?equipid="+str,true);
		  xmlhttp.send();
		}
        function save(){
			if(document.getElementById("equip_name").value.length==0)
            {
                alert('设备名称不能为空');
                return false;
            }
            
            if(document.getElementById("equip_model").value.length==0)
            {
                alert('设备型号不能为空');
                return false;
            }
            
            if(document.getElementById("specification").value.length==0)
            {
                alert('技术指标不能为空');
                return false;
            }
            
            if(document.getElementById("lab_name").value.length==0)
            {
                alert('所属实验室不能为空');
                return false;
            }
            
			if(document.getElementById("lab_location").value.length==0)
            {
                alert('实验室地点不能为空');
                return false;
            }
			if(document.getElementById("faculty").value.length==0)
            {
                alert('所属院系编号不能为空');
                return false;
            }
            if(document.getElementById("price").value.length==0)
            {
                alert('价格不能为空');
                return false;
            }
            
            if(document.getElementById("overtime_price").value.length==0)
            {
                alert('超时价格不能为空');
                return false;
            }
            
            if(document.getElementById("equip_status").value.length==0)
            {
                alert('设备状态不能为空');
                return false;
            }
            if(document.getElementById("equip_permission").value.length==0)
            {
                alert('权限不能为空');
                return false;
            }
            if(document.getElementById("equip_ip").value.length==0)
            {
                alert('设备终端IP地址不能为空');
                return false;
            }
            if(confirm("确认提交吗？")){
		        var temp = document.getElementById("equip_info");
		        temp.submit();
	        }
        }
        
    </script>
	
  </head>
  
  <body>
  	<jsp:include flush="true" page="head.jsp"></jsp:include>
	     <div class="container form-signin">
		     	<div class="row clearfix">
					<div class="col-md-12 column">
	    	 
				    	 <div class="row clearfix">
				    	 	<form id="equip_info" class="form-horizontal" action="EquipServlet" method="post" >
								<div class=" col-md-6 column">
									<input id="operation" name="operation" value="add" type="hidden">
									
									<label for="equip_number" id="equip_hint">设备编号*</label>
									<input class="form-control" id="equip_number" onchange="showHint()" name="equip_number" type="number"/>
									
									<label for="equip_model">设备型号*</label>
									<input class="form-control" id="equip_model" name="equip_model" type="text" />
									
									<label for="lab_name">所在实验室*</label>
									<input class="form-control" id="lab_name" name="lab_name" type="text" />
									
									<label for="lab_location">实验室所在地址*</label>
									<input class="form-control" id="lab_location" name="lab_location" type="text"/>
									
									<label for="owner">负责人</label>
									<input class="form-control" id="owner" name="owner" type="text" />
									
									<label for="Email">电子邮件</label>
									<input class="form-control" id="Email" name="Email" type="text" />
									
									<label for="price">价格*</label>
									<input class="form-control" id="price" name="price" type="text"  />
									
									<label for="min_time">最少使用时间</label>
									<input class="form-control" id="min_time" name="min_time" type="text"  />
									
									<label for="open_hours">开始时间</label>
									<div class='input-group date'>
						                <input id='open_hours' type='text' name="open_hours" class="form-control" />
						                <span class="input-group-addon">
						                     <span class="glyphicon glyphicon-calendar"></span>
						                </span>
					            	</div>
									
									<label for="equip_status">设备状态*</label>
									<select id="equip_status" name="equip_status" class="selectpicker show-tick form-control" >
										<option>开放</option>
										<option>关闭</option>
									</select>
									
									<label for="description">设备描述</label>
									<textarea class="form-control" id="description" name="description" rows="<%=row %>" cols="20" wrap="hard"></textarea>
								
									<label for="attachment">主要附件</label>
									<textarea class="form-control" id="attachment" name="attachment" rows="<%=row %>" cols="20" wrap="hard"></textarea>
								
								</div>
								
								
								<div class="col-md-6 column">
								
								<label for="equip_name">设备名称*</label>
								<input class="form-control" id="equip_name" name="equip_name" type="text" />
								
								<label for="faculty">所属院系*</label>
								<input class="form-control" id="faculty" name="faculty" type="text"/>
								
								
								<label for="equip_location">设备地址*</label>
								<input class="form-control" id="equip_location" name="equip_location" type="text" />
								
								<label for="build_time">建立时间</label>
								<div class='input-group date' >
									<input type='text' id='build_time' name="build_time" class="form-control" />
									<span class="input-group-addon">
										 <span class="glyphicon glyphicon-calendar"></span>
									</span>
								</div>
								
								<label for="research_area">研究领域</label>
								<input class="form-control" id="research_area" name="research_area" type="text" />
									
								
								<label for="phone">联系电话</label>
								<input class="form-control" id="phone" name="phone" type="text" />				
								
								<label for="equip_ip">设备终端IP地址*</label>
								<input class="form-control" id="equip_ip" name="equip_ip" type="text" />
							
								<label for="overtime_price">超时价格*</label>
								<input class="form-control" id="overtime_price" name="overtime_price" type="text" />
								
								<label for="max_time">最多使用时间</label>
								<input class="form-control" id="max_time" name="max_time" type="text"/>
							
								<label for="close_hours">截止时间</label>
								<div class='input-group date'>
				                <input id='close_hours' type='text' name="close_hours" class="form-control" />
				                <span class="input-group-addon">
				                     <span class="glyphicon glyphicon-calendar"></span>
				                </span>
				            	</div>
								
								<label for="equip_permission">设备权限*</label>
								<select id="equip_permission" name="equip_permission" class="selectpicker show-tick form-control" >
									<option>校内用户</option>
									<option>校外用户</option>
									<option>管理员</option>
								</select>
								
								<label for="specification">技术指标*</label>
								<textarea class="form-control" id="specification" name="specification" rows="<%=row %>" cols="20" wrap="hard"> </textarea>
								
							</div>
							</form>	
						</div>
					  
					</div>
					
		  		</div>
		  		<br><br><br>
		  		<div class="pull-right">
		  			<button class="btn btn-primary btn-lg" onclick="save()">保存</button>
		  		</div>
		  		<br><br>
		 </div>
  </body>
</html>

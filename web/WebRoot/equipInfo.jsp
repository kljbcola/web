<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page import="Bean.EquipInfoBean"%>
<%@page import="Model.EquipHandler"%>

<%
	String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

String equipnum=(String)request.getParameter("equip_number");
if(equipnum==null)
	response.sendRedirect("index.jsp");
EquipInfoBean equipinfo=EquipHandler.getEquipInfoBean(equipnum);
if(equipinfo==null)
	response.sendRedirect("index.jsp");
int row=4;
%>

<!DOCTYPE HTML>
<html>
  <head>
 	<meta charset="UTF-8">
    <base href="<%=basePath%>">
    
    <title>设备信息</title>
    
	<script src="js/jquery.min.js"></script>
	<link href="css/bootstrap.min.css" rel="stylesheet">
	<script src="js/bootstrap.min.js"></script>
    <link href="css/bootstrap-select.min.css" rel="stylesheet">
    <script src="js/bootstrap-select.min.js"></script>
    <link href="css/bootstrap-datetimepicker.min.css" rel="stylesheet">
    <script src="js/moment-with-locales.min.js"></script>
    <script src="js/bootstrap-datetimepicker.min.js"></script>
	
	    <script type="text/javascript">
        $(function () {
        	$('#build_time').datetimepicker({
                locale: 'zh-CN',
                format: 'YYYY-MM-DD'
            });
        	$('#open_hours').datetimepicker({
                locale: 'zh-CN',
                format: 'HH:mm'
            });
            $('#close_hours').datetimepicker({
                locale: 'zh-CN',
                format: 'HH:mm'
            });
            $('#equip_status').selectpicker('val', '<%=equipinfo.equip_status %>');
			$('#equip_permission').selectpicker('val', '<%=equipinfo.equip_permission %>');

        });
        function reset(){
            if(confirm("是否重置？")){
                window.location.reload(true);
            }
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
	    	 <form id="equip_info" class="form-horizontal" action="EquipServlet" method="post" >
	    	
					<div class="col-md-6 column">
						<input class="form-control" id="equip_number" name="equip_number" type="hidden" value="<%=equipinfo.equip_number %>"/>
						<input id="operation" name="operation" value="modify" type="hidden">
						<label for="equip_name">设备名称*</label>
						<input class="form-control" id="equip_name" name="equip_name" type="text" value="<%=equipinfo.equip_name %>"/>
						
						<label for="equip_model">设备型号*</label>
						<input class="form-control" id="equip_model" name="equip_model" type="text" value="<%=equipinfo.equip_model %>"/>
						
						<label for="lab_name">所在实验室*</label>
						<input class="form-control" id="lab_name" name="lab_name" type="text" value="<%=equipinfo.lab_name %>"/>
						
						<label for="lab_location">实验室所在地址*</label>
						<input class="form-control" id="lab_location" name="lab_location" type="text" value="<%=equipinfo.lab_location %>"/>
						
						<label for="owner">负责人</label>
						<input class="form-control" id="owner" name="owner" type="text" value="<%=equipinfo.owner %>"/>
						
						<label for="Email">电子邮件</label>
						<input class="form-control" id="Email" name="Email" type="text" value="<%=equipinfo.Email %>"/>
						
						<label for="price">价格*</label>
						<input class="form-control" id="price" name="price" type="text"  value="<%=equipinfo.price %>" />
						
						<label for="min_time">最少使用时间</label>
						<input class="form-control" id="min_time" name="min_time" type="text" value="<%=equipinfo.min_time %>" />
						
						<label for="open_hours">设备开放时间</label>
						<div class='input-group date'>
			                <input id='open_hours' type='text' name="open_hours" class="form-control" value="<%=equipinfo.open_hours %>"/>
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
						<textarea class="form-control" id="description" name="description" rows="<%=row %>" cols="20" wrap="hard"><%=equipinfo.description %>"</textarea>
					
						<label for="attachment">主要附件</label>
						<textarea class="form-control" id="attachment" name="attachment" rows="<%=row %>" cols="20" wrap="hard"><%=equipinfo.attachment %>"</textarea>
					
					</div>
					
					
					<div class="col-md-6 column">
					
					<label for="faculty">所属院系*</label>
					<input class="form-control" id="faculty" name="faculty" type="text" value="<%=equipinfo.faculty %>"/>
					
					
					<label for="equip_location">设备地址*</label>
					<input class="form-control" id="equip_location" name="equip_location" type="text" value="<%=equipinfo.lab_location %>"/>
					
					<label for="build_time">购入时间</label>
					<div class='input-group date' >
						<input type='text' id='build_time' name="build_time" class="form-control" value="<%=equipinfo.build_time %>"/>
						<span class="input-group-addon">
							 <span class="glyphicon glyphicon-calendar"></span>
						</span>
					</div>
					
					<label for="research_area">研究领域</label>
					<input class="form-control" id="research_area" name="research_area" type="text" value="<%=equipinfo.research_area %>"/>
						
					
					<label for="phone">联系电话</label>
					<input class="form-control" id="phone" name="phone" type="text" value="<%=equipinfo.phone %>"/>				
					
					<label for="equip_ip">设备终端IP地址*</label>
					<input class="form-control" id="equip_ip" name="equip_ip" type="text" value="<%=equipinfo.equip_ip %>" />
				
					<label for="overtime_price">超时价格*</label>
					<input class="form-control" id="overtime_price" name="overtime_price" type="text" value="<%=equipinfo.overtime_price %>"/>
					
					<label for="max_time">最多使用时间</label>
					<input class="form-control" id="max_time" name="max_time" type="text" value="<%=equipinfo.max_time %>"/>
				
					<label for="close_hours">设备截止时间</label>
					<div class='input-group date'>
	                <input id='close_hours' type='text' name="close_hours" class="form-control" value="<%=equipinfo.close_hours %>"/>
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
					<textarea class="form-control" id="specification" name="specification" rows="<%=row %>" cols="20" wrap="hard"><%=equipinfo.specification %>"</textarea>
					
				</div>
	  		 </form>
	  		
  		 </div>
  		 <br><br><br>
  		 <div class="pull-right">
  		 	 <button class="btn btn-primary btn-lg " onclick="save()">保存</button>
  		 </div>
  	</div>

  	
   
  </body>
</html>

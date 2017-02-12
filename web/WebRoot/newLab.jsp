<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page import="Bean.EquipInfoBean"%>
<%@page import="Model.EquipHandler"%>

<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

%>

<!DOCTYPE HTML>
<html>
  <head>
 	<meta charset="UTF-8">
    <base href="<%=basePath%>">
    
    <title>添加实验室</title>
    
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
        function save(){
			if(document.getElementById("lab_name").value.length==0)
            {
                alert('实验室名称不能为空');
                return false;
            }
			if(document.getElementById("lab_location").value.length==0)
            {
                alert('实验室地点不能为空');
                return false;
            }
			if(document.getElementById("faculty_number").value.length==0)
            {
                alert('所属院系编号不能为空');
                return false;
            }
            if(document.getElementById("price").value.length==0)
            {
                alert('使用价格不能为空');
                return false;
            }
            
             if(document.getElementById("overtime_price").value.length==0)
            {
                alert('超时价格不能为空');
                return false;
            }
            
            if(document.getElementById("lab_status").value.length==0)
            {
                alert('实验室状态不能为空');
                return false;
            }
            if(document.getElementById("lab_permission").value.length==0)
            {
                alert('权限不能为空');
                return false;
            }
            if(document.getElementById("lab_ip").value.length==0)
            {
                alert('实验室终端IP地址不能为空');
                return false;
            }
            if(confirm("确认提交吗？")){
		        var temp = document.getElementById("lab_info");
		        temp.submit();
	        }
        }
        
    </script>
	
  </head>
  
  <body>
  	<jsp:include flush="true" page="head.jsp"></jsp:include>
     <div class="container form-signin">
    	 <form id="lab_info" class="form-horizontal" action="LabServlet" method="post" >
			<div class="col-md-6 column">
				<input id="operation" name="operation" value="add" type="hidden">
				<label for="lab_name">实验室名称*</label>
				<input class="form-control" id="lab_name" name="lab_name" type="text"/>

				<label for="description">实验室描述</label>
				<input class="form-control" id="description" name="description" type="text"/>
				
				<label for="research_area">研究领域</label>
				<input class="form-control" id="research_area" name="research_area" type="text" />
				
				<label for="owner">负责人</label>
				<input class="form-control" id="owner" name="owner" type="text"/>
				
				<label for="price">价格*</label>
				<input class="form-control" id="price" name="price" type="text" />
				
				<label for="min_time">最少使用时间</label>
				<input class="form-control" id="min_time" name="min_time" type="text"/>
				
				<label for="open_hours">开始时间</label>
				<div class='input-group date'>
                <input id='open_hours' type='text' name="open_hours" class="form-control"/>
                <span class="input-group-addon">
                     <span class="glyphicon glyphicon-calendar"></span>
                </span>
            	</div>
				
				<label for="lab_status">实验室状态*</label>
				<select id="lab_status" name="lab_status" class="selectpicker show-tick form-control" >
					<option>开放</option>
					<option>关闭</option>
				</select>
				
				<label for="feature">功能特色</label>
				<input class="form-control" id="feature" name="feature" type="text"/>
				
				<label for="attachment">主要附件</label>
				<input class="form-control" id="attachment" name="attachment" type="text"/>
			</div>
			
			<div class="col-md-6 column">
				
				<label for="faculty_number">所属院系*</label>
				<input class="form-control" id="faculty_number" name="faculty_number" type="text"/>
				
				
				<label for="lab_location">实验室地址*</label>
				<input class="form-control" id="lab_location" name="lab_location" type="text"/>
				
				<label for="build_time">建立时间</label>
				<div class='input-group date' >
					<input type='text' id='build_time' name="build_time" class="form-control"/>
					<span class="input-group-addon">
						 <span class="glyphicon glyphicon-calendar"></span>
					</span>
				</div>
				
				<label for="phone">联系电话</label>
				<input class="form-control" id="phone" name="phone" type="text"/>				
				
				<label for="overtime_price">超时价格*</label>
				<input class="form-control" id="overtime_price" name="overtime_price" type="text"/>
				
				<label for="max_time">最多使用时间</label>
				<input class="form-control" id="max_time" name="max_time" type="text"/>
			
				<label for="close_hours">截止时间</label>
				<div class='input-group date'>
                <input id='close_hours' type='text' name="close_hours" class="form-control"/>
                <span class="input-group-addon">
                     <span class="glyphicon glyphicon-calendar"></span>
                </span>
            	</div>
				
				<label for="lab_permission">实验室权限*</label>
				<select id="lab_permission" name="lab_permission" class="selectpicker show-tick form-control" >
					<option>校内用户</option>
					<option>校外用户</option>
					<option>管理员</option>
				</select>
				
				<label for="lab_ip">实验室终端IP地址*</label>
				<input class="form-control" id="lab_ip" name="lab_ip" type="text"/>
			</div>
  		 </form>
  	</div>
  	<div class="container form-signin center-block">
  		<button class="btn btn-primary btn-pad ng-isolate-scope " onclick="save()">保存</button>
  	</div>
  	
     
  </body>
</html>

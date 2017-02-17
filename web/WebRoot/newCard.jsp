<%@page import="Bean.UserInfoBean"%>
<%@page import="Model.AlertHandle"%>
<%@ page language="java" 
import="java.util.*,Bean.UserBean,Model.AdminHandler" 
pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	
UserBean user=UserBean.checkSession(session);
if(user==null||!user.userType.equals("管理员")){
	AlertHandle.AlertWarning(session, "警告！","非法操作！");
	response.sendRedirect("index.jsp");
}
%>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>IC卡详情</title>
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
            $('#user_birthday').datetimepicker({
                locale: 'zh-CN',
                format: 'YYYY-M-DD'
            });
        });
        function reset(){
            if(confirm("是否重置？")){
                window.location.reload(true);
            }
        }
        function save(){
            if(document.getElementById("card_number").value.length==0)
            {
                alert('卡号不能为空');
                return false;
            }
            if(document.getElementById("user_id").value.length==0)
            {
                alert('卡主ID不能为空');
                return false;
            }
			if(document.getElementById("remaining_sum").value.length==0)
            {
                alert('剩余金额不能为空');
                return false;
            }
			if(document.getElementById("consumption").value.length==0)
            {
                alert('消费总额不能为空');
                return false;
            }
            
            if(confirm("确认提交吗？")){
		        var temp = document.getElementById("card_info");
		        temp.submit();
	        }
        }
        
    </script>
</head>

<body>
	<jsp:include flush="true" page="head.jsp"></jsp:include>
    <div class="container">
        <form id="card_info" class="form-horizontal" action="CardServlet" method="post" role="form">
			<input id="operation" name="operation" value="add" type="hidden">

            <label for="card_number">卡号</label>
            <input class="form-control" id="card_number" name="card_number" type="text"/>
            
            <label for="user_id">卡主ID</label>
            <input class="form-control" id="user_id" name="user_id" type="text"/>
            
            <label for="remaining_sum">剩余金额</label>
            <input class="form-control" id="remaining_sum" name="remaining_sum" type="text"/>
            
            <label for="consumption">消费总额</label>
            <input class="form-control" id="consumption" name="consumption" type="text"/>

           	<input id="status" name="status" value="正常" type="hidden">
   
            </form>
            <button class="btn btn-block btn-primary" onclick="save()">提交</button>
            <button class="btn btn-block btn-warning" onclick="reset()">重置</button>
    </div>

</body>

</html>
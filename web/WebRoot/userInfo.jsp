<%@page import="Model.AlertHandle"%>
<%@page import="Bean.UserInfoBean"%>
<%@ page language="java" 
import="java.util.*,Bean.UserBean,Model.AdminHandler" 
pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
String userID=(String)request.getParameter("userID");
if(userID==null){
	AlertHandle.AlertWarning(session, "警告！","非法操作！");
	response.sendRedirect("index.jsp");
	return;
}
	
UserBean user=UserBean.checkSession(session);
if(user==null||!user.userID.equals(userID) && !user.userType.equals("管理员")){
	AlertHandle.AlertWarning(session, "警告！","非法操作！");
	response.sendRedirect("index.jsp");
	return;
}
	
UserInfoBean userinfo=AdminHandler.getUserInfoBean(userID);
if(userinfo==null){
	AlertHandle.AlertDanger(session, "错误！","用户信息查找失败！");
	response.sendRedirect("index.jsp");
	return;
}
%>

<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>用户详情</title>
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
            $('#user_sex').selectpicker('val', '<%=userinfo.userSex %>');
			$('#user_type').selectpicker('val', '<%=userinfo.userType %>');
			$('#ID_type').selectpicker('val', '<%=userinfo.userID_Type %>');
        });
        function reset(){
            if(confirm("是否重置？")){
                window.location.reload(true);
            }
        }
        function save(){
			if(document.getElementById("user_name").value.length==0)
            {
                alert('名称不能为空');
                return false;
            }
			if(document.getElementById("user_sex").value.length==0)
            {
                alert('性别不能为空');
                return false;
            }
            if(document.getElementById("user_ID_number").value.length!=0 &&
            document.getElementById("ID_type").value=="身份证" && 
            document.getElementById("user_ID_number").value.length!=18)
			{
                alert('身份证号长度不足');
                return false;
            }
            if(confirm("确认提交吗？")){
		        var temp = document.getElementById("user_info");
		        temp.submit();
	        }
        }
        
    </script>
</head>

<body>
	<jsp:include flush="true" page="head.jsp"></jsp:include>
    <div class="container">
        <form id="user_info" class="form-horizontal" action="UserProduce" method="post" role="form">

			<input id="user_id" name="user_id" value="<%=userID %>" type="hidden">
			<input id="operation" name="operation" value="modify" type="hidden">

            <label for="user_account">名称</label>
            <input class="form-control" id="user_name" name="user_name" type="text" value="<%=userinfo.userName %>"/>
            
            <label for="user_sex">性别</label>
            <select id="user_sex" name="user_sex" class="selectpicker show-tick form-control">
                <option>男</option>
                <option>女</option>
            </select>

            <label for="ID_type">证件类型</label>
            <select id="ID_type" name="ID_type" class="selectpicker show-tick form-control">
                <option>身份证</option>
                <option>学生证</option>
            </select>
            

            <label for="user_ID_number">证件号</label>
            <input class="form-control" id="user_ID_number" name="user_ID_number" type="text" maxlength="18" value="<%=userinfo.userID_Number %>"/>
            

            <label for="user_telephone">电话</label>
            <input class="form-control" id="user_telephone" name="user_telephone" type="text" value="<%=userinfo.userTel %>" />
            
            <label for="user_address">地址</label>
            <input class="form-control" id="user_address" name="user_address" type="text" value="<%=userinfo.userAddress %>" />

            <label for="user_birthday">生日</label>
            <div class='input-group date'>
                <input id='user_birthday' type='text' name="user_birthday" class="form-control" value="<%=userinfo.userBirthDate %>" />
                <span class="input-group-addon">
                     <span class="glyphicon glyphicon-calendar"></span>
                </span>
            </div>
            

            <label for="user_remark">备注</label>
            <textarea class="form-control" id="user_remark" name="user_remark"><%=userinfo.userRemark %></textarea>
            
            </form>
            <button class="btn btn-block btn-primary" onclick="save()">保存</button>
            <button class="btn btn-block btn-warning" onclick="reset()">重置</button>
    </div>

</body>

</html>
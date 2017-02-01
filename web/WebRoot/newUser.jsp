<%@page import="Bean.UserInfoBean"%>
<%@ page language="java" 
import="java.util.*,Bean.UserBean,Model.AdminHandler" 
pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	
UserBean user=UserBean.checkSession(session);
if(!user.userType.equals("管理员"))
	response.sendRedirect("index.jsp");
%>

<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>用户详情</title>
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
        	if(document.getElementById("user_account").value.length==0)
            {
                alert('账号不能为空');
                return false;
            }
            if(document.getElementById("user_password").value!=document.getElementById("user_password_again").value)
            {
                alert('确认密码不符');
                return false;
            }
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
			if(document.getElementById("user_type").value.length==0)
            {
                alert('请选择用户类型');
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
			<input id="operation" name="operation" value="add" type="hidden">

            <label for="user_account">账号</label>
            <input class="form-control" id="user_account" name="user_account" type="text"/>
            
            <label for="user_password">密码</label>
            <input class="form-control" id="user_password" name="user_password" type="password"/>
            
            <label for="user_password_again">确认密码</label>
            <input class="form-control" id="user_password_again" name="user_password_again" type="password"/>
            
            <label for="user_account">名称</label>
            <input class="form-control" id="user_name" name="user_name" type="text"/>
            
            <label for="user_sex">性别</label>
            <select id="user_sex" name="user_sex" class="selectpicker show-tick form-control">
                <option>男</option>
                <option>女</option>
            </select>     

            <label for="user_type">用户类型</label>
            <select id="user_type" name="user_type" class="selectpicker show-tick form-control">
                <option>校内用户</option>
                <option>校外用户</option>
                <option>管理员</option>
            </select>
            
            <label for="user_card_number">IC卡号</label>
            <input class="form-control" id="user_card_number" name="user_card_number" type="text"/>
            

            <label for="ID_type">证件类型</label>
            <select id="ID_type" name="ID_type" class="selectpicker show-tick form-control">
                <option>身份证</option>
                <option>学生证</option>
            </select>
            

            <label for="user_ID_number">证件号</label>
            <input class="form-control" id="user_ID_number" name="user_ID_number" type="text" maxlength="18"/>
            

            <label for="user_telephone">电话</label>
            <input class="form-control" id="user_telephone" name="user_telephone" type="text" />
            
            <label for="user_address">地址</label>
            <input class="form-control" id="user_address" name="user_address" type="text"/>

            <label for="user_birthday">生日</label>
            <div class='input-group date'>
                <input id='user_birthday' type='text' name="user_birthday" class="form-control" />
                <span class="input-group-addon">
                     <span class="glyphicon glyphicon-calendar"></span>
                </span>
            </div>
            

            <label for="user_remark">备注</label>
            <textarea class="form-control" id="user_remark" name="user_remark"></textarea>
            
            </form>
            <button class="btn btn-block btn-primary" onclick="save()">提交</button>
            <button class="btn btn-block btn-warning" onclick="reset()">重置</button>
    </div>

</body>

</html>
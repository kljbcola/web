<%@page import="Bean.UserInfoBean"%>
<%@ page language="java" 
import="java.util.*,Bean.UserBean,Model.AdminHandler" 
pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
String userID=(String)request.getParameter("userID");
if(userID==null)
	response.sendRedirect("index.jsp");

UserInfoBean userinfo=AdminHandler.getUserInfoBean(userID);
if(userinfo==null)
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
    </script>
</head>

<body>
    <div class="container">
        <form class="form-horizontal" role="form">

            <label for="user_account">账号</label>
            <input class="form-control" id="user_account" type="text" value="<%=userinfo.userAccount %>"/>
            
            <label for="user_account">名称</label>
            <input class="form-control" id="user_account" type="text" value="<%=userinfo.userName %>"/>
            
            <label for="user_sex">性别</label>
            <select id="user_sex" class="selectpicker show-tick form-control">
                <option>男</option>
                <option>女</option>
            </select>
            

            <label for="user_type">用户类型</label>
            <select id="user_type" class="selectpicker show-tick form-control">
                <option>校内用户</option>
                <option>校外用户</option>
                <option>管理员</option>
            </select>
            
            <label for="user_card_number">IC卡号</label>
            <input class="form-control" id="user_card_number" type="text" value="<%=userinfo.userIC_Number %>"/>
            

            <label for="ID_type">证件类型</label>
            <select id="ID_type" class="selectpicker show-tick form-control">
                <option>身份证</option>
                <option>学生证</option>
            </select>
            

            <label for="user_ID_number">证件号</label>
            <input class="form-control" id="user_card_number" type="text" value="<%=userinfo.userID_Number %>"/>
            

            <label for="user_telephone">电话</label>
            <input class="form-control" id="user_telephone" type="text" value=<%=userinfo.userTel %> />
            

            <label for="user_birthday">生日</label>
            <div class='input-group date' id='user_birthday'>
                <input type='text' class="form-control" value=<%=userinfo.userBirthDate %> />
                <span class="input-group-addon">
                     <span class="glyphicon glyphicon-calendar"></span>
                </span>
            </div>
            

            <label for="user_remark">备注</label>
            <input class="form-control" id="user_remark" type="text" value=<%=userinfo.userRemark %> />
            
            </form>
    </div>

</body>

</html>
<%@page import="Model.CardHandler"%>
<%@page import="Bean.CardInfoBean"%>
<%@page import="Bean.UserInfoBean"%>
<%@page import="Model.AlertHandle"%>
<%@ page import="java.io.*,java.util.*" %>
<%@ page import="javax.servlet.*,java.text.*" %>
<%@ page language="java" 
import="java.util.*,Bean.UserBean,Model.AdminHandler" 
pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

String userAccount=request.getParameter("userAccount");
UserBean user=UserBean.checkSession(session);
//CardInfoBean card=CardHandler.getCardByUser(userAccount);
if(user==null||!user.userType.equals("管理员")){
	AlertHandle.AlertWarning(session, "警告！","非法操作！");
	response.sendRedirect("index.jsp");
	return ;
}

%>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>IC卡充值</title>
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
        
        var cardflag=false;
        function checkCard(){
        	var xmlhttp;
			var str=$('#card_number').val();
			if(str.length==0){cardflag=false;return;}
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
			    		cardflag=true;
			    		document.getElementById("card_hint").innerHTML="IC卡号(存在当前用户！)";
			    	}
			    	else{
			    		cardflag=false;
			    		document.getElementById("card_hint").innerHTML="IC卡号(不存在当前用户！)";
			    	}
		    	}
		  	}
		  	xmlhttp.open("GET","FastQuery?card_number="+str,true);
		  	xmlhttp.send();
        }
        function save(){
            if(document.getElementById("card_number").value.length==0)
            {
                alert('卡号不能为空');
                return false;
            }
            if(document.getElementById("card_number").value.length==0)
            {
                alert('卡号不能为空');
                return false;
            }
            if(!cardflag)
            {
            	alert('卡号无效!');
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
			<input id="operation" name="operation" value="paid" type="hidden">
			
            <input class="form-control" id="order_record_id" name="order_record_id" type="hidden" value="0"/>
			
			<label for="card_number" id="card_hint">卡号</label>
            <input class="form-control" id="card_number" onchange="checkCard()" name="card_number" type="text"/>

            <label for="paid_amount">充值总额</label>
            <input class="form-control" id="paid_amount" name="paid_amount" type="text"/>
            
            <input class="form-control" id="paid_reason" name="paid_reason" type="hidden" value="充值"/>
            
            <%   Date dNow = new Date( );
				   SimpleDateFormat ft = 
				   new SimpleDateFormat ("yyyy-MM-dd HH:mm:ss");
		    %>
			<input class="form-control" id="paid_time" name="paid_time" type="hidden" value="<%=ft.format(dNow) %>"/>
   
            </form>
            <button class="btn btn-block btn-primary" onclick="save()">提交</button>
            <button class="btn btn-block btn-warning" onclick="reset()">重置</button>
    </div>

</body>

</html>
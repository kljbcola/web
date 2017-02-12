<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
String type=(String)session.getAttribute("AlertType");
String title=(String)session.getAttribute("AlertTitle");
String content=(String)session.getAttribute("AlertContent");
if(type!=null&&title!=null&&content!=null){
%>
<div class="alert <%=type %>">
    <a href="" class="close" data-dismiss="alert">
        &times;
    </a>
    <strong><%=title %></strong>	<%=content %>
</div>
<%
session.removeAttribute("AlertType");
session.removeAttribute("AlertTitle");
session.removeAttribute("AlertContent");
}
%>
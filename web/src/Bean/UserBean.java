package Bean;

import javax.servlet.http.HttpSession;

public class UserBean {
	public String userID=null;
	public String userName=null;
	public String userType=null;
	public String userAccount=null;
	public UserBean(){}
	public UserBean(String id,String name,String type){
		userID=id;
		userName=name;
		userType=type;
	}
	public UserBean(String id,String name,String account,String type){
		userID=id;
		userName=name;
		userType=type;
		userAccount=account;
	}
	public void SetSession(HttpSession session)
	{
		session.setAttribute("userID",userID);
		session.setAttribute("userName",userName);
		session.setAttribute("userType",userType);
	}
	public static UserBean checkSession(HttpSession session)
	{
		if(session==null)return null;
		UserBean userBean=null;
		String id=(String)session.getAttribute("userID");
		if(id==null)
			return userBean;
		String name=(String)session.getAttribute("userName");
		if(name==null)
			return userBean;
		String type=(String)session.getAttribute("userType");
		if(type==null)
			return userBean;
		userBean=new UserBean(id,name,type);
		return userBean;
	}
}

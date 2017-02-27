package Servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Bean.UserBean;
import Bean.UserInfoBean;
import Model.AdminHandler;
import Model.AlertHandle;
import Model.CardHandler;
import Model.EquipHandler;
import Model.LoginHandler;

@WebServlet("/UserProduce")
public class UserProduce extends HttpServlet {
	private static final long serialVersionUID = 1L;
    public UserProduce() {
        super();
    }
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	UserInfoBean getUserByParameter(HttpServletRequest request)	{
		UserInfoBean userInfoBean=new UserInfoBean();
		userInfoBean.userID			=request.getParameter("user_id");
		userInfoBean.userAccount	=request.getParameter("user_account");
		userInfoBean.userPassWd		=request.getParameter("user_password");
		userInfoBean.userName		=request.getParameter("user_name");
		userInfoBean.userSex		=request.getParameter("user_sex");
		userInfoBean.userType		=request.getParameter("user_type");
		userInfoBean.userIC_Number	=request.getParameter("user_card_number");
		userInfoBean.userID_Type	=request.getParameter("ID_type");
		userInfoBean.userID_Number	=request.getParameter("user_ID_number");
		userInfoBean.userTel		=request.getParameter("user_telephone");
		userInfoBean.userBirthDate	=request.getParameter("user_birthday");
		userInfoBean.userRemark		=request.getParameter("user_remark");
		userInfoBean.userAddress	=request.getParameter("user_address");
		return userInfoBean;
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=utf-8");
		HttpSession session=request.getSession(false);
		System.out.println("userProduce");
		if(session==null)
			AlertHandle.AlertWarning(session, "警告", "权限不足!");
		else {
			String userID=request.getParameter("user_id");
			String op=request.getParameter("operation");
			UserBean user=UserBean.checkSession(session);
			switch (op) {
			case "add":
				if(user==null||!user.userType.equals("管理员"))
					AlertHandle.AlertWarning(session, "警告", "权限不足!");
				else {
					UserInfoBean userInfoBean=getUserByParameter(request);
					if(AdminHandler.addUser(userInfoBean))
					{
						AlertHandle.AlertSuccess(session, "成功", "添加用户成功!");
					}
					else
						AlertHandle.AlertWarning(session, "失败", "添加用户失败!");
					if(user.userType.equals("管理员")){
						response.sendRedirect("userManage.jsp");
						return;
					}
				}
				break;
			case "modify":
				if(user==null||!(user.userID.equals(userID)||user.userType.equals("管理员")))
					AlertHandle.AlertWarning(session, "警告", "权限不足!");
				else
				{
					UserInfoBean userInfoBean=getUserByParameter(request);
					if(AdminHandler.setUserInfo(userInfoBean)){
						AlertHandle.AlertSuccess(session, "成功", "修改成功!");
						UserBean userBean=new UserBean(userInfoBean.userID, userInfoBean.userName,user.userAccount,user.userType);
						userBean.SetSession(session);
					}
					else 
						AlertHandle.AlertWarning(session, "失败", "修改失败!");
					if(user.userType.equals("管理员")){
						response.sendRedirect("userManage.jsp");
						return;
					}
				}
				break;
			case "del":
				if(user==null||!user.userType.equals("管理员"))
					AlertHandle.AlertWarning(session, "警告", "权限不足!");
				else {
					if(AdminHandler.delUser(userID)){
						EquipHandler.disOrderByUser(userID);
						CardHandler.cardWByUserID(userID);
						AlertHandle.AlertSuccess(session, "成功", "删除用户成功!");
					}
					else 
						AlertHandle.AlertWarning(session, "失败", "删除用户失败!");
				}
				response.sendRedirect("userManage.jsp");
				return ;
			case "reset":
				if(user==null||!user.userType.equals("管理员"))
					AlertHandle.AlertWarning(session, "警告", "权限不足!");
				else {
					if(AdminHandler.resetUser(userID)){
						AlertHandle.AlertSuccess(session, "成功", "重置用户密码成功!");
					}
					else 
						AlertHandle.AlertWarning(session, "失败", "重置用户密码失败!");
				}
				response.sendRedirect("userManage.jsp");
				return ;	
			case "setpw":
				if(user==null)
					AlertHandle.AlertWarning(session, "警告", "请登录!");
				else {
					String oldpw=request.getParameter("user_old_password");
					String newpw=request.getParameter("user_new_password");
					System.out.println(user.userAccount);
					System.out.println(oldpw+"\n"+newpw);
					if(LoginHandler.checkPassWord(user.userAccount, oldpw)){
						if(AdminHandler.setUserPW(user.userID, newpw))
							AlertHandle.AlertSuccess(session, "成功", "设置用户密码成功!");
						else 
							AlertHandle.AlertWarning(session, "失败", "设置用户密码失败!");
					}
					else
					{
						AlertHandle.AlertWarning(session, "失败", "密码错误!");
					}
				}
				response.sendRedirect("userSetPW.jsp");
				return ;
			default:
				AlertHandle.AlertWarning(session, "失败", "未知操作!");
				break;
			}
		}
		response.sendRedirect("index.jsp");
	}

}

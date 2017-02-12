package Servlet;

import java.io.IOException;

import Bean.UserBean;
import Model.AlertHandle;
import Model.LoginHandler;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
/**
 * Servlet implementation class LoginServlet
 */
@WebServlet("/loginCheck")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public LoginServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=utf-8");
		HttpSession session=request.getSession(true);
		UserBean userBean=UserBean.checkSession(session);
		if (userBean!=null) {
			//out.println("<script type=\"text/javascript\">");
			//out.println("alert(\"重复登陆！\")");
			//out.println("window.location.href(\"index.jsp\");");
			//out.println("</script>");
			AlertHandle.AlertWarning(session, "警告", "您已登陆！");
			response.sendRedirect("index.jsp");
		}
		else {
			String name=request.getParameter("loginName");
			String pw=request.getParameter("loginPassword");
			if (name!=null&&name.length()!=0&&pw!=null&&pw.length()!=0) {
				userBean=LoginHandler.checkLogin(name, pw);
				if (userBean!=null) {
					userBean.SetSession(session);
					AlertHandle.Alert(session, "提示", "您已登录成功!");
					response.sendRedirect("index.jsp");
					//out.println("<script type=\"text/javascript\">");
					//out.println("alert(\"登陆成功！\")");
					//out.println("window.location.href(\"index.jsp\");");
					//out.println("</script>");
					
				}
				else {
					AlertHandle.AlertWarning(session, "警告", "用户名或密码错误！");
					response.sendRedirect("login.jsp");
				}
			}
			else {
				AlertHandle.AlertWarning(session, "警告", "错误的操作！");
				response.sendRedirect("index.jsp");
			}
		}
		
		
		
	}

}

package Servelt;

import java.io.IOException;
import java.io.PrintWriter;

import Bean.UserBean;
import Model.LoginHandler;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
/**
 * Servlet implementation class LoginServelt
 */
@WebServlet("/loginCheck")
public class LoginServelt extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public LoginServelt() {
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
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out=response.getWriter();
		HttpSession session=request.getSession(true);
		UserBean userBean=UserBean.checkSession(session);
		if (userBean!=null) {
			out.println("<script type=\"text/javascript\">");
			out.println("alert(\"重复登陆！\")");
			out.println("window.location.href(\"index.jsp\");");
			out.println("</script>");
		}
		else {
			String name=request.getParameter("loginName");
			String pw=request.getParameter("loginPassword");
			if (name!=null&&name.length()!=0&&pw!=null&&pw.length()!=0) {
				userBean=LoginHandler.checkLogin(name, pw);
				if (userBean!=null) {
					userBean.SetSession(session);
					out.println("<script type=\"text/javascript\">");
					out.println("alert(\"登陆成功！\")");
					out.println("window.location.href(\"index.jsp\");");
					out.println("</script>");
					//response.sendRedirect("index.jsp");
				}
				else {
					out.println("用户名或密码错误！");
				}
			}
			else {
				out.println("错误的操作！");
			}
		}
		
		
		
	}

}

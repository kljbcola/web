package Servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


import Bean.CardInfoBean;
import Model.AlertHandle;
import Model.CardHandler;

@WebServlet("/CardServlet")
public class CardServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    public CardServlet() {
        super();
    }
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	CardInfoBean getcardByParameter(HttpServletRequest request)	{
		CardInfoBean cardInfoBean=new CardInfoBean();
		cardInfoBean.card_number			=request.getParameter("card_number");
		cardInfoBean.user_id			=request.getParameter("user_id");
		cardInfoBean.remaining_sum			=request.getParameter("remaining_sum");
		cardInfoBean.consumption			=request.getParameter("consumption");
		cardInfoBean.status				=request.getParameter("status");
		
		return cardInfoBean;
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
    
		HttpSession session=request.getSession(false);
		if(session==null)
			AlertHandle.AlertWarning(session, "警告", "权限不足!");
		else {
			String op=request.getParameter("operation");
			switch (op) {
			case "add":
				CardInfoBean cardInfoBean=getcardByParameter(request);
				if(CardHandler.addCard(cardInfoBean)){
					AlertHandle.AlertSuccess(session, "成功", "添加IC卡成功!");
				}else 
					AlertHandle.AlertWarning(session, "失败", "添加IC卡失败!");
				break;
			case "modify":
					CardInfoBean cardInfoBean1=getcardByParameter(request);
					if(CardHandler.setCardInfo(cardInfoBean1)){
						System.out.printf("modify");
						//loadPicture(request,cardInfoBean1.card_name);
						AlertHandle.AlertSuccess(session, "成功", "修改IC卡成功!");
					}else 
						AlertHandle.AlertWarning(session, "失败", "修改IC卡失败!");
				break;
			case "del":
					System.out.println("del");
					String num=request.getParameter("card_number");
					if(CardHandler.delCard(num))
						AlertHandle.AlertSuccess(session, "成功", "删除IC卡成功!");
					else 
						AlertHandle.AlertWarning(session, "失败", "删除IC卡失败!");
				break;
			default:
				AlertHandle.AlertWarning(session, "失败", "未知操作!");
				break;
			}
		} 
		response.sendRedirect("cardManage.jsp");
	}

}

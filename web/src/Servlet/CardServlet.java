package Servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;



import Bean.CardInfoBean;
import Bean.PaidInfoBean;
import Bean.UserBean;
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
		cardInfoBean.user_account			=request.getParameter("user_account");
		cardInfoBean.remaining_sum			=request.getParameter("remaining_sum");
		cardInfoBean.consumption			=request.getParameter("consumption");
		cardInfoBean.status					=request.getParameter("status");
		return cardInfoBean;
	}
	PaidInfoBean getpaidByParameter(HttpServletRequest request)	{
		PaidInfoBean paidInfoBean=new PaidInfoBean();
		paidInfoBean.user_id					=request.getParameter("user_id");
		paidInfoBean.order_record_id			=request.getParameter("order_record_id");
		paidInfoBean.paid_amount				=request.getParameter("paid_amount");
		paidInfoBean.paid_reason				=request.getParameter("paid_reason");
		paidInfoBean.paid_time					=request.getParameter("paid_time");
		
		return paidInfoBean;
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        UserBean user;
		HttpSession session=request.getSession(false);
		if(session==null)
			AlertHandle.AlertWarning(session, "警告", "权限不足!");
		else {
			user=UserBean.checkSession(session);
			if(user==null)
			{
				AlertHandle.AlertWarning(session, "警告", "权限不足!");
				response.sendRedirect("cardManage.jsp");
				return;
			}
			String op=request.getParameter("operation");
			switch (op) {
			case "add":
				if(!user.userType.equals("管理员")){
					AlertHandle.AlertWarning(session, "警告", "权限不足!");
				}
				else{
					CardInfoBean cardInfoBean=getcardByParameter(request);
					if(cardInfoBean.card_number!=null&&cardInfoBean.user_account!=null){
						CardInfoBean oldCardInfoBean=CardHandler.getCardByUser(cardInfoBean.user_account);
						cardInfoBean.consumption=oldCardInfoBean.consumption;
						cardInfoBean.remaining_sum=oldCardInfoBean.remaining_sum;
						cardInfoBean.status="正常";
						if(CardHandler.addCard(cardInfoBean)&&CardHandler.changeUser(cardInfoBean)){
							AlertHandle.AlertSuccess(session, "成功", "补办成功!");
						}
						else 
							AlertHandle.AlertWarning(session, "失败", "补办失败!");
					}
					else {
						AlertHandle.AlertWarning(session, "失败", "补办失败!");
					}
				}
				break;
			case "modify":
				if(!user.userType.equals("管理员"))
					AlertHandle.AlertWarning(session, "警告", "权限不足!");
				else{
					CardInfoBean cardInfoBean=getcardByParameter(request);
					if(CardHandler.setCardInfo(cardInfoBean)){
						System.out.printf("modify");
						AlertHandle.AlertSuccess(session, "成功", "修改IC卡成功!");
					}else 
						AlertHandle.AlertWarning(session, "失败", "修改IC卡失败!");
				}
				break;
			case "paid":
				if(!user.userType.equals("管理员"))
					AlertHandle.AlertWarning(session, "警告", "权限不足!");
				else{
					PaidInfoBean paidInfoBean=getpaidByParameter(request);
					String card_number=request.getParameter("card_number");
					if(card_number==null){
						AlertHandle.AlertDanger(session, "失败", "操作错误!");
						response.sendRedirect("index.jsp");
						return;
					}
					paidInfoBean.user_id=CardHandler.getUserByCard(card_number);
					if(CardHandler.addPaidInfoAndMoney(paidInfoBean)){
						System.out.printf("paid");
						AlertHandle.AlertSuccess(session, "成功", "充值IC卡成功!");
					}else 
						AlertHandle.AlertWarning(session, "失败", "充值IC卡失败!");
				}
				break;
			case "del":
				if(!user.userType.equals("管理员"))
					AlertHandle.AlertWarning(session, "警告", "权限不足!");
				else{
					System.out.println("del");
					String num=request.getParameter("card_number");
					if(CardHandler.delCard(num))
						AlertHandle.AlertSuccess(session, "成功", "删除IC卡成功!");
					else 
						AlertHandle.AlertWarning(session, "失败", "删除IC卡失败!");
				}
				break;
			case "cardW":
				System.out.println("cardW");
				String num1=request.getParameter("card_number");
				if(CardHandler.cardW(num1))
					AlertHandle.AlertSuccess(session, "成功", "挂失成功!");
				else 
					AlertHandle.AlertWarning(session, "失败", "挂失失败!");
				response.sendRedirect("userCard.jsp");
				return;
			case "cardR":
				System.out.println("cardR");
				String num2=request.getParameter("card_number");
				if(CardHandler.cardR(num2))
					AlertHandle.AlertSuccess(session, "成功", "解除挂失成功!");
				else 
					AlertHandle.AlertWarning(session, "失败", "解除挂失失败!");
				response.sendRedirect("userCard.jsp");
				return;
			default:
				AlertHandle.AlertWarning(session, "失败", "未知操作!");
				break;
			}
		} 
		response.sendRedirect("cardManage.jsp");
	}

}

package Servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Bean.EquipInfoBean;
import Bean.OrderInfo;
import Bean.PaidInfoBean;
import Bean.UserBean;
import Model.AlertHandle;
import Model.CheckHandler;
import Model.EquipHandler;
import Model.CardHandler;
import Bean.CardInfoBean;

@WebServlet("/OrderProduce")
public class OrderProduce extends HttpServlet {
	private static final long serialVersionUID = 1L;
	 public OrderProduce() {
	        super();
	    }
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request, response);
	}
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=utf-8");
		try {
			HttpSession session=request.getSession(false);
			UserBean userBean=UserBean.checkSession(session);
			String op=request.getParameter("op");
			System.out.println(op);
			switch (op) {
			case "order":
				CardInfoBean cardinfo=CardHandler.getCardInfoBeanByUser(userBean.userAccount);
				float remaining_sum=Float.parseFloat(cardinfo.remaining_sum);
				float consumption=Float.parseFloat(cardinfo.consumption);
				String equip_number=request.getParameter("equip_number");
				String order_date=request.getParameter("order_date");
				float start_time=Float.valueOf(request.getParameter("start_time"));
				float end_time=Float.valueOf(request.getParameter("end_time"));
				if (end_time<start_time) {
					float tmp=start_time;
					start_time=end_time;
					end_time=tmp;
				}
				EquipInfoBean equipInfoBean=EquipHandler.getEquipInfoBean(equip_number);
				float v=Float.parseFloat(equipInfoBean.price);
				float sum=(end_time-start_time)*v/2;
				
				if(equipInfoBean.equip_permission.equals("关闭"))
				{
					AlertHandle.AlertDanger(session, "预约无效", "设备已停止预约！");
					response.sendRedirect("equipManage.jsp");
					return ;
				}
				if(userBean.userType.equals("校外用户")&&equipInfoBean.equip_permission.equals("校内外用户")){
					AlertHandle.AlertWarning(session, "预约无效", "您没有权限预约该设备!请确认设备开放对象！");
					response.sendRedirect("equipManage.jsp");
					return ;
				}
				if (!equipInfoBean.max_time.equals("")&&
						end_time-start_time>Float.valueOf(equipInfoBean.max_time)) {
					AlertHandle.AlertDanger(session, "预约无效", "超出设备最长预约时间！");
					response.sendRedirect("equipManage.jsp");
					return ;
				}
				if (end_time-start_time==0||!equipInfoBean.min_time.equals("")&&
						end_time-start_time<Float.valueOf(equipInfoBean.min_time)) {
					AlertHandle.AlertDanger(session, "预约无效", "预约时间不足！");
					response.sendRedirect("equipManage.jsp");
					return ;
				}
				if (!(remaining_sum>=0&&remaining_sum>=sum)) {  
					AlertHandle.AlertDanger(session, "预约无效", "卡内余额不足！");
					response.sendRedirect("equipManage.jsp");
					return ;
				}
				if(CheckHandler.checkOrderDate(equip_number, order_date, start_time, end_time)){
					String orderID;
					if((orderID=EquipHandler.equipOrder(userBean.userID, equip_number, order_date, start_time, end_time))!=null &&
							CardHandler.addPaidInfo(equipInfoBean,orderID,userBean.userID, -sum) &&
							CardHandler.setM(userBean.userID,remaining_sum-sum)&&CardHandler.setC(userBean.userID,consumption+sum)){
						AlertHandle.AlertSuccess(session, "提示", "设备预约成功！");
						response.sendRedirect("equipManage.jsp");
						return ;
						}
					else {
						AlertHandle.AlertDanger(session, "错误", "设备预约信息添加或扣除余额出错！");
						response.sendRedirect("equipManage.jsp");
						return ;
					}
				}
				else {
					AlertHandle.AlertDanger(session, "预约无效", "预约时间冲突！");
					response.sendRedirect("equipManage.jsp");
					return ;
				}
			case "disorder":
				String order_id=request.getParameter("order_id");
				if(order_id==null){
					AlertHandle.AlertDanger(session, "警告", "无效操作！");
					response.sendRedirect("OrderManage.jsp");
					return ;
				}
				OrderInfo orderInfo=EquipHandler.getOrderInfo(order_id);
				if(!orderInfo.user_id.equals(userBean.userID)&&!userBean.userType.equals("管理员")){
					AlertHandle.AlertDanger(session, "警告", "权限不足！");
					response.sendRedirect("OrderManage.jsp");
					return ;
				}
				if(!orderInfo.operation.equals("预约处理中")&&!orderInfo.operation.equals("预约已生效")){
					AlertHandle.AlertDanger(session, "警告", "无法取消该预约！");
					response.sendRedirect("OrderManage.jsp");
					return ;
				}
				PaidInfoBean paidInfoBean=CardHandler.getPaidInfo(order_id);
				paidInfoBean.paid_reason="预约金额返还";
				paidInfoBean.paid_amount=String.valueOf((-Float.valueOf(paidInfoBean.paid_amount)));
				float consumption1=CardHandler.getComsuptionByUser(orderInfo.user_id);
				float paid=-Float.parseFloat(paidInfoBean.paid_amount);
				System.out.println(consumption1+"~"+paid);
				if(CardHandler.addPaidInfoAndMoney(paidInfoBean)&&EquipHandler.setOrderStatus(order_id, "预约取消")
						&&CardHandler.setC(orderInfo.user_id, consumption1+paid)){
					AlertHandle.AlertSuccess(session, "提示", "预约取消成功！");
					response.sendRedirect("OrderManage.jsp");
					return ;
				}
				
				break;
			case "no_use_order":
				if(!userBean.userType.equals("管理员")){
					AlertHandle.AlertDanger(session, "警告", "权限不足！");
					response.sendRedirect("OrderManage.jsp");
					return ;
				}
				order_date=request.getParameter("order_date");
				equip_number=request.getParameter("equip_number");
				String range=request.getParameter("range");
				EquipHandler.clearAdminOrder(equip_number, order_date);
				if(range!=null&&!range.equals("")){
					String arr[]=range.split(";");
					for (int i = 0; i < arr.length; i++) {
						String num[]=arr[i].split(",");
						float start=Float.valueOf(num[0]);
						float end=Float.valueOf(num[1]);
						EquipHandler.equipOrderNouse(userBean.userID, equip_number, order_date, start, end);
					}
				}
				AlertHandle.AlertSuccess(session, "提示", "设置成功！");
				response.sendRedirect("adminOrder.jsp?equip_number="+equip_number);
				break;
			default:
				AlertHandle.AlertDanger(session, "警告", "无效操作！");
				response.sendRedirect("equipManage.jsp");
			}
			
		} catch (NullPointerException e) {
			response.sendRedirect("index.jsp");
			e.printStackTrace();
		}
		catch (Exception e) {
			response.sendRedirect("index.jsp");
			e.printStackTrace();
		}
		
	}

}
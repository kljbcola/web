package Servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;



import Bean.EquipInfoBean;
import Model.AlertHandle;
import Model.EquipHandler;

@WebServlet("/EquipServlet")
public class EquipServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    public EquipServlet() {
        super();
    }
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	EquipInfoBean getequipByParameter(HttpServletRequest request)	{
		EquipInfoBean equipInfoBean=new EquipInfoBean();
		equipInfoBean.equip_number			=request.getParameter("equip_number");
		equipInfoBean.equip_name			=request.getParameter("equip_name");
		equipInfoBean.equip_model			=request.getParameter("equip_model");
		equipInfoBean.specification			=request.getParameter("specification");
		equipInfoBean.lab_name				=request.getParameter("lab_name");
		equipInfoBean.lab_location			=request.getParameter("lab_location");
		equipInfoBean.faculty				=request.getParameter("faculty");
		equipInfoBean.description			=request.getParameter("description");
		equipInfoBean.build_time			=request.getParameter("build_time");
		equipInfoBean.research_area			=request.getParameter("research_area");
		equipInfoBean.attachment			=request.getParameter("attachment");
		equipInfoBean.owner					=request.getParameter("owner");
		equipInfoBean.phone					=request.getParameter("phone");
		equipInfoBean.Email					=request.getParameter("Email");
		equipInfoBean.price					=request.getParameter("price");
		equipInfoBean.overtime_price		=request.getParameter("overtime_price");
		equipInfoBean.min_time				=request.getParameter("min_time");
		equipInfoBean.max_time				=request.getParameter("max_time");
		equipInfoBean.equip_status			=request.getParameter("equip_status");
		equipInfoBean.open_hours			=request.getParameter("open_hours");
		equipInfoBean.close_hours			=request.getParameter("close_hours");
		equipInfoBean.equip_permission		=request.getParameter("equip_permission");
		equipInfoBean.equip_ip				=request.getParameter("equip_ip");
		return equipInfoBean;
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
				EquipInfoBean equipInfoBean=getequipByParameter(request);
				if(EquipHandler.addequip(equipInfoBean))
					AlertHandle.AlertSuccess(session, "成功", "添加实验室成功!");
				else 
					AlertHandle.AlertWarning(session, "失败", "添加实验室失败!");
				break;
			case "modify":
					EquipInfoBean equipInfoBean1=getequipByParameter(request);
					if(EquipHandler.setequipInfo(equipInfoBean1))
						AlertHandle.AlertSuccess(session, "成功", "修改实验室成功!");

					else 
						AlertHandle.AlertWarning(session, "失败", "修改实验室失败!");
				break;
			case "del":
					System.out.println("del");
					String num=request.getParameter("equip_number");
					if(EquipHandler.delequip(num))
						AlertHandle.AlertSuccess(session, "成功", "删除用户成功!");
					else 
						AlertHandle.AlertWarning(session, "失败", "删除实验室失败!");
				break;
			default:
				AlertHandle.AlertWarning(session, "失败", "未知操作!");
				break;
			}
		} 
		response.sendRedirect("equipManage.jsp");
	}

}

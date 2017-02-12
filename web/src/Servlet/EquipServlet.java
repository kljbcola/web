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

@WebServlet("/LabServlet")
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
	EquipInfoBean getLabByParameter(HttpServletRequest request)	{
		EquipInfoBean labInfoBean=new EquipInfoBean();
		labInfoBean.lab_number			=request.getParameter("lab_number");
		labInfoBean.lab_name			=request.getParameter("lab_name");
		labInfoBean.lab_location		=request.getParameter("lab_location");
		labInfoBean.faculty_number		=request.getParameter("faculty_number");
		labInfoBean.description			=request.getParameter("description");
		labInfoBean.build_time			=request.getParameter("build_time");
		labInfoBean.research_area		=request.getParameter("research_area");
		labInfoBean.attachment			=request.getParameter("attachment");
		labInfoBean.owner				=request.getParameter("owner");
		labInfoBean.phone				=request.getParameter("phone");
		labInfoBean.Email				=request.getParameter("Email");
		labInfoBean.feature				=request.getParameter("feature");
		labInfoBean.price				=request.getParameter("price");
		labInfoBean.overtime_price		=request.getParameter("overtime_price");
		labInfoBean.min_time			=request.getParameter("min_time");
		labInfoBean.max_time			=request.getParameter("max_time");
		labInfoBean.lab_status			=request.getParameter("lab_status");
		labInfoBean.open_hours			=request.getParameter("open_hours");
		labInfoBean.close_hours			=request.getParameter("close_hours");
		labInfoBean.lab_permission		=request.getParameter("lab_permission");
		labInfoBean.lab_ip	=request.getParameter("lab_ip");
		return labInfoBean;
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
				EquipInfoBean labInfoBean=getLabByParameter(request);
				if(EquipHandler.addLab(labInfoBean))
					AlertHandle.AlertSuccess(session, "成功", "添加实验室成功!");
				else 
					AlertHandle.AlertWarning(session, "失败", "添加实验室失败!");
				break;
			case "modify":
					EquipInfoBean labInfoBean1=getLabByParameter(request);
					if(EquipHandler.setLabInfo(labInfoBean1))
						AlertHandle.AlertSuccess(session, "成功", "修改实验室成功!");

					else 
						AlertHandle.AlertWarning(session, "失败", "修改实验室失败!");
				break;
			case "del":
					System.out.println("del");
					String num=request.getParameter("lab_number");
					if(EquipHandler.delLab(num))
						AlertHandle.AlertSuccess(session, "成功", "删除用户成功!");
					else 
						AlertHandle.AlertWarning(session, "失败", "删除实验室失败!");
				break;
			default:
				AlertHandle.AlertWarning(session, "失败", "未知操作!");
				break;
			}
		} 
		response.sendRedirect("labManage.jsp");
	}

}

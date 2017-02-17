package Servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Model.CheckHandler;

/**
 * Servlet implementation class FastQuery
 */
@WebServlet("/FastQuery")
public class FastQuery extends HttpServlet {
	private static final long serialVersionUID = 1L;
    public FastQuery() {
        super();
    }
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter writer=response.getWriter();
		String query;
		query=request.getParameter("account");
		if(query!=null){
			System.out.println("account");
			if(CheckHandler.checkUserAccount(query))
				writer.print("true");
			else
				writer.print("false");
		}
		else {
			query=request.getParameter("order_date");
			if (query!=null) {
				String equipid=request.getParameter("equipid");
				if(equipid!=null){
					String result=CheckHandler.getOrderMessage(equipid, query);
					writer.print(result);
				}
			}
			else {
				query=request.getParameter("equipid");
				if(query!=null){
					System.out.println("order_date");
					if(CheckHandler.checkEquipID(query))
						writer.print("true");
					else
						writer.print("false");
				}
			}
		}
		
		
	}

}

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
			if(CheckHandler.checkUserAccount(query))
				writer.print("true");
		}
		else {
			query=request.getParameter("equipid");
			if(query!=null){
				if(CheckHandler.checkEquipID(query))
					writer.print("true");
			}
		}
		
		
	}

}

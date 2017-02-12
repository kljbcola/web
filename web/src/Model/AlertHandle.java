package Model;

import javax.servlet.http.HttpSession;

public class AlertHandle {
	public static void Alert(HttpSession session,String title,String content){
		session.setAttribute("AlertType", "alert-info");
		session.setAttribute("AlertTitle", title);
		session.setAttribute("AlertContent", content);
	}
	public static void AlertSuccess(HttpSession session,String title,String content){
		session.setAttribute("AlertTitle", title);
		session.setAttribute("AlertContent", content);
		session.setAttribute("AlertType", "alert-success");
	}
	public static void AlertWarning(HttpSession session,String title,String content){
		session.setAttribute("AlertTitle", title);
		session.setAttribute("AlertContent", content);
		session.setAttribute("AlertType", "alert-warning");
	}
	public static void AlertDanger(HttpSession session,String title,String content){
		session.setAttribute("AlertTitle", title);
		session.setAttribute("AlertContent", content);
		session.setAttribute("AlertType", "alert-danger");
	}
}

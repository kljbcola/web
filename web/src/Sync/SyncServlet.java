package Sync;



import javax.servlet.http.HttpServlet;



public class SyncServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private SyncThread syncThread;
	public SyncServlet(){
	}
	 
	public void init(){  
		String str = null;  
		if (str == null && syncThread == null) { 
			syncThread = new SyncThread();  
			syncThread.start();
		}
	}
	public void destory(){  
		if (syncThread != null && syncThread.isInterrupted()) {  
			syncThread.interrupt();  
		}  
	}  
}

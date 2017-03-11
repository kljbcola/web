package Sync;


import java.util.HashMap;

import javax.servlet.http.HttpServlet;



public class SyncServlet extends HttpServlet {
	public static HashMap<String , Boolean> equipStatus=null;
	 private static final long serialVersionUID = 1L;
	 private SyncThread syncThread;
	 public SyncServlet(){
	 }
	 
	 public void init(){  
	        String str = null;  
	        if (str == null && syncThread == null) { 
	        	if(equipStatus==null)equipStatus=new HashMap<String , Boolean>();
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

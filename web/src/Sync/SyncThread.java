package Sync;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;
import java.net.UnknownHostException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.Map;

import Bean.OrderInfo;
import Model.AdminHandler;
import Model.CardHandler;
import Model.EquipHandler;

public class SyncThread extends Thread {
	public void run() {  
	        while (!this.isInterrupted()) {// 线程未中断执行循环 
	        	ArrayList<String> equipList=EquipHandler.getEquipNumber();
	        	for(int i=0;i<equipList.size();i++){
	        		SyncServlet.equipStatus.remove(equipList.get(i));
	        		SyncServlet.equipStatus.put(equipList.get(i), new Boolean(syncEquip(equipList.get(i))));
	        	}
	        	Iterator iter = SyncServlet.equipStatus.entrySet().iterator();
	        	while (iter.hasNext()) {
		        	Map.Entry entry = (Map.Entry) iter.next();
		        	String key =(String) entry.getKey();
		        	Boolean val =(Boolean) entry.getValue();
		        	System.out.println("equipNum:"+ key + "  connect:"+ val.toString());
	        	}
	            try {
	                Thread.sleep(20000);
	            } catch (InterruptedException e) {
	                e.printStackTrace();
	            }
	        }  
	    }  
	private boolean syncEquip(String equipNum){
		String equipIP=EquipHandler.getEquipIP(equipNum);
		if(equipIP==null||equipIP.equals("null"))
			return false;
		String[] ipstr=equipIP.split(":");
		String IpAddress=ipstr[0];
		if(ipstr.length<2)return false;
		int Port=Integer.valueOf(ipstr[1]);
		try {
			Socket socket = new Socket(IpAddress, Port);
			if(socket.isConnected()){
				PrintWriter write = new PrintWriter(socket.getOutputStream()); 
				BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
				String sendString="time;";
				SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");//设置日期格式
				sendString+=df.format(new Date())+";";
				sendString+="admin;";
				ArrayList<String> adminList = AdminHandler.getAdminCards();
				for (int i = 0; i < adminList.size(); i++) {
					sendString+=adminList.get(i)+";";
				}
				sendString+="end;order;";
				ArrayList<OrderInfo> orderList=EquipHandler.getOrderByEquipNum(equipNum);
				for (int i = 0; i < orderList.size(); i++) {
					OrderInfo orderInfo=orderList.get(i);
					String card_number=CardHandler.getCardByUserID(orderInfo.user_id);
					if(orderInfo.operation.equals("预约处理中")){
						sendString += orderInfo.order_record_id+","+card_number+","
							+orderInfo.order_date+","+orderInfo.start_time+","+orderInfo.end_time+",1;";
						orderInfo.operation="预约已生效";
					}
					else if(orderInfo.operation.equals("预约取消中")) {
						sendString += orderInfo.order_record_id+","+card_number+","
							+orderInfo.order_date+","+orderInfo.start_time+","+orderInfo.end_time+",0;";
						orderInfo.operation="预约已取消";
					}
				}
				sendString+="end;";
				System.out.println(sendString);
				write.print(sendString);
				write.flush();
				
				String readString=in.readLine();
				System.out.println(readString);
				write.close(); // 关闭Socket输出流
				in.close(); // 关闭Socket输入流
				socket.close(); // 关闭Socket
				String[] readOrders=readString.split(";");
				for(int i=0;i<readOrders.length;i++){
					if(readOrders[i].equals("quit"))break;
					String [] getOrderStrings=readOrders[i].split(",");
					String order_record_id=getOrderStrings[0];
					float exp_start_time=Float.valueOf(getOrderStrings[1]);
					float exp_end_time=Float.valueOf(getOrderStrings[2]);
					String operation=getOrderStrings[3];
					int op = Integer.valueOf(operation);
					if(op==3)
						operation="预约实验完成";
					else 
						operation="预约过期";
					EquipHandler.updateOrder(order_record_id, exp_start_time, exp_end_time, operation);
				}
				
				for (int i = 0; i < orderList.size(); i++) {
					OrderInfo orderInfo=orderList.get(i);
					EquipHandler.setOrderStatus(orderInfo.order_record_id, orderInfo.operation);
				}
				
				
				return true;
			}
		socket.close();
		} catch (Exception e) {
			//e.printStackTrace();
		}
		return false;
	}
	  
}

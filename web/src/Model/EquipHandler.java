package Model;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import Bean.EquipInfoBean;
import Bean.OrderInfo;
import Data.DbPool;

public class EquipHandler {
    static Connection con;
    static PreparedStatement ps;
    static ResultSet rs;
    private static String setValue(String val)
	{
		if(val!=null&&!val.equals("")){
			StringBuilder stringBuilder=new StringBuilder();
			stringBuilder.append('\'');
			for(int i=0;i<val.length();i++){
				char a=val.charAt(i);
				if(a=='\''|| a=='\"')stringBuilder.append('\\');
				stringBuilder.append(a);
			}
			stringBuilder.append('\'');
			return stringBuilder.toString();
		}
		return "null";
	}
    
    private static String clearNullString(String str){
    	if(str==null||str.equals("null"))
    		return "";
    	else return str;
    }
    
    public static String changeBank(String a){
    	String b="";
    	for (int i=0; i<a.length(); i++){
    		if (a.charAt(i)!='\n'&&a.charAt(i)!='\r') b=b+a.charAt(i);
    		else b+="<br>";
    	}
    	return b;
    }
    public static EquipInfoBean changeBank(EquipInfoBean equip){
    	equip.description=changeBank(equip.description);
    	equip.attachment=changeBank(equip.attachment);
    	equip.specification=changeBank(equip.specification);
    	System.out.println(equip.specification+"~~~~~~~~~~~~~");
    	return equip;
    }
    public static String getEquipIP(String equipnum){
    	String equipIP=null;
		con = DbPool.getConnection();
	        String strSql = "select equip_ip from equip_message where equip_number=?;";
	        try
	        {
	            ps = con.prepareStatement(strSql);
	            ps.setString(1,equipnum);
	            rs = ps.executeQuery();
	            if(rs.next())
	            {    
	            	equipIP=rs.getString(1);
	                //释放资源
	                DbPool.DBClose(con, ps, rs);            
	            }
	            else
	                DbPool.DBClose(con, ps, rs);          
	        }catch(Exception e)
	        {
	            e.printStackTrace();
	            System.out.println("getequipIP出错!");
	        }
		return equipIP;
    }
    public static ArrayList<String> getEquipNumber(){
		con = DbPool.getConnection();
		ArrayList<String> result=new ArrayList<String>();
	    String strSql = "select equip_number from equip_message;";
	    try
	    {
	        ps = con.prepareStatement(strSql);
	        rs = ps.executeQuery();
	        while(rs.next())
	            result.add(rs.getString(1));
	        DbPool.DBClose(con, ps, rs);  
	    }catch(Exception e)
	    {
	        e.printStackTrace();
	        System.out.println("getEquipNumber出错!");
	        return null;
	    }
		return result;
	}
    
    
    public static EquipInfoBean getEquipInfoBean(String equipnum){
    	EquipInfoBean equipInfoBean=null;
		con = DbPool.getConnection();
	        String strSql = "select * from equip_message where equip_number=?;";
	        try
	        {
	            ps = con.prepareStatement(strSql);
	            ps.setString(1,equipnum);
	            rs = ps.executeQuery();
	            if(rs.next())
	            {    
	            	equipInfoBean=new EquipInfoBean();
	            	equipInfoBean.equip_number=rs.getString("equip_number");
	            	equipInfoBean.equip_name=clearNullString(rs.getString("equip_name"));
	            	equipInfoBean.equip_model=clearNullString(rs.getString("equip_model"));
	            	equipInfoBean.specification=clearNullString(rs.getString("specification"));
	            	equipInfoBean.lab_name=clearNullString(rs.getString("lab_name"));
	            	equipInfoBean.lab_location=clearNullString(rs.getString("lab_location"));
	            	equipInfoBean.faculty=clearNullString(rs.getString("faculty"));
	            	equipInfoBean.description=clearNullString(rs.getString("description"));
	            	equipInfoBean.build_time=clearNullString(rs.getString("build_time"));
	            	equipInfoBean.research_area=clearNullString(rs.getString("research_area"));
	            	equipInfoBean.attachment=clearNullString(rs.getString("attachment"));
	            	equipInfoBean.owner=clearNullString(rs.getString("owner"));
	            	equipInfoBean.phone=clearNullString(rs.getString("phone"));
	            	equipInfoBean.Email=clearNullString(rs.getString("Email"));
	            	equipInfoBean.price=clearNullString(rs.getString("price"));
	            	equipInfoBean.overtime_price=clearNullString(rs.getString("overtime_price"));
	            	equipInfoBean.min_time=clearNullString(rs.getString("min_time"));
	            	equipInfoBean.max_time=clearNullString(rs.getString("max_time"));
	            	equipInfoBean.equip_status=clearNullString(rs.getString("equip_status"));
	            	equipInfoBean.equip_permission=clearNullString(rs.getString("equip_permission"));
	             	equipInfoBean.equip_ip=clearNullString(rs.getString("equip_ip"));
	                //释放资源
	                DbPool.DBClose(con, ps, rs);            
	            }
	            else
	            {
	                //释放资源
	                DbPool.DBClose(con, ps, rs);
	            }            
	        }catch(Exception e)
	        {
	            e.printStackTrace();
	            System.out.println("getequipInfoBean出错!");
	            return null;
	        }
		return equipInfoBean;
	}
    public static boolean setequipInfo(EquipInfoBean equipInfoBean)
	{
		 con = DbPool.getConnection();
		 int rs;
	        String strSql = "update equip_message set "
	        		+ "equip_name= "     		+setValue(equipInfoBean.equip_name) 
	        		+ ", equip_model= " 		+ setValue(equipInfoBean.equip_model)
	        		+ ", specification= " 		+ setValue(equipInfoBean.specification)
	        		+ ", lab_name= " 			+ setValue(equipInfoBean.lab_name)
	        		+ ", lab_location= " 		+ setValue(equipInfoBean.lab_location)
	        		+ ", faculty= "				+ setValue(equipInfoBean.faculty)
	        		+ ", description= " 		+ setValue(equipInfoBean.description)
	        		+ ", build_time= " 			+ setValue(equipInfoBean.build_time)
	        		+ ", research_area= " 		+ setValue(equipInfoBean.research_area)
	        		+ ", attachment= " 			+ setValue(equipInfoBean.attachment)
	        		+ ", owner= " 				+ setValue(equipInfoBean.owner)
	        		+ ", phone= " 				+ setValue(equipInfoBean.phone)
	        		+ ", Email= " 				+ setValue(equipInfoBean.Email)
	        		+ ", price= " 				+ setValue(equipInfoBean.price)
	        		+ ", overtime_price= " 		+ setValue(equipInfoBean.overtime_price)
	        		+ ", min_time= " 			+ setValue(equipInfoBean.min_time)
	        		+ ", max_time= " 			+ setValue(equipInfoBean.max_time)
	        		+ ", equip_status= " 		+ setValue(equipInfoBean.equip_status)
	        		+ ", equip_permission= " 	+ setValue(equipInfoBean.equip_permission)
	        		+ ", equip_ip= " 			+ setValue(equipInfoBean.equip_ip)
	        		+ " where equip_number=" 	+ setValue(equipInfoBean.equip_number)
	        		+ ";";
	        try
	        {
	            ps = con.prepareStatement(strSql);
	            rs = ps.executeUpdate();
	        }catch(Exception e)
	        {
	            e.printStackTrace();
	            System.out.println("数据修改出错!");
	            return false;
	        }
	        if(rs<1)
	        	return false;
	        else 
	        	return true;
	}
    public static boolean addequip(EquipInfoBean equipInfoBean)
	{
		 con = DbPool.getConnection();
		 int rs;
	        String strSql = "INSERT INTO equip_message "
	        		+ "(equip_number,	equip_name,		equip_model,	specification,		lab_name,		lab_location,"
	        		+ " faculty,		description,	build_time,		research_area,		attachment,		owner,"
	        		+ " phone,			Email,			price,			overtime_price,		min_time,		max_time,"
	        		+ "equip_status,	open_hours,		close_hours,	equip_permission,	equip_ip)  values "+"("
	        		+  			  setValue(equipInfoBean.equip_number)
	        		+ ", "   	+ setValue(equipInfoBean.equip_name) 
	        		+ ", " 		+ setValue(equipInfoBean.equip_model)
	        		+ ", " 		+ setValue(equipInfoBean.specification)
	        		+ ", " 		+ setValue(equipInfoBean.lab_name)
	        		+ ", " 		+ setValue(equipInfoBean.lab_location)
	        		+ ", "		+ setValue(equipInfoBean.faculty)
	        		+ ", " 		+ setValue(equipInfoBean.description)
	        		+ ", " 		+ setValue(equipInfoBean.build_time)
	        		+ ", " 		+ setValue(equipInfoBean.research_area)
	        		+ ", " 		+ setValue(equipInfoBean.attachment)
	        		+ ", " 		+ setValue(equipInfoBean.owner)
	        		+ ", " 		+ setValue(equipInfoBean.phone)
	        		+ ", " 		+ setValue(equipInfoBean.Email)
	        		+ ", " 		+ setValue(equipInfoBean.price)
	        		+ ", " 		+ setValue(equipInfoBean.overtime_price)
	        		+ ", " 		+ setValue(equipInfoBean.min_time)
	        		+ ", " 		+ setValue(equipInfoBean.max_time)
	        		+ ", " 		+ setValue(equipInfoBean.equip_status)
	        		+ ", " 		+ setValue(equipInfoBean.equip_permission)
	        		+ ",  " 	+ setValue(equipInfoBean.equip_ip) +");";
	        try
	        {
	            ps = con.prepareStatement(strSql);
	            rs = ps.executeUpdate();
	        }catch(Exception e)
	        {
	            e.printStackTrace();
	            System.out.println("数据添加出错!");
	            return false;
	        }
	        if(rs<1)
	        	return false;
	        else 
	        	return true;
	}
    public static boolean delequip(String num)
    {
        //从数据访问组件中取得连接
        con = DbPool.getConnection();
        String strSql = "delete from equip_message where equip_number=?;";
        int rs;
        try
        {
            ps = con.prepareStatement(strSql);
            ps.setString(1,num);
            rs = ps.executeUpdate();
       
        }catch(Exception e)
        {
            e.printStackTrace();
            System.out.println("delequip出错!");
            return false;
        }
        if (rs<1) return false;
        else return true;
    }
    public static boolean equipOrderNouse(String userID,String equipID,String date,float start_time,float end_time)
    {
    	con = DbPool.getConnection();
		 int rs;
	        String strSql = "INSERT INTO order_record "
	        		+ "(equip_number,user_id,order_date,start_time,end_time,operation) values "+"("
	        					+ setValue(equipID)
	        		+ ", " 		+ setValue(userID)
	        		+ ", "		+ setValue(date)
	        		+ ", " 		+ start_time
	        		+ ", " 		+ end_time
	        		+ ",'不可用');";
	        try
	        {
	            ps = con.prepareStatement(strSql);
	            rs = ps.executeUpdate();
	            ps.close();
	        }catch(Exception e)
	        {
	            e.printStackTrace();
	            System.out.println("数据添加出错!");
	            DbPool.DBClose(con, ps);
	            return false;
	        }
	        if(rs<1){
	        	return false;
	        }
	        else {
	        	return true;
	        }
    }
    public static String equipOrder(String userID,String equipID,String date,float start_time,float end_time)
    {
    	String orderID=null;
    	con = DbPool.getConnection();
		 int rs;
	        String strSql = "INSERT INTO order_record "
	        		+ "(equip_number,user_id,order_date,start_time,end_time,operation) values "+"("
	        					+ setValue(equipID)
	        		+ ", " 		+ setValue(userID)
	        		+ ", "		+ setValue(date)
	        		+ ", " 		+ start_time
	        		+ ", " 		+ end_time +",'预约处理中');";
	        try
	        {
	            ps = con.prepareStatement(strSql);
	            rs = ps.executeUpdate();
	            ps.close();
	        }catch(Exception e)
	        {
	            e.printStackTrace();
	            System.out.println("数据添加出错!");
	            DbPool.DBClose(con, ps);
	            return null;
	        }
	        if(rs<1){
	        	return null;
	        }
	        else {
	        	try {
	        		strSql ="SELECT LAST_INSERT_ID();";
					ps = con.prepareStatement(strSql);
					ResultSet rss = ps.executeQuery();
					rss.next();
					orderID=rss.getString(1);
		            DbPool.DBClose(con, ps);

				} catch (SQLException e) {
					System.out.println("数据查询出错!");
					e.printStackTrace();
					DbPool.DBClose(con, ps);
				}
	        	if (orderID.equals("0")) {
					return null;
				}
	        	else return orderID;
	        	
	        }
    }
    public static int disOrderByUser(String userid){
    	int count=0;
    	con = DbPool.getConnection();
        String strSql = "update order_record set operation='预约失败',remark='用户已删除' where user_id=? and operation in('预约处理中','预约已生效');";
        try
        {
            ps = con.prepareStatement(strSql);
            ps.setString(1,userid);
            count = ps.executeUpdate();
       
        }catch(Exception e)
        {
            e.printStackTrace();
            System.out.println("delorder出错!");
            return count;
        }
        return count;
    }
    
    public static int updateOrder(String order_record_id,float exp_start_time,float exp_end_time,String operation){
    	int count=0;
    	con = DbPool.getConnection();
        String strSql = "update order_record set exp_start_time=?,exp_end_time=?, operation=? where order_record_id=?;";
        try
        {
            ps = con.prepareStatement(strSql);
            ps.setString(1,String.valueOf(exp_start_time));
            ps.setString(2,String.valueOf(exp_end_time));
            ps.setString(3,operation);
            ps.setString(4,order_record_id);
            count = ps.executeUpdate();
        }catch(Exception e)
        {
            e.printStackTrace();
            System.out.println("updateOrder出错!");
            return count;
        }
        return count;
    }
    
    
    public static boolean delorder(String id)
    {
        //从数据访问组件中取得连接
        con = DbPool.getConnection();
        String strSql = "delete from order_record where order_record_id=?;";
        int rs;
        try
        {
            ps = con.prepareStatement(strSql);
            ps.setString(1,id);
            rs = ps.executeUpdate();
       
        }catch(Exception e)
        {
            e.printStackTrace();
            System.out.println("delorder出错!");
            return false;
        }
        if (rs<1) return false;
        else return true;
    }

    public static boolean clearAdminOrder(String equip_number,String order_date)
    {
        //从数据访问组件中取得连接
        con = DbPool.getConnection();
        String strSql = "delete from order_record where equip_number=? and order_date=? and operation='不可用';";
        int rs;
        try
        {
            ps = con.prepareStatement(strSql);
            ps.setString(1,equip_number);
            ps.setString(2,order_date);
            rs = ps.executeUpdate();
        }catch(Exception e)
        {
            e.printStackTrace();
            System.out.println("delorder出错!");
            return false;
        }
        if (rs<1) return false;
        else return true;
    }
    public static boolean setOrderStatus(String id,String status)
    {
    	con = DbPool.getConnection();
		 int rs;
	        String strSql = "update order_record set operation=?"
	        		+ " where order_record_id=?;";
	        try
	        {
	            ps = con.prepareStatement(strSql);
	            ps.setString(1, status);
	            ps.setString(2, id);
	            System.out.println(strSql);
	            rs = ps.executeUpdate();
	        }catch(Exception e)
	        {
	            e.printStackTrace();
	            System.out.println("数据修改出错!");
	            return false;
	        }
	        if(rs<1)
	        	return false;
	        else 
	        	return true;
    }
    public static OrderInfo getOrderInfo(String id)
    {
    	con = DbPool.getConnection();
    	OrderInfo orderInfo=null;
		 ResultSet rs;
	        String strSql = "select * from order_record where order_record_id=?;";
	        try
	        {
	            ps = con.prepareStatement(strSql);
	            ps.setString(1, id);
	            System.out.println(strSql);
	            rs = ps.executeQuery();
	            orderInfo=new OrderInfo();
	            rs.next();
	            orderInfo.equip_number=rs.getString("equip_number");
	            orderInfo.user_id=rs.getString("user_id");
	            orderInfo.order_date=rs.getString("order_date");
	            orderInfo.start_time=rs.getString("start_time");
	            orderInfo.end_time=rs.getString("end_time");
	            orderInfo.exp_start_time=rs.getString("exp_start_time");
	            orderInfo.exp_end_time=rs.getString("exp_end_time");
	            orderInfo.operation=rs.getString("operation");
	            orderInfo.remark=rs.getString("remark");
	        }catch(Exception e)
	        {
	            e.printStackTrace();
	            System.out.println("数据修改出错!");
	            return null;
	        }
	        return orderInfo;
    }
    public static int updateOrderByUserCard(String UserAccount,String card_number){
    	int count=0;
    	con = DbPool.getConnection();
        String strSql = "update order_record set card_number=?, operation='预约处理中' where user_id=(select user_id from user_message where user_name=?);";
        try
        {
            ps = con.prepareStatement(strSql);
            ps.setString(1,card_number);
            ps.setString(2,UserAccount);
            count = ps.executeUpdate();
        }catch(Exception e)
        {
            e.printStackTrace();
            System.out.println("updateOrderByUserCard出错!");
            return count;
        }
        return count;
    }
    
    public static ArrayList<OrderInfo> getOrderByEquipNum(String equipNum)
    {
    	con = DbPool.getConnection();
    	ArrayList<OrderInfo> orderList=new ArrayList<OrderInfo>();
    	OrderInfo orderInfo=null;
		ResultSet rs;
	        String strSql = "select * from order_record where equip_number=? and (operation='预约处理中' or operation='预约取消中');";
	        try
	        {
	            ps = con.prepareStatement(strSql);
	            ps.setString(1, equipNum);
	            rs = ps.executeQuery();
	            orderInfo=new OrderInfo();
	            while(rs.next()){
		            orderInfo.order_record_id=rs.getString(1);
		            orderInfo.equip_number=rs.getString(2);
		            orderInfo.user_id=rs.getString(3);
		            orderInfo.order_date=rs.getString(4);
		            orderInfo.start_time=rs.getString(5);
		            orderInfo.end_time=rs.getString(6);
		            orderInfo.exp_start_time=rs.getString(7);
		            orderInfo.exp_end_time=rs.getString(8);
		            orderInfo.operation=rs.getString(9);
		            orderInfo.remark=rs.getString(10);
		            orderList.add(orderInfo);
	            }
	        }catch(Exception e)
	        {
	            e.printStackTrace();
	            System.out.println("数据修改出错!");
	            return null;
	        }
	        return orderList;
    }
}
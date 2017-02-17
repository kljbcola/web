package Model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import Data.DbPool;

public class CheckHandler {
	static Connection con;
    static PreparedStatement ps;
    static ResultSet rs;
    public static boolean checkUserAccount(String userAccount)
    {
        //从数据访问组件中取得连接
        con = DbPool.getConnection();
        //得到Controller传入的用户输入的用户名及密码
        String strSql = "select user_id from user_message where user_name=?";
        try
        {
            ps = con.prepareStatement(strSql);
            ps.setString(1,userAccount);
            rs = ps.executeQuery();
            if(rs.next())
            {    
                //释放资源
                DbPool.DBClose(con, ps, rs);      
            	return true;
            }
            else
            {
                //释放资源
                DbPool.DBClose(con, ps, rs);
            }            
        }catch(Exception e)
        {
            e.printStackTrace();
            System.out.println("查询出错!");
            return false;
        }
        return false;
    }
    public static boolean checkEquipID(String equipID)
    {
        //从数据访问组件中取得连接
        con = DbPool.getConnection();
        //得到Controller传入的用户输入的用户名及密码
        String strSql = "select equip_name from equip_message where equip_number=?";
        try
        {
            ps = con.prepareStatement(strSql);
            ps.setString(1,equipID);
            rs = ps.executeQuery();
            if(rs.next())
            {    
                //释放资源
                DbPool.DBClose(con, ps, rs);      
            	return true;
            }
            else
            {
                //释放资源
                DbPool.DBClose(con, ps, rs);
            }            
        }catch(Exception e)
        {
            e.printStackTrace();
            System.out.println("查询出错!");
            return false;
        }
        return false;
    }
    public static String getOrderMessage(String equipID,String date)
    {
    	String result="";
        //从数据访问组件中取得连接
        con = DbPool.getConnection();
        String strSql = "select operation,start_time,end_time from order_record where equip_number="+equipID+" and order_date='"+date+"';";
        try
        {
            ps = con.prepareStatement(strSql);
            rs = ps.executeQuery();
            while(rs.next())
            {    
                if(!rs.getString("operation").equals("预约失败")){
	            	result+=rs.getString("start_time")+',';
	            	result+=rs.getString("end_time")+';';
                }
            }
            //释放资源
            DbPool.DBClose(con, ps, rs);      
        }catch(Exception e)
        {
            e.printStackTrace();
            System.out.println("查询出错!");
            return result;
        }
        return result;
    }
    public static boolean checkOrderDate(String equipID,String date,float start_time,float end_time)
    {
        //从数据访问组件中取得连接
        con = DbPool.getConnection();
        String strSql = "select operation,start_time,end_time from order_record where equip_number="+equipID+" and order_date='"+date+"';";
        try
        {
        	System.out.println("start_time:"+start_time+" end_time:"+end_time);
            ps = con.prepareStatement(strSql);
            rs = ps.executeQuery();
            while(rs.next())
            {    
                if(!rs.getString("operation").equals("预约失败")){
	            	float x=Float.valueOf(rs.getString("start_time"));
	            	float y=Float.valueOf(rs.getString("end_time"));
	            	System.out.println("x:"+x+" y:"+y);
	            	if(!(x>end_time||y<start_time))
	    				return false;
                }
            }
            //释放资源
            DbPool.DBClose(con, ps, rs);  
            return true;
        }catch(Exception e)
        {
            e.printStackTrace();
            System.out.println("查询出错!");
            return false;
        }
    }


}

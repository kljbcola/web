package Model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

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
        String strSql = "select operation,start_time,end_time,order_date from order_record where equip_number="+equipID+
        		" and (order_date='"+date+"' or (order_date='0000-00-00' and operation='不可用')) order by start_time;";
        System.out.println(strSql);
        try
        {
            ps = con.prepareStatement(strSql);
            rs = ps.executeQuery();
            Date nowDate=new Date();
        	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        	String nowDateStr=sdf.format(nowDate);
        	float nowTime=(float) (Calendar.getInstance().get(Calendar.HOUR_OF_DAY)+(Calendar.getInstance().get(Calendar.MINUTE)/60.0)+0.75);
            if(nowDateStr.equals(date)){
				result+="0,"+nowTime+",2;";
			}
            while(rs.next())
            {    
            	
            	float endt=Float.valueOf(rs.getString(3));
            	if (nowDateStr.equals(date)&&nowTime>endt) 
						continue;
            	String op=rs.getString(1);
            	result+=rs.getString(2)+',';
            	result+=rs.getString(3)+',';
            	String order_date=rs.getString(4);
                if(op.equals("预约处理中")||op.equals("预约已生效")){
	            	result+="2;";
                }
                else {
                	if(op.equals("不可用")&&order_date!=null){
		            	result+="1;";
	                }
                	else {
						result+="0;";
					}
                }
            }
            System.out.println(result);
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
    public static String getNoUseOrderMessage(String equipID)
    {
    	String result="";
        //从数据访问组件中取得连接
        con = DbPool.getConnection();
        String strSql = "select operation,start_time,end_time from order_record where equip_number="+equipID+
        		" and order_date='0000-00-00' and operation='不可用' order by start_time;";
        try
        {
            ps = con.prepareStatement(strSql);
            rs = ps.executeQuery();
            while(rs.next())
            {    
            	result+=rs.getString("start_time")+',';
            	result+=rs.getString("end_time")+',';
            	result+="1;";
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
            	String opString=rs.getString("operation");
                if(!opString.equals("预约失败")&&!opString.equals("预约取消")){
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
    public static boolean checkCardNumber(String CardNumber)
    {
        //从数据访问组件中取得连接
        con = DbPool.getConnection();
        //得到Controller传入的用户输入的用户名及密码
        String strSql = "select user_name from card_message where card_number=?";
        try
        {
            ps = con.prepareStatement(strSql);
            ps.setString(1,CardNumber);
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
                return false;
            }            
        }catch(Exception e)
        {
            e.printStackTrace();
            System.out.println("查询出错!");
            return false;
        }
        
    }

}

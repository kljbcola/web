package Model;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import Bean.CardInfoBean;
import Data.DbPool;

public class CardHandler {
    static Connection con;
    static PreparedStatement ps;
    static ResultSet rs;
    private static String setValue(String val)
	{
		
		if(val!=null&&!val.equals(""))
			return "\'"+val+"\'";
		return "null";
	}
    
    private static String clearNullString(String str){
    	if(str==null||str.equals("null"))
    		return "";
    	else return str;
    }
    
    
    public static CardInfoBean getCardInfoBean(String Cardnum){
    	System.out.println(Cardnum);
    	CardInfoBean CardInfoBean=null;
		con = DbPool.getConnection();
	        String strSql = "select * from card_message where card_number=?;";
	        try
	        {
	            ps = con.prepareStatement(strSql);
	            ps.setString(1,Cardnum);
	            rs = ps.executeQuery();
	            if(rs.next())
	            {    
	            	CardInfoBean=new CardInfoBean();
	            	CardInfoBean.card_number=clearNullString(rs.getString("card_number"));
	            	CardInfoBean.user_id=clearNullString(rs.getString("user_id"));
	            	CardInfoBean.remaining_sum=clearNullString(rs.getString("remaining_sum"));
	            	CardInfoBean.consumption=clearNullString(rs.getString("consumption"));
	            	CardInfoBean.status=clearNullString(rs.getString("status"));
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
	            System.out.println("getCardInfoBean出错!");
	            return null;
	        }
		return CardInfoBean;
	}
    public static boolean setCardInfo(CardInfoBean CardInfoBean)
	{
		 con = DbPool.getConnection();
		 int rs;
	        String strSql = "update card_message set "
	        		+ "user_id= "     		+setValue(CardInfoBean.user_id) 
	        		+ ", remaining_sum= " 		+ setValue(CardInfoBean.remaining_sum)
	        		+ ", consumption= " 		+ setValue(CardInfoBean.consumption)
	        		+ ", status= " 			+ setValue(CardInfoBean.status)
	        		+ " where card_number=" 	+ setValue(CardInfoBean.card_number)
	        		+ ";";
	        try
	        {
	            ps = con.prepareStatement(strSql);
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
    public static boolean changeUser(CardInfoBean CardInfoBean){
    	System.out.println("修改用户中~~");
    	con = DbPool.getConnection();
		 int rs;
		 	String strSql = "update user_message set "
	        		+ "card_number= "     		+setValue(CardInfoBean.card_number) 
	        		+ " where user_id=" 	+ setValue(CardInfoBean.user_id)
	        		+ ";";
	        try
	        {
	            ps = con.prepareStatement(strSql);
	            System.out.println(strSql);
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
    public static boolean addCard1(CardInfoBean CardInfoBean){
    	System.out.println("添加IC卡中~~");
    	con = DbPool.getConnection();
		 int rs;
	        String strSql = "INSERT INTO card_message "
	        		+ "(card_number,	user_id,		remaining_sum,		consumption,		status)  values "+"("
	        		+  			  setValue(CardInfoBean.card_number)
	        		+ ", "   	+ setValue(CardInfoBean.user_id) 
	        		+ ", " 		+ setValue(CardInfoBean.remaining_sum)
	        		+ ", " 		+ setValue(CardInfoBean.consumption)
	        		+ ", " 		+ setValue(CardInfoBean.status) +");";
	        try
	        {
	            ps = con.prepareStatement(strSql);
	            System.out.println(strSql);
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
    
    public static boolean addCard(CardInfoBean CardInfoBean)
	{
		 return addCard1(CardInfoBean)&&changeUser(CardInfoBean);
	}
    
    public static boolean delCard(String num)
    {
        //从数据访问组件中取得连接
        con = DbPool.getConnection();
        String strSql = "delete from card_message where card_number=?;";
        int rs;
        try
        {
            ps = con.prepareStatement(strSql);
            ps.setString(1,num);
            rs = ps.executeUpdate();
       
        }catch(Exception e)
        {
            e.printStackTrace();
            System.out.println("delCard出错!");
            return false;
        }
        if (rs<1) return false;
        else return true;
    }

}
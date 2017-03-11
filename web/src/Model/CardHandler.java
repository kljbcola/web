package Model;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.* ;
import java.text.*; 

import Bean.CardInfoBean;
import Bean.PaidInfoBean;
import Bean.EquipInfoBean;
import Data.DbPool;
public class CardHandler {
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
    public static float queryMoney(String card_number){
    	con = DbPool.getConnection();
        String strSql = "select remaining_sum from card_message where card_number=?;";
    	float result=0;
        try {
        	ps = con.prepareStatement(strSql);
            ps.setString(1,card_number);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
				
            	result=Float.valueOf(rs.getString("remaining_sum"));
            	//释放资源
                DbPool.DBClose(con, ps, rs);           
			}
		} catch (Exception e) {
			e.printStackTrace();
            System.out.println("getCardInfoBean出错!");
		}
        return result;
    }
    public static float queryPaid(String card_number){
    	con = DbPool.getConnection();
        String strSql = "select consumption from card_message where card_number=?;";
    	float result=0;
        try {
        	ps = con.prepareStatement(strSql);
            ps.setString(1,card_number);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
				
            	result=Float.valueOf(rs.getString("consumption"));
            	//释放资源
                DbPool.DBClose(con, ps, rs);           
			}
		} catch (Exception e) {
			e.printStackTrace();
            System.out.println("getCardInfoBean出错!");
		}
        return result;
    }
    public static CardInfoBean getCardInfoBeanByUser(String Username){
    	System.out.println(Username);
    	CardInfoBean CardInfoBean=null;
		con = DbPool.getConnection();
	        String strSql = "select * from card_message where status='正常'and user_name=?;";
	        
	        try
	        {
	            ps = con.prepareStatement(strSql);
	            ps.setString(1,Username);
	            System.out.println(strSql+Username);
	            rs = ps.executeQuery();
	            if(rs.next())
	            {    
	            	CardInfoBean=new CardInfoBean();
	            	CardInfoBean.card_number=clearNullString(rs.getString("card_number"));
	            	CardInfoBean.user_account=clearNullString(rs.getString("user_name"));
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
	            	CardInfoBean.user_account=clearNullString(rs.getString("user_name"));
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
    public static CardInfoBean getCardByUser(String UserAccount){
    	CardInfoBean CardInfoBean=null;
		con = DbPool.getConnection();
	        String strSql = "select * from card_message where card_number=(select card_number from user_message where user_name=?);";
	        try
	        {
	            ps = con.prepareStatement(strSql);
	            ps.setString(1,UserAccount);
	            rs = ps.executeQuery();
	            if(rs.next())
	            {    
	            	CardInfoBean=new CardInfoBean();
	            	CardInfoBean.card_number=clearNullString(rs.getString("card_number"));
	            	CardInfoBean.user_account=clearNullString(rs.getString("user_name"));
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
	        		+ "user_name= "     		+setValue(CardInfoBean.user_account) 
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
    public static String getUserByCard(String card_number){
    	String user_id=null;
		con = DbPool.getConnection();
	        String strSql = "select user_id from user_message where card_number=?;";
	        try
	        {
	            ps = con.prepareStatement(strSql);
	            ps.setString(1,card_number);
	            rs = ps.executeQuery();
	            if(rs.next())
	            {    
	            	user_id=rs.getString(1);
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
		return user_id;
	}
    public static String getCardByUserID(String user_id){
    	String card_number="";
		con = DbPool.getConnection();
	        String strSql = "select card_number from user_message where user_id=?;";
	        try
	        {
	            ps = con.prepareStatement(strSql);
	            ps.setString(1,user_id);
	            rs = ps.executeQuery();
	            if(rs.next())
	            {    
	            	card_number=rs.getString(1);
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
	            return card_number;
	        }
		return card_number;
	}
    public static boolean changeUser(CardInfoBean CardInfoBean){
    	System.out.println("修改用户中~~");
    	con = DbPool.getConnection();
		 int rs;
		 	String strSql = "update user_message set "
	        		+ "card_number= "     		+setValue(CardInfoBean.card_number) 
	        		+ " where user_name=" 	+ setValue(CardInfoBean.user_account)
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
    public static boolean addCard(CardInfoBean CardInfoBean){
    	System.out.println("添加IC卡中~~");
    	con = DbPool.getConnection();
		 int rs;
	        String strSql = "INSERT INTO card_message "
	        		+ "(card_number,	user_name,		remaining_sum,		consumption,		status)  values "+"("
	        		+  			  setValue(CardInfoBean.card_number)
	        		+ ", "   	+ setValue(CardInfoBean.user_account) 
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
    public static boolean addCardM(PaidInfoBean paidInfoBean){ //添加消费总额和余额
    	System.out.println("添加IC卡余额中~~");
    	
		 	float res;
		 	String s="";
	        String Sql = "SELECT remaining_sum FROM card_message where card_number=(select card_number from user_message where user_id="+setValue(paidInfoBean.user_id)+");";
	  
	        try
	        {	
	        	con = DbPool.getConnection();
	            ps = con.prepareStatement(Sql);
	            System.out.println(Sql);
	            rs = ps.executeQuery();
	            if(rs.next())
	            {    
		            s=clearNullString(rs.getString("remaining_sum"));
		            System.out.println(s+" "+paidInfoBean.paid_amount);
		            res=Float.parseFloat(s)+Float.parseFloat(paidInfoBean.paid_amount);
		            s=String.valueOf(res);
	            }
	            DbPool.DBClose(con, ps, rs);  
	        }catch(Exception e)
	        {
	            e.printStackTrace();
	            System.out.println("计算余额出错!");
	            return false;
	        }
		 	String strSql = "update card_message set remaining_sum = "+setValue(s)
		 					+" where card_number=(select card_number from user_message where user_id="+setValue(paidInfoBean.user_id)+");";
	        int cs;
	        try
	        {
	        	con = DbPool.getConnection();
	            ps = con.prepareStatement(strSql);
	            System.out.println(strSql);
	            cs = ps.executeUpdate();
	            DbPool.DBClose(con, ps);   
	        }catch(Exception e)
	        {
	            e.printStackTrace();
	            System.out.println("更新余额出错!");
	            return false;
	        }
	        if (cs<1) return false;
	        return true;
    }
    public static boolean addPaidInfoAndMoney(PaidInfoBean paidInfoBean){
    	return addPaidInfo(paidInfoBean)&&addCardM(paidInfoBean);
    }
    public static boolean addPaidInfo(PaidInfoBean paidInfoBean){
    	System.out.println("添加支付信息中~~");
    	con = DbPool.getConnection();  
    	Date dNow = new Date( );
		   SimpleDateFormat ft = 
		   new SimpleDateFormat ("yyyy-MM-dd HH:mm:ss");
		 int rs;
	        String strSql = "INSERT INTO paid_record "    
	        		+ "(user_id,	order_record_id,		paid_amount,		paid_reason,		paid_time)  values "+"("
	        		+  			  setValue(paidInfoBean.user_id)
	        		+ ", "   	+ setValue(paidInfoBean.order_record_id) 
	        		+ ", " 		+ setValue(paidInfoBean.paid_amount)
	        		+ ", " 		+ setValue(paidInfoBean.paid_reason)
	        		+ ", " 		+ setValue(ft.format(dNow)) +");"; //添加充值信息
	        System.out.println(strSql);
	        try
	        {
	            ps = con.prepareStatement(strSql);
	            System.out.println(strSql);
	            rs = ps.executeUpdate();
	        }catch(Exception e)
	        {
	            e.printStackTrace();
	            System.out.println("插入支付记录出错!");
	            return false;
	        }
	        DbPool.DBClose(con, ps);   
	        if(rs<1)
	        	return false;
	        else 
	        	return true;
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
    public static boolean addSum(String num){//挂失
    	con = DbPool.getConnection();
        String strSql = "update card_message set status=\"异常\" where card_number=?;";
        int rs;
        try
        {
            ps = con.prepareStatement(strSql);
            ps.setString(1,num);
            rs = ps.executeUpdate();
       
        }catch(Exception e)
        {
            e.printStackTrace();
            System.out.println("挂失出错!");
            return false;
        }
        if (rs<1) return false;
        else return true;
    }
    public static boolean cardW(String num){//挂失
    	con = DbPool.getConnection();
        String strSql = "update card_message set status=\"异常\" where card_number=?;";
        int rs;
        try
        {
            ps = con.prepareStatement(strSql);
            ps.setString(1,num);
            rs = ps.executeUpdate();
       
        }catch(Exception e)
        {
            e.printStackTrace();
            System.out.println("挂失出错!");
            return false;
        }
        if (rs<1) return false;
        else return true;
    }
    public static boolean cardWByUserID(String user_id){//挂失
    	con = DbPool.getConnection();
        String strSql = "update card_message set status=\"异常\" where card_number=(select card_number from user_message where user_id=?);";
        int rs;
        try
        {
            ps = con.prepareStatement(strSql);
            ps.setString(1,user_id);
            rs = ps.executeUpdate();
       
        }catch(Exception e)
        {
            e.printStackTrace();
            System.out.println("挂失出错!");
            return false;
        }
        if (rs<1) return false;
        else return true;
    }
    public static boolean cardR(String num){//解除挂失
    	con = DbPool.getConnection();
        String strSql = "update card_message set status=\"正常\" where card_number=?;";
        System.out.println(strSql+num);
        
        int rs;
        try
        {
            ps = con.prepareStatement(strSql);
            ps.setString(1,num);
            
            rs = ps.executeUpdate();
       
        }catch(Exception e)
        {
            e.printStackTrace();
            System.out.println("解除挂失出错!");
            return false;
        }
        if (rs<1) return false;
        else return true;
    }
    public static PaidInfoBean getPaidInfo(String order_id){
    	PaidInfoBean paidInfoBean=null;
    	con = DbPool.getConnection();
        String strSql = "select * from paid_record where order_record_id=?;";
        try {
            ps = con.prepareStatement(strSql);
            ps.setString(1, order_id);
			rs = ps.executeQuery();
			if(rs.next()){
				paidInfoBean=new PaidInfoBean();
				paidInfoBean.user_id=rs.getString("user_id");
				paidInfoBean.order_record_id=rs.getString("order_record_id");
				paidInfoBean.paid_amount=rs.getString("paid_amount");
				paidInfoBean.paid_reason=rs.getString("paid_reason");
				paidInfoBean.paid_record_id=rs.getString("paid_record_id");
				paidInfoBean.paid_time=rs.getString("paid_time");
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
    	return paidInfoBean;
    }
    public static boolean addPaidInfo(EquipInfoBean equipInfoBean,String order_id,String user_id,float v){  //预约
    	System.out.println("添加支付信息中~~");
    	con = DbPool.getConnection();        
		 int rs;
		   Date dNow = new Date( );
		   SimpleDateFormat ft = 
		   new SimpleDateFormat ("yyyy-MM-dd HH:mm:ss");
	        String strSql = "INSERT INTO paid_record "    
	        		+ "(user_id,	order_record_id,		paid_amount,		paid_reason,		paid_time)  values "+"("
	        		+  			  setValue(user_id)
	        		+ ", "   	+ setValue(order_id)
	        		+ ", " 		+ setValue(String.valueOf(v))
	        		+ ", " 		+ setValue("预约设备:"+equipInfoBean.equip_name+"预付款")
	        		+ ", " 		+ setValue(ft.format(dNow)) +");"; //添加充值信息
	        System.out.println(strSql);
	        try
	        {
	            ps = con.prepareStatement(strSql);
	            System.out.println(strSql);
	            rs = ps.executeUpdate();
	        }catch(Exception e)
	        {
	            e.printStackTrace();
	            System.out.println("插入充值记录出错!");
	            return false;
	        }
	        DbPool.DBClose(con, ps);   
	        if(rs<1)
	        	return false;
	        else 
	        	return true;
    }
    public static boolean setM(String user_id , float v){				
    	con = DbPool.getConnection();
    	String s=String.valueOf(v);
        String strSql = "update card_message set remaining_sum="+setValue(s)+" where card_number=(select card_number from user_message where user_id=?);";
        System.out.println(strSql+user_id+v);
        
        int rs;
        try
        {
            ps = con.prepareStatement(strSql);
            ps.setString(1,user_id);
            
            rs = ps.executeUpdate();
       
        }catch(Exception e)
        {
            e.printStackTrace();
            System.out.println("扣除余额出错!");
            return false;
        }
        if (rs<1) return false;
        else return true;
    }
    public static boolean setC(String user_id , float v){			//修改消费记录	
    	con = DbPool.getConnection();
    	String s=String.valueOf(v);
        String strSql = "update card_message set consumption="+setValue(s)+" where card_number=(select card_number from user_message where user_id=?);";
        System.out.println(strSql+user_id+v);
        int rs;
        try
        {
            ps = con.prepareStatement(strSql);
            ps.setString(1,user_id);
            rs = ps.executeUpdate();
       
        }catch(Exception e)
        {
            e.printStackTrace();
            System.out.println("修改消费记录出错!");
            return false;
        }
        if (rs<1) return false;
        else return true;
    }
    public static float getComsuptionByUser(String user_id){
    	con = DbPool.getConnection();
        String strSql = "SELECT consumption from card_message  where card_number=(select card_number from user_message where user_id=?);";
      
        try
        {
            ps = con.prepareStatement(strSql);
            ps.setString(1,user_id);
            rs = ps.executeQuery();
			if(rs.next()){
				String s=rs.getString("consumption");
				return Float.parseFloat(s);
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
    	return 0;
    }
}
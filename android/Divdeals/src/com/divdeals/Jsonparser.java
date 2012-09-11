package com.divdeals;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.util.ArrayList;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;

public class Jsonparser {
	
	public static ArrayList<Dealinfo> getdeals(Context con, String c_name)
	{
		ArrayList<Dealinfo> all_deals = new ArrayList<Dealinfo>();
		String result = getResponseFromUrl("http://api.yipit.com/v1/deals/?key=jmqgADVW3gtdYTr4&division="+c_name);
		

    	if(result!="")
    	{
    	try{
    		JSONObject json_result = new JSONObject(result);
    		
    		if(json_result.has("response"))
    		{
    				
    			System.out.println("got response 1===========");
    			//JSONObject json_deal=new JSONObject("deals");
    			JSONObject json_response = json_result.getJSONObject("response");
    			
    			//System.out.println("got response==========="+json_response);
    			JSONArray deal_arr = json_response.getJSONArray("deals");
    			
    			for(int i=0;i<deal_arr.length();i++)
    			 {  
    				Dealinfo df = new Dealinfo();
    				
    				
    				JSONObject jObj = deal_arr.getJSONObject(i);
    				String active = getkeyValue_Str(jObj,"active");
    				
    				String date_added = getkeyValue_Str(jObj,"date_added");
    				String end_date = getkeyValue_Str(jObj,"end_date");
    				String id_deal = getkeyValue_Str(jObj,"id");
    				String mobile_url = getkeyValue_Str(jObj,"mobile_url");
    				String title = getkeyValue_Str(jObj,"title");
    				String url = getkeyValue_Str(jObj,"url");
    				String yipit_title = getkeyValue_Str(jObj,"yipit_title");
    				String yipit_url = getkeyValue_Str(jObj,"yipit_url");
    				
    				df.active = active;
    				df.date_added=date_added;
    				df.end_date=end_date;
    				df.id_deal=id_deal;
    				df.mobile_url=mobile_url;
    				df.title=title;
    				df.url=url;
    				df.yipit_title=yipit_title;
    				df.yipit_url=yipit_url;
    				System.out.println("urllllll+++++====+"+yipit_title);
    				
    				if(jObj.has("business"))
    				{
    					
        				
    					JSONObject json_business = jObj.getJSONObject("business");
    					String id_business = getkeyValue_Str(json_business,"id");
    					String name = getkeyValue_Str(json_business,"name");
        				String url_business = getkeyValue_Str(json_business,"url");
    					
        				df.id_business=id_business;
        				df.name=name;
        				df.url_business=url_business;
    					//System.out.println("id====="+id);
    					//System.out.println("name====="+name);
    					//System.out.println("url====="+url);
    					
    					JSONArray location_arr = json_business.getJSONArray("locations");
    					for(int j=0;j<location_arr.length();j++)
    					{
    						JSONObject jObj_loc = location_arr.getJSONObject(j);
    						String address_loc = getkeyValue_Str(jObj_loc,"address");
    						String id_loc = getkeyValue_Str(jObj_loc,"id");
    						String lat_loc = getkeyValue_Str(jObj_loc,"lat");
    						String locality_loc = getkeyValue_Str(jObj_loc,"locality");
    						String lon_loc = getkeyValue_Str(jObj_loc,"lon");
    						String phone_loc = getkeyValue_Str(jObj_loc,"phone");
    						String smart_locality_loc = getkeyValue_Str(jObj_loc,"smart_locality");
    						String state_loc = getkeyValue_Str(jObj_loc,"state");
    						String zip_code_loc = getkeyValue_Str(jObj_loc,"zip_code");
    						
    						df.address_loc=address_loc;
    						df.id_loc=id_loc;
    						df.lat_loc=lat_loc;
    						df.locality_loc=locality_loc;
    						df.lon_loc=lon_loc;
    						df.phone_loc=phone_loc;
    						df.smart_locality_loc=smart_locality_loc;
    						df.state_loc=state_loc;
    						df.zip_code_loc=zip_code_loc;
    						
    						//System.out.println("id_loc====="+id_loc);
    						//System.out.println("add_loc====="+address_loc);
    						
    						
    					}
    					
    					
    				}
    				
    				if(jObj.has("discount"))
    				{
    					JSONObject json_discount = jObj.getJSONObject("discount");
    					String dis_formated = getkeyValue_Str(json_discount,"formatted");
    					String dis_raw = getkeyValue_Str(json_discount,"raw");
    					
    					df.dis_formated=dis_formated;
    					df.dis_raw=dis_raw;
    					//System.out.println("discount====="+dis_formated);
    				}
    				
    				if(jObj.has("division"))
    				{
    					JSONObject json_division = jObj.getJSONObject("division");
    					String div_active = getkeyValue_Str(json_division,"active");
    					String div_lat = getkeyValue_Str(json_division,"lat");
    					String div_lon = getkeyValue_Str(json_division,"lon");
    					String div_name = getkeyValue_Str(json_division,"name");
    					String div_slug = getkeyValue_Str(json_division,"slug");
    					String div_stimezone_diff = getkeyValue_Str(json_division,"time_zone_diff");
    					String div_url = getkeyValue_Str(json_division,"url");
    					
    					df.div_active=div_active;
    					df.div_lat=div_lat;
    					df.div_lon=div_lon;
    					df.div_name=div_name;
    					df.div_slug=div_slug;
    					df.div_stimezone_diff=div_stimezone_diff;
    					df.div_url=div_url;
        				
    					//System.out.println("name====="+div_name);
    				}
    				
    				if(jObj.has("images"))
    				{
    					JSONObject json_images = jObj.getJSONObject("images");
    					String img_big = getkeyValue_Str(json_images,"image_big");
    					String img_small = getkeyValue_Str(json_images,"image_small");
    					
    					//byte[] img_small1=getkeyValue_img( img_small);
    					//byte[] img_big1=getkeyValue_img( img_big);
    				    
    					df.path_big=img_big;
    					df.path_small=img_small;
    					
    					//df.img_big=img_big1;
    					//df.img_small=img_small1;
    					System.out.println("IMAGE====="+img_small);
    				}
    				
    				if(jObj.has("price"))
    				{
    					JSONObject json_price = jObj.getJSONObject("price");
    					String price_formatated = getkeyValue_Str(json_price,"formatted");
    					String price_raw = getkeyValue_Str(json_price,"raw");
    					
    					df.price_formatated=price_formatated;
    					df.price_raw=price_raw;
    					//System.out.println("discount====="+dis_formated);
    				}
    				
    				if(jObj.has("source"))
    				{
    					JSONObject json_source = jObj.getJSONObject("source");
    					String source_name = getkeyValue_Str(json_source,"name");
    					String source_paid = getkeyValue_Str(json_source,"paid");
    					String source_slug = getkeyValue_Str(json_source,"slug");
    					String source_url = getkeyValue_Str(json_source,"url");
    					
    					df.source_name=source_name;
    					df.source_paid=source_paid;
    					df.source_slug=source_slug;
    					df.source_url=source_url;
    					//System.out.println("discount====="+dis_formated);
    					
        				
    				}
    				
    				if(jObj.has("value"))
    				{
    					JSONObject json_value = jObj.getJSONObject("value");
    					String value_formated = getkeyValue_Str(json_value,"formatted");
    					String value_raw = getkeyValue_Str(json_value,"raw");
    					
    					df.value_formated=value_formated;
    					df.value_raw=value_raw;
    					//System.out.println("discount====="+dis_formated);
    				}
    				
    				if(jObj.has("tags"))
    				{
    					JSONArray tags_arr = jObj.getJSONArray("tags");
    					for(int j=0;j<tags_arr.length();j++)
    					{
    						JSONObject jObj_tags = tags_arr.getJSONObject(j);
    						String tag_name = getkeyValue_Str(jObj_tags,"name");
    						String tag_slug = getkeyValue_Str(jObj_tags,"slug");
    						String tag_url = getkeyValue_Str(jObj_tags,"url");
    						
    						df.tag_name=tag_name;
    						df.tag_slug=tag_slug;
    						df.tag_url=tag_url;
            				
    						System.out.println("tag name====="+tag_name);
    					}
    					
    				}
    				
    				all_deals.add(df);
    				
    			
    			}
    			
    			
    		}
    		
    		System.out.println("in get deals");
    		return all_deals;
    		
    		
    	}
    	catch (Exception e) {
			// TODO: handle exception
    		return null;
		}
	}
		return null;
		
	}

	private static byte[] getkeyValue_img( String string) {
		// TODO Auto-generated method stub
		try
	    {
	    InputStream is = (InputStream) new URL(string).getContent();
	    //Drawable d = Drawable.createFromStream(is, "src name");
	    byte[] buffer = new byte[8192];
	    int bytesRead;
	    ByteArrayOutputStream output = new ByteArrayOutputStream();
	    while ((bytesRead = is.read(buffer)) != -1)
	    {
	        output.write(buffer, 0, bytesRead);
	    }
	    return output.toByteArray();
	    
	    }catch (Exception e) {
	    System.out.println("Exc="+e);
	    return null;
	    
	    }
		
	}

	private static String getkeyValue_Str(JSONObject jo, String tag) {
		String key_value = "";
		
		if(jo.has(tag))
		{
			try {
				key_value = jo.getString(tag);
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		return key_value;
	}

	public static String getResponseFromUrl(String url) {
    	 
    	System.out.println("hello world++++++++++url="+url);
    	
    	String result = null ;
    	
        // Making HTTP request
        try {
        	
            DefaultHttpClient httpClient = new DefaultHttpClient();
            
            HttpGet httpPost = new HttpGet(url);
           
            HttpResponse httpResponse = httpClient.execute(httpPost);
            System.out.println("hello http++++++++++result="+result);
            HttpEntity httpEntity = httpResponse.getEntity();
            
            result = EntityUtils.toString(httpEntity);
            
            
            
            
            
            
            return result ;
            
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
            return null;
        } catch (ClientProtocolException e) {
            e.printStackTrace();
            return null;
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }
}

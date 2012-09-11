package com.divdeals;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.net.URL;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.Parcelable;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.SimpleOnPageChangeListener;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ArrayAdapter;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

public class MainActivity extends Activity {
	protected Activity mActivity,mContext;
	private EfficientAdapter ea;
	private ListView lv;
	private TextView txt_name,detail_dealname,detail_price,detail_discount,detail_dayleft,address,business_name;
	private static ArrayList<Dealinfo> mall_rows;
	private ProgressDialog mDialog;
	private static Drawable img;
	private ViewPager myPager;
	private ImageView facebook,twitter,tellafriend;
	private Date date1,date2;
	private MyPagerAdapter adapter;
	private ImageView image;
	PageListener pageListener ;
	 
	private int currentPage = 0 ;
	private String c_name;
	final String[] Countriesname = new String[] { "New York", "Los Angeles",
			"Chicago", "Boston", "San Diego", "San Francisco", "Atlanta",
			"Washington DC", "Seattle", "Toronto", "Houston", "Miami",
			"Denver",

			"Dallas", "Phoenix", "Philadelphia", "Las Vegas", "Orange County",
			"Portland", "Minneapolis", "Austin", "San Jose", "Orlando",
			"Vancouver", "St. Louis", "Kansas City", "Milwaukee", "Cincinnati",
			"Indianapolis", "Nashville", "Montreal", "Baltimore", "Sacramento",
			"Salt Lake City", "Fort Lauderdale", "San Antonio", "Pittsburgh",
			"Raleigh Durham", "North Jersey", "New Orleans",
			"Tampa / St. Petersburg", "Cleveland", "Detroit", "Palm Beach",
			"Charlotte", "Oakland", "Columbus", "Calgary", "Edmonton", "Ottawa"

	};
	final String[] Countriesname_link = new String[] { "new-york", "los-angeles",
			"chicago", "boston", "san-diego", "san-francisco", "atlanta",
			"washington-dc", "seattle", "toronto", "houston", "miami",
			"denver", "dallas", "phoenix", "philadelphia", "las-vegas",
			"orange-county", "portland", "minneapolis", "austin", "san-jose",
			"orlando", "vancouver", "st-louis", "kansas-city", "milwaukee",
			"cincinnati", "indianapolis", "nashville", "montreal", "baltimore",
			"sacramento", "salt-lake-city", "fort-lauderdale", "san-antonio",
			"pittsburgh", "raleigh-durham", "rorth-jersey", "new-orleans",
			"tampa-st-petersburg", "cleveland", "detroit", "palm-beach",
			"charlotte", "oakland", "columbus", "calgary", "edmonton", "ottawa"};
	
	private com.divdeals.MainActivity.ThreadPreLoader task;
	private Handler handler = new Handler(Looper.getMainLooper());
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.viewpager);
        
        Bundle b = getIntent().getExtras();
		
		if(b!=null)
		{
			c_name=b.getString("country");
			System.out.println("bundle+++==+"+c_name);
			
		}
		
        mActivity = this;
		mContext = this;
         adapter = new MyPagerAdapter();
         myPager = (ViewPager) findViewById(R.id.threepanelpager);
        myPager.setAdapter(adapter);
         myPager.setCurrentItem(0);
         
         
         myPager.setOffscreenPageLimit(3);
         
         
        pageListener = new PageListener();
        myPager.setOnPageChangeListener(pageListener);
    
        task = new ThreadPreLoader(MainActivity.this);
		task.execute();
		handler = new Handler(Looper.getMainLooper());
		
		
        
   
        
        
    }

    
    private static class EfficientAdapter extends BaseAdapter {

	    private LayoutInflater mInflater;
	    public ImageLoader imageLoader;
	    public Activity activity;

	    public EfficientAdapter(Context context,Activity a) {
	    	activity=a;
	        mInflater = LayoutInflater.from(context);
	        imageLoader=new ImageLoader(context.getApplicationContext());
	      
	    }

	    public int getCount() {
			
	    return mall_rows.size();
	    }

	    public Object getItem(int position) {
	    return position;
	    }

	    public long getItemId(int position) {
	    return position;
	    }

	    public View getView(int position, View convertView, ViewGroup parent) {
	    ViewHolder holder;
	    //System.out.println("====="+position+"====="+convertView+"======"+parent);
	    if (convertView == null) {
	    convertView = mInflater.inflate(R.layout.deals_custom, null);
	    
	    holder = new ViewHolder();
	    holder.title_img = (ImageView) convertView.findViewById(R.id.list_img);
	    holder.title_name = (TextView) convertView.findViewById(R.id.list_name);
	    

	    convertView.setTag(holder);
	    System.out.println("sumit+++"+holder);
	    } 
	    else {
	        holder = (ViewHolder) convertView.getTag();
	        System.out.println("sumit123+++"+holder);
	    }
	    
	    //System.out.println("+++"+position);
	   
	    System.out.println("array list imgggg====="+mall_rows.get(position).path_small);
	    if (mall_rows.get(position).path_small != null) {
	    	
//	    	byte[] logo_img = mall_rows.get(position).img_small;
//	    	ByteArrayInputStream imageStream = new ByteArrayInputStream(
//					logo_img);
//			Drawable theImage = Drawable.createFromStream(imageStream, "src");
//			holder.title_img.setBackgroundDrawable(theImage);
			
//			Bitmap theImage = BitmapFactory.decodeStream(imageStream);
//			holder.title_img.setImageBitmap(theImage);
	    	
	    	
	    	holder.title_img.setTag(mall_rows.get(position));
	        imageLoader.DisplayImage(mall_rows.get(position).path_small, activity, holder.title_img);
	    	
	    } else{
			holder.title_img.setBackgroundResource(R.drawable.logo_new);
		}
	    
	   	 holder.title_name.setText(mall_rows.get(position).title);
	         
	         
	    
	    
	    

	    return convertView ;
	    
	    }

	    static class ViewHolder {
	    	ImageView title_img;
	    	TextView title_name;
	        
	    }
	}
    
    private static Drawable LoadImageFromWebOperations(String url)
    {
    try
    {
    InputStream is = (InputStream) new URL(url).getContent();
    Drawable d = Drawable.createFromStream(is, "src name");
    return d;
    }catch (Exception e) {
    System.out.println("Exc="+e);
    return null;
    }
    }
    
    public class ThreadPreLoader extends AsyncTask<Object, String, Void> {

		private Activity mActivity;

		public ThreadPreLoader(Activity activity) {
			mActivity = activity;
		}

		protected void onPreExecute() {
			mDialog = new ProgressDialog(mActivity);
			mDialog.setMessage("Loading Please Wait....");
			mDialog.show();
		}

		protected Void doInBackground(Object... args) {
			if (getMessagelist()) {
				this.onPostExecute();
			}
			return null;
		}

		protected void onProgressUpdate1(String msg) {

			mDialog.setMessage(msg);
		}

		protected void onPostExecute() {
			updatecontent();
			// mDialog.dismiss();
		}
	}
    
   public boolean getMessagelist()
    {
    	mall_rows = Jsonparser.getdeals(this,c_name);
    	
    	
		return true;
    }
   private void updatecontent() {
		handler.post(new Runnable() {

			public void run() {
				// TODO Auto-generated method stub
				
				final ImageLoader imageLoader1=new ImageLoader(MainActivity.this);
			    Activity activity;
				try {

			    	lv = (ListView) findViewById(R.id.list_divdeals);
					txt_name=(TextView)findViewById(R.id.txt1);
					
					ea = new EfficientAdapter(MainActivity.this,MainActivity.this);

				    lv.setAdapter(ea);
					lv.setOnItemClickListener(new OnItemClickListener() {

						@Override
						public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
								long arg3) {
							// TODO Auto-generated method stub
							
							
					        myPager.setCurrentItem(1);
					        int position=arg2;
					        //Toast.makeText(getBaseContext(),"clicked=="+position, Toast.LENGTH_SHORT).show();
					        
					        image=(ImageView)findViewById(R.id.img_big);
					        detail_dealname=(TextView)findViewById(R.id.txt_dealname);
					        detail_price=(TextView)findViewById(R.id.txt_price);
					        detail_discount=(TextView)findViewById(R.id.txt_discount);
					        detail_dayleft=(TextView)findViewById(R.id.txt_dayleft);
					        business_name=(TextView)findViewById(R.id.txt_placename);
					        address=(TextView)findViewById(R.id.txt_address);
					        
					          
					        String str_date1 = mall_rows.get(position).date_added;
					        String str_time1 = "11:00 AM";

					        String str_date2 = mall_rows.get(position).end_date;
					        String str_time2 = "12:15 AM" ;

					        DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
					         try {
								date1 = formatter.parse(str_date1);
							} catch (ParseException e) {
								// TODO Auto-generated catch blocks
								e.printStackTrace();
							}
					         try {
								date2 = formatter.parse(str_date2);
							} catch (ParseException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}

					        // Get msec from each, and subtract.
					        long diff = date2.getTime() - date1.getTime();

					        System.out.println("Difference In Days: " + (diff / (1000 * 60 * 60 * 24)));  
					         
					        
					        
					    	
					    	
					    	 if (mall_rows.get(position).path_big != null) {
					    		 
					    		 try
					    		 {
					    			 imageLoader1.DisplayImage(mall_rows.get(position).path_big, MainActivity.this,image);
					    		 }
					    		 catch (Exception e) {
										// TODO: handle exception
						    			 System.out.println("thread===="+e);
						    			 image.setBackgroundResource(R.drawable.ic_launcher);
									}
					 	    } else{
					 			image.setBackgroundResource(R.drawable.ic_launcher);
					 		}
					    	 
							//image.setBackgroundDrawable(theImage);
							detail_dealname.setText(mall_rows.get(position).yipit_title);
							detail_price.setText(mall_rows.get(position).price_formatated);
							detail_discount.setText((mall_rows.get(position).dis_formated)+" OFF");
							detail_dayleft.setText((diff / (1000 * 60 * 60 * 24))+" Days left");
							business_name.setText(mall_rows.get(position).name);
							address.setText(mall_rows.get(position).address_loc);
							
					    
						}
					});
					
			    	mDialog.dismiss();
					
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		});
	}

   
   private class MyPagerAdapter extends PagerAdapter implements OnClickListener {

       public int getCount() {
               return 3;
       }

       public Object instantiateItem(View collection, int position) {

    	   
    	    LayoutInflater mInflater = null;
			
			View convertView = null ;
    	   
//               LayoutInflater inflater = (LayoutInflater) collection.getContext()
//                               .getSystemService(Context.LAYOUT_INFLATER_SERVICE);

               //int resId = 0;
               switch (position) {
               case 0:
                      // resId = R.layout.activity_main;
            	   mInflater = LayoutInflater.from(mContext);
   				   convertView = mInflater.inflate(R.layout.activity_main, null);
   				   
 
   				   
   				
                       break;
               case 1:
                    //   resId = R.layout.details;
            	      mInflater = LayoutInflater.from(mContext);
   				     convertView = mInflater.inflate(R.layout.details, null);
   				     
   				  facebook=(ImageView)convertView.findViewById(R.id.img_facebook);
			        twitter=(ImageView)convertView.findViewById(R.id.img_twitter);
			        tellafriend=(ImageView)convertView.findViewById(R.id.img_tell);
			        
			        facebook.setOnClickListener(this);
			        twitter.setOnClickListener(this);
			        tellafriend.setOnClickListener(this);
                       break;
               case 2:
                      // resId = R.layout.countries;
            	       mInflater = LayoutInflater.from(mContext);
   				       convertView = mInflater.inflate(R.layout.countries, null);
   				   

   				       
   				    ListView lv1 = (ListView)convertView.findViewById(R.id.list_countries);

   				 lv1.setAdapter(new ArrayAdapter<String>(MainActivity.this,android.R.layout.simple_list_item_1,Countriesname));
   				 lv1.setOnItemClickListener(new OnItemClickListener() {

					@Override
					public void onItemClick(AdapterView<?> arg0, View arg1,
							int position, long arg3) {
						// TODO Auto-generated method stub
						Intent intent = new Intent(MainActivity.this,MainActivity.class);
						Bundle b = new Bundle();
						b.putString("country", Countriesname_link[position]);
						intent.putExtras(b);
						startActivity(intent);
						
					}
				});
   				  
   				 

                       break;
               
               }

//               View view = inflater.inflate(resId, null);
//
//               ((ViewPager) collection).addView(view, 0);
//
//               return view;
                 ((ViewPager) collection).addView(convertView);
				
   			     return convertView ;
       }

       @Override
       public void destroyItem(View arg0, int arg1, Object arg2) {
               ((ViewPager) arg0).removeView((View) arg2);

       }

       @Override
       public void finishUpdate(View arg0) {
               // TODO Auto-generated method st

       }

       @Override
       public boolean isViewFromObject(View arg0, Object arg1) {
               return arg0 == ((View) arg1);
               

       }

       @Override
       public void restoreState(Parcelable arg0, ClassLoader arg1) {
               // TODO Auto-generated method stub

       }

       @Override
       public Parcelable saveState() {
               // TODO Auto-generated method stub
               return null;
       }

       @Override
       public void startUpdate(View arg0) {
               // TODO Auto-generated method stub

       }

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		if(v==facebook)
		{
			Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse("https://facebook.com/Euro2012game"));
			startActivity(browserIntent);
		}
		
		if(v==twitter)
		{
			Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse("https://twitter.com/Euro2012game"));
			startActivity(browserIntent);
		}
		
		if(v==tellafriend)
		{
			final Intent emailIntent = new Intent(android.content.Intent.ACTION_CHOOSER);
			emailIntent.setAction(Intent.ACTION_SEND);
		    emailIntent.setType("text/plain");
		    
		    emailIntent.putExtra(android.content.Intent.EXTRA_EMAIL, new String[]{""});
		    emailIntent.putExtra(android.content.Intent.EXTRA_SUBJECT, "Check out the Yipit deals");
		    emailIntent.putExtra(android.content.Intent.EXTRA_TEXT, "This is a cool Android App,I found. Check it out "); 

		    startActivity(Intent.createChooser(emailIntent, "Send mail..."));
		}
	}

    }
	private class PageListener extends SimpleOnPageChangeListener {
        
		public void onPageSelected(int position) {
				        	
        	currentPage = position ;
        		
		}
   	}
	
	public static long daysBetween(Calendar startDate, Calendar endDate) {  
		  Calendar date = (Calendar) startDate.clone();  
		  long daysBetween = 0;  
		  while (date.before(endDate)) {  
		    date.add(Calendar.DAY_OF_MONTH, 1);  
		    daysBetween++;  
		  }  
		  return daysBetween;  
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
}

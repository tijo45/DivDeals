package com.divdeals;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ArrayAdapter;
import android.widget.ListView;

public class Launchlist extends Activity {

	final String[] Countries = new String[] { "New York", "Los Angeles",
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
	final String[] Countries_link = new String[] { "new-york", "los-angeles",
			"chicago", "boston", "san-diego", "san-francisco", "atlanta",
			"washington-dc", "seattle", "toronto", "houston", "miami",
			"denver", "dallas", "phoenix", "philadelphia", "las-vegas",
			"orange-county", "portland", "minneapolis", "austin", "san-jose",
			"orlando", "vancouver", "st-louis", "kansas-city", "milwaukee",
			"cincinnati", "indianapolis", "nashville", "montreal", "baltimore",
			"sacramento", "salt-lake-city", "fort-lauderdale", "san-antonio",
			"pittsburgh", "raleigh-durham", "north-jersey", "new-orleans",
			"tampa-st-petersburg", "cleveland", "detroit", "palm-beach",
			"charlotte", "oakland", "columbus", "calgary", "edmonton", "ottawa" };

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);

		ListView lv = (ListView) findViewById(R.id.list_divdeals);

		lv.setAdapter(new ArrayAdapter<String>(this,
				android.R.layout.simple_list_item_1, Countries));

		System.out.println("size of array====" + Countries.length);
		int size = Countries.length;

		lv.setOnItemClickListener(new OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> parent, View view,
					int position, long id) {
				
				Intent intent = new Intent(Launchlist.this,MainActivity.class);
				Bundle b = new Bundle();
				b.putString("country", Countries_link[position]);
				intent.putExtras(b);
				startActivity(intent);

			}
		});

	}

}
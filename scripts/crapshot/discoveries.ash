import <_types>

string [5] discoveryTypes;
discoveryTypes[0] = "cook";
discoveryTypes[1] = "cocktail";
discoveryTypes[2] = "combine";
discoveryTypes[3] = "smith";
discoveryTypes[4] = "multi";

boolean regCheck(string html, string checkthis) {
	checkthis = replace_string(checkthis, "+", "\\+");
	checkthis = replace_string(checkthis, "(0)", "\\(([0-9]+)\\)");
	checkthis = replace_string(checkthis, "</b>", "(</a>){0,1}</b>");
	checkthis = replace_string(checkthis, "</b> <font", "</b>(\\s){0,1}<font");
	checkthis = replace_string(checkthis, "<font size=1>", "<font size=1>(?:<font size=2>\\[<a href=\"craft.php\\?mode=\\w+&a=\\d+&b=\\d+\">\\w+</a>\\]</font>)?");

	matcher reg = create_matcher(checkthis, html);
	return reg.find();
}

boolean discoveryCheck(string html, ItemImage thing) {
	if(thing.gifname != "none") return regCheck(html, thing.gifname);
	return (index_of(html, ">"+thing.itemname+"<") != -1);
}

string visit_discoveries(string url) {
	matcher reg = create_matcher("<font size=2>.*?</font>", visit_url(url));
	return replace_all(reg, "");
}

string generateDiscoveriesSnapshot() {
  string r = "";
  ItemImage [int] map;

	foreach y in discoveryTypes {
		string d = discoveryTypes[y];
		string rd = "";

		string html = visit_discoveries("craft.php?mode=discoveries&what=" + d);
		file_to_map("crapshot_dis_" + d + ".txt", map);

		foreach x in map {
			boolean answer = discoveryCheck(html, map[x]);
			rd += (answer ? "1" : "") + "|";
		}

		r += "&discoveries[" + d + "]=" + rd;
	}

  return r.substring(1);
}

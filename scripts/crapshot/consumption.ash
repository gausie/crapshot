import <_types>

string [2] consumptionTypes;
consumptionTypes[0] = "food";
consumptionTypes[1] = "booze";

boolean consumptionCheck(string html, string name) {
	name = name.to_lower_case().replace_string("(", "\\(").replace_string(")", "\\)");
	matcher m = create_matcher(">\\s*" + name + "(?:\\s*)</a>", to_lower_case(html));
	return find(m);
}

string generateConsumptionSnapshot() {
  string r;
  ItemImage [int] map;

	string html = visit_url("showconsumption.php");

	foreach y in consumptionTypes {
    string c = consumptionTypes[y];
		file_to_map("crapshot_con_" + c + ".txt", map);
		string rc = "";

		foreach x in map {
			boolean answer = consumptionCheck(html, map[x].itemname);
			rc += (answer ? "1" : "") + "|";
		}

		r += "&consumption[" + c + "]=" + rc;
	}

  return r.substring(1);
}

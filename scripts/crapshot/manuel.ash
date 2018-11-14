import <_types>

string [3] manuelTypes;
manuelTypes[0] = "casually";
manuelTypes[1] = "thoroughly";
manuelTypes[2] = "exhaustively";

string generateManuelSnapshot() {
  string r = "";

  string html = visit_url("questlog.php?which=6&vl=a");
	if(!contains_text(html, "Monster Manuel")) return r;

  foreach y in manuelTypes {
    string t = manuelTypes[y];
		matcher m = create_matcher(t + "(?:.*?)([0-9]+) creature(s?)[.]", html);
		if(find(m)) r+= group(m,1);
    r += "";
	}

  return "manuel=" + r;
}

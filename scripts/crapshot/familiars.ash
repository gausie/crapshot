import <_types>
import <_utils>

int familiarCheck(string familiarsHtml, string ascensionsHtml, ItemImage fam) {
	debug("Looking for familiar: " + fam.itemname);
	if(familiarsHtml.index_of("the " + fam.itemname + "</td>") > 0) {
		matcher m = create_matcher("alt=\"" + fam.itemname + " .([0-9.]+)..", ascensionsHtml);
		int percent = 0;
		while(find(m)) {
			string percentMatch = group(m, 1);
			percent = max(percent, percentMatch.to_int());
		}
		return percent;
	}

	if(i_a(fam.a) > 0) return -1;

	return -2;
}

string generateFamiliarsSnapshot() {
  string r = "";
  ItemImage [int] familiars;
  file_to_map("crapshot_familiars.txt", familiars);

	string familiarsHtml = visit_url("familiarnames.php");
	string ascensionsHtml = visit_url("ascensionhistory.php?back=self&who=" + my_id(), false) + visit_url("ascensionhistory.php?back=self&prens13=1&who=" + my_id(), false);
	foreach x in familiars {
		int answer = familiarCheck(familiarsHtml, ascensionsHtml, familiars[x]);
		r += (answer > -2 ? answer.to_string() : "") + "|";
	}

  return "familiars=" + r;
}

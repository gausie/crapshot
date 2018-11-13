import <_types>
import <_utils>

string familiarCheck(string familiarsHtml, string ascensionsHtml, ItemImage fam) {
	debug("Looking for familiar: " + fam.itemname);
	if(index_of(familiarsHtml, "the " + fam.itemname + "</td>") > 0) {
		matcher m = create_matcher("alt=\"" + fam.itemname + " .([0-9.]+)..", ascensionsHtml);
		float percent = 0.0;
		while(find(m)) {
			string percentMatch = group(m, 1);
			percent = max(percent, to_float(percentMatch));
		}

		return percent.to_string();
	}

	if(i_a(fam.a) > 0) return "hatchling";

	return "";
}

string [string] generateFamiliarsSnapshot() {
  string [string] r;
  ItemImage [int] familiars;
  file_to_map("crapshot_familiars.txt", familiars);

	string familiarsHtml = visit_url("familiarnames.php");
	string ascensionsHtml = visit_url("ascensionhistory.php?back=self&who=" +my_id(), false) + visit_url("ascensionhistory.php?back=self&prens13=1&who=" +my_id(), false);
	foreach x in familiars {
		r[familiars[x].itemname] = familiarCheck(familiarsHtml, ascensionsHtml, familiars[x]);
	}

  return r;
}

import <_types>
import <_utils>

string arcadeCheck(string html, string name) {
	if(i_a(name) > 0) return "yes";
	if(index_of(html, name) > 0) return "possible";
	return "";
}

string [string] generateArcadeSnapshot() {
  string [string] r;
  ItemImage [int] rogueprogram;

  file_to_map("crapshot_rogueprogram.txt", rogueprogram);
  string html = visit_url("arcade.php?ticketcounter=1");

  foreach x in rogueprogram {
    r[rogueprogram[x].itemname] = arcadeCheck(html, rogueprogram[x].itemname);
  }

  return r;
}

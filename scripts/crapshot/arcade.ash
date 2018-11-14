import <_types>
import <_utils>

/**
 * -1: not earned
 *  0: can buy
 *  1: has bought
 */
int arcadeCheck(string html, string name) {
	if(i_a(name) > 0) return 1;
	if(index_of(html, name) > 0) return 0;
	return -1;
}

string generateArcadeSnapshot() {
  string r = "";
  ItemImage [int] arcade;

  file_to_map("crapshot_arcade.txt", arcade);
  string html = visit_url("arcade.php?ticketcounter=1");

  foreach x in arcade {
		int answer = arcadeCheck(html, arcade[x].itemname);
    r += (answer > -1 ? answer.to_string() : "") + "|";
  }

  return "arcade=" + r;
}

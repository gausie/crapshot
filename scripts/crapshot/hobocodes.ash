import <_types>
import <_utils>

string generateHoboCodesSnapshot() {
  string r = "";
  ItemImage [int] hobocodes;
  file_to_map("crapshot_hobocodes.txt", hobocodes);

  string html = visit_url("questlog.php?which=5");
  foreach x in hobocodes {
    boolean answer = isIn(html, hobocodes[x].itemname);
    r += (answer ? "1" : "") + "|";
  }

  return "hobocodes=" + r;
}

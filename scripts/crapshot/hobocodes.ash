import <_types>
import <_utils>

boolean [string] generateHoboCodesSnapshot() {
  boolean [string] r;
  ItemImage [int] hobocodes;
  file_to_map("crapshot_hobocodes.txt", hobocodes);

  string html = visit_url("questlog.php?which=5");
  foreach x in hobocodes
  {
    r[hobocodes[x].itemname] = isIn(html, hobocodes[x].itemname);
  }

  return r;
}

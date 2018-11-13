import <_types>
import <_utils>

boolean [string] generateTrophiesSnapshot() {
  boolean [string] r;
  ItemImage [int] trophies;
  file_to_map("crapshot_trophies.txt", trophies);
  string html = visit_url("trophies.php");

  foreach x in trophies {
    r[trophies[x].itemname] = isIn(html, "/" + trophies[x].itemname);
  }

  return r;
}

import "crapshot/_types";
import "crapshot/_utils";

string generateTrophiesSnapshot() {
  string r = "";
  Trophy [int] trophies;
  file_to_map("crapshot_trophies.txt", trophies);
  string html = visit_url("trophies.php");

  foreach x, trophy in trophies {
    boolean answer = isIn(html, "/" + trophy.image);
    r += (answer ? "1" : "") + "|";
  }

  return "trophies=" + r;
}

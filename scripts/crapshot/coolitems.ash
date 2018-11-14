import <_types>
import <_utils>

string generateCoolItemsSnapshot() {
  string r = "";
  ItemImage [int] coolitems;
  file_to_map("crapshot_coolitems.txt", coolitems);

  foreach x in coolitems {
    int answer = i_a(coolitems[x].itemname);
    r += (answer > 0 ? answer.to_string() : "") + "|";
  }

  return "coolitems=" + r;
}

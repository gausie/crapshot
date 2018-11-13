import <_types>
import <_utils>

int [string] generateCoolItemsSnapshot() {
  int [string] r;
  ItemImage [int] coolitems;
  file_to_map("crapshot_coolitems.txt", coolitems);

  foreach x in coolitems {
    r[coolitems[x].itemname] = i_a(coolitems[x].itemname);
  }

  return r;
}

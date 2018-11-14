import "crapshot/_types";

string generateTrackedSnapshot() {
  string r;
  ItemImage [int] tracked;
  file_to_map("crapshot_tracked.txt", tracked);

  foreach x in tracked {
    r += get_property(tracked[x].a) + "|";
  }

  return "tracked=" + r;
}

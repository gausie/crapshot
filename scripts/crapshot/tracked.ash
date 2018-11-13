import <_types>

string [string] generateTrackedSnapshot() {
  string [string] r;
  ItemImage [int] tracked;
  file_to_map("crapshot_tracked.txt", tracked);

  foreach x in tracked {
    r[tracked[x].a] = get_property(tracked[x].a);
  }

  return r;
}

import <_types>

string [string] generateDemonNamesSnapshot() {
  string [string] r;

	for i from 1 to 12 {
		r["demonName"+i] = get_property("demonName"+i);
	}

  return r;
}

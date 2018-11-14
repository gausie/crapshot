import <_types>

string generateDemonNamesSnapshot() {
  string r = "";

	for i from 1 to 12 {
		r += get_property("demonName"+i) + "|";
	}

  return "demonnames=" + r;
}

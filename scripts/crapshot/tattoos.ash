import <_types>

string tattooCheck(string html, ItemImage tat) {
	if(last_index_of(html, "/"+tat.gifname+".gif") > 0) {
		return "yes";
	}

	string [7] outfitItems;
	outfitItems[0] = tat.a;
	outfitItems[1] = tat.b;
	outfitItems[2] = tat.c;
	outfitItems[3] = tat.d;
	outfitItems[4] = tat.e;
	outfitItems[5] = tat.f;
	outfitItems[6] = tat.g;

	boolean hasallitems = true;

	foreach i in outfitItems {
		if((outfitItems[i] != "none") && (outfitItems[i] != "")) {
			hasallitems = hasallitems && (i_a(outfitItems[i]) > 0);
		}
	}

	if (hasallitems) return "possible";

	//This is a terrible way of doing this, but the hobo tattoo goes after the salad one.
	//We are not doing this, make it the first tattoo....
	if(tat.gifname == "saladtat") {
		for i from 19 to 1 {
			if(index_of(html, "hobotat"+i) != -1) return "" + i;
		}
	}

	return "";
}

string [string] generateTattoosSnapshot() {
	string [string] r;
  ItemImage [int] tattoos;
  file_to_map("crapshot_tattoos.txt", tattoos);
  string html = visit_url("account_tattoos.php");

  foreach x in tattoos {
    r[tattoos[x].itemname] = tattooCheck(html, tattoos[x]);
  }

  return r;
}

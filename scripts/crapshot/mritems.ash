import <_types>
import <_utils>

int mrItemCheck(string html, ItemImage it) {
	int amount = 0;
	switch(it.itemname)
	{
		case "b":				//Bind-on-use Items
			return i_a(to_item(it.gifname)) + i_a(to_item(it.a));

		case "f":				//Familiar
			return (index_of(html, "the " + it.a) > 0 ? 1 : 0) + i_a(to_item(it.gifname));

		case "g":				//Garden Stuff
			return (index_of(html, it.b) > 0 ? 1 : 0) + i_a(to_item(it.gifname)) + i_a(to_item(it.a));

		case "i":				//Item
			return i_a(to_item(it.gifname));

		case "o":				//Foldable
			amount = i_a(to_item(it.gifname));
			if (it.a != "none") amount += i_a(to_item(it.a));
			if (it.b != "none") amount += i_a(to_item(it.b));
			if (it.c != "none") amount += i_a(to_item(it.c));
			if (it.d != "none") amount += i_a(to_item(it.d));
			if (it.e != "none") amount += i_a(to_item(it.e));
			if (it.f != "none") amount += i_a(to_item(it.f));
			return amount;

		case "p":				//Correspondences (Pen Pal, Game Magazine, etc)
		 	return (contains_text(visit_url("account.php?tab=correspondence"), ">" + it.a +"</option>") ? 1 : 0) + i_a(to_item(it.gifname));

		case "e":				// get campground, otherwise visit page, check for matching text
			amount = i_a(to_item(it.gifname));
			if(get_campground() contains to_item(it.gifname)) return amount + 1;
			if(contains_text(visit_url(it.a), it.b)) return amount + 1;
			//For bind-on-use workshed items
			if(get_campground() contains to_item(it.c)) return amount + 1;
			return amount;

		case "s":				//Check mafia setting
			return (get_property(it.a).to_boolean() ? 1 : 0) + i_a(to_item(it.gifname));

		case "t":				//Tome, Libram, Grimore
			return (index_of(html, it.a) > 0 ? 1 : 0) + i_a(to_item(it.gifname));
	}

	return 0;
}

int [string] generateMrItemsSnapshot() {
  int [string] r;
  ItemImage [int] mritems;
  file_to_map("crapshot_mritems.txt", mritems);

  string html = visit_url("familiarnames.php") + visit_url("campground.php?action=bookshelf");
  foreach x in mritems {
    r[mritems[x].itemname] = mrItemCheck(html, mritems[x]);
  }

  return r;
}

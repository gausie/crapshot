boolean debug = false;
void debug(string s) {
	if (debug) { print(s, "blue"); }
}

int i_a(item i) {
	if (i == $item[none]) return 0;

	int amt = item_amount(i) + closet_amount(i) + equipped_amount(i) + storage_amount(i) + display_amount(i) + shop_amount(i);

	//Make a check for familiar equipment NOT equipped on the current familiar.
	foreach fam in $familiars[] {
		if(have_familiar(fam) && (fam != my_familiar()) && (familiar_equipped_equipment(fam) == i)) amt += 1;
	}

	//Thanks, Bale!
	if(get_campground() contains i) amt += 1;

	return amt;
}

int i_a(string name) {
	if(name == "none" || name == "") return 0;
	item i = to_item(name);
	return i_a(i);
}

boolean isIn(string html, string name) {
	if((length(name) > 7) && (index_of(name, "_thumb") >= length(name) - 6)) {
		name = substring(name, 0, length(name) - 6);
	}

	matcher reg = create_matcher(name, html);
	return reg.find();
}

boolean confirmElementalPlane(string name) {
	string msg1 = "Mafia does not think you have ";
	string msg2 = " but it appears that you might. Select Yes to confirm that you have it. Select No to indicate that you do not have it.";
	return user_confirm(msg1 + name + msg2, 15000, false);
}

void confirmElementalPlanes() {
	if(get_property("spookyAirportAlways").to_boolean() &&
		get_property("sleazeAirportAlways").to_boolean() &&
		get_property("stenchAirportAlways").to_boolean() &&
		get_property("coldAirportAlways").to_boolean() &&
		get_property("hotAirportAlways").to_boolean()) return;

	string html = visit_url("place.php?whichplace=airport");
	if(!get_property("spookyAirportAlways").to_boolean() && contains_text(html, "airport_spooky")) {
		set_property("spookyAirportAlways", confirmElementalPlane("Conspiracy Island"));
	}
	if(!get_property("sleazeAirportAlways").to_boolean() && contains_text(html, "airport_sleaze")) {
		set_property("sleazeAirportAlways", confirmElementalPlane("Spring Break Beach"));
	}
	if(!get_property("stenchAirportAlways").to_boolean() && contains_text(html, "airport_stench")) {
		set_property("stenchAirportAlways", confirmElementalPlane("Disneylandfill"));
	}
	if(!get_property("hotAirportAlways").to_boolean() && contains_text(html, "airport_hot")) {
		set_property("hotAirportAlways", confirmElementalPlane("That 70s Volcano"));
	}
	if(!get_property("coldAirportAlways").to_boolean() && contains_text(html, "airport_cold")) {
		set_property("coldAirportAlways", confirmElementalPlane("The Glaciest"));
	}
}

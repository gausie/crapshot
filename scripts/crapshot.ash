script "crapshot.ash";
since r18892;

#	This is a fork of cheesecookie's fork of bumcheekcity's snapshot script.
#	Code comes straight from that. Relay layout is copied from cheesecookie's website layout which is copied from bumcheekcity's.
#	Things are then hacked onto it in order to increase support. Beep beep. Boop boop.

boolean debug = false;
void debug(string s) {
	if (debug) { print(s, "blue"); }
}

record ItemImage {
	string itemname;
	string gifname;
	string a;
	string b;
	string c;
	string d;
	string e;
	string f;
	string g;
};

ItemImage [int] ascrewards, booze, concocktail, confood, conmeat, conmisc, consmith, coolitems, familiars, food, hobopolis, rogueprogram, manuel, mritems, skills, slimetube, tattoos, trophies, warmedals, tracked;
string [int] paths;

record Result {
	string [string] skills;
	string [string] tattoos;
	boolean [string] trophies;
	string [string] familiars;
	int [string] hobopolis;
	int [string] slimetube;
	int [string] warmedals;
	int telescope;
	int [string] ascrewards;
	string [string] tracked;
	boolean [string] concocktail;
	boolean [string] confood;
	boolean [string] conmeat;
	boolean [string] consmith;
	boolean [string] conmisc;
	int [string] mritems;
	int [string] coolitems;
	boolean [string] food;
	boolean [string] booze;
	string [string] arcade;
	string [string] demonNames;
	int karma;
	int [string] paths;
	boolean inrun;
	string version;
	string timestamp;
}

int i_a(string name) {
	if((name == "none") || (name == ""))
	{
		return 0;
	}

	item i = to_item(name);
	int amt = item_amount(i) + closet_amount(i) + equipped_amount(i) + storage_amount(i);
	amt = amt + display_amount(i) + shop_amount(i);

	//Make a check for familiar equipment NOT equipped on the current familiar.
	foreach fam in $familiars[]
	{
		if(have_familiar(fam) && fam != my_familiar())
		{
			if(name == to_string(familiar_equipped_equipment(fam)) && name != "none")
			{
				amt = amt + 1;
			}
		}
	}

	//Thanks, Bale!
	if(get_campground() contains i) amt += 1;

	return amt;
}

void updateMapFiles() {
	file_to_map("crapshot_skills", skills);
	file_to_map("crapshot_tattoos", tattoos);
	file_to_map("crapshot_trophies", trophies);
	file_to_map("crapshot_familiars", familiars);
	file_to_map("crapshot_hobopolis", hobopolis);
	file_to_map("crapshot_slimetube", slimetube);
	file_to_map("crapshot_warmedals", warmedals);
	file_to_map("crapshot_ascensionrewards", ascrewards);
	file_to_map("crapshot_dis_cocktail", concocktail);
	file_to_map("crapshot_dis_food", confood);
	file_to_map("crapshot_dis_meat", conmeat);
	file_to_map("crapshot_dis_smith", consmith);
	file_to_map("crapshot_dis_misc", conmisc);
	file_to_map("crapshot_mritems", mritems);
	file_to_map("crapshot_coolitems", coolitems);
	file_to_map("crapshot_con_food", food);
	file_to_map("crapshot_con_booze", booze);
	file_to_map("crapshot_rogueprogram", rogueprogram);
	file_to_map("crapshot_manuel", manuel);
	file_to_map("crapshot_tracked", tracked);
	file_to_map("crapshot_paths.txt", paths);
}

boolean consumptionCheck(string html, string name) {
	name = name.to_lower_case().replace_string("(", "\\(").replace_string(")", "\\)");
	matcher m = create_matcher(">\\s*" + name + "(?:\\s*)</a>", to_lower_case(html));
	return find(m);
}

boolean isIn(string html, string name) {
	if((length(name) > 7) && (index_of(name, "_thumb") >= length(name) - 6)) {
		name = substring(name, 0, length(name) - 6);
	}

	matcher reg = create_matcher(name, html);
	return reg.find();
}

boolean regCheck(string html, string checkthis) {
	checkthis = replace_string(checkthis, "+", "\\+");
	checkthis = replace_string(checkthis, "(0)", "\\(([0-9]+)\\)");
	checkthis = replace_string(checkthis, "</b>", "(</a>){0,1}</b>");
	checkthis = replace_string(checkthis, "</b> <font", "</b>(\\s){0,1}<font");
	checkthis = replace_string(checkthis, "<font size=1>", "<font size=1>(?:<font size=2>\\[<a href=\"craft.php\\?mode=\\w+&a=\\d+&b=\\d+\">\\w+</a>\\]</font>)?");

	matcher reg = create_matcher(checkthis, html);
	return reg.find();
}

boolean discoveryCheck(string html, ItemImage thing) {
	if(thing.gifname != "none") return regCheck(html, thing.gifname);
	return (index_of(html, ">"+thing.itemname+"<") != -1)
}

//forceReturn basically stops the script trying to check for a lowercase version of the monster.
int manuelTimes(string monsterName, string questmanpage, string firstFact, boolean forceReturn) {
	string montag="<td rowspan=4 valign=top class=small><b><font size=\+2>";
	int istart=0;
	int iend=0;
	string ssub="";
	int rcount=0;

	//Manually override monsterName in some circumstances
	if(contains_text(monsterName, "fabricator g")) {
		monsterName = "fabricator g";
	}
	if(contains_text(monsterName, "novio cad")) {
		monsterName = "novio cad";
	}
	if(contains_text(monsterName, "padre cad")) {
		monsterName = "padre cad";
	}
	if(contains_text(monsterName, "novia cad")) {
		monsterName = "novia cad";
	}
	if(contains_text(monsterName, "persona inoce")) {
		monsterName = "persona inoce";
	}

	string searchForThis = "";
	//If we specify a first fact then we should search for the monster name AND fact, else just the monster name.
	if(firstFact != "") {
		searchForThis = montag+monsterName+"</font></b><ul><li>"+firstFact;
	} else {
		searchForThis = montag+monsterName;
	}

		if(contains_text(questmanpage, searchForThis))
		{
			istart = index_of(questmanpage,searchForThis,iend);
			iend = index_of(questmanpage,montag,istart+2);
			if(istart == -1) { istart = 1; }
			if(iend == -1) { iend = length(questmanpage); }
			ssub = substring(questmanpage,istart,iend);
			matcher ii = create_matcher("(<li>)",ssub);
			rcount=0;
			while(find(ii)) { rcount += 1; }
		}

		if(forceReturn) return rcount;

		if(rcount == 0) {
			//print("trying lowercase");
			return manuelTimes(to_lower_case(monsterName), questmanpage, firstFact, true);
		}
	return rcount;
}
int manuelTimes(string monsterName, string questmanpage, string firstFact)
{
	return manuelTimes(monsterName, questmanpage, firstFact, false);
}

string familiarCheck(string familiarsHtml, string ascensionsHtml, ItemImage fam) {
	debug("Looking for familiar: " + fam.itemname);
	if(index_of(familiarsHtml, "the " + fam.itemname + "</td>") > 0) {
		matcher m = create_matcher("alt=\"" + fam.itemname + " .([0-9.]+)..", ascensionsHtml);
		float percent = 0.0;
		while(find(m)) {
			string percentMatch = group(m, 1);
			percent = max(percent, to_float(percentMatch));
		}

		return percent.to_string();
	}

	if(i_a(familiars[x].a) > 0) return "hatchling";

	return null;
}

string skillCheck(string html, ItemImage sk) {
	string overwrite = sk.a
	if(overwrite == "none") {
		overwrite = "";
	}

	if(index_of(html, ">"+sk.itemname+"</a> (<b>HP</b>)") != -1) {
		if(sk.itemname == "Slimy Shoulders") {
			return "hp-" + (get_property("skillLevel48").to_int() / 2);
		} else if(sk.itemname == "Slimy Sinews") {
			return "hp-" + (get_property("skillLevel46").to_int() / 2);
		} else if(sk.itemname == "Slimy Synapses") {
			return "hp-" + get_property("skillLevel47");
		}

		return "hp";
	} else if((length(overwrite) > 0) && (index_of(html, overwrite) > 0)) {
		return "hp";
	} else if(index_of(html, ">"+sk.itemname+"</a> (P)") != -1) {
		if(sk.itemname == "Slimy Shoulders") {
			return "p-" + (get_property("skillLevel48").to_int() / 2);
		} else if(sk.itemname == "Slimy Sinews") {
			return "p-" + (get_property("skillLevel46").to_int() / 2);
		} else if(sk.itemname == "Slimy Synapses") {
			return "p-" + get_property("skillLevel47");
		}

		return "p";
	} else if((sk.itemname == "Toggle Optimality") && have_skill(sk)) {
		return "hp";
	}

	return null;
}

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

	if(hasallitems) return "possible";

	//This is a terrible way of doing this, but the hobo tattoo goes after the salad one.
	//We are not doing this, make it the first tattoo....
	if(tat.gifname == "saladtat") {
		for i from 19 to 1 {
			if(index_of(html, "hobotat"+i) != -1) return "" + i;
		}
	}
}

int mrItemCheck(string html, ItemImage it) {
	switch(mritems[x].itemname)
	{
		case "b":				//Bind-on-use Items
			return i_a(to_item(mritems[x].gifname)) + i_a(to_item(mritems[x].a));

		case "f":				//Familiar
			return (index_of(html, "the " + mritems[x].a) > 0 ? 1 : 0) + i_a(to_item(mritems[x].gifname));

		case "g":				//Garden Stuff
			return (index_of(html, mritems[x].b) > 0 ? 1 : 0) + i_a(to_item(mritems[x].gifname)) + i_a(to_item(mritems[x].a));

		case "i":				//Item
			return i_a(to_item(mritems[x].gifname));

		case "o":				//Foldable
			int itemAmount = i_a(to_item(mritems[x].gifname));
			if (mritems[x].a != "none") amount += i_a(to_item(mritems[x].a));
			if (mritems[x].b != "none") amount += i_a(to_item(mritems[x].b));
			if (mritems[x].c != "none") amount += i_a(to_item(mritems[x].c));
			if (mritems[x].d != "none") amount += i_a(to_item(mritems[x].d));
			if (mritems[x].e != "none") amount += i_a(to_item(mritems[x].e));
			if (mritems[x].f != "none") amount += i_a(to_item(mritems[x].f));
			return amount;

		case "p":				//Correspondences (Pen Pal, Game Magazine, etc)
		 	return (contains_text(visit_url("account.php?tab=correspondence"), ">" + mritems[x].a +"</option>") ? 1 : 0) + i_a(to_item(mritems[x].gifname));

		case "e":				// get campground, otherwise visit page, check for matching text
			int amount = i_a(to_item(mritems[x].gifname));
			if(get_campground() contains to_item(mritems[x].gifname)) return amount + 1;
			if(contains_text(visit_url(mritems[x].a), mritems[x].b)) return amount + 1;
			//For bind-on-use workshed items
			if(get_campground() contains to_item(mritems[x].c)) return amount + 1;
			return amount;

		case "s":				//Check mafia setting
			return (get_property(mritems[x].a).to_boolean() ? 1 : 0) + i_a(to_item(mritems[x].gifname));

		case "t":				//Tome, Libram, Grimore
			return (index_of(html, mritems[x].a) > 0 ? 1 : 0) + i_a(to_item(mritems[x].gifname));
	}
}

string arcadeCheck(string html, string name) {
	if(i_a(name) > 0) return "yes";
	if(index_of(html, rogueprogram[x].itemname) > 0) return "possible";
	return null;
}

string visit_discoveries(string url) {
	matcher reg = create_matcher("<font size=2>.*?</font>", visit_url(url));
	return replace_all(reg, "");
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

string generate_snapshot() {
	Result result;

	print("Updating map files...", "olive");
	updateMapFiles();

	print("Checking skills...", "olive");
	string bookshelfHtml = visit_url("campground.php?action=bookshelf");
	string skillsHtml = visit_url("charsheet.php") + bookshelfHtml;
	foreach x in skills {
		result["skills"][skills[x].itename] = skillCheck(skillsHtml, skills[x]);
	}

	print("Checking tattoos...", "olive");]
	string tattosHtml = visit_url("account_tattoos.php");
	foreach x in tattoos {
		result["tattoos"][tattoos[x].itename] = tattooCheck(tattosHtml, tattoos[x]);
	}

	print("Checking trophies...", "olive");
	string trophiesHtml = visit_url("trophies.php");
	foreach x in trophies {
		result["trophies"][trophies[x].itename] = isIn(trophiesHtml, "/" + trophies[x].itemname);
	}

	print("Checking familiars...", "olive");
	string familiarsHtml = visit_url("familiarnames.php");
	string ascensionsHtml = visit_url(" ascensionhistory.php?back=self&who=" +my_id(), false) + visit_url(" ascensionhistory.php?back=self&prens13=1&who=" +my_id(), false);
	foreach x in familiars {
		result["familiars"][familiars[x].itemname] = familiarCheck(familiarsHtml, ascensionsHtml, familiars[x]);
	}

	print("Checking hobopolis loot and hobo codes...", "olive");
	string hoboCodeHtml = visit_url("questlog.php?which=5");
	foreach x in hobopolis
	{
		if(x >= 44 && x <= 63) {
			result["hobopolis"][hobopolis[x].itemname] = isIn(hoboCodeHtml, hobopolis[x].itemname) ? 1 : 0;
		} else {
			result["hobopolis"][hobopolis[x].itemname] = i_a(hobopolis[x].itemname);
		}
	}

	print("Checking Slime Tube loot...", "olive");
	foreach x in slimetube {
		result["slimetube"][slimetube[x].itemname] = i_a(slimetube[x].itemname);
	}

	print("Checking War Medals...", "olive");
	foreach x in warmedals {
		result["warmedals"][warmedals[x].itemname] = i_a(warmedals[x].itemname);
	}

	print("Checking for Telescope", "olive");
	result["scope"] = get_property("telescopeUpgrades").to_int();

	print("Checking for Ascension Rewards", "olive");
	foreach x in ascrewards {
		result["ascrewards"][ascrewards[x].itemname] = i_a(ascrewards[x].itemname);
	}

	print("Checking for Mafia Tracked Data", "olive");
	foreach x in tracked {
		result["tracked"][tracked[x].a] = get_property(tracked[x].a);
	}

	print("Checking for Discoveries [Cocktail]", "olive");
	string cookDiscoveriesHtml = visit_discoveries("craft.php?mode=discoveries&what=cook");
	string cocktailDiscoveriesHtml = visit_discoveries("craft.php?mode=discoveries&what=cocktail");
	string combineDiscoveriesHtml = visit_discoveries("craft.php?mode=discoveries&what=combine");
	string smithDiscoveriesHtml = visit_discoveries("craft.php?mode=discoveries&what=smith");
	string multiDiscoveriesHtml = visit_discoveries("craft.php?mode=discoveries&what=multi");

	foreach x in concocktail {
		result["concocktail"][concocktail[x].itemname] = discoveryCheck(cocktailDiscoveriesHtml, concocktail[x]);
	}

	print("Checking for Discoveries [Food]", "olive");
	foreach x in confood {
		result["confood"][confood[x].itemname] = discoveryCheck(cookDiscoveriesHtml, confood[x]);
	}

	print("Checking for Discoveries [Meat Pasting]", "olive");
	foreach x in conmeat {
		result["conmeat"][conmeat[x].itemname] = discoveryCheck(combineDiscoveriesHtml, conmeat[x]);
	}

	print("Checking for Discoveries [Meatsmithing]", "olive");
	foreach x in consmith {
		result["consmith"][consmith[x].itemname] = discoveryCheck(smithDiscoveriesHtml, consmith[x]);
	}

	print("Checking for Discoveries [Misc]", "olive");
	foreach x in conmisc {
		result["conmisc"][conmisc[x].itemname] = discoveryCheck(multiDiscoveriesHtml, conmisc[x]);
	}

	print("Checking for Mr. Items", "olive");
	string mrItemHtml = familiarNamesHtml + bookshelfHtml;
	foreach x in mritems {
		result["mritems"][mritems[x].itemname] = mrItemCheck(mrItemHtml, mritems[x]);
	}

	print("Checking for Cool Items", "olive");
	foreach x in coolitems {
		result["coolitems"][coolitems[x].itemname] = i_a(coolitems[x].itemname);
	}

	print("Checking for Consumed Food", "olive");
	string consumptionHtml = visit_url("showconsumption.php");
	foreach x in food {
		result["food"][food[x].itemname] = consumptionCheck(consumptionHtml, food[x].itemname);
	}

	print("Checking for Consumed Booze", "olive");
	foreach x in booze {
		result["booze"][booze[x].itemname] = consumptionCheck(consumptionHtml, booze[x].itemname);
	}

	print("Checking for Rogue Program Stuff", "olive");
	48Html = visit_url("arcade.php?ticketcounter=1");
	foreach x in rogueprogram {
		result["arcade"][rogueprogram[x].itemname] = arcadeCheck(arcadeHtml, rogueprogram[x].itemname);
	}

	print("Checking Demon Names", "olive");
	int i = 1, numdemon = 12;
	while(i <= numdemon)
	{
		result["demonnames"]["demonName"+i] = get_property("demonName"+i);
		i = i + 1;
	}

	print("Checking Karma", "olive");
	string karma = visit_url("questlog.php?which=3");
	matcher m = create_matcher("Your current Karmic balance is ([0-9,]+)", karma);
	int k = 0;
	while(find(m)) k = to_int(group(m, 1));
	debug("You have "+k+" karma");
	result["karma"] = k;

	print("Checking Path Points", "olive");
	foreach key in paths
	{
		result["paths"][key] = to_int(get_property(paths[key]));
	}

	string manuelHtml = visit_url("questlog.php?which=6&vl=a");
	if(contains_text(manuelHtml, "Monster Manuel"))
	{
		print("Checking simplified Manuel data", "olive");

		matcher m = create_matcher("casually(?:.*?)([0-9]+) creature(s?)[.]", manuelHtml);
		string researchVal = "0";
		if(find(m)) researchVal = group(m,1);
		result["manuel"]["casually"] = researchVal;

		m = create_matcher("thoroughly(?:.*?)([0-9]+) creature(s?)[.]", manuelHtml);
		researchVal = "0";
		if(find(m)) researchVal = group(m,1);
		result["manuel"]["thoroughly"] = researchVal;

		m = create_matcher("exhaustively(?:.*?)([0-9]+) creature(s?)[.]", manuelHtml);
		researchVal = "0";
		if(find(m)) researchVal = group(m,1);
		result["manuel"]["exhaustively"] = researchVal;
	}

	result["inrun"] = !get_property("kingLiberated").to_boolean();
	result["version"] = svn_info("crapshot").last_changed_rev;
	result["timestamp"] = now_to_string("yyyy-MM-dd'T'HH:mm:ss.SSSX");

	map_to_file(result.to_json(), "crapshot_snapshot.txt");

	return result;
}

void main()
{
	if(!get_property("kingLiberated").to_boolean())
	{
		if(!user_confirm("This script should not be run while you are in-run. It may blank out some of your skills, telescope, bookshelf or some other aspect of your profile until you next run it in aftercore. Are you sure you want to run it (not recommended)?", 15000, false))
		{
			abort("User aborted. Beep");
		}
	}

	confirmElementalPlanes();

	Result result = generate_snapshot();
	print(result.to_json());
}

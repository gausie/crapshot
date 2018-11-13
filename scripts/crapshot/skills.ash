import <_types>
import <_utils>

string skillCheck(string html, ItemImage sk) {
	string overwrite = sk.a;
	if(overwrite == "none") overwrite = "";

	if(index_of(html, ">"+sk.itemname+"</a> (<b>HP</b>)") != -1) {
		if(sk.itemname == "Slimy Shoulders") {
			return "hp-" + (get_property("skillLevel48").to_int() / 2);
		}
		if(sk.itemname == "Slimy Sinews") {
			return "hp-" + (get_property("skillLevel46").to_int() / 2);
		}
		if(sk.itemname == "Slimy Synapses") {
			return "hp-" + get_property("skillLevel47");
		}
		return "hp";
	}

	if((length(overwrite) > 0) && (index_of(html, overwrite) > 0)) {
		return "hp";
	}

	if(index_of(html, ">"+sk.itemname+"</a> (P)") != -1) {
		if(sk.itemname == "Slimy Shoulders") {
			return "p-" + (get_property("skillLevel48").to_int() / 2);
		}
		if(sk.itemname == "Slimy Sinews") {
			return "p-" + (get_property("skillLevel46").to_int() / 2);
		}
		if(sk.itemname == "Slimy Synapses") {
			return "p-" + get_property("skillLevel47");
		}
		return "p";
	}

	if((sk.itemname == "Toggle Optimality") && to_skill("Calculate the Universe").have_skill()) {
		return "hp";
	}

	return "";
}

string [string] generateSkillsSnapshot() {
  string [string] r;
  ItemImage [int] skills;
  file_to_map("crapshot_skills.txt", skills);

  string html = visit_url("charsheet.php") + visit_url("campground.php?action=bookshelf");
  foreach x in skills {
    r[skills[x].itemname] = skillCheck(html, skills[x]);
  }

  return r;
}

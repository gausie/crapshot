import <_types>
import <_utils>

/**
 *  0: not permed
 *  1: permed
 *  2: hardcore permed
 */
int skillCheck(string html, string name, string overwrite) {
	if(overwrite == "none") overwrite = "";

	if(html.index_of(">" + name + "</a> (<b>HP</b>)") != -1) return 2;

	if((overwrite.length() > 0) && (html.index_of(overwrite) > 0)) return 2;

	if(html.index_of(">" + name + "</a> (P)") != -1) return 1;

	if((name == "Toggle Optimality") && name.to_skill().have_skill()) return 2;

	return 0;
}

string generateSkillsSnapshot() {
  string r = "";
  ItemImage [int] skills;
  file_to_map("crapshot_skills.txt", skills);

  string html = visit_url("charsheet.php") + visit_url("campground.php?action=bookshelf");
  foreach x in skills {
		int answer = skillCheck(html, skills[x].itemname, skills[x].a);
		r += (answer > 0 ? answer.to_string() : "") + "|";
  }

  return "skills=" + r;
}

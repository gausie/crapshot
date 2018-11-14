import "crapshot/_types";
import "crapshot";

void main() {
	Trophy [int] trophies;
	string [string] outfits, tattoos;
	ItemImage [int] arcade, con_booze, con_food, coolitems, demon, dis_cocktail, dis_combine, dis_cook, dis_multi, dis_smith, familiars, hobocodes, manuel, mritems, skills, tracked;
	file_to_map("crapshot_arcade.txt", arcade);
	file_to_map("crapshot_con_booze.txt", con_booze);
	file_to_map("crapshot_con_food.txt", con_food);
	file_to_map("crapshot_coolitems.txt", coolitems);
	file_to_map("crapshot_demon.txt", demon);
	file_to_map("crapshot_dis_cocktail.txt", dis_cocktail);
	file_to_map("crapshot_dis_combine.txt", dis_combine);
	file_to_map("crapshot_dis_cook.txt", dis_cook);
	file_to_map("crapshot_dis_multi.txt", dis_multi);
	file_to_map("crapshot_dis_smith.txt", dis_smith);
	file_to_map("crapshot_familiars.txt", familiars);
	file_to_map("crapshot_hobocodes.txt", hobocodes);
	file_to_map("crapshot_manuel.txt", manuel);
	file_to_map("crapshot_mritems.txt", mritems);
	file_to_map("crapshot_skills.txt", skills);
	file_to_map("crapshot_outfits.txt", outfits);
	file_to_map("crapshot_tattoos.txt", tattoos);
	file_to_map("crapshot_tracked.txt", tracked);
	file_to_map("crapshot_trophies.txt", trophies);

	string [int] cache;
	file_to_map("crapshot_cache.txt", cache);
	string r;

	if (cache.count() == 0) {
		r = generate_snapshot();
		cache[0] = r;
		map_to_file(cache, "crapshot_cache.txt");
	} else {
	  r = cache[0];
	}

	buffer page;
	page.append("<style>\n" +
    "\ttable { font-size: 10px; }\n" +
    "\t.hp { background-color: #afa; }\n" +
    "\t.p { background-color: #eea; }\n" +
  "</style>\n");
	page.append("<script type=\"text/javascript\">\n" +
		"\tconst snapshot_qs = \"" + r + "\";\n" +
		"\tconst data = {\n" +
			"\t\tarcade:" + arcade.to_json() + ",\n" +
			"\t\tcon_booze:" + con_booze.to_json() + ",\n" +
			"\t\tcon_food:" + con_food.to_json() + ",\n" +
			"\t\tcoolitems:" + coolitems.to_json() + ",\n" +
			"\t\tdemon:" + demon.to_json() + ",\n" +
			"\t\tdis_cocktail:" + dis_cocktail.to_json() + ",\n" +
			"\t\tdis_combine:" + dis_combine.to_json() + ",\n" +
			"\t\tdis_cook:" + dis_cook.to_json() + ",\n" +
			"\t\tdis_multi:" + dis_multi.to_json() + ",\n" +
			"\t\tdis_smith:" + dis_smith.to_json() + ",\n" +
			"\t\tfamiliars:" + familiars.to_json() + ",\n" +
			"\t\thobocodes:" + hobocodes.to_json() + ",\n" +
			"\t\tmanuel:" + manuel.to_json() + ",\n" +
			"\t\tmritems:" + mritems.to_json() + ",\n" +
			"\t\tskills:" + skills.to_json() + ",\n" +
			"\t\toutfits:" + outfits.to_json() + ",\n" +
			"\t\ttattoos:" + tattoos.to_json() + ",\n" +
			"\t\ttracked:" + tracked.to_json() + ",\n" +
			"\t\ttrophies:" + trophies.to_json() + ",\n" +
		"\t};\n" +
	"</script>\n");
  page.append("<script type=\"text/javascript\" src=\"crapshot/crapshot.js\"></script>\n");
	page.append("<div id=\"crapshot\"></div>");
	writeln(page);
}

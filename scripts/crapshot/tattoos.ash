import "crapshot/_utils";

int [string] stagedTats;
stagedTats["aol"] = 5;
stagedTats["hobocode"] = 19;
stagedTats["asc"] = 12;
stagedTats["hasc"] = 12;

int tattooCheck(string html, string image) {
  if(stagedTats contains image) {
    for i from stagedTats[image] to 1 {
      string zero = ((image == "Asc" || image == "Hasc") && i < 10) ? "0" : "";
      if(index_of(html, image+zero+i) != -1) return i;
    }
  }

  if(last_index_of(html, "/"+image+".gif") > 0) return 1;

  return 0;
}

boolean outfitCheck(string outfit) {
  item [int] pieces = outfit_pieces(outfit);

  boolean hasOutfit = true;

  foreach piece in pieces {
    hasOutfit = hasOutfit && (i_a(piece) > 0);
  }

  return hasOutfit;
}

/**
 * 0: has outfit
 * 1: has tattoo
 * N: has tattoo of N level
 */
string generateTattoosSnapshot() {
  string r = "";

  string [string] outfits;
  file_to_map("crapshot_outfits.txt", outfits);

  string [string] tattoos;
  file_to_map("crapshot_tattoos.txt", tattoos);

  string html = visit_url("account_tattoos.php");

  foreach outfit in outfits {
    string tat = outfit_tattoo(outfit);
    if (tat.length() < 4) continue;
    int answer = tattooCheck(html, tat.substring(0, tat.length() - 4));
    if (answer == 0 && !outfitCheck(outfit)) answer = -1;
    r += (answer >= 0 ? answer.to_string() : "") + "|";
  }

  foreach tattoo, image in tattoos {
    int answer = tattooCheck(html, image);
    r += (answer > 0 ? answer.to_string() : "") + "|";
  }

  return "tattoos=" + r;
}

void main() {
  print(generateTattoosSnapshot());
}

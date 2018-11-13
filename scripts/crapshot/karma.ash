int generateKarmaSnapshot() {
  int r;

  string html = visit_url("questlog.php?which=3");
  matcher m = create_matcher("Your current Karmic balance is ([0-9,]+)", html);
  while(find(m)) r = to_int(group(m, 1));

  return r;
}

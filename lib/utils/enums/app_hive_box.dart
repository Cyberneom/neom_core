enum AppHiveBox {
  settings(false),
  timeline(false),
  releases(true),
  player(true),
  downloads(false),
  pdfCache(false),
  mp3Cache(false),
  stats(false),
  favoriteItems(false),
  directory(false),
  nupale(false),
  casete(false),
  profile(false);

  final bool limit;
  const AppHiveBox(this.limit);
}

class Trip {
  final String name;
  final String description;
  final String savesLabel;

  const Trip({
    required this.name,
    this.description = "",
    this.savesLabel = "No saves yet",
  });
}

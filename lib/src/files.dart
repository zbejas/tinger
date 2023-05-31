import 'dart:io';

/// Reads links from a file and returns them as a list of strings.
///
/// The file at [filePath] is read and its contents are split by newline
/// characters. Empty lines are removed from the list of links. If there are
/// duplicate links, only one copy of each link is kept in the list.
///
/// Returns a list of links.
List<String> readLinksFromFile(String filePath) {
  final file = File(filePath);
  final contents = file.readAsStringSync();
  var links = contents.split('\n');

  // Remove empty lines
  links.removeWhere((link) => link.isEmpty);

  print('Found ${links.length} links in $filePath');

  final oldLength = links.length;

  links = links.toSet().toList();

  if (links.length != oldLength) {
    print('Removed ${oldLength - links.length} duplicate links');
  }

  return links;
}

/// Checks if a file exists at the given [filePath].
///
/// Returns a [Future] that completes with `true` if the file exists, or
/// `false` otherwise.
Future<bool> fileExists(String filePath) async {
  return File(filePath).exists();
}

/// Writes the given list of [links] to a file at the given [filePath].
///
/// The links are joined with two newline characters between each link before
/// being written to the file.
Future<void> writeToFile(List<String> links, String filePath) async {
  final file = File(filePath);
  await file.writeAsString(links.join('\n\n'));
}

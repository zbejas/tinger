import 'dart:io';
import 'package:args/args.dart';
import 'package:tinger/tinger.dart';

void main(List<String> arguments) async {
  final parser = parseArgs(arguments);

  final results = parser.parse(arguments);

  if (results['help'] == true) {
    print(parser.usage);
    return;
  }

  final path = results['path'] as String;
  final output = results['output'] as String;
  final timeout = int.tryParse(results['timeout'] as String);
  final retries = int.tryParse(results['retries'] as String);

  if (!await fileExists(path)) {
    print('Could not find file at $path');
    exit(0);
  }

  List<String> links = readLinksFromFile(path);

  print('Checking links...');

  final workingLinks = await findWorkingLinks(
    links,
    timeout: Duration(
      seconds: timeout!,
    ),
    retries: retries!,
  );

  await Future.delayed(Duration(seconds: 1));

  print('\nFound ${workingLinks.length} working links.');

  if (workingLinks.isNotEmpty) {
    print('Writing working links to $output');
    await writeToFile(workingLinks, output);
  } else {
    print('No working links found.');
  }

  print('Done!');
  exit(0);
}

/// Parses command line arguments using the `args` package.
ArgParser parseArgs(List<String> arguments) {
  return ArgParser()
    ..addSeparator(
      '\nTinger is a command line tool to check for working trackers and sorts them into a new file.\n'
      '\nUsage:',
    )
    ..addOption(
      'path',
      abbr: 'p',
      defaultsTo: 'list.txt',
      valueHelp: '/home/user/list.txt',
      help: 'Path to file containing links',
    )
    ..addOption(
      'output',
      abbr: 'o',
      defaultsTo: 'working_links.txt',
      valueHelp: '/home/user/working_links.txt',
      help: 'Path to output file',
    )
    ..addOption(
      'timeout',
      abbr: 't',
      defaultsTo: '3',
      valueHelp: '3',
      help: 'Timeout in seconds',
    )
    ..addOption(
      'retries',
      abbr: 'r',
      defaultsTo: '3',
      valueHelp: '3',
      help: 'Number of retries',
    )
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
    );
}

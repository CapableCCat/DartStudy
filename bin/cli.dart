// const version = '0.0.1'; // Add this line

// void main(List<String> arguments) {
//   if (arguments.isEmpty) {
//     print('Hello, Dart!');
//   } else if (arguments.first == 'version') {
//     print('Dartpedia CLI version $version');
//   }
// }

const version = '0.1.0';

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    print('Hello, World!');
    print('Hello, Dart!');
  }
  // else if (arguments.first == 'version') {
  //   print('Dartpedia CLI version $version');
  // }
  else if (arguments.first == 'search') {
    print('Search command recognized!');
  } 
  else {
    printUsage();
  }
}

void printUsage() {
  print(
    "The following commmands are valid: 'help', 'version', 'search <ARTICLE-TITLE>'",
  );
}

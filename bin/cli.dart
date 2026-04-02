import 'dart:io';

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
  if (arguments.isEmpty || arguments.first == 'help') {
    printUsage();
  }
  // if (arguments.isEmpty) {
  //   print('Hello, World!');
  //   print('Hello, Dart!');
  // }
  else if (arguments.first == 'version') {
    print('Dartpedia CLI version $version');
  } else if (arguments.first == 'search') {
    print('Search command recognized!');
    final inputArgs = arguments.length > 1 ? arguments.sublist(1) : null;
    searchWikipedia(inputArgs);
  } else {
    printUsage();
  }
}

void printUsage() {
  print(
    "The following commmands are valid: 'help', 'version', 'search <ARTICLE-TITLE>'",
  );
}

void searchWikipedia(List<String>? arguments) {
  // print('SearchingWikipedia received arguments: $arguments');
  final String articleTitle;

  // 如果用户没有传入参数,则提示用户输入文章标题
  // If the user didn't pass in arguments, request an article title.
  if (arguments == null || arguments.isEmpty) {
    // Dart 静态分析可以检测到 articleTitle 在执行 print 语句时保证被初始化。无论该函数体中路径如何，该变量都是不可空的。
    // Dart static analysis can detect that articleTitle is guaranteed to be initialized when the print statement is executed.
    // No matter which path is taken through this function body, the variable is non-nullable.
    print('Please provide an article title.');

    // 等待输入,如果输入为空,则返回空字符串作为默认值
    // Await input and provide a default empty string if the input is null.
    articleTitle = stdin.readLineSync() ?? '';
  } else {
    // 否则,将参数合并为单个字符串
    // Otherwise, join the arguments into a single string.
    articleTitle = arguments.join(' ');
  }

  // print('Current article title: $articleTitle');

  print('Looking up article about "$articleTitle". Please wait...');
  print('Here ya go!');
  print('(Pretend this is an article about "$articleTitle" from Wikipedia.)');
}

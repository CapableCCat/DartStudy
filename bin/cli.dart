import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  }
  // else if (arguments.first == 'search') {
  //   print('Search command recognized!');
  //   final inputArgs = arguments.length > 1 ? arguments.sublist(1) : null;
  //   searchWikipedia(inputArgs);
  // }
  else if (arguments.first == 'wikipedia') {
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

void searchWikipedia(List<String>? arguments) async {
  // print('SearchingWikipedia received arguments: $arguments');
  final String articleTitle;

  // 如果用户没有传入参数,则提示用户输入文章标题
  // If the user didn't pass in arguments, request an article title.
  if (arguments == null || arguments.isEmpty) {
    // Dart 静态分析可以检测到 articleTitle 在执行 print 语句时保证被初始化。无论该函数体中路径如何，该变量都是不可空的。
    // Dart static analysis can detect that articleTitle is guaranteed to be initialized when the print statement is executed.
    // No matter which path is taken through this function body, the variable is non-nullable.
    print('Please provide an article title.');

    // Read input
    final inputFromStdin = stdin.readLineSync();

    if (inputFromStdin == null || inputFromStdin.isEmpty) {
      print('No article title provided. Exiting.');
      // Exit the function if no valid input
      return;
    }

    // 等待输入,如果输入为空,则返回空字符串作为默认值
    // Await input and provide a default empty string if the input is null.
    // articleTitle = stdin.readLineSync() ?? '';

    articleTitle = inputFromStdin;
  } else {
    // 否则,将参数合并为单个字符串
    // Otherwise, join the arguments into a single string.
    articleTitle = arguments.join(' ');
  }

  // print('Current article title: $articleTitle');

  print('Looking up article about "$articleTitle". Please wait...');

  // Call the API and await the result
  // var articleContent = await getWikipediaArticle(articleTitle);
  // print(articleContent);

  var articleContent = await getBaiduWikiArticle(articleTitle);
  print(articleContent);

  // print('Here ya go!');
  // print('(Pretend this is an article about "$articleTitle" from Wikipedia.)');
}

// Future<String> getWikipediaArticle(String articleTitle) async {
//   final url = Uri.https(
//     // Wikipedia API domain
//     // 'en.wikipedia.org',
//     // Only permit exist one domain
//     'zh.wikipedia.org',

//     // API path for article summary
//     '/api/rest_v1/page/summary/$articleTitle',
//   );

//   // Make the HTTP request
//   final response = await http.get(url);

//   if (response.statusCode == 200) {
//     // Return the response body if successful
//     return response.body;
//   }

//   // Return an error message if the request failed
//   return 'Error: Failed to fetch article "$articleTitle". Status code: ${response.statusCode}';
// }

Future<String> getBaiduWikiArticle(String articleTitle) async {
  final url = Uri.parse(
    'https://baike.baidu.com/api/openapi/BaikeLemmaCardApi?scope=103&format=json&appid=379020&bk_key=${Uri.encodeComponent(articleTitle)}&bk_length=600',
  );

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final title = data['title'] ?? articleTitle;
      final abstract = data['abstract'] ?? 'No abstract';
      return "✅ $title\n$abstract";
    } else {
      return "Error: Status code ${response.statusCode}";
    }
  } catch (e) {
    return "Error: $e";
  }
}

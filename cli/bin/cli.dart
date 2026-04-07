import 'dart:io';
import 'package:http/http.dart' as http;
// import 'dart:convert';
import 'package:command_runner/command_runner.dart';

const version = '0.1.0';

void main(List<String> arguments) async {
  // 配置代理
  // Proxy Setting
  HttpOverrides.global = MyHttpOverrides();

  // if (arguments.isEmpty || arguments.first == 'help') {
  //   printUsage();
  // }
  // if (arguments.isEmpty) {
  //   print('Hello, World!');
  //   print('Hello, Dart!');
  // }
  // else if (arguments.first == 'version') {
  //   print('Dartpedia CLI version $version');
  // }
  // else if (arguments.first == 'search') {
  //   print('Search command recognized!');
  //   final inputArgs = arguments.length > 1 ? arguments.sublist(1) : null;
  //   searchWikipedia(inputArgs);
  // }
  // else if (arguments.first == 'wikipedia') {
  //   final inputArgs = arguments.length > 1 ? arguments.sublist(1) : null;
  //   searchWikipedia(inputArgs);
  // } else {
  //   printUsage();
  // }

  var runner = CommandRunner();
  await runner.run(arguments);
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

    // 输入读取
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

  // 调用API并等待返回结果
  // Call the API and await the result
  // 维基百科
  // WikiPedia
  var articleContent = await getWikipediaArticle(articleTitle);
  print(articleContent);

  // 百度百科
  // BaiduWiki
  // var articleContent = await getBaiduWikiArticle(articleTitle);
  // print(articleContent);

  // print('Here ya go!');
  // print('(Pretend this is an article about "$articleTitle" from Wikipedia.)');
}

Future<String> getWikipediaArticle(String articleTitle) async {
  final url = Uri.https(
    // Wikipedia API domain
    'en.wikipedia.org',

    // 注意1：
    // Uri.https 标准用法格式：
    // Uri.https(
    //   // 域名 domain
    //   String authority,
    //   // API路径 API path
    //   String unencodedPath,
    //   // 可选查询参数 Optional query parameters
    //   [Map<String, String>? queryParameters]
    // )
    // 由此(Uri.https格式)只允许存在一个域名
    //
    // NOTE1:
    // Uri.https Standard Format:
    // Uri.https(
    //   // Domain
    //   String authority,
    //   // API path
    //   String unencodedPath,
    //   // Optional query parameters
    //   [Map<String, String>? queryParameters]
    // )
    // Thus (Uri.https format) Only permit exist one domain

    // 注意2：
    // Wikipedia 的 REST API 是“按语言站点独立”的。
    // 不同语言的维基百科，文章标题可能不一致。
    //
    // 例如：
    // 英文：Dart_(programming_language)
    // 中文：Dart
    //
    // 因此，如果你将域名改为 zh.wikipedia.org，
    // 也需要同步修改文章标题，否则会返回 404。
    // 'zh.wikipedia.org',
    //
    // NOTE2:
    // The Wikipedia REST API is language-specific.
    // Different language versions of Wikipedia may use different article titles.
    //
    // For example:
    // English: https://en.wikipedia.org/api/rest_v1/page/summary/Dart_(programming_language)
    // Chinese: https://zh.wikipedia.org/api/rest_v1/page/summary/Dart
    //
    // So if you switch the domain to 'zh.wikipedia.org',
    // you may also need to change the article title accordingly.

    // API path for article summary
    '/api/rest_v1/page/summary/$articleTitle',
  );

  // Make the HTTP request
  final response = await http.get(url);

  if (response.statusCode == 200) {
    // Return the response body if successful
    return response.body;
  }

  // Return an error message if the request failed
  return 'Error: Failed to fetch article "$articleTitle". Status code: ${response.statusCode}';
}

// Future<String> getBaiduWikiArticle(String articleTitle) async {
//   final url = Uri.parse(
//     'https://baike.baidu.com/api/openapi/BaikeLemmaCardApi?scope=103&format=json&appid=379020&bk_key=${Uri.encodeComponent(articleTitle)}&bk_length=600',
//   );

//   try {
//     final response = await http.get(url);
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       final title = data['title'] ?? articleTitle;
//       final abstract = data['abstract'] ?? 'No abstract';
//       return "✅ $title\n$abstract";
//     } else {
//       return "Error: Status code ${response.statusCode}";
//     }
//   } catch (e) {
//     return "Error: $e";
//   }
// }

// Proxy Setting Detail
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..findProxy = (Uri) {
        return "PROXY 127.0.0.1:7890";
      };
  }
}

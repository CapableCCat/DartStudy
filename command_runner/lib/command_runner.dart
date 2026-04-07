/// A simple command runner to handle command-line arguments.
///
/// More extensive documentation for this library goes here.

// 将该文件声明为库，定义了可重用 Dart 代码单元的边界和公共接口。
// declares this file as a library,
// which defines the boundaries and public interface of a reusable unit of Dart code.
library;

// 关键：
// 使得 command_runner_base.dart 的声明可以被其他导入该包的包 command_runner。
// 如果没有这个导出语句， command_runner_base.dart 中的类和函数将成为 command_runner 包的私有，
// 你无法在 dartpedia 应用中使用它们。
// 
// Key: 
// makes declarations from command_runner_base.dart available to other packages that import the command_runner package.
// Without this export statement,
// the classes and functions within command_runner_base.dart would be private to the command_runner package,
// and you wouldn't be able to use them in your dartpedia application.
export 'src/command_runner_base.dart';


// TODO: Export any other libraries intended for clients of this package.

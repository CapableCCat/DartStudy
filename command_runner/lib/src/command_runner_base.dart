class CommandRunner {
  /// 使用给定的参数运行命令行应用程序逻辑。
  /// Runs the comman-line application logic with the given arguments.
  Future<void> run(List<String> input) async {
    print('CommandRunner received arguments: $input');
  }
}

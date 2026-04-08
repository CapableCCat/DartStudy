import 'dart:async';

import 'arguments.dart';

// 打印程序和参数使用情况。
//
// 当传入一个命令作为参数时，它会打印该命令的用法。
// 仅包含该命令及其选项和其他详细信息。
// 当设置了“verbose”标志时，它会打印所有命令的选项和详细信息。
//
// 此命令不会自动添加到 CommandRunner 实例中。
// 软件包用户应该使用 [CommandRunner.addCommand] 自行添加，
// 或者创建他们自己的命令来打印用法。
// 
// Prints program and argument usage.
//
// When given a command as an argument, it prints the usage of
// that command only, including its options and other details.
// When the flag 'verbose' is set, it prints options and details for all commands.
//
// This command isn't automatically added to CommandRunner instances.
// Packages users should add it themselves with [CommandRunner.addCommand],
// or create their own command that prints usage.

class HelpCommand extends Command {
  HelpCommand() {
    addFlag(
      'verbose',
      abbr: 'v',
      help: 'When true, this command will print each command and its options.',
    );
    addOption(
      'command',
      abbr: 'c',
      help:
          "When a command is passed as an argument, prints only that command's verbose usage.",
    );
  }
  @override
  String get name => 'help';

  @override
  String get description => 'Prints usage information to the command line.';

  @override
  String? get help => 'Prints this usage information';

  @override
  FutureOr<Object?> run(ArgResults args) async {
    var usage = runner.usage;
    for (var command in runner.commands) {
      usage += '\n ${command.usage}';
    }

    return usage;
  }
}

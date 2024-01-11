import 'dart:async';

typedef TaskCallback = void Function(bool success, dynamic result);
typedef TaskFutureFuc = Future Function();

class TaskQueue {
  TaskQueue({this.concurrenceCount = 1});

  int concurrenceCount;
  int _currentRunningCount = 0;
  final List<TaskItem> _taskList = [];

  Future addTask(TaskFutureFuc futureFunc, {dynamic param}) {
    Completer completer = Completer();
    TaskItem taskItem = TaskItem(
      futureFunc,
      (success, result) {
        if (success) {
          completer.complete(result);
        } else {
          completer.completeError(result);
        }
        _currentRunningCount = _currentRunningCount - 1;
        //递归任务
        _doTask();
      },
    );
    _taskList.add(taskItem);
    _doTask();
    return completer.future;
  }

  Future<void> _doTask() async {
    if (_currentRunningCount == concurrenceCount) {
      return;
    }
    if (_taskList.isEmpty) return;
    //获取先进入的任务
    TaskItem task = _taskList[0];
    _currentRunningCount = _currentRunningCount + 1;
    _taskList.removeAt(0);
    try {
      //执行任务
      var result = await task.futureFun();
      //完成任务
      task.callback(true, result);
    } catch (_) {
      task.callback(false, _.toString());
    }
  }
}

class TaskItem {
  final TaskFutureFuc futureFun;
  final TaskCallback callback;

  const TaskItem(
    this.futureFun,
    this.callback,
  );
}

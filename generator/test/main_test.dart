import 'package:dio/dio.dart';
import 'package:mock_web_server/mock_web_server.dart';
import 'package:test/test.dart';
import '../example/lib/example.dart';
import 'src/task_data.dart';

MockWebServer _server;
RestClient _client;
final _headers = {"Content-Type": "application/json"};
final dispatcherMap = <String, MockResponse>{};
void main() {
  setUp(() async {
    _server = MockWebServer();
    // _server.dispatcher = (HttpRequest request) async {
    //   var res = dispatcherMap[request.uri.path];
    //   if (res != null) {
    //     return res;
    //   }
    //   return new MockResponse()..httpCode = 404;
    // };
    await _server.start();
    _client = RestClient(Dio(), baseUrl: _server.url);
  });

  tearDown(() {
    _server.shutdown();
  });

  test("test empy task list", () async {
    _server.enqueue(
        body: demoEmptyListJson, headers: {"Content-Type": "application/json"});
    final tasks = await _client.getTasks();
    expect(tasks, isNotNull);
    expect(tasks.length, 0);
  });

  test("test task list", () async {
    _server.enqueue(body: demoTaskListJson, headers: _headers);
    final tasks = await _client.getTasks();
    expect(tasks, isNotNull);
    expect(tasks.length, 1);
  });

  test("test task detail", () async {
    _server.enqueue(headers: _headers, body: demoTaskJson);
    final task = await _client.getTask("id");
    expect(task, isNotNull);
    expect(task.id, demoTask.id);
    expect(task.avatar, demoTask.avatar);
    expect(task.name, demoTask.name);
    expect(task.createdAt, demoTask.createdAt);
  });

  test("create new task", () async {
    _server.enqueue(headers: _headers, body: demoTaskJson);
    final task = await _client.createTask(demoTask);
    expect(task, isNotNull);
    expect(task.id, demoTask.id);
    expect(task.avatar, demoTask.avatar);
    expect(task.name, demoTask.name);
    expect(task.createdAt, demoTask.createdAt);
  });

  test("update task all content", () async {
    _server.enqueue(headers: _headers, body: demoTaskJson);
    final task = await _client.updateTask("id", demoTask);
    expect(task, isNotNull);
    expect(task.id, demoTask.id);
    expect(task.avatar, demoTask.avatar);
    expect(task.name, demoTask.name);
    expect(task.createdAt, demoTask.createdAt);
  });

  test("update task part content", () async {
    _server.enqueue(headers: _headers, body: demoTaskJson);
    final task = await _client.updateTaskPart("id", {"name": "demo name 2"});
    expect(task, isNotNull);
    expect(task.id, demoTask.id);
    expect(task.avatar, demoTask.avatar);
    expect(task.name, demoTask.name);
    expect(task.createdAt, demoTask.createdAt);
  });

  test("delete a task", () async {
    _server.enqueue();
    await _client.deleteTask("id").then((it) {
      expect(null, null);
    });
  });
}

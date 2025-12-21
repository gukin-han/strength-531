import 'package:flutter/material.dart'; // 기본 UI import

void main() {
  // 플러터 앱의 시작점
  runApp(const MyApp()); // MyApp 위젯을 실행하겠다는 의미
}

class MyApp extends StatelessWidget {
  // 앱 전체의
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoPage(),
    ); // home은 앱을 처음 켰을때의 첫 화면
  }
}

// widget = 설정
// state = 실제 상태/동작

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List<Todo> todos = [];
  // 컨트롤러: 입력창의 값을 읽고/바꾸는 리모컨
  final TextEditingController _controller = TextEditingController();

  void _sortTodos() {
    todos.sort((a, b) {
      if (a.isDone == b.isDone) return 0;
      return a.isDone ? 1 : -1; // 완료 (true)는 뒤로
    });
  }

  // 메모리 정리?
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Expanded(child: TextField(controller: _controller)),
              ElevatedButton(
                onPressed: () {
                  final text = _controller.text.trim();
                  if (text.isEmpty) return;

                  setState(() {
                    todos.add(Todo(title: text));
                    _sortTodos();
                  });

                  _controller.clear();
                },
                child: const Text('추가'),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  secondary: IconButton(
                    onPressed: () {
                      setState(() {
                        todos.removeAt(index);
                        _sortTodos();
                      });
                    },
                    icon: const Icon(Icons.delete),
                  ),
                  title: Text(todo.title),
                  value: todo.isDone,
                  onChanged: (value) {
                    setState(() {
                      todo.isDone = value ?? false;
                      _sortTodos();
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Todo {
  String title;
  bool isDone;

  Todo({required this.title, this.isDone = false});
}

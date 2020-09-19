




import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:todo_app/todo.dart';
import 'package:uuid/uuid.dart';

part 'todos_state.freezed.dart';

@freezed
abstract class TodosState with _$TodosState {//TodosStateのクラスをチェック
  const factory TodosState({
    @Default(<Todo>[]) List<Todo> todos,//すべてのTodoが入るtodos
  }) = TodosStateData;//TodosStateDataであればデータの読み込みが終わったという判断ができるように
  const factory TodosState.loading() = TodosStateLoading;//TodosStateLoadingであればまだ読み込み中
}

//ここからDB
class TodosController extends StateNotifier<TodosState> with LocatorMixin {//LocatorMixinをmixinする事でcontextにあるproviderへのアクセスを容易する
  TodosController() : super(const TodosState.loading());

  final _uuid = Uuid();

  @override
  void initState() async {//initStateで5秒間ウエイトを入れ,初期データとしていくつかのTodoをstateへ設定
    super.initState();

    await Future<void>.delayed(const Duration(seconds: 3));

    // 初期データを設定、TodosStateLoadingからTodoStateDataへ変わるのでローディング完了の状態となる
    state = TodosState(
      todos: [
        Todo(id: _uuid.v4(), title: 'テスト'),
        Todo(id: _uuid.v4(), title: 'TodoApp'),
        Todo(id: _uuid.v4(), title: 'provider'),
      ],
    );
  }

  void add(String title) {//追加機能
    final currentState = state;//stateは不変なので更新する場合は現在のstateからcopywithでコピーするか、新規のstateで上書きする。
    if (currentState is TodosStateData) {
      // todosのクローンに新しいTodoを追加してstateを更新
      final todos = currentState.todos.toList()
        ..add(
          Todo(id: _uuid.v4(), title: title),
        );
      state = currentState.copyWith(
        todos: todos,
      );
    }
  }

  void toggle(Todo todo) {
    final currentState = state;
    if (currentState is TodosStateData) {
      // Todoを検索してcomplatedをtoggleし、stateを更新
      final todos = currentState.todos.map((t) {
        if (t == todo) {
          return t.copyWith(
            completed: !t.completed,
          );
        }
        return t;
      }).toList();
      state = TodosState(
        todos: todos,
      );
    }
  }
}
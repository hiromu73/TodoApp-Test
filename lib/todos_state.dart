



import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:todo_app/todo.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'todos_state.freezed.dart';



@freezed
abstract class TodosState with _$TodosState  {
  const factory TodosState( {//TodosStateのクラスをチェック
    @Default(<Todo>[]) List<Todo> todos,//すべてのTodoが入るtodos
  }) = TodosStateData;//TodosStateDataであればデータの読み込みが終わったという判断ができるように
  const factory TodosState.loading() = TodosStateLoading;//TodosStateLoadingであればまだ読み込み中
}

//ここからDB
class TodosController extends StateNotifier<TodosState> with LocatorMixin  {
//LocatorMixinをmixinする事でcontextにあるproviderへのアクセスを容易する
  TodosController() : super(const TodosState.loading());

  final _uuid = Uuid();

  @override
  void initState() async {
    super.initState();
    await Future<void>.delayed(const Duration(seconds: 3));//initStateで3秒間ウエイトを入れ,初期データとしていくつかのTodoをstateへ設定
    // 初期データを設定、TodosStateLoadingからTodoStateDataへ変わるのでローディング完了の状態となる

    var prefs = await SharedPreferences.getInstance();
    state = TodosState(
    todos: [
      Todo(id: _uuid.v4(), title: 'テスト'),
      Todo(id: prefs.getString('_uuid.v4()') , title: prefs.getString('title') ),
      Todo(id: prefs.getString('_uuid.v4()') , title: prefs.getString('title') ),
      Todo(id: prefs.getString('_uuid.v4()') , title: prefs.getString('title') ),
    ],
      );
  }

  void add(String title) async {//追加機能
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final currentState =  state;
    if (currentState is TodosStateData) {
      // todosのクローンに新しいTodoを追加してstateを更新
      final todos = currentState.todos.toList()
    ..add(
          Todo(id: _uuid.v4(), title: title),
    );
      prefs.setString('id',_uuid.v4());
      prefs.setString('title',title) ;
      prefs.setString('id',_uuid.v4());
      prefs.setString('title',title) ;
      state = currentState.copyWith(//stateはimmutableでメンバ変数を直接変更することはできないので、stateを更新するときは現在のstateからcopyWithでコピーするか、新規のstateで上書きする
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

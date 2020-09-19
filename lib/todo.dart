


import 'package:flutter/foundation.dart'; // *.freezed.dartで必要なのでimportしておく
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:state_notifier/state_notifier.dart';

part 'todo.freezed.dart';

@freezed
abstract class Todo with _$Todo {
  const factory Todo({
    String id,  // uuidで割りつける予定
    String title,
    @Default(false) bool completed,//@Defaultで初期値を与えるpage=0ではない
  }) = TodoData;
}

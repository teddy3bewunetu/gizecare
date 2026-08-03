/// Kind of note stored in the Notebook module.
enum NoteType {
  text,
  todo;

  static NoteType fromStorage(String value) {
    return switch (value) {
      'todo' => NoteType.todo,
      _ => NoteType.text,
    };
  }

  String get storageValue => name;
}

class TaskItem {
  final String id;
  final String title;
  final bool done;
  final String status;
  final String assignedTo;

  TaskItem({required this.id, required this.title, this.done = false, this.status = '', this.assignedTo = ''});
}

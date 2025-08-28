import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Data/Repositories/tasks_repository.dart';
import 'tasks_tab_page.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<ITasksRepository>(
      create: (ctx) => TasksRepository(ctx.read()),
      child: const TasksTabPage(),
    );
  }
}



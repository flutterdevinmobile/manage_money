import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'empty_state_widget.dart';

/// Base list page following DRY principle
abstract class BaseListPage<T, B extends BlocBase> extends StatefulWidget {
  const BaseListPage({super.key});
}

abstract class BaseListPageState<T, B extends BlocBase, P extends BaseListPage<T, B>> 
    extends State<P> {
  
  abstract final String title;
  abstract final IconData emptyIcon;
  abstract final String emptyTitle;
  abstract final String? emptySubtitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: buildAppBarActions(),
      ),
      body: buildBody(),
      floatingActionButton: buildFloatingActionButton(),
    );
  }

  Widget buildBody() {
    return BlocBuilder<B, dynamic>(
      builder: (context, state) {
        if (isLoadingState(state)) {
          return const Center(child: CircularProgressIndicator());
        } else if (isLoadedState(state)) {
          final items = getItemsFromState(state);
          if (items.isEmpty) {
            return EmptyStateWidget(
              icon: emptyIcon,
              title: emptyTitle,
              subtitle: emptySubtitle,
            );
          }
          return RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) => buildListItem(items[index], index),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  // Abstract methods to be implemented by subclasses
  bool isLoadingState(dynamic state);
  bool isLoadedState(dynamic state);
  List<T> getItemsFromState(dynamic state);
  Widget buildListItem(T item, int index);
  Future<void> onRefresh();
  
  // Optional methods with default implementations
  List<Widget> buildAppBarActions() => [];
  Widget? buildFloatingActionButton() => null;
}

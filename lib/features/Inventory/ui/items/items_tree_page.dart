import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/search_row.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/theme/app_colors.dart';
import 'package:gmcappclean/features/Inventory/bloc/inventory_bloc.dart';
import 'package:gmcappclean/features/Inventory/models/groups_model.dart';
import 'package:gmcappclean/features/Inventory/models/items_model.dart';
import 'package:gmcappclean/features/Inventory/models/items_tree_model.dart';
import 'package:gmcappclean/features/Inventory/services/inventory_services.dart';
import 'package:gmcappclean/features/Inventory/ui/groups/group_page.dart';
import 'package:gmcappclean/features/Inventory/ui/items/items_page.dart';
import 'package:gmcappclean/init_dependencies.dart';

class ItemsTreePage extends StatelessWidget {
  const ItemsTreePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InventoryBloc(
        InventoryServices(
          apiClient: getIt<ApiClient>(),
          authInteractor: getIt<AuthInteractor>(),
        ),
      )..add(GetItemsTree()),
      child: const ItemsTreePageChild(),
    );
  }
}

class ItemsTreePageChild extends StatefulWidget {
  const ItemsTreePageChild({super.key});

  @override
  State<ItemsTreePageChild> createState() => _ItemsTreePageChildState();
}

class _ItemsTreePageChildState extends State<ItemsTreePageChild> {
  final searchController = TextEditingController();

  List<ItemsTreeModel> _originalItemsTree = [];
  List<ItemsTreeModel> _filteredItemsTree = [];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('شجرة المواد'),
        ),
        body: BlocConsumer<InventoryBloc, InventoryState>(
          listener: (context, state) {
            if (state is InventorySuccess<ItemsModel>) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemsPage(itemsModel: state.result),
                ),
              );
            } else if (state is InventorySuccess<GroupsModel>) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GroupPage(
                    groupModel: state.result,
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is InventoryLoading) {
              return const Center(child: Loader());
            } else if (state is InventoryError) {
              return Center(child: Text(state.errorMessage));
            } else if (state is InventorySuccess) {
              if (_originalItemsTree.isEmpty) {
                _originalItemsTree = state.result ?? [];
                _filteredItemsTree = _originalItemsTree;
              }

              return Column(
                children: [
                  SearchRow(
                    textEditingController: searchController,
                    onSearch: () {
                      final query = searchController.text.trim();
                      setState(() {
                        if (query.isEmpty) {
                          _filteredItemsTree = _originalItemsTree;
                        } else {
                          _filteredItemsTree =
                              _filterTree(_originalItemsTree, query);
                        }
                      });
                      FocusScope.of(context).unfocus();
                    },
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: _filteredItemsTree.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  FontAwesomeIcons.solidClipboard,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'لا توجد بيانات لعرضها.',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: _filteredItemsTree.length,
                            itemBuilder: (context, index) {
                              final node = _filteredItemsTree[index];
                              return _buildTreeNode(node);
                            },
                          ),
                  ),
                ],
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  List<ItemsTreeModel> _filterTree(List<ItemsTreeModel> nodes, String query) {
    List<ItemsTreeModel> result = [];

    for (var node in nodes) {
      var filteredChildren = _filterTree(node.children, query);
      var filteredItems = node.items
          .where(
              (item) => item.name.contains(query) || item.code.contains(query))
          .toList();

      bool matchesNode = node.name.contains(query) || node.code.contains(query);

      if (matchesNode ||
          filteredChildren.isNotEmpty ||
          filteredItems.isNotEmpty) {
        result.add(ItemsTreeModel(
          id: node.id,
          name: node.name,
          code: node.code,
          type: node.type,
          children: filteredChildren,
          items: filteredItems,
        ));
      }
    }

    return result;
  }

  Widget _buildTreeNode(ItemsTreeModel node, {double indent = 0}) {
    final hasChildren = node.children.isNotEmpty || node.items.isNotEmpty;

    if (!hasChildren) {
      return Padding(
        padding: EdgeInsets.only(right: indent + 16, left: 8),
        child: Card(
          elevation: 1,
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: const Icon(Icons.label_outline,
                size: 20, color: Colors.blueGrey),
            title: Text(node.name,
                style: const TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text(node.code,
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            dense: true,
            onLongPress: () => context.read<InventoryBloc>().add(
                  GetOneGroup(id: node.id),
                ),
          ),
        ),
      );
    }

    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.only(right: indent, left: 8),
      child: GestureDetector(
        onLongPress: () => context.read<InventoryBloc>().add(
              GetOneGroup(id: node.id),
            ),
        child: ExpansionTile(
          key: PageStorageKey<int>(node.id),
          title: Text(
            '${node.name} (${node.code})',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          childrenPadding: const EdgeInsets.only(right: 12),
          children: [
            ...node.items.map((item) => Padding(
                  padding: EdgeInsets.only(right: indent + 16),
                  child: ListTile(
                    leading: Icon(
                      Icons.circle,
                      size: 18,
                      color: isDark
                          ? AppColors.gradient2
                          : AppColors.lightGradient2,
                    ),
                    title: Text(item.name),
                    subtitle: Text(item.code,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey)),
                    dense: true,
                    onLongPress: () => context.read<InventoryBloc>().add(
                          GetOneItem(id: item.id),
                        ),
                  ),
                )),
            ...node.children
                .map((child) => _buildTreeNode(child, indent: indent + 16)),
          ],
        ),
      ),
    );
  }
}

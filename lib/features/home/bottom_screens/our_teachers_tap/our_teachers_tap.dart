import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class OurTeachersTap extends StatefulWidget {
  @override
  _OurTeachersTapState createState() => _OurTeachersTapState();
}

class _OurTeachersTapState extends State<OurTeachersTap> {
  final String query = """
    query ChildCategories {
      childCategories(storeId: "A2Z", maxLevel: 3) {
        childCategories {
          name
          childCategories {
            childCategories {
              id
              imgSrc
              name
              level
              parent {
                name
              }
            }
          }
        }
      }
    }
  """;

  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _filteredCategories = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterCategories);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCategories() {
    setState(() {
      if (_searchController.text.isEmpty) {
        _filteredCategories = _categories;
      } else {
        _filteredCategories = _categories
            .where((category) =>
        category['name']
            ?.toLowerCase()
            .contains(_searchController.text.toLowerCase()) ??
            false)
            .toList();
      }
    });
  }

  Future<void> _fetchCategories(QueryResult result) async {
    if (!result.isLoading && !result.hasException) {
      final dynamic rootCategories =
          result.data?['childCategories']?['childCategories'] ?? [];
      List<Map<String, dynamic>> extractedCategories =
      _extractCategories(rootCategories);
      if (_categories != extractedCategories) {
        setState(() {
          _categories = extractedCategories;
          _filterCategories();
        });
      }
    }
  }

  List<Map<String, dynamic>> _extractCategories(dynamic rootCategories) {
    final List<Map<String, dynamic>> extractedCategories = [];
    if (rootCategories is List) {
      for (var category in rootCategories) {
        if (category is Map<String, dynamic> &&
            category['childCategories'] is List) {
          for (var subCategory in category['childCategories']) {
            if (subCategory is Map<String, dynamic> &&
                subCategory['childCategories'] is List) {
              extractedCategories.addAll(List<Map<String, dynamic>>.from(
                  subCategory['childCategories']));
            }
          }
        }
      }
    }
    return extractedCategories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: Query(
              options: QueryOptions(
                document: gql(query),
              ),
              builder: (QueryResult result,
                  {VoidCallback? refetch, FetchMore? fetchMore}) {
                if (result.hasException) {
                  return Text(result.exception.toString());
                }

                if (result.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Fetch and process categories without calling setState directly in the build
                _fetchCategories(result);

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 2,
                  ),
                  itemCount: _filteredCategories.length,
                  itemBuilder: (context, index) {
                    final category = _filteredCategories[index];
                    return Card(
                      child: Column(
                        children: [
                          category['imgSrc'] != null
                              ? Image.network(
                            category['imgSrc'],
                            height: 100,
                            fit: BoxFit.cover,
                          )
                              : Container(
                              height: 100, color: Colors.grey[300]),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              category['name'] ?? 'Unknown Category',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                              'Parent: ${category['parent']?['name'] ?? 'Unknown Parent'}'),
                        ],
                      ),
                    );
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

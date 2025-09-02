import 'package:flutter/material.dart';

import '../widgets/administrator.dart';
import 'add_administrator_page.dart';

class AdministrativePage extends StatefulWidget {
  @override
  _AdministrativePageState createState() => _AdministrativePageState();
}

class _AdministrativePageState extends State<AdministrativePage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'الكل';
  List<String> _filters = ['الكل', 'منسق', 'HR','HR(عام)'];

  List<Administrator> _administrators = [
    Administrator(
        id: '1',
        name: 'حذيفة إبراهيم جوهر',
        position: 'منسق',
        department: 'قسم التطوع'),
    Administrator(
        id: '2',
        name: 'أحمد محمد سعيد',
        position: 'HR',
        department: 'الموارد البشرية'),
    Administrator(
        id: '3',
        name: 'فاطمة علي حسن',
        position: 'HR',
        department: 'الموارد البشرية'),
    Administrator(
        id: '4',
        name: 'محمد عبد الله',
        position: 'HR',
        department: 'الموارد البشرية'),
    Administrator(
        id: '5',
        name: 'سارة يوسف',
        position: 'HR(عام)',
        department: 'الموارد البشرية'),
    Administrator(
        id: '6', name: 'خالد أحمد', position: 'منسق', department: 'قسم التطوع'),
  ];

  List<Administrator> get _filteredAdministrators {
    List<Administrator> filtered = _administrators;

    if (_selectedFilter != 'الكل') {
      filtered = filtered.where((a) => a.position == _selectedFilter).toList();
    }

    if (_searchController.text.isNotEmpty) {
      filtered = filtered
          .where((a) =>
              a.name.contains(_searchController.text) ||
              a.position.contains(_searchController.text) ||
              a.department.contains(_searchController.text))
          .toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Center(
          child: Text(
            'الفريق الإداري',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF2E4A8B),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      // More circular border
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.filter_alt_sharp,
                          color: Color(0xFF2E4A8B)),
                      onPressed: _showFilterDialog,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        // More circular border
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: 'البحث عن إداري',
                          suffixIcon:
                              Icon(Icons.search, color: Colors.grey[400]),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الإداريين (كل الأقسام)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E4A8B),
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: _filters
                        .map(
                          (filter) => Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: FilterChip(
                              label: Text(filter),
                              selected: _selectedFilter == filter,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedFilter = filter;
                                });
                              },
                              selectedColor:
                                  Color(0xFF2E4A8B).withOpacity(0.2),
                              checkmarkColor: Color(0xFF2E4A8B),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: _filteredAdministrators.length,
                itemBuilder: (context, index) {
                  final admin = _filteredAdministrators[index];
                  return _buildAdministratorCard(admin);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddAdministratorPage()),
          );
        },
        backgroundColor: Color(0xFF2E4A8B),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildAdministratorCard(Administrator admin) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey[300],
            child: Text(
              admin.name.split(' ')[0][0] + admin.name.split(' ')[1][0],
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  admin.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.right,
                ),
                Text(
                  admin.department,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getPositionColor(admin.position).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              admin.position,
              style: TextStyle(
                color: _getPositionColor(admin.position),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getPositionColor(String position) {
    switch (position) {
      case 'منسق':
        return Colors.blue;
      case 'HR':
        return Colors.green;
      case 'HR(عام)':
        return Colors.orange;
      default:
        return Color(0xFF2E4A8B);
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تصفية حسب المنصب'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _filters
              .map((filter) => RadioListTile<String>(
                    title: Text(filter),
                    value: filter,
                    groupValue: _selectedFilter,
                    onChanged: (value) {
                      setState(() {
                        _selectedFilter = value!;
                      });
                      Navigator.pop(context);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }
}

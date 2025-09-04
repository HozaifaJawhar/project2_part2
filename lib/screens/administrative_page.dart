import 'package:ammerha_management/screens/user_account_page.dart';
import 'package:ammerha_management/widgets/basics/drawer.dart';
import 'package:ammerha_management/widgets/basics/search_textfield.dart';
import 'package:flutter/material.dart';
import '../config/theme/app_theme.dart';
import '../widgets/administrator.dart';
import 'create_account_page.dart';

class AdministrativePage extends StatefulWidget {
  @override
  _AdministrativePageState createState() => _AdministrativePageState();
}

class _AdministrativePageState extends State<AdministrativePage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'الكل';
  List<String> _filters = ['الكل', 'منسق', 'HR'];

  List<Administrator> _administrators = [
    Administrator(
      id: '1',
      name: 'حذيفة إبراهيم جوهر',
      position: 'منسق',
      department: 'قسم التطوع',
    ),
    Administrator(
      id: '2',
      name: 'أحمد محمد سعيد',
      position: 'HR',
      department: 'الموارد البشرية',
    ),
    Administrator(
      id: '3',
      name: 'فاطمة علي حسن',
      position: 'HR',
      department: 'الموارد البشرية',
    ),
    Administrator(
      id: '4',
      name: 'محمد عبد الله',
      position: 'HR',
      department: 'الموارد البشرية',
    ),
    Administrator(
      id: '5',
      name: 'سارة يوسف',
      position: 'HR',
      department: 'الموارد البشرية',
    ),
    Administrator(
      id: '6',
      name: 'خالد أحمد',
      position: 'منسق',
      department: 'قسم التطوع',
    ),
  ];

  List<Administrator> get _filteredAdministrators {
    List<Administrator> filtered = _administrators;

    if (_selectedFilter != 'الكل') {
      filtered = filtered.where((a) => a.position == _selectedFilter).toList();
    }

    if (_searchController.text.isNotEmpty) {
      filtered = filtered
          .where(
            (a) =>
                a.name.contains(_searchController.text) ||
                a.position.contains(_searchController.text) ||
                a.department.contains(_searchController.text),
          )
          .toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
          backgroundColor: AppColors.primary,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.notifications_outlined, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
        drawer: CustomDrawer(),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // color: Colors.white,
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
                        icon: Icon(
                          Icons.filter_alt_sharp,
                          color: AppColors.primary,
                        ),
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
                        child: SearchTextfield(hintText: 'البحث عن إداري'),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'الإداريين (كل الأقسام)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  SizedBox(height: 8),
                ],
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
              MaterialPageRoute(builder: (context) => CreateAccountPage()),
            );
          },
          tooltip: 'Increment',
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildAdministratorCard(Administrator admin) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserAccountPage()),
        );
      },
      child: Container(
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
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
              ),
              child: const Image(
                image: AssetImage("assets/images/profile.png"),
                fit: BoxFit.cover,
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
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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
      ),
    );
  }

  Color _getPositionColor(String position) {
    switch (position) {
      case 'منسق':
        return AppColors.primary;
      case 'HR':
        return AppColors.primary;
      default:
        return AppColors.primary;
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
              .map(
                (filter) => RadioListTile<String>(
                  title: Text(filter),
                  value: filter,
                  groupValue: _selectedFilter,
                  onChanged: (value) {
                    setState(() {
                      _selectedFilter = value!;
                    });
                    Navigator.pop(context);
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

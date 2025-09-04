import 'package:ammerha_management/widgets/basics/drawer.dart';
import 'package:ammerha_management/widgets/basics/search_textfield.dart';
import 'package:flutter/material.dart';
import '../config/theme/app_theme.dart';
import '../widgets/volunteers.dart';

class VolunteersPage extends StatefulWidget {
  @override
  _VolunteersPageState createState() => _VolunteersPageState();
}

class _VolunteersPageState extends State<VolunteersPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'الكل';
  List<String> _filters = [
    'الكل',
    'صحة نفسية',
    'طفل',
    'كبار السن',
    'تعليم',
    'طبي',
  ];

  List<Volunteer> _volunteers = [
    Volunteer(
      id: '1',
      name: 'حديقة إبراهيم جوهر',
      department: 'صحة نفسية',
      opportunities: 25,
      hasGoldBadge: true,
    ),
    Volunteer(
      id: '2',
      name: 'سارة محمد أحمد',
      department: 'طفل',
      opportunities: 18,
      hasGoldBadge: true,
    ),
    Volunteer(
      id: '3',
      name: 'محمد عبد الله سعيد',
      department: 'كبار السن',
      opportunities: 32,
      hasGoldBadge: true,
    ),
    Volunteer(
      id: '4',
      name: 'فاطمة علي حسن',
      department: 'تعليم',
      opportunities: 25,
      hasGoldBadge: false,
    ),
    Volunteer(
      id: '5',
      name: 'أحمد خالد محمود',
      department: 'طبي',
      opportunities: 28,
      hasGoldBadge: true,
    ),
    Volunteer(
      id: '6',
      name: 'نور الهدى يوسف',
      department: 'صحة نفسية',
      opportunities: 22,
      hasGoldBadge: true,
    ),
  ];

  List<Volunteer> get _filteredVolunteers {
    List<Volunteer> filtered = _volunteers;

    if (_selectedFilter != 'الكل') {
      filtered = filtered
          .where((v) => v.department == _selectedFilter)
          .toList();
    }

    if (_searchController.text.isNotEmpty) {
      filtered = filtered
          .where(
            (v) =>
                v.name.contains(_searchController.text) ||
                v.department.contains(_searchController.text),
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
          title: const Center(
            child: Text(
              'إدارة المتطوعين',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          backgroundColor: AppColors.primary,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
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
              Padding(
                padding: const EdgeInsets.all(16.0),
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
                        child: SearchTextfield(hintText: 'البحث عن متطوع'),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(
                  'المتطوعين',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: _filteredVolunteers.length,
                  itemBuilder: (context, index) {
                    final volunteer = _filteredVolunteers[index];
                    return _buildVolunteerCard(volunteer);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVolunteerCard(Volunteer volunteer) {
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
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
              // TODO: Replace this with NetworkImage or AssetImage
              // Example: DecorationImage(image: NetworkImage(volunteer.photoUrl), fit: BoxFit.cover)
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
                  volunteer.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.right,
                ),
                Text(
                  volunteer.department,
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
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                if (volunteer.hasGoldBadge) ...[
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.amber,
                      // TODO: Replace this with actual gold badge image
                      // Example: DecorationImage(image: AssetImage('assets/gold_badge.png'), fit: BoxFit.cover)
                    ),
                    child: const Image(
                      image: AssetImage("assets/icons/medal3.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  '${volunteer.opportunities} فرصة',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تصفية حسب القسم'),
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

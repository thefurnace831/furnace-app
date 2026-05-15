import 'package:flutter/material.dart';
import 'package:furnace_app/api/user.dart';
import 'package:furnace_app/furnace_ui.dart';

// Screen used for viewing and searching students/users.
class ViewStudentsScreen extends StatefulWidget {
  const ViewStudentsScreen({super.key});

  @override
  State<ViewStudentsScreen> createState() => _ViewStudentsScreenState();
}

class _ViewStudentsScreenState extends State<ViewStudentsScreen> {

  // Controller used for the search text field.
  final TextEditingController _searchController = TextEditingController();

  // Temporary mock student data for testing.
  // This can later be replaced with real data from Back4App.
  final List<User> _students = [
    User(
      userId: '1',
      name: 'Test Student',
      email: 'teststudent@email.com',
    ),
    User(
      userId: '2',
      name: 'Alex Johnson',
      email: 'alex@email.com',
    ),
    User(
      userId: '3',
      name: 'Maria Lopez',
      email: 'maria@email.com',
    ),
  ];

  // List that stores filtered student results.
  List<User> _filteredStudents = [];

  @override
  void initState() {
    super.initState();

    // Start by displaying all students.
    _filteredStudents = _students;
  }

  @override
  void dispose() {

    // Dispose controller when screen is removed from memory.
    _searchController.dispose();

    super.dispose();
  }

  // Filters students based on search input.
  void _filterStudents(String searchText) {

    // Makes search lowercase and trims spaces.
    final query = searchText.toLowerCase().trim();

    setState(() {

      // If search field is empty, show all students.
      if (query.isEmpty) {

        _filteredStudents = _students;

      } else {

        // Filter by student name or email.
        _filteredStudents = _students.where((student) {

          final name = student.name.toLowerCase();
          final email = student.email.toLowerCase();

          return name.contains(query) || email.contains(query);

        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text('The Furnace'),
      ),

      body: FurnaceBackground(

        pattern: true,

        child: FurnaceContent(

          maxWidth: 560,

          child: FurnacePanel(

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.stretch,

              children: [

                // Furnace logo/header section.
                const FurnaceBrandHeader(
                  title: 'Admin Dashboard',
                  subtitle: 'Viewing All Users',
                  logoWidth: 220,
                ),

                const SizedBox(height: 20),

                // Search bar for filtering students.
                TextField(

                  controller: _searchController,

                  // Runs filtering every time user types.
                  onChanged: _filterStudents,

                  decoration: InputDecoration(

                    hintText: 'Search students',

                    prefixIcon: const Icon(Icons.search),

                    // Clear button only appears if text exists.
                    suffixIcon: _searchController.text.isEmpty
                        ? null
                        : IconButton(

                      icon: const Icon(Icons.clear),

                      onPressed: () {

                        // Clear search field.
                        _searchController.clear();

                        // Reset student list.
                        _filterStudents('');
                      },
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Expanded allows the list to fill remaining space.
                Expanded(

                  // Display message if no students are found.
                  child: _filteredStudents.isEmpty

                      ? const Center(
                    child: Text('No students found.'),
                  )

                  // Otherwise display filtered student list.
                      : ListView.separated(

                    itemCount: _filteredStudents.length,

                    separatorBuilder: (context, index) {
                      return const Divider(height: 1);
                    },

                    itemBuilder: (context, index) {

                      // Current student item.
                      final student = _filteredStudents[index];

                      return ListTile(

                        leading: const Icon(Icons.person),

                        title: Text(student.name),

                        subtitle: Text(student.email),

                        // Placeholder for future student detail navigation.
                        onTap: () {

                          debugPrint(
                            'Selected student: ${student.name}',
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

class StudentCard extends StatelessWidget {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String schoolName;
  final String grade;

  const StudentCard({super.key, required this.fullName, required this.email, required this.phoneNumber, required this.schoolName, required this.grade});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(21, 19, 21, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.person, size: 48),
                const SizedBox(width: 8),
                 Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        email,
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFFBBBAB9),
                        ),
                      ),
                      SizedBox(height: 1),
                      Text(
                        phoneNumber,
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFFBBBAB9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 7),
            Text(
              schoolName,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              grade,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

@Preview(name: 'Student card preview')
Widget StudentCardPreview() {
  return StudentCard(
    fullName: "Cody Hopkins",
    email: "cody@cody.com",
    phoneNumber: "(111) 111-2222",
    schoolName: "Oak Ridge High School",
    grade: "Grade 123",
  );
}

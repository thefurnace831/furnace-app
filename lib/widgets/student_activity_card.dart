import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:furnace_app/api/time_log.dart';

class StudentActivityCard extends StatelessWidget {
  final List<TimeLog> logs;
  final int sessionsAttended;
  final String lastSessionAttended;

  const StudentActivityCard({super.key, required this.logs, required this.sessionsAttended, required this.lastSessionAttended});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: const BorderSide(color: Color(0xFFE7DED2), width: 1)),
      child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 19, 17, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "# sessions attended",
                    style: TextStyle(
                        fontSize: 8,
                        letterSpacing: 0.96,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF69655D)),
                  ),
                  Text(
                    "${sessionsAttended} sessions",
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.96,
                    ),
                  )
                ],
              ),
              Container(height: 13),
              Divider(
                height: 1,
                color: Color(0xFFF4EDE3),
              ),
              Container(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "last session joined",
                    style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.96,
                        color: Color(0xFF69655D)),
                  ),
                  Text(
                    lastSessionAttended,
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.96,
                    ),
                  )
                ],
              ),
              Container(height: 16),
              Divider(
                height: 1,
                color: Color(0xFFF4EDE3),
              ),
              Container(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "session history ",
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.96,
                      color: Color(0xFF69655D),
                    ),
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: logs.length,
                      itemBuilder: (context, index) {
                        final log = logs[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 7),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                log.room,
                                style: const TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.96,
                                ),
                              ),
                              Text(
                                log.totalTime,
                                style: const TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.96,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              )
            ],
          )),
    );
  }
}

@Preview(name: 'Student activity card preview')
Widget StudentActivityCardPreview() {
  List<TimeLog> logs = [

  ];
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: StudentActivityCard(
          sessionsAttended: 5,
          lastSessionAttended: "2 weeks ago",
          logs: logs,
        ),
      ),
    ),
  );
}

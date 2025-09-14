import 'package:flutter/material.dart';
import 'package:planning/main_classes.dart';

class EventsListPage extends StatefulWidget {
  @override
  _EventsListPageState createState() => _EventsListPageState();
}

class _EventsListPageState extends State<EventsListPage> {
  
  Color _getStatusColor(String status) {
    switch (status) {
      case "Present":
        return Colors.green;
      case "Absent":
        return Colors.red;
      case "Not defined":
      default:
        return Colors.grey;
    }
  }

  void _updateParticipantStatus(Event event, Person person, String newStatus, String prev_status) {
    setState(() {
      for (int i = 0; i < event.event_participants.length; i++) {
        if (event.event_participants[i].$1 == person) {
          event.event_participants[i] = (person, newStatus);
          break;
        }
      }
      
      for (int i = 0; i < person.events_participated.length; i++) {
        if (person.events_participated[i].$1 == event) {
          person.events_participated[i] = (event, newStatus);
          if(newStatus =="Absent"){
            person.n_abcenses++;
          }
          if(prev_status =="Absent" && newStatus=="Present"){
            person.n_abcenses--;
          }
          break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Events'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'All Events (${list_of_events.length})',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            
            if (list_of_events.isEmpty)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event_busy, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No events created yet',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Go back to create your first event!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: list_of_events.length,
                  itemBuilder: (context, index) {
                    final event = list_of_events[index];
                    return Card(
                      margin: EdgeInsets.only(bottom: 8),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Icon(Icons.event, color: Colors.white),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event.event_title,
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  SizedBox(height: 4),
                                  Text('Date: ${event.event_date.toString().split(' ')[0]}'),
                                  Text('Time: ${event.event_time.format(context)}'),
                                  Text('Participants: ${event.event_participants.length}'),
                                ],
                              ),
                            ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Event Details"),
                                      content: StatefulBuilder(
                                        builder: (BuildContext context, StateSetter setDialogState) {
                                          return SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Event name: ${event.event_title}"),
                                                Text("Date: ${event.event_date.toString().split(' ')[0]}"),
                                                Text("Time: ${event.event_time.format(context)}"),
                                                Text("Number of participants: ${event.event_participants.length}"),
                                                SizedBox(height: 10),
                                                Text("Participants:", style: TextStyle(fontWeight: FontWeight.bold)),
                                                if (event.event_participants.isEmpty)
                                                  Text("No participants added", style: TextStyle(fontStyle: FontStyle.italic))
                                                else
                                                  ...event.event_participants.map((participant) => Padding(
                                                    padding: EdgeInsets.only(left: 16),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: 8,
                                                          height: 8,
                                                          decoration: BoxDecoration(
                                                            color: _getStatusColor(participant.$2),
                                                            shape: BoxShape.circle,
                                                          ),
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text("${participant.$1.name}"),
                                                        SizedBox(width: 8),
                                                        DropdownButton<String>(
                                                          value: participant.$2,
                                                          hint: Text('Define a status'),
                                                          items: precense.map((String s) {
                                                            return DropdownMenuItem<String>(
                                                              value: s,
                                                              child: Text(s),
                                                            );
                                                          }).toList(),
                                                          onChanged: (String? newState) {
                                                            if (newState != null) {
                                                              setDialogState(() {
                                                                _updateParticipantStatus(event, participant.$1, newState, participant.$2);
                                                              });
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(),
                                          child: Text("Close"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text("Details"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightBlue,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                    );
                  },
                ),
              ),
            
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Back to Calendar'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
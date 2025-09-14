import 'package:planning/main_classes.dart';
import 'package:flutter/material.dart';

class Person_details extends StatefulWidget{
  @override
    State<Person_details> createState() => Person_details_State();
}

class Person_details_State extends State<Person_details>{
  Person? selected_person; // Move this to class level

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Person Details",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
          
          DropdownButton<Person>(
              value: selected_person,
              hint: Text('Choose a person'),
              isExpanded: true, // Make dropdown full width
              items: defaultParticipants.map((Person person) {
                return DropdownMenuItem<Person>(
                  value: person,
                  child: Text(person.name),
                );
              }).toList(),
              onChanged: (Person? newPerson) {
                setState(() {
                  selected_person = newPerson;
                });
              },
            ),
            SizedBox(height: 20),
            
            if (selected_person != null) ...[
              Container(
                width: double.infinity,  
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selected_person!.name,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text("Position: ${selected_person!.position}"),
                        Text("Absences: ${selected_person!.n_abcenses}"),
                        Text("Events participated: ${selected_person!.events_participated.length}"),
                      ],
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: 16),
              
              if(selected_person!.events_participated.length != 0) ...[
                Text(
                  "Events History:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                ...selected_person!.events_participated.map((event) => Card(
                  margin: EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getStatusColor(event.$2),
                      child: Icon(Icons.event, color: Colors.white, size: 16),
                    ),
                    title: Text(
                      event.$1.event_title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Text("Status: ${event.$2}"),
                        Text("Date: ${_formatDate(event.$1.event_date)}"),
                        Text("Time: ${event.$1.event_time.format(context)}"),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                )),
              ] else ...[
                Text(
                  "No events participated yet",
                  style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                ),
              ]
            ] else ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  children: [
                    Icon(Icons.person_outline, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      "No person selected",
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ]

        ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Present":
        return Colors.green;
      case "Absent":
        return Colors.red;
      case "No status":
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }
}
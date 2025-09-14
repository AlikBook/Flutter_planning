import 'package:flutter/material.dart';
import 'package:planning/main_classes.dart';  
final TextEditingController _dateController = TextEditingController();
final TextEditingController _timeController = TextEditingController();
final TextEditingController _eventNameController = TextEditingController();




class MyForm extends StatefulWidget{
  final VoidCallback? onEventCreated; // Add callback parameter
  
  const MyForm({Key? key, this.onEventCreated}) : super(key: key);
  
  @override
    State<MyForm> createState() => MyForm_State();
}

class MyForm_State extends State<MyForm>{
  String _event_name = "";
  DateTime? _event_date;
  List<(Person,String)> participants = [];
  int n_participants = 0;
  Person? selected_person;
  TimeOfDay? _eventTime;

  

  void _add_person_to_event(Person? person_to_add){
    if (person_to_add != null) {
      bool alreadyExists = participants.any((participant) => participant.$1 == person_to_add);
      
      if (!alreadyExists) {
        setState(() {
          participants.add((person_to_add, precense[2])); 
          n_participants++;
          print("Added participant: ${person_to_add.name}. Total participants: ${participants.length}");
        });
      } else {
        print("Failed to add participant. ${person_to_add.name} is already in the list");
      }
    } else {
      print("Failed to add participant. person_to_add is null");
    }
  }

  void _resetForm() {
    print("Before reset - participants list length: ${participants.length}");
    setState(() {
      _event_name = "";
      _event_date = null;
      _eventTime = null;
      participants.clear();
      n_participants = 0;
      selected_person = null;
      _dateController.clear();
      _timeController.clear();
      _eventNameController.clear();
      print("After reset - participants list cleared");
    });
  }

  void _create_event(){
    if (_event_name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event name is required')),
      );
      return;
    }
    
    if (_eventTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event time is required')),
      );
      return;
    }
    
    if (_event_date == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event date is required')),
      );
      return;
    }

    Event new_event = Event(
      _event_name,
      _eventTime!, 
      _event_date!, 
      List.from(participants)
    );

    print("Creating event with ${participants.length} participants:");
    for (var participant in participants) {
      print("  - ${participant.$1.name} (${participant.$2})");
    }
    print("Event participants list: ${new_event.event_participants.length}");

    bool eventExists = list_of_events.any((event) => 
      event.event_title == _event_name &&
      event.event_date.year == _event_date!.year &&
      event.event_date.month == _event_date!.month &&
      event.event_date.day == _event_date!.day &&
      event.event_time.hour == _eventTime!.hour &&
      event.event_time.minute == _eventTime!.minute
    );

    if (eventExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An event with this name, date, and time already exists')),
      );
      return;
    }

    for (var participant in participants) {

      participant.$1.events_participated.add((new_event,precense[2]));
    }
    
    list_of_events.add(new_event);
    
    // Notify parent widget to refresh
    if (widget.onEventCreated != null) {
      widget.onEventCreated!();
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Event "${_event_name}" created successfully!')),
    );
    
    _resetForm();
  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double formWidth = constraints.maxWidth > 600 ? 400 : constraints.maxWidth * 0.9;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
              
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              width: formWidth,
              constraints: BoxConstraints(
                minWidth: 250,
                maxWidth: 400,
              ),
              child: 
                TextField(
                      controller: _eventNameController,
                      onChanged: (value) => setState(() => _event_name = value),
                      cursorColor: Colors.black,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: "Enter the name of the event :",
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(),
                        hoverColor: Colors.black,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1),
                        ),
                      ),
                    ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              width: formWidth,
              constraints: BoxConstraints(
                minWidth: 250,
                maxWidth: 400,
              ),
              child: 
                TextField(
                  controller: _dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Select event date",
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _event_date ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _event_date = pickedDate;
                        _dateController.text = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                      });
                    }
                  },
                ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              width: formWidth,
              constraints: BoxConstraints(
                minWidth: 250,
                maxWidth: 400,
              ),
              child: TextField(
                controller: _timeController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Select event time",
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.access_time),
                ),
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: _eventTime ?? TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      _eventTime = pickedTime;
                      _timeController.text = pickedTime.format(context);
                    });
                  }
                },
              ),
            ),

            Container(
              width: formWidth,
              constraints: BoxConstraints(
                minWidth: 250,
                maxWidth: 400,
              ),
              child: constraints.maxWidth < 400 
                ? Column(  // Stack vertically on small screens
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DropdownButton<Person>(
                        value: selected_person,
                        hint: Text('Choose a person'),
                        isExpanded: true,
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
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          _add_person_to_event(selected_person);
                        },
                        child: Text("Add person"),
                      ),
                    ],
                  )
                : Row(  // Keep side by side on larger screens
                    children: [
                      Expanded(
                        child: DropdownButton<Person>(
                          value: selected_person,
                          hint: Text('Choose a person'),
                          isExpanded: true,
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
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          _add_person_to_event(selected_person);
                        },
                        child: Text("Add person"),
                      ),
                    ],
                  ),
            ),
            Text("List of participants :"),
            Text(n_participants.toString()),
            ...participants.map((participant) => ListTile(
              leading: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              ),
              title: Text("${participant.$1.name} - ${participant.$2}"),
            )),
            SizedBox(height: 20),
            Container(
              width: formWidth,
              constraints: BoxConstraints(
                minWidth: 250,
                maxWidth: 400,
              ),
              child: ElevatedButton(
                onPressed: () {
                  _create_event();
                },
                child: Text("Create event"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 45),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

}
import 'package:flutter/material.dart';

final List<String> precense = ["Present","Absent","No status"];

final List<Person> defaultParticipants = [
  Person('Alice', 'Manager', 0),
  Person('Bob', 'Developer', 0),
  Person('Carol', 'Designer', 0),
];

final List<Event> list_of_events = [];




class Person{
  final String name;
  final String position;
  int n_abcenses;
  List<(Event,String)> events_participated = [];
  Person(this.name,this.position,this.n_abcenses);
  
}


class Event {
    String event_title;
    TimeOfDay event_time;
    DateTime event_date;
    List<(Person, String)> event_participants;


    Event(this.event_title, this.event_time, this.event_date,this.event_participants);
  }





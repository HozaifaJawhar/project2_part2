import 'package:ammerha_management/config/theme/app_theme.dart';
import 'package:ammerha_management/core/models/event.dart';
import 'package:ammerha_management/widgets/basics/drawer.dart';
import 'package:ammerha_management/widgets/events/ended_event_card.dart';

import 'package:flutter/material.dart';

class EndedEvent extends StatefulWidget {
  const EndedEvent({super.key});

  @override
  State<EndedEvent> createState() => _EndedEventState();
}

class _EndedEventState extends State<EndedEvent> {
  @override
  Widget build(BuildContext context) {
    List<Event> events = [
      Event(
        id: 1,
        name: 'name1',
        status: 'status1',
        description: 'description1',
        date: null,
      ),
      Event(
        id: 2,
        name: 'name2',
        status: 'status2',
        description: 'description2',
        date: null,
      ),
      Event(
        id: 3,
        name: 'name3',
        status: 'status3',
        description: 'description3',
        date: null,
      ),
    ];
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: Text(
          'تقييم الفعاليات ',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontFamily: 'Cairo',
            fontSize: 25,
            color: AppColors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(
                size: 30,
                Icons.notifications_none_outlined,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
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
              padding: const EdgeInsets.only(top: 16, right: 16),
              child: Text(
                'الفعاليات المنتهية ',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Cairo',
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
                child: ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return EndedEventCard(event: event);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

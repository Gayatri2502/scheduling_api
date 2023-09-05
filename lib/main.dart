import 'package:flutter/material.dart';
import 'package:scheduling_api/demo.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scheduling API ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Scheduling API '),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime _today = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> events = {};
  ValueNotifier<List<Event>> selectedEvent = ValueNotifier([]);
  TextEditingController eventController = new TextEditingController();
  List<Event> getEventForDay(DateTime day) {
    return events[day] ?? [];
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _today;
    selectedEvent = ValueNotifier(getEventForDay(_selectedDay!));
    eventController.clear();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime today) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _today = today;
        _selectedDay = selectedDay;
        selectedEvent.value = getEventForDay(_selectedDay!);
      });
    }
  }
  // void _onDateSelected (DateTime day, DateTime selectedDay) {
  //   setState(() {
  //     _today = day;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  scrollable: true,
                  title: const Text(
                    'scheduled Event Name: ',
                    style: TextStyle(fontSize: 15),
                  ),
                  content: Padding(
                    padding: const EdgeInsets.all(6),
                    child: TextField(
                      controller: eventController,
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          events.addAll({
                            _selectedDay!: [Event(title: eventController.text)]
                          });
                          Navigator.of(context).pop();
                          selectedEvent.value = getEventForDay(_selectedDay!);
                        },
                        child: const Text('Add'))
                  ],
                );
              });
        },
        child: const Icon(Icons.add),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Schedule your Appointment :',
            ),
            Text(
              _today.toString().split(' ')[0],
            ),
            // SizedBox(
            //   height: 20,
            // ),
            // ElevatedButton(onPressed: () {}, child: Text('Calendar')),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TableCalendar(
                rowHeight: 60,
                eventLoader: getEventForDay,
                daysOfWeekHeight: 25,
                selectedDayPredicate: (day) => isSameDay(day, _today),
                availableGestures: AvailableGestures.all,
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: _today,
                onDaySelected: _onDaySelected,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: ValueListenableBuilder<List<Event>>(
                  valueListenable: selectedEvent,
                  builder: (context, value, _) {
                    return ListView.builder(
                        itemCount: value.length,
                        itemBuilder: (context, i) {
                          final eventName = value[i];

                          return Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              onTap: () => print(" "),
                              title: Text(
                                  "Scheduled Event: \t\t\t\t\t\t${eventName.title}"),
                            ),
                          );
                        });
                  }),
            )
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

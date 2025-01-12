import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowing_app/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        theme: getTheme(Brightness.light),
        darkTheme: getTheme(Brightness.dark),
        title: 'Knowing',
        home: const HomePage(),
      ),
    );
  }
}

enum CyclePhase {
  menstruation,
  follicular,
  ovulation,
  luteal1,
  luteal2,
}

enum MoodAndEmotion {
  positive,
  neutral,
  negative,
  disturbed,
}

enum Stressor {
  painAndDiscomfort,
  illness,
  lackOfSleep,
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _date = DateTime.now();
  CyclePhase? _cyclePhase;
  double? _energyLevel;
  MoodAndEmotion? _moodAndEmotion;
  double? _sleepQuality;
  double? _stressLevel;
  // TODO: Set<Stressor> _stressors = {};
  Stressor? _stressors;
  String _sportTypes = '';
  String _foodIntake = '';
  double? _appetiteLevel;
  String _bodySymptoms = '';
  String _observations = '';
  int? _weightAm;
  int? _weightPm;
  String _misc = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.calendar_month),
            title: Text(_date.toString()),
            onTap: () async {
              final today = DateTime.now();
              final date = await showDatePicker(
                context: context,
                firstDate: today.subtract(const Duration(days: 365)),
                lastDate: today,
              );
              if (date != null) {
                setState(() {
                  _date = date;
                });
              }
            },
          ),
          DropdownButtonFormField<CyclePhase?>(
            value: _cyclePhase,
            decoration: InputDecoration(label: Text('Phase of cycle')),
            items: [null, ...CyclePhase.values]
                .map((phase) => DropdownMenuItem(
                      value: phase,
                      child: Text(phase?.name ?? 'None'),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _cyclePhase = value;
              });
            },
          ),
          Text('Energy level'),
          Slider(
            value: _energyLevel ?? 0,
            max: 5,
            divisions: 6,
            onChanged: (value) {
              setState(() {
                _energyLevel = value;
              });
            },
          ),
          DropdownButtonFormField<MoodAndEmotion?>(
            value: _moodAndEmotion,
            decoration: InputDecoration(label: Text('Mood & emotion')),
            items: [null, ...MoodAndEmotion.values]
                .map((phase) => DropdownMenuItem(
                      value: phase,
                      child: Text(phase?.name ?? 'None'),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _moodAndEmotion = value;
              });
            },
          ),
          Text('Sleep quality'),
          Slider(
            value: _sleepQuality ?? 0,
            max: 5,
            divisions: 6,
            onChanged: (value) {
              setState(() {
                _sleepQuality = value;
              });
            },
          ),
          Text('Stress level'),
          Slider(
            value: _stressLevel ?? 0,
            max: 5,
            divisions: 6,
            onChanged: (value) {
              setState(() {
                _stressLevel = value;
              });
            },
          ),
          // TODO: Multiselect
          DropdownButtonFormField<Stressor?>(
            value: _stressors,
            decoration: InputDecoration(label: Text('Mood & emotion')),
            items: [null, ...Stressor.values]
                .map((phase) => DropdownMenuItem(
                      value: phase,
                      child: Text(phase?.name ?? 'None'),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _stressors = value;
              });
            },
          ),
          TextFormField(
            decoration: InputDecoration(label: Text('Sport types')),
            onChanged: (value) {
              setState(() {
                _sportTypes = value;
              });
            },
          ),
          TextFormField(
            decoration: InputDecoration(label: Text('Food intake')),
            onChanged: (value) {
              setState(() {
                _foodIntake = value;
              });
            },
          ),
          Slider(
            value: _appetiteLevel ?? 0,
            max: 5,
            divisions: 6,
            onChanged: (value) {
              setState(() {
                _appetiteLevel = value;
              });
            },
          ),
          TextFormField(
            decoration: InputDecoration(label: Text('Body symptoms')),
            onChanged: (value) {
              setState(() {
                _bodySymptoms = value;
              });
            },
          ),
          TextFormField(
            decoration: InputDecoration(label: Text('Observations')),
            onChanged: (value) {
              setState(() {
                _observations = value;
              });
            },
          ),
          TextFormField(
            decoration: InputDecoration(label: Text('Weight am')),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) {
              setState(() {
                _weightAm = int.tryParse(value);
              });
            },
          ),
          TextFormField(
            decoration: InputDecoration(label: Text('Weight pm')),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) {
              setState(() {
                _weightPm = int.tryParse(value);
              });
            },
          ),
          TextFormField(
            decoration:
                InputDecoration(label: Text('Sickness, travel, other events')),
            onChanged: (value) {
              setState(() {
                _misc = value;
              });
            },
          ),
        ],
      ),
    );
  }
}

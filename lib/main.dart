import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';

void main() {
  runApp(const AlarmChessPuzzleApp());
}

class AlarmChessPuzzleApp extends StatelessWidget {
  const AlarmChessPuzzleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alarm Chess Puzzle',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const AlarmHomePage(),
    );
  }
}

class AlarmHomePage extends StatefulWidget {
  const AlarmHomePage({super.key});

  @override
  State<AlarmHomePage> createState() => _AlarmHomePageState();
}

class _AlarmHomePageState extends State<AlarmHomePage> {
  List<AlarmEntry> alarms = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alarm Chess Puzzle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Alarms',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SetAlarmPage()),
                ).then((newAlarm) {
                  if (newAlarm != null) {
                    setState(() {
                      alarms.add(newAlarm);
                    });
                  }
                });
              },
              child: const Text('Set New Alarm'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChessPuzzlePage(
                      puzzle: ChessPuzzle(
                        pgn: '1. e4 c5 2. Nf3 d6',
                        solutionMoves: ['e2e4', 'c7c5', 'g1f3'],
                        description: 'Test puzzle',
                      ),
                    ),
                  ),
                );
              },
              child: const Text('Test: Go to Puzzle'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: alarms.isEmpty
                  ? const Center(
                      child: Text('No alarms set'),
                    )
                  : ListView.builder(
                      itemCount: alarms.length,
                      itemBuilder: (context, index) {
                        final alarm = alarms[index];
                        return ListTile(
                          title: Text('${alarm.hour}:${alarm.minute.toString().padLeft(2, '0')}'),
                          subtitle: Text(alarm.puzzle.description),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                alarms.removeAt(index);
                              });
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class AlarmEntry {
  final int hour;
  final int minute;
  final ChessPuzzle puzzle;

  AlarmEntry({
    required this.hour,
    required this.minute,
    required this.puzzle,
  });
}

class ChessPuzzle {
  final String pgn;
  final List<String> solutionMoves; // e.g., ['e4', 'd5']
  final String description;

  ChessPuzzle({
    required this.pgn,
    required this.solutionMoves,
    required this.description,
  });
}

class SetAlarmPage extends StatefulWidget {
  const SetAlarmPage({super.key});

  @override
  State<SetAlarmPage> createState() => _SetAlarmPageState();
}

class _SetAlarmPageState extends State<SetAlarmPage> {
  int selectedHour = 7;
  int selectedMinute = 0;
  
  late ChessPuzzle selectedPuzzle;

  final List<ChessPuzzle> samplePuzzles = [
    ChessPuzzle(
      pgn: '1.e4c52.Nf3d6',
      solutionMoves: ['e2e4', 'c7c5', 'g1f3'],
      description: 'Sicilian Defense - Move e4, c5, Nf3',
    ),
    ChessPuzzle(
      pgn: '1. d4 Nf6 2. c4 g6',
      solutionMoves: ['d2d4', 'g8f6', 'c2c4'],
      description: 'King\'s Indian Defense - Move d4, Nf6, c4',
    ),
    ChessPuzzle(
      pgn: '1. Nf3 Nf6 2. c4 g6',
      solutionMoves: ['g1f3', 'g8f6', 'c2c4'],
      description: 'Reti Opening - Move Nf3, Nf6, c4',
    ),
  ];

  @override
  void initState() {
    super.initState();
    selectedPuzzle = samplePuzzles[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Alarm'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('Select Time:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<int>(
                  value: selectedHour,
                  items: List.generate(24, (i) => i)
                      .map((h) => DropdownMenuItem(
                            value: h,
                            child: Text('$h'),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedHour = value ?? 0;
                    });
                  },
                ),
                const Text(':'),
                DropdownButton<int>(
                  value: selectedMinute,
                  items: List.generate(60, (i) => i)
                      .map((m) => DropdownMenuItem(
                            value: m,
                            child: Text(m.toString().padLeft(2, '0')),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedMinute = value ?? 0;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text('Select Puzzle:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            DropdownButton<ChessPuzzle>(
              value: selectedPuzzle,
              items: samplePuzzles
                  .map((puzzle) => DropdownMenuItem(
                        value: puzzle,
                        child: SizedBox(
                          width: 300,
                          child: Text(puzzle.description, overflow: TextOverflow.ellipsis),
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedPuzzle = value ?? samplePuzzles[0];
                });
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  AlarmEntry(
                    hour: selectedHour,
                    minute: selectedMinute,
                    puzzle: selectedPuzzle,
                  ),
                );
              },
              child: const Text('Save Alarm'),
            ),
          ],
        ),
      ),
    );
  }
}

class ChessPuzzlePage extends StatefulWidget {
  final ChessPuzzle puzzle;

  const ChessPuzzlePage({super.key, required this.puzzle});

  @override
  State<ChessPuzzlePage> createState() => _ChessPuzzlePageState();
}

class _ChessPuzzlePageState extends State<ChessPuzzlePage> {
  late ChessBoardController boardController;
  int moveCount = 0;
  String? lastMoveStatus;

  @override
  void initState() {
    super.initState();
    boardController = ChessBoardController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solve Chess Puzzle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              widget.puzzle.description,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'PGN: ${widget.puzzle.pgn}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            if (lastMoveStatus != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: lastMoveStatus!.contains('Best')
                      ? Colors.green[100]
                      : lastMoveStatus!.contains('Valid')
                          ? Colors.blue[100]
                          : Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  lastMoveStatus!,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: lastMoveStatus!.contains('Best')
                        ? Colors.green[900]
                        : lastMoveStatus!.contains('Valid')
                            ? Colors.blue[900]
                            : Colors.red[900],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            const SizedBox(height: 20),
            Expanded(
              child: ChessBoard(
                controller: boardController,
                boardColor: BoardColor.brown,
                onMove: () {
                  // Handle move validation here
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      boardController.resetBoard();
                      lastMoveStatus = null;
                      moveCount = 0;
                    });
                  },
                  child: const Text('Reset'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Back to Alarms'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

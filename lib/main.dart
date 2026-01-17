import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

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
      pgn: '1. e4 c5 2. Nf3 d6',
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
  late chess.Chess game;
  int moveCount = 0;
  String? lastMoveStatus;

  @override
  void initState() {
    super.initState();
    game = chess.Chess();
    game.load_pgn(widget.puzzle.pgn);
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
              child: ChessBoardWidget(
                game: game,
                solutionMoves: widget.puzzle.solutionMoves,
                onMoveResult: (status) {
                  setState(() {
                    lastMoveStatus = status;
                    moveCount++;
                  });
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
                      game = chess.Chess();
                      game.load_pgn(widget.puzzle.pgn);
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

class ChessBoardWidget extends StatefulWidget {
  final chess.Chess game;
  final List<String> solutionMoves;
  final Function(String) onMoveResult;

  const ChessBoardWidget({
    super.key,
    required this.game,
    required this.solutionMoves,
    required this.onMoveResult,
  });

  @override
  State<ChessBoardWidget> createState() => _ChessBoardWidgetState();
}

class _ChessBoardWidgetState extends State<ChessBoardWidget> {
  String? selectedSquare;
  List<String> validMoves = [];
  int solutionIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  String _indexToSquare(int row, int col) {
    return String.fromCharCode('a'.codeUnitAt(0) + col) + (8 - row).toString();
  }

  List<List<chess.Piece?>> _getBoardGrid() {
    final boardFlat = widget.game.board;
    final boardGrid = <List<chess.Piece?>>[];
    for (int row = 0; row < 8; row++) {
      final rowPieces = <chess.Piece?>[];
      for (int col = 0; col < 8; col++) {
        final index = row * 8 + col;
        rowPieces.add(boardFlat[index]);
      }
      boardGrid.add(rowPieces);
    }
    return boardGrid;
  }

  void _onSquareTapped(int row, int col) {
    final square = _indexToSquare(row, col);
    
    if (selectedSquare == null) {
      // Select a piece
      final boardGrid = _getBoardGrid();
      if (boardGrid[row][col] != null) {
        setState(() {
          selectedSquare = square;
          // Get valid moves for this square
          final moves = widget.game.moves({'square': square});
          validMoves = List<String>.from(moves);
        });
      }
    } else {
      // Try to move to this square
      final moveStr = '$selectedSquare$square';
      try {
        final moves = widget.game.moves({'verbose': true});
        bool validMove = false;
        String? executedMove;

        for (var m in moves) {
          if ((m['from'] == selectedSquare && m['to'] == square)) {
            widget.game.move(m);
            executedMove = moveStr;
            validMove = true;
            break;
          }
        }
        
        setState(() {
          if (validMove) {
            // Check if it's the best move
            String status;
            if (solutionIndex < widget.solutionMoves.length &&
                executedMove == widget.solutionMoves[solutionIndex]) {
              final moveDisplay = executedMove ?? moveStr;
              status = '✓ Best move! ${moveDisplay.substring(0, 2).toUpperCase()}-${moveDisplay.substring(2).toUpperCase()}';
              solutionIndex++;
            } else if (solutionIndex < widget.solutionMoves.length) {
              final expectedMove = widget.solutionMoves[solutionIndex];
              status = '✗ Not the best move. Expected: ${expectedMove.substring(0, 2).toUpperCase()}-${expectedMove.substring(2).toUpperCase()}';
            } else {
              status = '✓ Move valid but puzzle already solved!';
            }
            widget.onMoveResult(status);
            
            selectedSquare = null;
            validMoves = [];
          } else {
            // Invalid move, try selecting this square instead
            selectedSquare = square;
            final boardGrid = _getBoardGrid();
            if (boardGrid[row][col] != null) {
              final movesForSquare = widget.game.moves({'square': square});
              validMoves = List<String>.from(movesForSquare);
            } else {
              selectedSquare = null;
              validMoves = [];
            }
          }
        });
      } catch (e) {
        setState(() {
          selectedSquare = null;
          validMoves = [];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final boardGrid = _getBoardGrid();
    
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 8,
          ),
          itemCount: 64,
          itemBuilder: (context, index) {
            final row = index ~/ 8;
            final col = index % 8;
            final isLight = (row + col) % 2 == 0;
            final square = _indexToSquare(row, col);
            final isSelected = selectedSquare == square;
            final isValidMove = validMoves.contains(square);
            final piece = boardGrid[row][col];

            return GestureDetector(
              onTap: () => _onSquareTapped(row, col),
              child: Container(
                color: isSelected
                    ? Colors.yellow
                    : isValidMove
                        ? Colors.green
                        : isLight
                            ? Colors.grey[300]
                            : Colors.grey[600],
                child: Center(
                  child: Text(
                    _getPieceSymbol(piece),
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _getPieceSymbol(chess.Piece? piece) {
    if (piece == null) return '';
    final symbols = {
      'p': '♟', 'n': '♞', 'b': '♝', 'r': '♜', 'q': '♛', 'k': '♚',
      'P': '♙', 'N': '♘', 'B': '♗', 'R': '♖', 'Q': '♕', 'K': '♔',
    };
    return symbols[piece.type] ?? '';
  }
}

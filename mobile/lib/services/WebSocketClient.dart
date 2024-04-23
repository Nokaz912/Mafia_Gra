import 'dart:async';
import 'dart:convert';
import 'package:mobile/models/VotingSummary.dart';
import 'package:mobile/state/GameState.dart';
import 'package:mobile/state/RoomState.dart';
import 'package:mobile/state/RoundState.dart';
import 'package:mobile/state/AccountState.dart';
import 'package:mobile/state/VotingState.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:mobile/utils/Constants.dart' as Constants;
import '../models/GameStart.dart';
import '../models/Room.dart';
import '../models/Round.dart';

class WebSocketClient {
  static WebSocketClient? _instance;
  StompClient? _stompClient;
  final List<void Function({Map<String, String>? unsubscribeHeaders})> _unsubscribeFunctions = [];

  final String baseUrl = "ws://${Constants.baseUrl}";

  final _roomUpdate = StreamController<Room>.broadcast();
  Stream<Room> get roomUpdate => _roomUpdate.stream;

  final _gameStartUpdate = StreamController<GameStart>.broadcast();
  Stream<GameStart> get gameStartUpdate => _gameStartUpdate.stream;

  final _roundStartUpdate = StreamController<Round>.broadcast();
  Stream<Round> get roundStartUpdate => _roundStartUpdate.stream;

  final _votingSummaryUpdate = StreamController<VotingSummary>.broadcast();
  Stream<VotingSummary> get votingSummaryUpdate => _votingSummaryUpdate.stream;

  final AccountState _accountState = AccountState();
  final RoomState _roomState = RoomState();
  final GameState _gameState = GameState();
  final RoundState _roundState = RoundState();
  final VotingState _votingState = VotingState();

  WebSocketClient._internal();

  factory WebSocketClient() {
    _instance ??= WebSocketClient._internal();
    return _instance!;
  }

  Future<void> connect(int roomId) async {
    if (_stompClient != null && _stompClient!.connected) {
      return;
    }
    if (_accountState.currentAccount == null) {
      return;
    }

    Completer<void> connectionCompleter = Completer<void>();
    StompConfig config = StompConfig(
        url: "$baseUrl/ws",
        onConnect: (StompFrame frame) {
          _unsubscribeFunctions.add(_stompClient!.subscribe(
            destination: "/topic/$roomId/room",
            callback: (frame) {
              Map<String, dynamic> roomJson = jsonDecode(frame.body!);
              Room room = Room.fromJson(roomJson);
              _roomState.setRoom(room);
            }
          ));
          _unsubscribeFunctions.add(_stompClient!.subscribe(
            destination: "/user/queue/game-start",
            callback: (frame) {
              Map<String, dynamic> gameStartJson = jsonDecode(frame.body!);
              GameStart gameStart = GameStart.fromJson(gameStartJson);
              _gameState.setGame(gameStart);
            }
          ));
          _unsubscribeFunctions.add(_stompClient!.subscribe(
            destination: "/topic/$roomId/round-start",
            callback: (frame) {
              Map<String, dynamic> roundStartJson = jsonDecode(frame.body!);
              Round round = Round.fromJson(roundStartJson);
              _roundState.setRound(round);
            }
          ));
          _unsubscribeFunctions.add(_stompClient!.subscribe(
            destination: "/topic/$roomId/voting-summary",
            callback: (frame) {
              Map<String, dynamic> votingSummaryJson = jsonDecode(frame.body!);
              VotingSummary votingSummary = VotingSummary.fromJson(votingSummaryJson);
              _votingState.setVotingSummary(votingSummary);
            }
          ));
          _unsubscribeFunctions.add(_stompClient!.subscribe(
            destination: "/topic/$roomId/game-end",
            callback: (frame) {
              _gameState.setGame(null);
              _roundState.setRound(null);
              _votingState.setVotingSummary(null);
            }
          ));
          connectionCompleter.complete();
        },
        onDisconnect: (StompFrame frame) {
          print("disconnected");
        },
        stompConnectHeaders: {
          'login': _accountState.currentAccount!.username,
          'passcode': _accountState.currentAccount!.password
        }
    );
    _stompClient = StompClient(config: config);
    _stompClient?.activate();

    return connectionCompleter.future;
  }

  void unsubscribeAll() {
    for(var unsubscribeFn in _unsubscribeFunctions) {
      unsubscribeFn(unsubscribeHeaders: {});
    }
    _unsubscribeFunctions.clear();
  }

  void disconnect() {
    unsubscribeAll();
    _stompClient?.deactivate();
  }
}

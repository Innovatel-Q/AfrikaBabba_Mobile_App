import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'dart:async';

class PusherService {
  // Instance de Pusher
  static final PusherChannelsFlutter _pusher = PusherChannelsFlutter.getInstance();
  final String apiKey = dotenv.env['PUSHER_APP_KEY'] ?? '';
  final String cluster = dotenv.env['PUSHER_APP_CLUSTER'] ?? '';

  static const String channelPrefix = 'conversation.';

  // StreamController pour diffuser les événements
  static final StreamController<String> _eventStreamController = StreamController<String>.broadcast();
  static Stream<String> get eventStream => _eventStreamController.stream;

  // Liste des IDs de conversations suivies
  final List<int> conversationIds = [];

  // Méthode d'initialisation
  Future<PusherService> init() async {
    try {
      await _pusher.init(
        apiKey: apiKey,
        cluster: cluster,
        onConnectionStateChange: (currentState, previousState) {
          print('État de la connexion : $currentState, Précédent état : $previousState');
        },
        onError: (message, code, error) {
          print('Erreur Pusher: $message, Code: $code, Erreur: $error');
        },
      );
      await _pusher.connect();
      return this;
    } catch (e) {
      print('Erreur d\'initialisation Pusher : $e');
      rethrow;
    }
  }

  // Générer le nom du canal
  String _getChannelName(int conversationId) => '$channelPrefix$conversationId';
  // Abonnement à une conversation
  Future<void> subscribeToConversation(int conversationId) async {
    if (!conversationIds.contains(conversationId)) {
      try {
        await _pusher.subscribe(
          channelName: _getChannelName(conversationId),
          onEvent: (event) {
            _eventStreamController.add(event.data);
          },
        );
        conversationIds.add(conversationId);
        print('Abonné au canal ${_getChannelName(conversationId)}');
      } catch (e) {
        print('Erreur lors de l\'abonnement au canal : $e');
      }
    }
  }

  // Désabonnement d'une conversation
  Future<void> unsubscribeFromConversation(int conversationId) async {
    if (conversationIds.contains(conversationId)) {
      try {
        await _pusher.unsubscribe(channelName: _getChannelName(conversationId));
        conversationIds.remove(conversationId);
        print('Désabonné du canal ${_getChannelName(conversationId)}');
      } catch (e) {
        print('Erreur lors du désabonnement du canal : $e');
      }
    }
  }

  // Déconnexion de Pusher et nettoyage du StreamController
  Future<void> disconnect() async {
    await _pusher.disconnect();
    await _eventStreamController.close();
    print("Déconnecté de Pusher et StreamController fermé");
  }
}

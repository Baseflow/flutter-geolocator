class PositionFactory {
  static Map<String, double> createMockPosition() {
    return const <String, double>{
      'latitude': 52.561270,
      'longitude': 5.639382,
      'altitude': 3000.0,
      'accuracy': 0.0,
      'heading': 0.0,
      'speed': 0.0,
      'speed_accuracy': 0.0
    };
  }

  static List<Map<String, double>> createMockPositions() {
    return const [
      <String, double>{
        'latitude': 52.561270,
        'longitude': 5.639382,
        'altitude': 3000.0,
        'accuracy': 0.0,
        'heading': 0.0,
        'speed': 0.0,
        'speed_accuracy': 0.0
      },
      <String, double>{
        'latitude': 52.560919,
        'longitude': 5.639771,
        'altitude': 3000.0,
        'accuracy': 0.0,
        'heading': 0.0,
        'speed': 0.0,
        'speed_accuracy': 0.0
      },
      <String, double>{
        'latitude': 52.562143,
        'longitude': 5.641147,
        'altitude': 3000.0,
        'accuracy': 0.0,
        'heading': 0.0,
        'speed': 0.0,
        'speed_accuracy': 0.0
      },
      <String, double>{
        'latitude': 52.562454,
        'longitude': 5.640372,
        'altitude': 3000.0,
        'accuracy': 0.0,
        'heading': 0.0,
        'speed': 0.0,
        'speed_accuracy': 0.0
      },
      <String, double>{
        'latitude': 52.561242,
        'longitude': 5.639010,
        'altitude': 3000.0,
        'accuracy': 0.0,
        'heading': 0.0,
        'speed': 0.0,
        'speed_accuracy': 0.0
      }
    ];
  }
}
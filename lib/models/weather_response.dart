class WeatherResponse {
  final Location location;
  final Current current;
  final Forecast forecast;

  WeatherResponse({
    required this.location,
    required this.current,
    required this.forecast,
  });

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    return WeatherResponse(
      location: Location.fromJson(json['location']),
      current: Current.fromJson(json['current']),
      forecast: Forecast.fromJson(json['forecast']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'location': location.toJson(),
      'current': current.toJson(),
      'forecast': forecast.toJson(),
    };
  }
}

class Location {
  final String name;
  final String localtime;

  Location({required this.name, required this.localtime});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'],
      localtime: json['localtime'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'localtime': localtime,
    };
  }
}

class Current {
  final double tempC;
  final Condition condition;
  final double windKph;
  final int humidity;

  Current({
    required this.tempC,
    required this.condition,
    required this.windKph,
    required this.humidity,
  });

  factory Current.fromJson(Map<String, dynamic> json) {
    return Current(
      tempC: json['temp_c'].toDouble(),
      condition: Condition.fromJson(json['condition']),
      windKph: json['wind_kph'].toDouble(),
      humidity: json['humidity'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'temp_c': tempC,
      'condition': condition.toJson(),
      'wind_kph': windKph,
      'humidity': humidity,
    };
  }
}

class Forecast {
  final List<ForecastDay> forecastday;

  Forecast({required this.forecastday});

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      forecastday: (json['forecastday'] as List)
          .map((e) => ForecastDay.fromJson(e))
          .toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'forecastday': forecastday.map((day) => day.toJson()).toList(),
    };
  }
}

class ForecastDay {
  final String date;
  final Day day;

  ForecastDay({required this.date, required this.day});

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    return ForecastDay(
      date: json['date'],
      day: Day.fromJson(json['day']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'day': day.toJson(),
    };
  }
}

class Day {
  final double avgtempC;
  final double maxwindKph;
  final double avghumidity;
  final Condition condition;

  Day({
    required this.avgtempC,
    required this.maxwindKph,
    required this.avghumidity,
    required this.condition,
  });

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      avgtempC: json['avgtemp_c'].toDouble(),
      maxwindKph: json['maxwind_kph'].toDouble(),
      avghumidity: json['avghumidity'].toDouble(),
      condition: Condition.fromJson(json['condition']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'avgtemp_c': avgtempC,
      'maxwind_kph': maxwindKph,
      'avghumidity': avghumidity,
      'condition': condition.toJson(),
    };
  }
}

class Condition {
  final String text;
  String icon;

  Condition({required this.text, required this.icon});

  factory Condition.fromJson(Map<String, dynamic> json) {
    var iconUrl = json['icon'] as String;
    if (iconUrl.startsWith('https:https:')) {
      iconUrl = iconUrl.replaceFirst('https:https:', 'https:');
    } else if (!iconUrl.startsWith('https:')) {
      iconUrl = 'https:$iconUrl';
    }

    return Condition(
      text: json['text'],
      icon: iconUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'icon': icon,
    };
  }
}

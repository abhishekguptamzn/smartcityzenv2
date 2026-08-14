import 'city_model.dart';

class CityInformationModel {
  final String? id;
  final String? cityId;
  final CityModel? city;
  final String? about;
  final String? nickname;
  final String? foundedYear;
  final String? ancientName;
  final String? heroImageUrl;
  final OriginAndNameModel? originAndName;
  final GeographyModel? geography;
  final List<CultureItemModel> cultureAndTraditions;
  final List<HeritageItemModel> heritageAndArchitecture;
  final List<FamousItemModel> famousFor;
  final List<TimelineItemModel> timeline;
  final List<PersonalityItemModel> notablePersonalities;
  final List<FactItemModel> historicalFacts;
  final bool isPublished;

  const CityInformationModel({
    this.id,
    this.cityId,
    this.city,
    this.about,
    this.nickname,
    this.foundedYear,
    this.ancientName,
    this.heroImageUrl,
    this.originAndName,
    this.geography,
    this.cultureAndTraditions = const [],
    this.heritageAndArchitecture = const [],
    this.famousFor = const [],
    this.timeline = const [],
    this.notablePersonalities = const [],
    this.historicalFacts = const [],
    this.isPublished = true,
  });

  factory CityInformationModel.fromJson(Map<String, dynamic> json) {
    return CityInformationModel(
      id: json['id'] as String?,
      cityId: json['city_id'] as String?,
      city: json['city'] != null && json['city'] is Map<String, dynamic>
          ? CityModel.fromJson(json['city'] as Map<String, dynamic>)
          : null,
      about: json['about'] as String?,
      nickname: json['nickname'] as String?,
      foundedYear: json['founded_year'] as String?,
      ancientName: json['ancient_name'] as String?,
      heroImageUrl: json['hero_image_url'] as String?,
      originAndName: json['origin_and_name'] != null && json['origin_and_name'] is Map<String, dynamic>
          ? OriginAndNameModel.fromJson(json['origin_and_name'] as Map<String, dynamic>)
          : null,
      geography: json['geography'] != null && json['geography'] is Map<String, dynamic>
          ? GeographyModel.fromJson(json['geography'] as Map<String, dynamic>)
          : null,
      cultureAndTraditions: _parseList(json['culture_and_traditions'], CultureItemModel.fromJson),
      heritageAndArchitecture: _parseList(json['heritage_and_architecture'], HeritageItemModel.fromJson),
      famousFor: _parseList(json['famous_for'], FamousItemModel.fromJson),
      timeline: _parseList(json['timeline'], TimelineItemModel.fromJson),
      notablePersonalities: _parseList(json['notable_personalities'], PersonalityItemModel.fromJson),
      historicalFacts: _parseFacts(json['historical_facts']),
      isPublished: json['is_published'] as bool? ?? true,
    );
  }

  static List<T> _parseList<T>(dynamic list, T Function(Map<String, dynamic>) fromJson) {
    if (list is List) {
      final results = <T>[];
      for (final item in list) {
        if (item is Map<String, dynamic>) {
          results.add(fromJson(item));
        }
      }
      return results;
    }
    return [];
  }

  static List<FactItemModel> _parseFacts(dynamic facts) {
    if (facts is List) {
      final result = <FactItemModel>[];
      for (final item in facts) {
        if (item is Map<String, dynamic>) {
          result.add(FactItemModel.fromJson(item));
        } else if (item is String) {
          result.add(FactItemModel(title: 'Historical Fact', fact: item));
        }
      }
      return result;
    }
    return [];
  }
}

class OriginAndNameModel {
  final String? etymology;
  final String? ancientScriptures;
  final String? linguisticRoot;
  final List<String> historicalNames;
  final String? meaning;
  final String? didYouKnow;

  const OriginAndNameModel({
    this.etymology,
    this.ancientScriptures,
    this.linguisticRoot,
    this.historicalNames = const [],
    this.meaning,
    this.didYouKnow,
  });

  factory OriginAndNameModel.fromJson(Map<String, dynamic> json) {
    List<String> names = [];
    if (json['historical_names'] is List) {
      names = (json['historical_names'] as List).map((e) => e.toString()).toList();
    }
    return OriginAndNameModel(
      etymology: json['etymology'] as String?,
      ancientScriptures: json['ancient_scriptures'] as String?,
      linguisticRoot: json['linguistic_root'] as String?,
      historicalNames: names,
      meaning: json['meaning'] as String?,
      didYouKnow: json['did_you_know'] as String?,
    );
  }
}

class GeographyModel {
  final String? location;
  final String? terrain;
  final List<String> rivers;
  final String? elevation;
  final String? climate;
  final String? coordinates;
  final String? area;
  final List<String> nearbyDistricts;

  const GeographyModel({
    this.location,
    this.terrain,
    this.rivers = const [],
    this.elevation,
    this.climate,
    this.coordinates,
    this.area,
    this.nearbyDistricts = const [],
  });

  factory GeographyModel.fromJson(Map<String, dynamic> json) {
    List<String> rList = [];
    if (json['rivers'] is List) {
      rList = (json['rivers'] as List).map((e) => e.toString()).toList();
    }
    List<String> nList = [];
    if (json['nearby_districts'] is List) {
      nList = (json['nearby_districts'] as List).map((e) => e.toString()).toList();
    }
    return GeographyModel(
      location: json['location'] as String?,
      terrain: json['terrain'] as String?,
      rivers: rList,
      elevation: json['elevation'] as String?,
      climate: json['climate'] as String?,
      coordinates: json['coordinates'] as String?,
      area: json['area'] as String?,
      nearbyDistricts: nList,
    );
  }
}

class CultureItemModel {
  final String name;
  final String category;
  final String description;
  final List<String> items;

  const CultureItemModel({
    required this.name,
    required this.category,
    required this.description,
    this.items = const [],
  });

  factory CultureItemModel.fromJson(Map<String, dynamic> json) {
    List<String> itemList = [];
    if (json['items'] is List) {
      itemList = (json['items'] as List).map((e) => e.toString()).toList();
    }
    return CultureItemModel(
      name: json['name'] as String? ?? 'Culture',
      category: json['category'] as String? ?? 'Tradition',
      description: json['description'] as String? ?? '',
      items: itemList,
    );
  }
}

class HeritageItemModel {
  final String name;
  final String architecturalStyle;
  final String constructionYear;
  final bool unescoHeritage;
  final String description;
  final String? imageUrl;

  const HeritageItemModel({
    required this.name,
    required this.architecturalStyle,
    required this.constructionYear,
    required this.unescoHeritage,
    required this.description,
    this.imageUrl,
  });

  factory HeritageItemModel.fromJson(Map<String, dynamic> json) {
    return HeritageItemModel(
      name: json['name'] as String? ?? json['title'] as String? ?? 'Monument',
      architecturalStyle: json['architectural_style'] as String? ?? json['style'] as String? ?? 'Heritage',
      constructionYear: json['construction_year'] as String? ?? json['year'] as String? ?? 'Ancient Era',
      unescoHeritage: json['unesco_heritage'] as bool? ?? json['unesco'] as bool? ?? false,
      description: json['description'] as String? ?? '',
      imageUrl: json['image_url'] as String?,
    );
  }
}

class FamousItemModel {
  final String title;
  final String category;
  final String description;
  final String? imageUrl;

  const FamousItemModel({
    required this.title,
    required this.category,
    required this.description,
    this.imageUrl,
  });

  factory FamousItemModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('title')) {
      return FamousItemModel(
        title: json['title'] as String? ?? '',
        category: json['category'] as String? ?? 'Famous Hallmark',
        description: json['description'] as String? ?? '',
        imageUrl: json['image_url'] as String?,
      );
    }
    final val = json.values.isNotEmpty ? json.values.first.toString() : json.toString();
    return FamousItemModel(
      title: val,
      category: 'Heritage Hallmark',
      description: val,
    );
  }
}

class TimelineItemModel {
  final String era;
  final String period;
  final String title;
  final String description;
  final String? imageUrl;

  const TimelineItemModel({
    required this.era,
    required this.period,
    required this.title,
    required this.description,
    this.imageUrl,
  });

  factory TimelineItemModel.fromJson(Map<String, dynamic> json) {
    return TimelineItemModel(
      era: json['era'] as String? ?? 'Historical Era',
      period: json['period'] as String? ?? '',
      title: json['title'] as String? ?? 'Milestone Event',
      description: json['description'] as String? ?? '',
      imageUrl: json['image_url'] as String?,
    );
  }
}

class PersonalityItemModel {
  final String name;
  final String era;
  final String title;
  final String contribution;
  final String? photoUrl;

  const PersonalityItemModel({
    required this.name,
    required this.era,
    required this.title,
    required this.contribution,
    this.photoUrl,
  });

  factory PersonalityItemModel.fromJson(Map<String, dynamic> json) {
    return PersonalityItemModel(
      name: json['name'] as String? ?? 'Historical Figure',
      era: json['era'] as String? ?? 'Historical Era',
      title: json['title'] as String? ?? 'Notable Figure',
      contribution: json['contribution'] as String? ?? json['description'] as String? ?? '',
      photoUrl: json['photo_url'] as String? ?? json['image_url'] as String?,
    );
  }
}

class FactItemModel {
  final String title;
  final String fact;

  const FactItemModel({
    required this.title,
    required this.fact,
  });

  factory FactItemModel.fromJson(Map<String, dynamic> json) {
    return FactItemModel(
      title: json['title'] as String? ?? 'Did You Know?',
      fact: json['fact'] as String? ?? json['description'] as String? ?? '',
    );
  }
}

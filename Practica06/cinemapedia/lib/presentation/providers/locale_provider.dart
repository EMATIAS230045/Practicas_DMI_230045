import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

/// Tipo de contenido: Películas o Series
enum ContentType { movies, tv }

final contentTypeProvider = StateProvider<ContentType>((ref) => ContentType.movies);

/// Provider que guarda el locale/país seleccionado por el usuario.
final localeProvider = StateProvider<Locale>((ref) => const Locale('es', 'MX'));

/// Las 7 opciones disponibles con bandera, nombre nativo/completo y código de API.
/// Se separa el nombre limpio (name) para evitar que se duplique con la bandera en la UI.
final localeOptions = <Map<String, dynamic>>[
  {
    'flag': '🇺🇸',
    'shortLabel': '🇺🇸 US',
    'name': 'English (US)',
    'countryName': 'Estados Unidos',
    'label': '🇺🇸 English (US)',
    'code': 'US',
    'locale': const Locale('en', 'US'),
    'apiLang': 'en-US',
  },
  {
    'flag': '🇲🇽',
    'shortLabel': '🇲🇽 MX',
    'name': 'Español (MX)',
    'countryName': 'México',
    'label': '🇲🇽 Español (MX)',
    'code': 'MX',
    'locale': const Locale('es', 'MX'),
    'apiLang': 'es-MX',
  },
  {
    'flag': '🇨🇴',
    'shortLabel': '🇨🇴 CO',
    'name': 'Español (CO)',
    'countryName': 'Colombia',
    'label': '🇨🇴 Español (CO)',
    'code': 'CO',
    'locale': const Locale('es', 'CO'),
    'apiLang': 'es-CO',
  },
  {
    'flag': '🇩🇪',
    'shortLabel': '🇩🇪 DE',
    'name': 'Deutsch (DE)',
    'countryName': 'Alemania',
    'label': '🇩🇪 Deutsch (DE)',
    'code': 'DE',
    'locale': const Locale('de', 'DE'),
    'apiLang': 'de-DE',
  },
  {
    'flag': '🇨🇳',
    'shortLabel': '🇨🇳 CN',
    'name': '中文 (CN)',
    'countryName': 'China',
    'label': '🇨🇳 中文 (CN)',
    'code': 'CN',
    'locale': const Locale('zh', 'CN'),
    'apiLang': 'zh-CN',
  },
  {
    'flag': '🇪🇬',
    'shortLabel': '🇪🇬 EG',
    'name': 'العربية (EG)',
    'countryName': 'Egipto',
    'label': '🇪🇬 العربية (EG)',
    'code': 'EG',
    'locale': const Locale('ar', 'EG'),
    'apiLang': 'ar-EG',
  },
  {
    'flag': '🇷🇺',
    'shortLabel': '🇷🇺 RU',
    'name': 'Русский (RU)',
    'countryName': 'Rusia',
    'label': '🇷🇺 Русский (RU)',
    'code': 'RU',
    'locale': const Locale('ru', 'RU'),
    'apiLang': 'ru-RU',
  },
];

/// Obtiene el código de idioma para la API de TMDB según el locale.
String getApiLanguage(Locale locale) {
  final option = localeOptions.firstWhere(
    (opt) => (opt['locale'] as Locale) == locale,
    orElse: () => localeOptions[1],
  );
  return option['apiLang'] as String;
}

/// Obtiene la etiqueta corta con bandera y código (ej. "🇲🇽 MX")
String getShortLabel(Locale locale) {
  final option = localeOptions.firstWhere(
    (opt) => (opt['locale'] as Locale) == locale,
    orElse: () => localeOptions[1],
  );
  return option['shortLabel'] as String;
}

/// Obtiene la bandera emoji según el locale.
String getFlag(Locale locale) {
  final option = localeOptions.firstWhere(
    (opt) => (opt['locale'] as Locale) == locale,
    orElse: () => localeOptions[1],
  );
  return option['flag'] as String;
}

/// Obtiene el nombre del país del locale activo.
String getCountryName(Locale locale) {
  final option = localeOptions.firstWhere(
    (opt) => (opt['locale'] as Locale) == locale,
    orElse: () => localeOptions[1],
  );
  return option['countryName'] as String;
}

/// Obtiene el código de país (ej. "MX", "US")
String getCountryCode(Locale locale) {
  final option = localeOptions.firstWhere(
    (opt) => (opt['locale'] as Locale) == locale,
    orElse: () => localeOptions[1],
  );
  return option['code'] as String;
}

/// Obtiene la clasificación oficial corta para el badge (ej. "B", "PG-13", "16")
String getShortClassification(Locale locale, {bool isTv = false}) {
  final country = locale.countryCode ?? 'US';
  switch (country) {
    case 'US':
      return isTv ? 'TV-14' : 'PG-13';
    case 'MX':
      return 'B';
    case 'CO':
      return '+12';
    case 'DE':
      return 'FSK 12';
    case 'CN':
      return '+12';
    case 'EG':
      return 'PG-12';
    case 'RU':
      return '16+';
    default:
      return 'PG-13';
  }
}

/// Obtiene la clasificación oficial de cine o TV según el país y si es serie o película.
String getClassification(Locale locale, {bool isTv = false}) {
  final country = locale.countryCode ?? 'US';
  switch (country) {
    case 'US':
      return isTv
          ? 'TV (TV-Y, TV-G, TV-PG, TV-14, TV-MA)'
          : 'MPA (G, PG, PG-13, R, NC-17)';
    case 'MX':
      return 'RTC (AA, A, B, B15, C, D)';
    case 'CO':
      return 'Oficial (T, +7, +12, +15, +18)';
    case 'DE':
      return 'FSK (0, 6, 12, 16, 18)';
    case 'CN':
      return 'Oficial (Todo público, +12, +16, +18)';
    case 'EG':
      return 'Oficial (G, PG, PG-12, +16, +18)';
    case 'RU':
      return 'RARS (0+, 6+, 12+, 16+, 18+)';
    default:
      return 'MPA (G, PG, PG-13, R, NC-17)';
  }
}

// ── Traducciones simples de textos estáticos de la UI para 7 idiomas ──

const _translations = <String, Map<String, String>>{
  'en': {
    'movies': 'Movies',
    'tvSeries': 'TV Series',
    'contentType': 'Content Type',
    'languageRegion': 'Language / Region',
    'inTheaters': 'In Theaters',
    'onTheAir': 'On The Air',
    'monday20': 'Monday 20',
    'upcoming': 'Coming Soon',
    'airingToday': 'Airing Today',
    'thisMonth': 'This month',
    'topRated': 'Top Rated',
    'allTime': 'All time',
    'popular': 'Popular',
    'release': 'Release:',
    'firstAirDate': 'First Air Date:',
    'actors': 'Actors',
    'genres': 'Genres',
    'similarMovies': 'Similar Movies',
    'similarSeries': 'Similar Series',
    'videos': 'Videos',
    'favorites': 'Favorites',
    'noFavorites': 'No favorites yet',
    'startSearching': 'Start searching',
    'classification': 'Classification',
    'titleInSelectedLanguage': 'Title in selected language',
    'originalTitle': 'Original title',
    'classificationFrom': 'Classification obtained from:',
  },
  'es': {
    'movies': 'Películas',
    'tvSeries': 'Series',
    'contentType': 'Tipo de contenido',
    'languageRegion': 'Idioma / Región',
    'inTheaters': 'En cines',
    'onTheAir': 'En emisión',
    'monday20': 'Lunes 20',
    'upcoming': 'Próximamente',
    'airingToday': 'Emitiéndose hoy',
    'thisMonth': 'En este mes',
    'topRated': 'Mejor calificadas',
    'allTime': 'Desde siempre',
    'popular': 'Populares',
    'release': 'Estreno:',
    'firstAirDate': 'Primera emisión:',
    'actors': 'Actores',
    'genres': 'Géneros',
    'similarMovies': 'Películas similares',
    'similarSeries': 'Series similares',
    'videos': 'Videos',
    'favorites': 'Favoritos',
    'noFavorites': 'No tienes favoritos',
    'startSearching': 'Empieza a buscar',
    'classification': 'Clasificación',
    'titleInSelectedLanguage': 'Título en idioma seleccionado',
    'originalTitle': 'Título original',
    'classificationFrom': 'Clasificación obtenida desde:',
  },
  'de': {
    'movies': 'Filme',
    'tvSeries': 'Serien',
    'contentType': 'Inhaltstyp',
    'languageRegion': 'Sprache / Region',
    'inTheaters': 'Im Kino',
    'onTheAir': 'Auf Sendung',
    'monday20': 'Montag 20',
    'upcoming': 'Demnächst',
    'airingToday': 'Heute im TV',
    'thisMonth': 'Diesen Monat',
    'topRated': 'Bestbewertet',
    'allTime': 'Aller Zeiten',
    'popular': 'Beliebt',
    'release': 'Veröffentlichung:',
    'firstAirDate': 'Erstausstrahlung:',
    'actors': 'Schauspieler',
    'genres': 'Genres',
    'similarMovies': 'Ähnliche Filme',
    'similarSeries': 'Ähnliche Serien',
    'videos': 'Videos',
    'favorites': 'Favoriten',
    'noFavorites': 'Noch keine Favoriten',
    'startSearching': 'Suche starten',
    'classification': 'Klassifizierung',
    'titleInSelectedLanguage': 'Titel in ausgewählter Sprache',
    'originalTitle': 'Originaltitel',
    'classificationFrom': 'Altersfreigabe bezogen aus:',
  },
  'zh': {
    'movies': '电影',
    'tvSeries': '电视剧',
    'contentType': '内容类型',
    'languageRegion': '语言 / 地区',
    'inTheaters': '正在上映',
    'onTheAir': '正在热播',
    'monday20': '周一 20',
    'upcoming': '即将上映',
    'airingToday': '今日播出',
    'thisMonth': '本月',
    'topRated': '高分排行',
    'allTime': '历年精选',
    'popular': '热门',
    'release': '上映日期：',
    'firstAirDate': '首播日期：',
    'actors': '主演阵容',
    'genres': '题材类型',
    'similarMovies': '类似电影',
    'similarSeries': '类似电视剧',
    'videos': '精彩预告',
    'favorites': '我的收藏',
    'noFavorites': '暂无收藏',
    'startSearching': '开始探索',
    'classification': '官方分级',
    'titleInSelectedLanguage': '所选语言标题',
    'originalTitle': '原产地标题',
    'classificationFrom': '分级标准来源：',
  },
  'ar': {
    'movies': 'أفلام',
    'tvSeries': 'مسلسلات',
    'contentType': 'نوع المحتوى',
    'languageRegion': 'اللغة / المنطقة',
    'inTheaters': 'في السينما',
    'onTheAir': 'يبث حالياً',
    'monday20': 'الإثنين 20',
    'upcoming': 'قريباً',
    'airingToday': 'يُعرض اليوم',
    'thisMonth': 'هذا الشهر',
    'topRated': 'الأعلى تقييماً',
    'allTime': 'على مر التاريخ',
    'popular': 'شائع',
    'release': 'تاريخ الإصدار:',
    'firstAirDate': 'أول عرض:',
    'actors': 'طاقم التمثيل',
    'genres': 'التصنيفات',
    'similarMovies': 'أفلام مشابهة',
    'similarSeries': 'مسلسلات مشابهة',
    'videos': 'مقاطع الفيديو',
    'favorites': 'المفضلة',
    'noFavorites': 'لا توجد عناصر مفضلة',
    'startSearching': 'ابدأ البحث',
    'classification': 'التصنيف العمري',
    'titleInSelectedLanguage': 'العنوان باللغة المحددة',
    'originalTitle': 'العنوان الأصلي',
    'classificationFrom': 'التصنيف مأخوذ من:',
  },
  'ru': {
    'movies': 'Фильмы',
    'tvSeries': 'Сериалы',
    'contentType': 'Тип контента',
    'languageRegion': 'Язык / Регион',
    'inTheaters': 'В кинотеатрах',
    'onTheAir': 'В эфире',
    'monday20': 'Понедельник 20',
    'upcoming': 'Скоро',
    'airingToday': 'Сегодня в эфире',
    'thisMonth': 'В этом месяце',
    'topRated': 'Лучшие оценки',
    'allTime': 'За всё время',
    'popular': 'Популярное',
    'release': 'Премьера:',
    'firstAirDate': 'Первый эфир:',
    'actors': 'Актёры',
    'genres': 'Жанры',
    'similarMovies': 'Похожие фильмы',
    'similarSeries': 'Похожие сериалы',
    'videos': 'Видео',
    'favorites': 'Избранное',
    'noFavorites': 'Нет избранного',
    'startSearching': 'Начать поиск',
    'classification': 'Классификация',
    'titleInSelectedLanguage': 'Название на выбранном языке',
    'originalTitle': 'Оригинальное название',
    'classificationFrom': 'Классификация получена из:',
  },
};

/// Traduce una clave al idioma del locale actual.
String tr(Locale locale, String key) {
  final lang = locale.languageCode;
  return _translations[lang]?[key] ?? _translations['es']?[key] ?? key;
}

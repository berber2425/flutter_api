import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import "package:http/http.dart" as http;

final ValueNotifier<GraphQLClient> clientNotifier = ValueNotifier(
  GraphQLClient(
    link: HttpLink("http://localhost:3000/graphql", httpClient: GlobalClient()),
    cache: GraphQLCache(store: InMemoryStore()),
  ),
);

GraphQLClient get client => clientNotifier.value;

class GlobalClient extends http.BaseClient {
  final Map<String, String> additionalHeaders = {};

  static final GlobalClient _instance = GlobalClient._internal();

  factory GlobalClient() {
    return _instance;
  }

  GlobalClient._internal();

  final http.Client _client = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    request.headers.addAll(additionalHeaders);
    final res = await _client.send(request);
    // CookieSession.updateCookie(res.headers);

    return res;
  }

  bool sendDeviceHeaders = true;

  void updateHeaders({String? deviceId, String? orgId}) {
    // final packageInfo = await PackageInfo.fromPlatform();
    // final deviceToken = await NotificationController().deviceToken;
    // final apnsToken = await NotificationController().apnsToken;
    // deviceHeaders = <String, String?>{
    //   "device-id": deviceToken,
    //   "apns-token": apnsToken,
    //   "os": defaultTargetPlatform.name,
    //   "app-version": packageInfo.version,
    //   "locales": LocalizationManager()
    //       .preferredLocales
    //       .map((e) => e.toString())
    //       .join(",")
    // }.removeNulls();
    // sendDeviceHeaders = true;
    if (deviceId != null) additionalHeaders["device-id"] = deviceId;
    if (orgId != null) additionalHeaders["org-id"] = orgId;
  }
}

// class CookieSession {
//   static final Map<String, String> headers = {};

//   static SharedPreferences? _prefs;

//   static Future<void> init() async {
//     _prefs = await SharedPreferences.getInstance();
//     final cookie = _prefs!.getString("cookie");
//     if (cookie != null) {
//       final ck = Cookie.fromSetCookieValue(cookie);
//       if (ck.expires != null && ck.expires!.isBefore(DateTime.now())) {
//         _prefs!.remove("cookie");
//       } else {
//         CookieSession.headers['cookie'] = cookie;
//       }
//     }
//   }
// }

// /// Cookie cross-site availability configuration.
// ///
// /// The value of [Cookie.sameSite], which defines whether an
// /// HTTP cookie is available from other sites or not.
// ///
// /// Has three possible values: [lax], [strict] and [none].
// final class SameSite {
//   /// Default value, cookie with this value will generally not be sent on
//   /// cross-site requests, unless the user is navigated to the original site.
//   static const lax = SameSite._("Lax");

//   /// Cookie with this value will never be sent on cross-site requests.
//   static const strict = SameSite._("Strict");

//   /// Cookie with this value will be sent in all requests.
//   ///
//   /// [Cookie.secure] must also be set to true, otherwise the `none` value
//   /// will have no effect.
//   static const none = SameSite._("None");

//   static const List<SameSite> values = [lax, strict, none];

//   final String name;

//   const SameSite._(this.name);

//   @override
//   String toString() => "SameSite=$name";
// }

// /// Utility functions for working with dates with HTTP specific date
// /// formats.
// class HttpDate {
//   // From RFC-2616 section "3.3.1 Full Date",
//   // http://tools.ietf.org/html/rfc2616#section-3.3.1
//   //
//   // HTTP-date    = rfc1123-date | rfc850-date | asctime-date
//   // rfc1123-date = wkday "," SP date1 SP time SP "GMT"
//   // rfc850-date  = weekday "," SP date2 SP time SP "GMT"
//   // asctime-date = wkday SP date3 SP time SP 4DIGIT
//   // date1        = 2DIGIT SP month SP 4DIGIT
//   //                ; day month year (e.g., 02 Jun 1982)
//   // date2        = 2DIGIT "-" month "-" 2DIGIT
//   //                ; day-month-year (e.g., 02-Jun-82)
//   // date3        = month SP ( 2DIGIT | ( SP 1DIGIT ))
//   //                ; month day (e.g., Jun  2)
//   // time         = 2DIGIT ":" 2DIGIT ":" 2DIGIT
//   //                ; 00:00:00 - 23:59:59
//   // wkday        = "Mon" | "Tue" | "Wed"
//   //              | "Thu" | "Fri" | "Sat" | "Sun"
//   // weekday      = "Monday" | "Tuesday" | "Wednesday"
//   //              | "Thursday" | "Friday" | "Saturday" | "Sunday"
//   // month        = "Jan" | "Feb" | "Mar" | "Apr"
//   //              | "May" | "Jun" | "Jul" | "Aug"
//   //              | "Sep" | "Oct" | "Nov" | "Dec"

//   /// Format a date according to
//   /// [RFC-1123](http://tools.ietf.org/html/rfc1123 "RFC-1123"),
//   /// e.g. `Thu, 1 Jan 1970 00:00:00 GMT`.
//   static String format(DateTime date) {
//     const List wkday = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
//     const List month = [
//       "Jan",
//       "Feb",
//       "Mar",
//       "Apr",
//       "May",
//       "Jun",
//       "Jul",
//       "Aug",
//       "Sep",
//       "Oct",
//       "Nov",
//       "Dec"
//     ];

//     DateTime d = date.toUtc();
//     StringBuffer sb = StringBuffer()
//       ..write(wkday[d.weekday - 1])
//       ..write(", ")
//       ..write(d.day <= 9 ? "0" : "")
//       ..write(d.day.toString())
//       ..write(" ")
//       ..write(month[d.month - 1])
//       ..write(" ")
//       ..write(d.year.toString())
//       ..write(d.hour <= 9 ? " 0" : " ")
//       ..write(d.hour.toString())
//       ..write(d.minute <= 9 ? ":0" : ":")
//       ..write(d.minute.toString())
//       ..write(d.second <= 9 ? ":0" : ":")
//       ..write(d.second.toString())
//       ..write(" GMT");
//     return sb.toString();
//   }

//   /// Parse a date string in either of the formats
//   /// [RFC-1123](http://tools.ietf.org/html/rfc1123 "RFC-1123"),
//   /// [RFC-850](http://tools.ietf.org/html/rfc850 "RFC-850") or
//   /// ANSI C's asctime() format. These formats are listed here.
//   ///
//   ///     Thu, 1 Jan 1970 00:00:00 GMT
//   ///     Thursday, 1-Jan-1970 00:00:00 GMT
//   ///     Thu Jan  1 00:00:00 1970
//   ///
//   /// For more information see [RFC-2616 section
//   /// 3.1.1](http://tools.ietf.org/html/rfc2616#section-3.3.1
//   /// "RFC-2616 section 3.1.1").
//   static DateTime parse(String date) {
//     // ignore: constant_identifier_names
//     const int SP = 32;
//     const List wkdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
//     const List weekdays = [
//       "Monday",
//       "Tuesday",
//       "Wednesday",
//       "Thursday",
//       "Friday",
//       "Saturday",
//       "Sunday"
//     ];
//     const List months = [
//       "Jan",
//       "Feb",
//       "Mar",
//       "Apr",
//       "May",
//       "Jun",
//       "Jul",
//       "Aug",
//       "Sep",
//       "Oct",
//       "Nov",
//       "Dec"
//     ];

//     const int formatRfc1123 = 0;
//     const int formatRfc850 = 1;
//     const int formatAsctime = 2;

//     int index = 0;
//     String tmp;

//     void expect(String s) {
//       if (date.length - index < s.length) {
//         throw Exception("Invalid HTTP date $date");
//       }
//       String tmp = date.substring(index, index + s.length);
//       if (tmp != s) {
//         throw Exception("Invalid HTTP date $date");
//       }
//       index += s.length;
//     }

//     int expectWeekday() {
//       int weekday;
//       // The formatting of the weekday signals the format of the date string.
//       int pos = date.indexOf(",", index);
//       if (pos == -1) {
//         int pos = date.indexOf(" ", index);
//         if (pos == -1) throw Exception("Invalid HTTP date $date");
//         tmp = date.substring(index, pos);
//         index = pos + 1;
//         weekday = wkdays.indexOf(tmp);
//         if (weekday != -1) {
//           return formatAsctime;
//         }
//       } else {
//         tmp = date.substring(index, pos);
//         index = pos + 1;
//         weekday = wkdays.indexOf(tmp);
//         if (weekday != -1) {
//           return formatRfc1123;
//         }
//         weekday = weekdays.indexOf(tmp);
//         if (weekday != -1) {
//           return formatRfc850;
//         }
//       }
//       throw Exception("Invalid HTTP date $date");
//     }

//     int expectMonth(String separator) {
//       int pos = date.indexOf(separator, index);
//       if (pos - index != 3) throw Exception("Invalid HTTP date $date");
//       tmp = date.substring(index, pos);
//       index = pos + 1;
//       int month = months.indexOf(tmp);
//       if (month != -1) return month;
//       throw Exception("Invalid HTTP date $date");
//     }

//     int expectNum(String separator) {
//       int pos;
//       if (separator.isNotEmpty) {
//         pos = date.indexOf(separator, index);
//       } else {
//         pos = date.length;
//       }
//       String tmp = date.substring(index, pos);
//       index = pos + separator.length;
//       try {
//         int value = int.parse(tmp);
//         return value;
//       } on FormatException {
//         throw Exception("Invalid HTTP date $date");
//       }
//     }

//     void expectEnd() {
//       if (index != date.length) {
//         throw Exception("Invalid HTTP date $date");
//       }
//     }

//     int format = expectWeekday();
//     int year;
//     int month;
//     int day;
//     int hours;
//     int minutes;
//     int seconds;
//     if (format == formatAsctime) {
//       month = expectMonth(" ");
//       if (date.codeUnitAt(index) == SP) index++;
//       day = expectNum(" ");
//       hours = expectNum(":");
//       minutes = expectNum(":");
//       seconds = expectNum(" ");
//       year = expectNum("");
//     } else {
//       expect(" ");
//       day = expectNum(format == formatRfc1123 ? " " : "-");
//       month = expectMonth(format == formatRfc1123 ? " " : "-");
//       year = expectNum(" ");
//       hours = expectNum(":");
//       minutes = expectNum(":");
//       seconds = expectNum(" ");
//       expect("GMT");
//     }
//     expectEnd();
//     return DateTime.utc(year, month + 1, day, hours, minutes, seconds, 0);
//   }

//   // Parse a cookie date string.
//   static DateTime _parseCookieDate(String date) {
//     const List monthsLowerCase = [
//       "jan",
//       "feb",
//       "mar",
//       "apr",
//       "may",
//       "jun",
//       "jul",
//       "aug",
//       "sep",
//       "oct",
//       "nov",
//       "dec"
//     ];

//     int position = 0;

//     Never error() {
//       throw Exception("Invalid cookie date $date");
//     }

//     bool isEnd() => position == date.length;

//     bool isDelimiter(String s) {
//       int char = s.codeUnitAt(0);
//       if (char == 0x09) return true;
//       if (char >= 0x20 && char <= 0x2F) return true;
//       if (char >= 0x3B && char <= 0x40) return true;
//       if (char >= 0x5B && char <= 0x60) return true;
//       if (char >= 0x7B && char <= 0x7E) return true;
//       return false;
//     }

//     bool isNonDelimiter(String s) {
//       int char = s.codeUnitAt(0);
//       if (char >= 0x00 && char <= 0x08) return true;
//       if (char >= 0x0A && char <= 0x1F) return true;
//       if (char >= 0x30 && char <= 0x39) return true; // Digit
//       if (char == 0x3A) return true; // ':'
//       if (char >= 0x41 && char <= 0x5A) return true; // Alpha
//       if (char >= 0x61 && char <= 0x7A) return true; // Alpha
//       if (char >= 0x7F && char <= 0xFF) return true; // Alpha
//       return false;
//     }

//     bool isDigit(String s) {
//       int char = s.codeUnitAt(0);
//       if (char > 0x2F && char < 0x3A) return true;
//       return false;
//     }

//     int getMonth(String month) {
//       if (month.length < 3) return -1;
//       return monthsLowerCase.indexOf(month.substring(0, 3));
//     }

//     int toInt(String s) {
//       int index = 0;
//       for (; index < s.length && isDigit(s[index]); index++) {}
//       return int.parse(s.substring(0, index));
//     }

//     var tokens = <String>[];
//     while (!isEnd()) {
//       while (!isEnd() && isDelimiter(date[position])) {
//         position++;
//       }
//       int start = position;
//       while (!isEnd() && isNonDelimiter(date[position])) {
//         position++;
//       }
//       tokens.add(date.substring(start, position).toLowerCase());
//       while (!isEnd() && isDelimiter(date[position])) {
//         position++;
//       }
//     }

//     String? timeStr;
//     String? dayOfMonthStr;
//     String? monthStr;
//     String? yearStr;

//     for (var token in tokens) {
//       if (token.isEmpty) continue;
//       if (timeStr == null &&
//           token.length >= 5 &&
//           isDigit(token[0]) &&
//           (token[1] == ":" || (isDigit(token[1]) && token[2] == ":"))) {
//         timeStr = token;
//       } else if (dayOfMonthStr == null && isDigit(token[0])) {
//         dayOfMonthStr = token;
//       } else if (monthStr == null && getMonth(token) >= 0) {
//         monthStr = token;
//       } else if (yearStr == null &&
//           token.length >= 2 &&
//           isDigit(token[0]) &&
//           isDigit(token[1])) {
//         yearStr = token;
//       }
//     }

//     if (timeStr == null ||
//         dayOfMonthStr == null ||
//         monthStr == null ||
//         yearStr == null) {
//       error();
//     }

//     int year = toInt(yearStr);
//     if (year >= 70 && year <= 99) {
//       year += 1900;
//     } else if (year >= 0 && year <= 69) {
//       year += 2000;
//     }
//     if (year < 1601) error();

//     int dayOfMonth = toInt(dayOfMonthStr);
//     if (dayOfMonth < 1 || dayOfMonth > 31) error();

//     int month = getMonth(monthStr) + 1;

//     var timeList = timeStr.split(":");
//     if (timeList.length != 3) error();
//     int hour = toInt(timeList[0]);
//     int minute = toInt(timeList[1]);
//     int second = toInt(timeList[2]);
//     if (hour > 23) error();
//     if (minute > 59) error();
//     if (second > 59) error();

//     return DateTime.utc(year, month, dayOfMonth, hour, minute, second, 0);
//   }
// }

// class _Cookie implements Cookie {
//   String _name;
//   String _value;
//   @override
//   DateTime? expires;
//   @override
//   int? maxAge;
//   @override
//   String? domain;
//   String? _path;
//   @override
//   bool httpOnly = false;
//   @override
//   bool secure = false;
//   @override
//   SameSite? sameSite;

//   _Cookie(String name, String value)
//       : _name = _validateName(name),
//         _value = _validateValue(value),
//         httpOnly = true;

//   @override
//   String get name => _name;
//   @override
//   String get value => _value;

//   @override
//   String? get path => _path;

//   @override
//   set path(String? newPath) {
//     _validatePath(newPath);
//     _path = newPath;
//   }

//   @override
//   set name(String newName) {
//     _validateName(newName);
//     _name = newName;
//   }

//   @override
//   set value(String newValue) {
//     _validateValue(newValue);
//     _value = newValue;
//   }

//   _Cookie.fromSetCookieValue(String value)
//       : _name = "",
//         _value = "" {
//     // Parse the 'set-cookie' header value.
//     _parseSetCookieValue(value);
//   }

//   // Parse a 'set-cookie' header value according to the rules in RFC 6265.
//   void _parseSetCookieValue(String s) {
//     int index = 0;

//     bool done() => index == s.length;

//     String parseName() {
//       int start = index;
//       while (!done()) {
//         if (s[index] == "=") break;
//         index++;
//       }
//       return s.substring(start, index).trim();
//     }

//     String parseValue() {
//       int start = index;
//       while (!done()) {
//         if (s[index] == ";") break;
//         index++;
//       }
//       return s.substring(start, index).trim();
//     }

//     void parseAttributes() {
//       String parseAttributeName() {
//         int start = index;
//         while (!done()) {
//           if (s[index] == "=" || s[index] == ";") break;
//           index++;
//         }
//         return s.substring(start, index).trim().toLowerCase();
//       }

//       String parseAttributeValue() {
//         int start = index;
//         while (!done()) {
//           if (s[index] == ";") break;
//           index++;
//         }
//         return s.substring(start, index).trim().toLowerCase();
//       }

//       while (!done()) {
//         String name = parseAttributeName();
//         String value = "";
//         if (!done() && s[index] == "=") {
//           index++; // Skip the = character.
//           value = parseAttributeValue();
//         }
//         if (name == "expires") {
//           expires = HttpDate._parseCookieDate(value);
//         } else if (name == "max-age") {
//           maxAge = int.parse(value);
//         } else if (name == "domain") {
//           domain = value;
//         } else if (name == "path") {
//           path = value;
//         } else if (name == "httponly") {
//           httpOnly = true;
//         } else if (name == "secure") {
//           secure = true;
//         } else if (name == "samesite") {
//           sameSite = switch (value) {
//             "lax" => SameSite.lax,
//             "none" => SameSite.none,
//             "strict" => SameSite.strict,
//             _ => throw Exception(
//                 'SameSite value should be one of Lax, Strict or None.')
//           };
//         }
//         if (!done()) index++; // Skip the ; character
//       }
//     }

//     _name = _validateName(parseName());
//     if (done() || _name.isEmpty) {
//       throw Exception("Failed to parse header value [$s]");
//     }
//     index++; // Skip the = character.
//     _value = _validateValue(parseValue());
//     if (done()) return;
//     index++; // Skip the ; character.
//     parseAttributes();
//   }

//   @override
//   String toString() {
//     StringBuffer sb = StringBuffer();
//     sb
//       ..write(_name)
//       ..write("=")
//       ..write(_value);
//     var expires = this.expires;
//     if (expires != null) {
//       sb
//         ..write("; Expires=")
//         ..write(HttpDate.format(expires));
//     }
//     if (maxAge != null) {
//       sb
//         ..write("; Max-Age=")
//         ..write(maxAge);
//     }
//     if (domain != null) {
//       sb
//         ..write("; Domain=")
//         ..write(domain);
//     }
//     if (path != null) {
//       sb
//         ..write("; Path=")
//         ..write(path);
//     }
//     if (secure) sb.write("; Secure");
//     if (httpOnly) sb.write("; HttpOnly");
//     if (sameSite != null) sb.write("; $sameSite");

//     return sb.toString();
//   }

//   static String _validateName(String newName) {
//     const separators = [
//       "(",
//       ")",
//       "<",
//       ">",
//       "@",
//       ",",
//       ";",
//       ":",
//       "\\",
//       '"',
//       "/",
//       "[",
//       "]",
//       "?",
//       "=",
//       "{",
//       "}"
//     ];
//     for (int i = 0; i < newName.length; i++) {
//       int codeUnit = newName.codeUnitAt(i);
//       if (codeUnit <= 32 ||
//           codeUnit >= 127 ||
//           separators.contains(newName[i])) {
//         throw FormatException(
//             "Invalid character in cookie name, code unit: '$codeUnit'",
//             newName,
//             i);
//       }
//     }
//     return newName;
//   }

//   static String _validateValue(String newValue) {
//     int start = 0;
//     int end = newValue.length;
//     if (2 <= newValue.length &&
//         newValue.codeUnits[start] == 0x22 &&
//         newValue.codeUnits[end - 1] == 0x22) {
//       start++;
//       end--;
//     }

//     for (int i = start; i < end; i++) {
//       int codeUnit = newValue.codeUnits[i];
//       if (!(codeUnit == 0x21 ||
//           (codeUnit >= 0x23 && codeUnit <= 0x2B) ||
//           (codeUnit >= 0x2D && codeUnit <= 0x3A) ||
//           (codeUnit >= 0x3C && codeUnit <= 0x5B) ||
//           (codeUnit >= 0x5D && codeUnit <= 0x7E))) {
//         throw FormatException(
//             "Invalid character in cookie value, code unit: '$codeUnit'",
//             newValue,
//             i);
//       }
//     }
//     return newValue;
//   }

//   static void _validatePath(String? path) {
//     if (path == null) return;
//     for (int i = 0; i < path.length; i++) {
//       int codeUnit = path.codeUnitAt(i);
//       // According to RFC 6265, semicolon and controls should not occur in the
//       // path.
//       // path-value = <any CHAR except CTLs or ";">
//       // CTLs = %x00-1F / %x7F
//       if (codeUnit < 0x20 || codeUnit >= 0x7f || codeUnit == 0x3b /*;*/) {
//         throw FormatException(
//             "Invalid character in cookie path, code unit: '$codeUnit'");
//       }
//     }
//   }
// }

// /// Representation of a cookie. For cookies received by the server as Cookie
// /// header values only [name] and [value] properties will be set. When building a
// /// cookie for the 'set-cookie' header in the server and when receiving cookies
// /// in the client as 'set-cookie' headers all fields can be used.
// abstract interface class Cookie {
//   /// The name of the cookie.
//   ///
//   /// Must be a `token` as specified in RFC 6265.
//   ///
//   /// The allowed characters in a `token` are the visible ASCII characters,
//   /// U+0021 (`!`) through U+007E (`~`), except the separator characters:
//   /// `(`, `)`, `<`, `>`, `@`, `,`, `;`, `:`, `\`, `"`, `/`, `[`, `]`, `?`, `=`,
//   /// `{`, and `}`.
//   late String name;

//   /// The value of the cookie.
//   ///
//   /// Must be a `cookie-value` as specified in RFC 6265.
//   ///
//   /// The allowed characters in a cookie value are the visible ASCII characters,
//   /// U+0021 (`!`) through U+007E (`~`) except the characters:
//   /// `"`, `,`, `;` and `\`.
//   /// Cookie values may be wrapped in a single pair of double quotes
//   /// (U+0022, `"`).
//   late String value;

//   /// The time at which the cookie expires.
//   DateTime? expires;

//   /// The number of seconds until the cookie expires. A zero or negative value
//   /// means the cookie has expired.
//   int? maxAge;

//   /// The domain that the cookie applies to.
//   String? domain;

//   /// The path within the [domain] that the cookie applies to.
//   String? path;

//   /// Whether to only send this cookie on secure connections.
//   bool secure = false;

//   /// Whether the cookie is only sent in the HTTP request and is not made
//   /// available to client side scripts.
//   bool httpOnly = false;

//   /// Whether the cookie is available from other sites.
//   ///
//   /// This value is `null` if the SameSite attribute is not present.
//   ///
//   /// See [SameSite] for more information.
//   SameSite? sameSite;

//   /// Creates a new cookie setting the name and value.
//   ///
//   /// [name] and [value] must be composed of valid characters according to RFC
//   /// 6265.
//   ///
//   /// By default the value of `httpOnly` will be set to `true`.
//   factory Cookie(String name, String value) => _Cookie(name, value);

//   /// Creates a new cookie by parsing a header value from a 'set-cookie'
//   /// header.
//   factory Cookie.fromSetCookieValue(String value) {
//     return _Cookie.fromSetCookieValue(value);
//   }

//   /// Returns the formatted string representation of the cookie. The
//   /// string representation can be used for setting the Cookie or
//   /// 'set-cookie' headers
//   @override
//   String toString();
// }

# Berber Flutter API

Berber platformunun Flutter uygulamaları için API altyapısı. Bu paket, backend servisleriyle iletişim için gerekli tüm API katmanını sağlar.

## Özellikler

- GraphQL client entegrasyonu
- HTTP client yönetimi
- Hata yönetimi
- Önbellekleme
- Yeniden deneme mekanizması
- Oturum yönetimi
- İstek interceptor'ları

## Teknik Detaylar

### Kullanılan Teknolojiler

- Flutter
- GraphQL (berber2425/gql_client)
- Dio HTTP client
- Hive (önbellekleme için)

### Geliştirme Ortamı Gereksinimleri

- Flutter SDK
- VS Code veya Android Studio
- Git

### Kurulum

1. Repository'yi klonlayın

```bash
git clone https://github.com/berber2425/flutter_api.git
```

2. Bağımlılıkları yükleyin

```bash
flutter pub get
```

## Proje Yapısı

```
lib/
  ├── src/
  │   ├── client/         # API client implementasyonları
  │   │   ├── graphql/    # GraphQL client
  │   │   └── http/       # HTTP client
  │   ├── interceptors/   # İstek interceptor'ları
  │   ├── cache/          # Önbellekleme yönetimi
  │   ├── error/          # Hata yönetimi
  │   ├── retry/          # Yeniden deneme mekanizması
  │   └── auth/           # Oturum yönetimi
  └── berber_api.dart     # Ana paket dosyası
```

## Kullanım

```dart
import 'package:berber_api/berber_api.dart';

// API istemcisini yapılandırma
final api = BerberApi(
  baseUrl: 'https://api.berber.com',
  authToken: 'user-token',
);

// GraphQL isteği örneği
final response = await api.graphql.query(
  document: UserQueries.getUser,
  variables: {'id': 'user-id'},
);

// HTTP isteği örneği
final response = await api.http.get('/users/me');

// Önbellekli istek örneği
final response = await api.cached.get(
  '/users/me',
  duration: Duration(minutes: 5),
);
```

## Özelleştirme

### İstek Interceptor'ı Ekleme

```dart
api.addInterceptor(
  BerberInterceptor(
    onRequest: (request) {
      // İstek öncesi işlemler
      return request;
    },
    onResponse: (response) {
      // Yanıt sonrası işlemler
      return response;
    },
    onError: (error) {
      // Hata durumunda işlemler
      return error;
    },
  ),
);
```

### Yeniden Deneme Stratejisi

```dart
api.setRetryStrategy(
  RetryStrategy(
    maxAttempts: 3,
    delayBetweenAttempts: Duration(seconds: 1),
    shouldRetry: (error) {
      // Hangi hatalarda yeniden deneneceğini belirle
      return error.isNetworkError;
    },
  ),
);
```

## Katkıda Bulunma

1. Fork yapın
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Değişikliklerinizi commit edin (`git commit -m 'feat: add amazing feature'`)
4. Branch'inizi push edin (`git push origin feature/amazing-feature`)
5. Pull Request oluşturun

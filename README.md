# Xtream UI - Docker

Bu proje, Xtream UI IPTV Panel'in Docker üzerinde çalışan versiyonudur.

## Özellikler

- Tam Docker desteği
- MySQL veritabanı
- Redis cache
- Otomatik kurulum
- Admin paneli
- Kanal yönetimi
- EPG desteği
- Film ve dizi yönetimi
- Playlist oluşturma

## Gereksinimler

- Docker
- Docker Compose

## Kurulum

1. Projeyi klonlayın:
```bash
git clone https://github.com/dearbulut/xtream-docker.git
cd xtream-docker
```

2. Docker Compose ile başlatın:
```bash
docker-compose up -d
```

3. Tarayıcıda açın:
```
http://localhost:8000
```

4. Giriş yapın:
- Email: admin@example.com
- Şifre: password

## Servisler

- **Web Uygulaması**: Laravel 11
- **Veritabanı**: MySQL 8.0
- **Cache**: Redis

## Portlar

- Web uygulaması: 8000
- MySQL: 3306
- Redis: 6379

## Kalıcı Veriler

Veriler Docker volumes'da saklanır:
- MySQL verileri: mysql_data volume
- Uygulama storage: ./storage dizini

## Durdurma

```bash
docker-compose down
```

Verileri tamamen silmek için:
```bash
docker-compose down -v
```

## Sorun Giderme

1. Logları kontrol etme:
```bash
docker-compose logs -f
```

2. Container'ları yeniden başlatma:
```bash
docker-compose restart
```

3. Temiz kurulum:
```bash
docker-compose down -v
docker system prune -a
docker-compose up -d --build
```

## Lisans

MIT License
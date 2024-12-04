# pymongo-api

## Задание 1. Планирование

Схемы приложения находятся тут: https://drive.google.com/file/d/1G8XDKuPBGRL1FXMgBxP1zA86DqaDoB4J/view?usp=sharing

На первой схеме показана исходная структура приложения

1 этап. Далее показан первый вариант схемы - использование шардирование в MongoDB для повышения производительности.

2 этап. Второй вариант схемы. Показана реализация репликации MongoDB для повышения отказоустойчивости.

3 этап. Третий вариант схемы - показано кэширование для ещё большего повышения производительности.

4 этап. Показана релизация трех инстансов приложения с использованием API Gateway  и Consul.

5 этап. Показана реализация сервиса CDN для доставки статического контента пользователям в разных регионах.



## Как запустить

Перед запуском желательно удалить все запущенные контейнеры

```shell
docker-compose down
```

Запускаем mongodb и приложение

```shell
docker compose up -d
```

Заполняем mongodb данными

```shell
./scripts/mongo-init.sh
```

## Как проверить

### Если вы запускаете проект на локальной машине

Откройте в браузере http://localhost:8080

### Если вы запускаете проект на предоставленной виртуальной машине

Узнать белый ip виртуальной машины

```shell
curl --silent http://ifconfig.me
```

Откройте в браузере http://<ip виртуальной машины>:8080

## Доступные эндпоинты

Список доступных эндпоинтов, swagger http://<ip виртуальной машины>:8080/docs
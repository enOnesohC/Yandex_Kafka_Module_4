# Инструкция по развёртыванию проекта

## Описание проекта

Данный проект показывает работу с коннекторами kafka.
Окружение проекта состоит из контейнеров docker:

- kafka: кластер kafka из трёх брокеров
- ui kafka: интерфейс для взаимодействия с брокерами kafka
- postgresql: база данных
- schema-registry: хранение схем для топиков
- debezium-ui: интерфейс для взаимодействия с коннектором debezium
- kafka-connect: соединяет коннекторы и брокеры
- jmx-kafka: источник JMX-метрик на каждый брокер 
- connector-registrator: выполняет привязку debezium к postgresql, единоразово, при развёртывании контейнеров
- kafka-exporter: сбор данных с топиков
- grafana: визуализация метрик
- prometheus: хранилище метрик

## Шаг 1.

Проверьте, установлен ли Docker на вашем компьютере. Если нет, скачайте и установите его с официального сайта Docker.
Проверьте, что Docker работает, выполнив команду в терминале:

docker --version 
Ожидаемый вывод: версия установленного Docker.

Создать папку в корне проекта: confluent-hub-components

Скачать файлы с адресов:
https://mvnrepository.com/artifact/org.apache.kafka/connect-file/3.9.0
https://www.confluent.io/hub/confluentinc/kafka-connect-jdbc
https://debezium.io/documentation/reference/stable/install.html

распаковать их в папку confluent-hub-components

## Шаг 2.

В терминале перейдите в папку, в которой будет располагаться тестовый проект
Выполнить команду:
git clone https://github.com/enOnesohC/Yandex_Kafka_Module_4.git

Ожидаемый результат: устанавливается тестовое окружение в папку

## Шаг 3.

Откройте терминал в папке с файлом docker-compose.yaml

Для запуска всех сервисов используйте команду:
docker-compose up 

## Шаг 4.

Выполнить команду:
curl.exe http://localhost:8083/connector-plugins

Ожидаемый вывод: список подключенных коннекторов

## Шаг 5.

Выполнить команду:

curl.exe -s http://localhost:8083/connectors/pg-connector/status

Ожидаемый вывод: "connector":{"state":"RUNNING"..."

## Шаг 6.

Подключиться к БД, используя команду:
docker exec -it postgres psql -h 127.0.0.1 -U postgres-user -d customers

Ввести команды:
INSERT INTO users (name, email) VALUES ('John Doe', 'john@example.com');
INSERT INTO users (name, email) VALUES ('Jane Smith', 'jane@example.com');
INSERT INTO users (name, email) VALUES ('Alice Johnson', 'alice@example.com');
INSERT INTO users (name, email) VALUES ('Bob Brown', 'bob@example.com');

Ввести команды:
INSERT INTO orders (user_id, product_name, quantity) VALUES (1, 'Product A', 2);
INSERT INTO orders (user_id, product_name, quantity) VALUES (1, 'Product B', 1);
INSERT INTO orders (user_id, product_name, quantity) VALUES (2, 'Product C', 5);
INSERT INTO orders (user_id, product_name, quantity) VALUES (3, 'Product D', 3);

## Шаг 7.

Выполнить скрипт из файла GetMessages.py

Ожидаемый результат: Количество выведенных сообщений должно быть 8 (по 4 в каждом топике)

## Шаг 8.

Перейти по адресу: http://localhost:9090/targets?search=

Ожидаемый результат: все targets имеют статус "UP"

## Шаг 9.

Перейти по адресу: http://localhost:3001/
Зайти в grafana c использованием логина "admin" и пароля "kafka"
Вывести Dashboard Kafka Cluster / Global HealthCheck

Ожидаемый результат: должны быть активны параметры Dashboard

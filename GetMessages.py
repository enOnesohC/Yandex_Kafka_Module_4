from confluent_kafka import Consumer, serialization

conf = {
    'bootstrap.servers': 'localhost:9094',
    'group.id': 'my-reader-group',
    'auto.offset.reset': 'earliest',   # читать с начала
    'enable.auto.commit': False,
}

consumer = Consumer(conf)
consumer.subscribe(['customers.public.users', 'customers.public.orders'])

print("Подключено, читаем сообщения...\n")

try:
    while True:
        msg = consumer.poll(0.1)
        if msg is None:
            continue
        if msg.error():
            print(f"Ошибка SingleMessageConsumer: {msg.error()}")
            continue

        key = msg.key().decode("utf-8") if msg.key() else None
        value = serialization.StringDeserializer('utf_8')(msg.value())
        print(
            f"Получено сообщение: {key=}, {value=}"
        )
except KeyboardInterrupt:
    print("\nОстановлено пользователем")
finally:
    consumer.close()
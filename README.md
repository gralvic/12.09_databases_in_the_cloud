# Домашнее задание к занятию 12.09 "Базы данных в облаке" - Алексей Григорьев

### Задание 1


#### Создание кластера
1. Перейдите на главную страницу сервиса Managed Service for PostgreSQL.
1. Создайте кластер PostgreSQL со следующими параметрами:
- Класс хоста: s2.micro, диск network-ssd любого размера;
- Хосты: нужно создать два хоста в двух  разных зонах доступности  и указать необходимость публичного доступа (публичного IP адреса) для них;
- Установите учетную запись для пользователя и базы.

Остальные параметры оставьте по умолчанию либо измените по своему усмотрению.

* Нажмите кнопку "Создать кластер" и дождитесь окончания процесса создания (Статус кластера = RUNNING). Кластер создается от 5 до 10 минут.

![image](https://github.com/gralvic/12.09_databases_in_the_cloud/blob/main/01_PostgresSQL_cluster_for_Netology.png)

#### Подключение к мастеру и реплике 

* Используйте инструкцию по подключению к кластеру, доступную на вкладке "Обзор": cкачайте SSL сертификат и подключитесь к кластеру с помощью утилиты psql, указав hostname всех узлов и атрибут ```target_session_attrs=read-write```.

* Проверьте, что подключение прошло к master-узлу.
```
select case when pg_is_in_recovery() then 'REPLICA' else 'MASTER' end;
```
* Посмотрите количество подключенных реплик:
```
select count(*) from pg_stat_replication;
```

### Проверьте работоспособность репликации в кластере

* Создайте таблицу и вставьте одну-две строки.
```
CREATE TABLE test_table(text varchar);
```
```
insert into test_table values('Строка 1');
```

![image](https://github.com/gralvic/12.09_databases_in_the_cloud/blob/main/02_master.png)

* Выйдите из psql командой ```\q```.

* Теперь подключитесь к узлу-реплике. Для этого из команды подключения удалите атрибут ```target_session_attrs``` , и в параметре атрибут ```host``` передайте только имя хоста-реплики. Роли хостов можно посмотреть на соответствующей вкладке UI консоли.

* Проверьте, что подключение прошло к узлу-реплике.
```
select case when pg_is_in_recovery() then 'REPLICA' else 'MASTER' end;
```
* Проверьте состояние репликации
```
select status from pg_stat_wal_receiver;
```

* Для проверки, что механизм репликации данных работает между зонами доступности облака, выполните запрос к таблице, созданной на предыдущем шаге:
```
select * from test_table;
```

![image](https://github.com/gralvic/12.09_databases_in_the_cloud/blob/main/03_replica.png)

*В качестве результата вашей работы пришлите скриншоты:*

*1) Созданной базы данных;*
*2) Результата вывода команды на реплике ```select * from test_table;```.*



### Задание 2*

Создайте кластер, как в задании 1 с помощью terraform.


*В качестве результата вашей работы пришлите скришоты:*

*1) Скриншот созданной базы данных;*
*2) Код terraform, создающий базу данных.*

---

Задания, помеченные звездочкой * - дополнительные (не обязательные к выполнению) и никак не повлияют на получение вами зачета по этому домашнему заданию. Вы можете их выполнить, если хотите глубже и/или шире разобраться в материале.

![image](https://github.com/gralvic/12.09_databases_in_the_cloud/blob/main/04_creating_cluster_by_terraform.png)

![image](https://github.com/gralvic/12.09_databases_in_the_cloud/blob/main/05_creating_database_by_terraform.png)

![image](https://github.com/gralvic/12.09_databases_in_the_cloud/blob/main/06_connect_to_database.png)

Ссылка на конфигурационный файл Terraform
https://github.com/gralvic/12.09_databases_in_the_cloud/blob/main/main.tf


-- Лукьянчиков Валерий Геннадьевич
-- Домашнее задание ко второму модулю
-- Вариант 4
--
-- Задание:
-- Заполнить таблицы минимум пятью записями.
-- 1. Вывести номера стеллажей, объем одного места
--    и суммарный объем всех мест.
-- 2. Вывести названия клиентов и количество их товаров.

CREATE TABLE rooms (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    useful_volume NUMERIC(10,2) NOT NULL CHECK (useful_volume > 0),
    min_temperature NUMERIC(5,2),
    max_temperature NUMERIC(5,2),
    min_humidity NUMERIC(5,2),
    max_humidity NUMERIC(5,2),
    CHECK (min_temperature <= max_temperature),
    CHECK (min_humidity BETWEEN 0 AND 100),
    CHECK (max_humidity BETWEEN 0 AND 100)
);

CREATE TABLE racks (
    id SERIAL PRIMARY KEY,
    rack_number INTEGER NOT NULL,
    room_id INTEGER NOT NULL REFERENCES rooms(id),
    places_count INTEGER NOT NULL CHECK (places_count > 0),
    place_height NUMERIC(10,2) NOT NULL,
    place_width NUMERIC(10,2) NOT NULL,
    place_length NUMERIC(10,2) NOT NULL,
    max_load NUMERIC(10,2) NOT NULL,
    UNIQUE (room_id, rack_number)
);

CREATE TABLE clients (
    id SERIAL PRIMARY KEY,
    company_name VARCHAR(200) NOT NULL,
    bank_details TEXT NOT NULL
);

CREATE TABLE goods (
    id SERIAL PRIMARY KEY,
    height NUMERIC(10,2) NOT NULL,
    width NUMERIC(10,2) NOT NULL,
    length NUMERIC(10,2) NOT NULL,
    weight NUMERIC(10,2) NOT NULL,
    arrival_date DATE NOT NULL DEFAULT CURRENT_DATE,
    contract_number VARCHAR(50) NOT NULL,
    client_id INTEGER NOT NULL REFERENCES clients(id),
    contract_end_date DATE NOT NULL,
    min_temperature NUMERIC(5,2),
    max_temperature NUMERIC(5,2),
    min_humidity NUMERIC(5,2),
    max_humidity NUMERIC(5,2),
    rack_id INTEGER NOT NULL REFERENCES racks(id),
    position_number INTEGER NOT NULL,
    CHECK (contract_end_date >= arrival_date),
    UNIQUE (rack_id, position_number)
);

INSERT INTO rooms
(name, useful_volume, min_temperature, max_temperature, min_humidity, max_humidity)
VALUES
('Склад 1', 500, 15, 25, 30, 60),
('Склад 2', 600, 10, 20, 30, 65),
('Склад 3', 400, 5, 15, 40, 70),
('Склад 4', 700, 15, 25, 30, 60),
('Склад 5', 550, 10, 25, 35, 65);

INSERT INTO racks
(rack_number, room_id, places_count, place_height,
 place_width, place_length, max_load)
VALUES
(1, 1, 10, 1.5, 1.2, 1.0, 1000),
(2, 2, 12, 1.8, 1.0, 1.2, 1200),
(3, 3, 8, 1.2, 1.0, 1.0, 800),
(4, 4, 15, 2.0, 1.5, 1.2, 1500),
(5, 5, 10, 1.5, 1.0, 1.0, 1000);

INSERT INTO clients (company_name, bank_details)
VALUES
('ООО Альфа', 'Р/с 40702810000000000001'),
('ООО Бета', 'Р/с 40702810000000000002'),
('ООО Гамма', 'Р/с 40702810000000000003'),
('ООО Дельта', 'Р/с 40702810000000000004'),
('ООО Вектор', 'Р/с 40702810000000000005');

INSERT INTO goods
(height, width, length, weight, arrival_date,
 contract_number, client_id, contract_end_date,
 min_temperature, max_temperature,
 min_humidity, max_humidity, rack_id, position_number)
VALUES
(1.0, 0.8, 0.7, 50, '2026-09-01', 'D001', 1, '2027-09-01', 15, 25, 30, 60, 1, 1),
(1.2, 0.9, 0.8, 70, '2026-09-02', 'D002', 2, '2027-09-02', 10, 20, 30, 65, 2, 1),
(0.8, 0.7, 0.6, 30, '2026-09-03', 'D003', 3, '2027-09-03', 5, 15, 40, 70, 3, 1),
(1.5, 1.0, 0.9, 90, '2026-09-04', 'D004', 4, '2027-09-04', 15, 25, 30, 60, 4, 1),
(1.0, 0.8, 0.7, 40, '2026-09-05', 'D005', 5, '2027-09-05', 10, 25, 35, 65, 5, 1),
(0.9, 0.7, 0.6, 35, '2026-09-06', 'D006', 1, '2027-09-06', 15, 25, 30, 60, 1, 2),
(1.1, 0.8, 0.7, 45, '2026-09-07', 'D007', 2, '2027-09-07', 10, 20, 30, 65, 2, 2),
(0.7, 0.6, 0.5, 25, '2026-09-08', 'D008', 3, '2027-09-08', 5, 15, 40, 70, 3, 2);

-- Задание 1
SELECT
    rack_number,
    place_height * place_width * place_length AS place_volume,
    place_height * place_width * place_length * places_count AS total_volume
FROM racks;

-- Задание 2
SELECT
    clients.company_name,
    COUNT(goods.id) AS goods_count
FROM clients
LEFT JOIN goods ON clients.id = goods.client_id
GROUP BY clients.id, clients.company_name
ORDER BY clients.company_name;

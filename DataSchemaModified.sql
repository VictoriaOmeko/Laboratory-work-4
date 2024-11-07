-- Видалення таблиць з каскадним видаленням можливих описів цілісності
DROP TABLE IF EXISTS feedback CASCADE;
DROP TABLE IF EXISTS creative_work CASCADE;
DROP TABLE IF EXISTS workspace CASCADE;
DROP TABLE IF EXISTS lighting_setting CASCADE;
DROP TABLE IF EXISTS "user" CASCADE;
DROP TABLE IF EXISTS audience CASCADE;

-- Таблиця користувачів
CREATE TABLE user (
    user_id SERIAL PRIMARY KEY,  -- ID користувача
    name VARCHAR(50) NOT NULL,  -- Ім'я користувача
    role VARCHAR(20) NOT NULL CHECK (role ~ '^(admin|artist|viewer)$'),
    -- Роль користувача, регулярний вираз для обмеження на перелік ролей
    CONSTRAINT user_name_unique UNIQUE (name)
);

-- Таблиця налаштувань освітлення
CREATE TABLE lighting_setting (
    lighting_setting_id SERIAL PRIMARY KEY,  -- ID налаштування
    brightness INT CHECK
    (brightness BETWEEN 0 AND 100),  -- Яскравість, від 0 до 100
    color VARCHAR(7) CHECK (color ~ '^#([A-Fa-f0-9]{6})$'),
    -- HEX-код кольору (регулярний вираз)
    direction VARCHAR(50),  -- Напрямок освітлення
    model VARCHAR(50) UNIQUE,  -- Модель освітлення, має бути унікальною
    user_id INT REFERENCES "user" (user_id)
    ON DELETE SET NULL  -- Зовнішній ключ на користувача
);

-- Таблиця робочого простору
CREATE TABLE workspace (
    workspace_id SERIAL PRIMARY KEY,  -- ID робочого простору
    location VARCHAR(100) NOT NULL UNIQUE,  -- Місце розташування
    lighting_setting_id INT
    REFERENCES lighting_setting (lighting_setting_id) ON DELETE SET NULL
    -- Зовнішній ключ на налаштування освітлення
);

-- Таблиця творчих робіт
CREATE TABLE creative_work (
    creative_work_id SERIAL PRIMARY KEY,  -- ID творчої роботи
    title VARCHAR(100) NOT NULL,  -- Назва творчої роботи
    content TEXT NOT NULL,  -- Зміст творчої роботи
    creation_date DATE CHECK (creation_date <= CURRENT_DATE),
    -- Дата створення, не може перевищувати поточну
    user_id INT REFERENCES "user" (user_id) ON DELETE SET NULL
    -- Зовнішній ключ на користувача
);

-- Таблиця аудиторій
CREATE TABLE audience (
    audience_id SERIAL PRIMARY KEY  -- ID аудиторії
);

-- Таблиця відгуків
CREATE TABLE feedback (
    feedback_id SERIAL PRIMARY KEY,  -- ID відгуку
    comments TEXT,  -- Коментарі до творчої роботи
    ratings INT CHECK (ratings BETWEEN 1 AND 5),  -- Оцінка, від 1 до 5
    date DATE CHECK (date <= CURRENT_DATE),
    -- Дата відгуку, не може перевищувати поточну
    creative_work_id INT REFERENCES creative_work
    (creative_work_id) ON DELETE CASCADE,  -- Зовнішній ключ на творчу роботу
    audience_id INT REFERENCES audience (audience_id)
    ON DELETE CASCADE  -- Зовнішній ключ на аудиторію
);
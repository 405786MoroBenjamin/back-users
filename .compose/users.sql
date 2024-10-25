-- CREATE DATABASE IF NOT EXISTS users;

-- CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY 'root';
-- GRANT ALL PRIVILEGES ON Users.* TO 'root'@'%';
-- FLUSH PRIVILEGES;

-- USE users

CREATE TABLE users (
                       id INT AUTO_INCREMENT PRIMARY KEY,
                       name VARCHAR(255),
                       lastname VARCHAR(255),
                       username VARCHAR(255),
                       password VARCHAR(255),
                       dni INT,
                       active TINYINT(1),
                       avatar_url VARCHAR(255),
                       birth_date DATE,
                       telegram_id INT,
                       created_datetime DATETIME,
                       last_updated_datetime DATETIME,
                       created_user INT,
                       last_updated_user INT
);

CREATE TABLE plotusers (
                           id INT AUTO_INCREMENT PRIMARY KEY,
                           plot_id INT,
                           user_id INT,
                           created_datetime DATETIME,
                           last_updated_datetime DATETIME,
                           created_user INT,
                           last_updated_user INT,
                           FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE roles (
                       id INT AUTO_INCREMENT PRIMARY KEY,
                       description VARCHAR(255),
                       created_datetime DATETIME,
                       last_updated_datetime DATETIME,
                       created_user INT,
                       last_updated_user INT
);

CREATE TABLE userroles (
                           id INT AUTO_INCREMENT PRIMARY KEY,
                           role_id INT,
                           user_id INT,
                           created_datetime DATETIME,
                           last_updated_datetime DATETIME,
                           created_user INT,
                           last_updated_user INT,
                           FOREIGN KEY (role_id) REFERENCES roles(id),
                           FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE users_audit (
                             version_id INT AUTO_INCREMENT PRIMARY KEY,
                             id INT,
                             version INT,
                             name VARCHAR(255),
                             lastname VARCHAR(255),
                             username VARCHAR(255),
                             password VARCHAR(255),
                             dni INT,
                             active TINYINT(1),
                             avatar_url VARCHAR(255),
                             birth_date DATE,
                             telegram_id INT,
                             created_datetime DATETIME,
                             last_updated_datetime DATETIME,
                             created_user INT,
                             last_updated_user INT
);

CREATE TABLE plotusers_audit (
                                 version_id INT AUTO_INCREMENT PRIMARY KEY,
                                 id INT,
                                 version INT,
                                 plot_id INT,
                                 user_id INT,
                                 created_datetime DATETIME,
                                 last_updated_datetime DATETIME,
                                 created_user INT,
                                 last_updated_user INT
);

CREATE TABLE roles_audit (
                             version_id INT AUTO_INCREMENT PRIMARY KEY,
                             id INT,
                             version INT,
                             description VARCHAR(255),
                             created_datetime DATETIME,
                             last_updated_datetime DATETIME,
                             created_user INT,
                             last_updated_user INT
);

CREATE TABLE userroles_audit (
                                 version_id INT AUTO_INCREMENT PRIMARY KEY,
                                 id INT,
                                 version INT,
                                 role_id INT,
                                 user_id INT,
                                 created_datetime DATETIME,
                                 last_updated_datetime DATETIME,
                                 created_user INT,
                                 last_updated_user INT
);

-- Trigger para insertar en la auditoría de Users
DELIMITER $$
CREATE TRIGGER trg_users_insert
    AFTER INSERT ON users
    FOR EACH ROW
BEGIN
    INSERT INTO users_audit (id, version, name, lastname, username, password, dni, active, avatar_url, birth_date, telegram_id, created_datetime, last_updated_datetime, created_user, last_updated_user)
    VALUES (NEW.id, 1, NEW.name, NEW.lastname, NEW.username, NEW.password, NEW.dni, NEW.active, NEW.avatar_url, NEW.birth_date, NEW.telegram_id, NEW.created_datetime, NEW.last_updated_datetime, NEW.created_user, NEW.last_updated_user);
END $$


-- Trigger para actualizar en la auditoría de Users
DELIMITER $$
CREATE TRIGGER trg_users_update
    AFTER UPDATE ON users
    FOR EACH ROW
BEGIN
    DECLARE latest_version INT;
    SELECT MAX(version) INTO latest_version FROM users_audit WHERE id = NEW.id;
    SET latest_version = IFNULL(latest_version, 0) + 1;

    INSERT INTO users_audit (id, version, name, lastname, username, password, dni, active, avatar_url, birth_date, telegram_id, created_datetime, last_updated_datetime, created_user, last_updated_user)
    VALUES (NEW.id, latest_version, NEW.name, NEW.lastname, NEW.username, NEW.password, NEW.dni,  NEW.active, NEW.avatar_url, NEW.birth_date, telegram_id, NEW.created_datetime, NEW.last_updated_datetime, NEW.created_user, NEW.last_updated_user);
END $$

-- Trigger para insertar en la auditoría de PlotUsers
DELIMITER $$
CREATE TRIGGER trg_plotusers_insert
    AFTER INSERT ON plotusers
    FOR EACH ROW
BEGIN
    INSERT INTO plotusers_audit (id, version, plot_id, user_id, created_datetime, last_updated_datetime, created_user, last_updated_user)
    VALUES (NEW.id, 1, NEW.plot_id, NEW.user_id, NEW.created_datetime, NEW.last_updated_datetime, NEW.created_user, NEW.last_updated_user);
END $$

-- Trigger para actualizar en la auditoría de PlotUsers
DELIMITER $$
CREATE TRIGGER trg_plotusers_update
    AFTER UPDATE ON plotusers
    FOR EACH ROW
BEGIN
    DECLARE latest_version INT;
    SELECT MAX(version) INTO latest_version FROM plotusers_audit WHERE id = NEW.id;
    SET latest_version = IFNULL(latest_version, 0) + 1;

    INSERT INTO plotusers_audit (id, version, plot_id, user_id, created_datetime, last_updated_datetime, created_user, last_updated_user)
    VALUES (NEW.id, latest_version, NEW.plot_id, NEW.user_id, NEW.created_datetime, NEW.last_updated_datetime, NEW.created_user, NEW.last_updated_user);
END $$

-- Trigger para insertar en la auditoría de Roles
DELIMITER $$
CREATE TRIGGER trg_roles_insert
    AFTER INSERT ON roles
    FOR EACH ROW
BEGIN
    INSERT INTO roles_audit (id, version, description, created_datetime, last_updated_datetime, created_user, last_updated_user)
    VALUES (NEW.id, 1, NEW.description, NEW.created_datetime, NEW.last_updated_datetime, NEW.created_user, NEW.last_updated_user);
END $$

-- Trigger para actualizar en la auditoría de Roles
DELIMITER $$
CREATE TRIGGER trg_roles_update
    AFTER UPDATE ON roles
    FOR EACH ROW
BEGIN
    DECLARE latest_version INT;
    SELECT MAX(version) INTO latest_version FROM roles_audit WHERE id = NEW.id;
    SET latest_version = IFNULL(latest_version, 0) + 1;

    INSERT INTO roles_audit (id, version, description, created_datetime, last_updated_datetime, created_user, last_updated_user)
    VALUES (NEW.id, latest_version, NEW.description, NEW.created_datetime, NEW.last_updated_datetime, NEW.created_user, NEW.last_updated_user);
END $$

-- Trigger para insertar en la auditoría de UserRoles
DELIMITER $$
CREATE TRIGGER trg_userroles_insert
    AFTER INSERT ON userroles
    FOR EACH ROW
BEGIN
    INSERT INTO userroles_audit (id, version, role_id, user_id, created_datetime, last_updated_datetime, created_user, last_updated_user)
    VALUES (NEW.id, 1, NEW.role_id, NEW.user_id, NEW.created_datetime, NEW.last_updated_datetime, NEW.created_user, NEW.last_updated_user);
END $$

-- Trigger para actualizar en la auditoría de UserRoles
DELIMITER $$
CREATE TRIGGER trg_userroles_update
    AFTER UPDATE ON userroles
    FOR EACH ROW
BEGIN
    DECLARE latest_version INT;
    SELECT MAX(version) INTO latest_version FROM userroles_audit WHERE id = NEW.id;
    SET latest_version = IFNULL(latest_version, 0) + 1;

    INSERT INTO userroles_audit (id, version, role_id, user_id, created_datetime, last_updated_datetime, created_user, last_updated_user)
    VALUES (NEW.id, latest_version, NEW.role_id, NEW.user_id, NEW.created_datetime, NEW.last_updated_datetime, NEW.created_user, NEW.last_updated_user);
END $$

INSERT INTO roles (description, created_datetime, last_updated_datetime, created_user, last_updated_user)
VALUES
('Admin', NOW(), NOW(), 1, 1),
('Owner', NOW(), NOW(), 1, 1),
('Family Member', NOW(), NOW(), 1, 1),
('XD', NOW(), NOW(), 1, 1);

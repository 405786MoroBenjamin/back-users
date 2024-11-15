
-- Tabla dni_type
CREATE TABLE dni_type (
                          id INT AUTO_INCREMENT PRIMARY KEY,
                          description VARCHAR(255),
                          created_datetime DATETIME,
                          last_updated_datetime DATETIME,
                          created_user INT,
                          last_updated_user INT
);


CREATE TABLE users (
                       id INT AUTO_INCREMENT PRIMARY KEY,
                       name VARCHAR(255),
                       lastname VARCHAR(255),
                       username VARCHAR(255),
                       password VARCHAR(255),
                       dni VARCHAR(255),
                       dni_type_id INT,
                       active TINYINT(1),
                       avatar_url VARCHAR(255),
                       birth_date DATE,
                       telegram_id INT,
                       created_datetime DATETIME,
                       last_updated_datetime DATETIME,
                       created_user INT,
                       last_updated_user INT,
                       FOREIGN KEY (dni_type_id) REFERENCES dni_type(id)
);

-- Tabla plotusers
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

-- Tabla roles
CREATE TABLE roles (
                       id INT AUTO_INCREMENT PRIMARY KEY,
                       description VARCHAR(255),
                       created_datetime DATETIME,
                       last_updated_datetime DATETIME,
                       created_user INT,
                       last_updated_user INT
);

-- Tabla userroles
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

-- Tablas de auditoría
CREATE TABLE users_audit (
                             version_id INT AUTO_INCREMENT PRIMARY KEY,
                             id INT,
                             version INT,
                             name VARCHAR(255),
                             lastname VARCHAR(255),
                             username VARCHAR(255),
                             password VARCHAR(255),
                             dni VARCHAR(255),
                             dni_type_id INT,
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


CREATE TABLE dni_type_audit (
                                version_id INT AUTO_INCREMENT PRIMARY KEY,
                                id INT,
                                version INT,
                                description VARCHAR(255),
                                created_datetime DATETIME,
                                last_updated_datetime DATETIME,
                                created_user INT,
                                last_updated_user INT
);

-- Triggers de auditoría
DELIMITER $$

-- Trigger para insertar en la auditoría de Users
CREATE TRIGGER trg_users_insert
    AFTER INSERT ON users
    FOR EACH ROW
BEGIN
    INSERT INTO users_audit (id, version, name, lastname, username, password, dni_type_id, dni, active, avatar_url, birth_date, telegram_id, created_datetime, last_updated_datetime, created_user, last_updated_user)
    VALUES (NEW.id, 1, NEW.name, NEW.lastname, NEW.username, NEW.password, NEW.dni_type_id,NEW.dni , NEW.active, NEW.avatar_url, NEW.birth_date, NEW.telegram_id, NEW.created_datetime, NEW.last_updated_datetime, NEW.created_user, NEW.last_updated_user);
END $$

-- Trigger para actualizar en la auditoría de Users
CREATE TRIGGER trg_users_update
    AFTER UPDATE ON users
    FOR EACH ROW
BEGIN
    DECLARE latest_version INT;
    SELECT MAX(version) INTO latest_version FROM users_audit WHERE id = NEW.id;
    SET latest_version = IFNULL(latest_version, 0) + 1;

    INSERT INTO users_audit (id, version, name, lastname, username, password, dni_type_id, dni, active, avatar_url, birth_date, telegram_id, created_datetime, last_updated_datetime, created_user, last_updated_user)
    VALUES (NEW.id, latest_version, NEW.name, NEW.lastname, NEW.username, NEW.password, NEW.dni_type_id, NEW.dni, NEW.active, NEW.avatar_url, NEW.birth_date, NEW.telegram_id, NEW.created_datetime, NEW.last_updated_datetime, NEW.created_user, NEW.last_updated_user);
END $$

-- Trigger para insertar en la auditoría de PlotUsers
CREATE TRIGGER trg_plotusers_insert
    AFTER INSERT ON plotusers
    FOR EACH ROW
BEGIN
    INSERT INTO plotusers_audit (id, version, plot_id, user_id, created_datetime, last_updated_datetime, created_user, last_updated_user)
    VALUES (NEW.id, 1, NEW.plot_id, NEW.user_id, NEW.created_datetime, NEW.last_updated_datetime, NEW.created_user, NEW.last_updated_user);
END $$

-- Trigger para actualizar en la auditoría de PlotUsers
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
CREATE TRIGGER trg_roles_insert
    AFTER INSERT ON roles
    FOR EACH ROW
BEGIN
    INSERT INTO roles_audit (id, version, description, created_datetime, last_updated_datetime, created_user, last_updated_user)
    VALUES (NEW.id, 1, NEW.description, NEW.created_datetime, NEW.last_updated_datetime, NEW.created_user, NEW.last_updated_user);
END $$

-- Trigger para actualizar en la auditoría de Roles
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
CREATE TRIGGER trg_userroles_insert
    AFTER INSERT ON userroles
    FOR EACH ROW
BEGIN
    INSERT INTO userroles_audit (id, version, role_id, user_id, created_datetime, last_updated_datetime, created_user, last_updated_user)
    VALUES (NEW.id, 1, NEW.role_id, NEW.user_id, NEW.created_datetime, NEW.last_updated_datetime, NEW.created_user, NEW.last_updated_user);
END $$

-- Trigger para actualizar en la auditoría de UserRoles
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

DELIMITER ;

DELIMITER $$

-- Trigger para insertar en la auditoría de dni_type
CREATE TRIGGER trg_dni_type_insert
    AFTER INSERT ON dni_type
    FOR EACH ROW
BEGIN
    INSERT INTO dni_type_audit (id, version, description, created_datetime, last_updated_datetime, created_user, last_updated_user)
    VALUES (NEW.id, 1, NEW.description, NEW.created_datetime, NEW.last_updated_datetime, NEW.created_user, NEW.last_updated_user);
END $$

-- Trigger para actualizar en la auditoría de dni_type
CREATE TRIGGER trg_dni_type_update
    AFTER UPDATE ON dni_type
    FOR EACH ROW
BEGIN
    DECLARE latest_version INT;
    SELECT MAX(version) INTO latest_version FROM dni_type_audit WHERE id = NEW.id;
    SET latest_version = IFNULL(latest_version, 0) + 1;

    INSERT INTO dni_type_audit (id, version, description, created_datetime, last_updated_datetime, created_user, last_updated_user)
    VALUES (NEW.id, latest_version, NEW.description, NEW.created_datetime, NEW.last_updated_datetime, NEW.created_user, NEW.last_updated_user);
END $$

DELIMITER ;

-- Insertar roles
INSERT INTO roles (description, created_datetime, last_updated_datetime, created_user, last_updated_user)
VALUES
    ('Admin', NOW(), NOW(), 1, 1),
    ('Owner', NOW(), NOW(), 1, 1),
    ('Family Member', NOW(), NOW(), 1, 1),
    ('Minor Member', NOW(), NOW(), 1, 1);

-- Insertar tipos de DNI
INSERT INTO dni_type (description, created_datetime, last_updated_datetime, created_user, last_updated_user)
VALUES
    ('DNI', NOW(), NOW(), 1, 1),
    ('CUIT', NOW(), NOW(), 1, 1),
    ('CUIL', NOW(), NOW(), 1, 1),
    ('Pasaporte', NOW(), NOW(), 1, 1);
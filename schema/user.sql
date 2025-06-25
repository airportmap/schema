CREATE TABLE user (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR( 32 ) NOT NULL UNIQUE,
    email VARCHAR( 255 ) NOT NULL UNIQUE,
    passwd VARCHAR( 255 ) NOT NULL,
    registred DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    _role ENUM( 'user', 'moderator', 'admin', 'bot' ) NOT NULL DEFAULT 'user',
    _status ENUM( 'pending', 'active', 'banned', 'suspended', 'deleted' ) NOT NULL DEFAULT 'pending',
    last_login DATETIME NULL
);
CREATE TABLE user (

    _id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    username VARCHAR( 32 ) NOT NULL UNIQUE,
    email VARCHAR( 255 ) NOT NULL UNIQUE,
    passwd_hash VARCHAR( 255 ) NOT NULL,
    token VARCHAR( 255 ) NULL,

    _verified DATETIME NULL,
    _role ENUM( 'user', 'moderator', 'admin', 'bot' ) NOT NULL DEFAULT 'user',
    _status ENUM( 'pending', 'active', 'banned', 'suspended', 'deleted' ) NOT NULL DEFAULT 'pending',

    registered DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    activated DATETIME NULL,

    last_login DATETIME NULL,
    failed_attempts INT UNSIGNED NOT NULL DEFAULT 0,
    last_failed DATETIME NULL,

    _2fa_secret VARCHAR( 255 ) NULL,
    _2fa_created DATETIME NULL,

    edit_count INT UNSIGNED NOT NULL DEFAULT 0,
    approved_edits INT UNSIGNED NOT NULL DEFAULT 0,
    rejected_edits INT UNSIGNED NOT NULL DEFAULT 0,
    last_edit DATETIME NULL,

    KEY user_role ( _role ),
    KEY account_status ( _status )

);
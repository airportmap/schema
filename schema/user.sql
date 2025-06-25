CREATE TABLE user (

    _id INT( 10 ) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,

    username VARBINARY( 32 ) NOT NULL UNIQUE,
    email VARBINARY( 255 ) NOT NULL UNIQUE,
    passwd_hash TINYBLOB NOT NULL,
    passwd_newhash TINYBLOB NULL,
    token BINARY( 32 ) NULL,
    token_expires DATETIME NULL,

    _role ENUM( 'user', 'moderator', 'admin', 'bot' ) NOT NULL DEFAULT 'user',
    _status ENUM( 'pending', 'active', 'banned', 'suspended', 'deleted' ) NOT NULL DEFAULT 'pending',
    _verified DATETIME NULL,

    registered DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    activated DATETIME NULL,

    last_login DATETIME NULL,
    failed_attempts INT UNSIGNED NOT NULL DEFAULT 0,
    last_failed DATETIME NULL,

    edit_count INT UNSIGNED NOT NULL DEFAULT 0,
    pending_edits INT UNSIGNED NOT NULL DEFAULT 0,
    approved_edits INT UNSIGNED NOT NULL DEFAULT 0,
    rejected_edits INT UNSIGNED NOT NULL DEFAULT 0,
    last_edit DATETIME NULL,

    _2fa_secret VARBINARY( 255 ) NULL,
    _2fa_created DATETIME NULL,

    _options JSON NULL,

    KEY user_role ( _role ),
    KEY account_status ( _status )

);
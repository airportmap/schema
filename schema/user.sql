-- ========================================================================
-- TABLE user
-- ------------------------------------------------------------------------
-- Defines all registered users of the Airportmap platform, including
-- their authentication data, role assignments, 2FA support, activity
-- statistics, and optional configuration.
--
-- Usernames and emails are stored as binary values to enforce strict
-- case-sensitivity and prevent normalization issues.
-- ========================================================================

CREATE TABLE user (

    -- Auto incrementing user ID
    _id INT( 10 ) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,

    -- Unique, case-sensitive username and email (stored in binary)
    username VARBINARY( 32 ) NOT NULL,
    email VARBINARY( 255 ) NOT NULL,

    -- Hashed login credentials
    passwd_hash TINYBLOB NOT NULL,           -- current password hash (e.g. bcrypt or Argon2)
    passwd_newhash TINYBLOB NULL,            -- temporary/next-gen hash (for migration or reset)

    -- Email verification or session token (binary-safe)
    token BINARY( 32 ) NULL,
    token_expires DATETIME NULL,

    -- Role-based access control (RBAC)
    _role ENUM( 'user', 'moderator', 'admin', 'bot' ) NOT NULL DEFAULT 'user',

    -- Account lifecycle status
    _status ENUM( 'pending', 'active', 'blocked', 'closed' ) NOT NULL DEFAULT 'pending',

    -- Internal verification (e.g. for trusted editors or staff)
    _verified DATETIME NULL,

    -- Timestamps for registration and activation
    registered DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    activated DATETIME NULL,

    -- Login history and failed attempt tracking
    last_login DATETIME NULL,
    failed_attempts INT UNSIGNED NOT NULL DEFAULT 0,
    last_failed DATETIME NULL,

    -- Edit statistics used for moderation and trust assessment
    edit_count INT UNSIGNED NOT NULL DEFAULT 0,
    pending_edits INT UNSIGNED NOT NULL DEFAULT 0,
    approved_edits INT UNSIGNED NOT NULL DEFAULT 0,
    rejected_edits INT UNSIGNED NOT NULL DEFAULT 0,
    last_edit DATETIME NULL,

    -- Two-factor authentication (TOTP support)
    _2fa_secret TINYBLOB NULL,
    _2fa_created DATETIME NULL,

    -- Optional user-defined or system-assigned JSON options
    _options JSON DEFAULT NULL,

    -- Indexes for administrative filtering
    PRIMARY KEY ( _id ),
    UNIQUE KEY user_uname ( username ),
    UNIQUE KEY user_email ( email ),
    KEY user_role ( _role ),
    KEY account_status ( _status )

);
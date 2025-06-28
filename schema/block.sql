-- ========================================================================
-- TABLE block
-- ------------------------------------------------------------------------
-- Stores block entries for users, IP addresses, email addresses or
-- user-agents (e.g. bots, suspicious clients). Blocks can be applied
-- manually by moderators/admins or automatically by the system.
--
-- During login, registration, or any user interaction, this table can
-- be queried to check whether the request source is blocked.
-- ========================================================================

CREATE TABLE block (

    -- Internal ID for each block entry
    _id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,

    -- Type of the target: 'ip', 'user', 'email', 'ua' (user agent)
    _type ENUM ( 'ip', 'user', 'email', 'ua' ) NOT NULL,

    -- What is being blocked (stored as raw binary value, e.g. IP, user ID, email hash)
    _target TINYBLOB NOT NULL,

    -- ID of the user who initiated the block (admin or moderator),
    -- or NULL for automated/system-generated blocks
    actor INT UNSIGNED NULL,

    -- Optional reason or comment for the block
    reason BLOB NULL,

    -- When the block was issued
    blocked DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- When the block will expire (NULL means permanent block)
    expires DATETIME NULL,

    -- Optional flags or structured meta data
    _meta JSON NULL,

    -- Indexes
    KEY block_target ( _type, _target( 32 ) ),
    KEY block_actor ( actor ),
    KEY block_expires ( expires ),

    -- Foreign key constraints
    FOREIGN KEY ( actor ) REFERENCES user ( _id ),

    -- Integrity checks
    CHECK ( JSON_VALID( _meta ) OR _meta IS NULL )

);

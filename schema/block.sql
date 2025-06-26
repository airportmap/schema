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
    _id INT( 10 ) UNSIGNED NOT NULL AUTO_INCREMENT,

    -- Type of the target: 'ip', 'user', 'email', 'ua' (user agent)
    _type ENUM( 'ip', 'user', 'email', 'ua' ) NOT NULL,

    -- What is being blocked (stored as raw binary value, e.g. IP, user ID, email hash)
    _target VARBINARY( 255 ) NOT NULL,

    -- ID of the user who initiated the block (admin, moderator),
    -- or -1 for automated/system-generated blocks
    actor INT( 10 ) UNSIGNED NOT NULL,

    -- Optional reason or comment for the block
    reason BLOB NULL,

    -- When the block was issued
    blocked DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- When the block will expire (NULL means permanent block)
    expires DATETIME NULL,

    -- Optional flags or structured data
    _options JSON NULL,

    -- Indexes for searching / filtering operations
    PRIMARY KEY ( _id ),
    KEY block_target ( _type, _target( 32 ) ),
    KEY block_expires ( expires ),

    -- Foreign key constraints
    FOREIGN KEY ( actor ) REFERENCES user ( _id )

);
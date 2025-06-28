-- ========================================================================
-- TABLE: audit
-- ------------------------------------------------------------------------
-- Records security-relevant actions and permission changes performed
-- by users or the system (e.g. role changes, bans, unbans, updates)
-- on user accounts.
-- ========================================================================

CREATE TABLE audit (

    -- Internal audit log ID
    _id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,

    -- Affected user
    user INT UNSIGNED NOT NULL,

    -- Acting user (admin, moderator, or NULL for system)
    actor INT UNSIGNED NULL,

    -- Action type
    _type ENUM (
      'create',         -- User account created
      'update',         -- Profile data or settings changed
      'activate',       -- Account activated
      'delete',         -- Account permanently removed
      'role_change',    -- Role or permission level changed
      'ban',            -- Account banned
      'unban',          -- Account unbanned
      'pw_reset',       -- Password manually reset by admin or via link
      'login_failed',   -- Too many failed login attempts / lockout
      'email_change',   -- Email address modified
      '2fa_enable',     -- Two-factor authentication enabled
      '2fa_disable',    -- Two-factor authentication disabled
      'data_export'     -- User data export (GDPR)
    ) NOT NULL,

    -- Timestamp of the action
    ts DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- Optional structured meta data for extensibility
    _meta JSON NULL,

    -- Indexes
    KEY audit_user ( user ),
    KEY audit_actor ( actor ),
    KEY audit_type ( _type ),
    KEY audit_ts ( ts ),

    -- Foreign key constraints
    FOREIGN KEY ( user ) REFERENCES user ( _id ),
    FOREIGN KEY ( actor ) REFERENCES user ( _id ),

    -- Integrity checks
    CHECK ( _meta IS NULL OR JSON_VALID( _meta ) )

);
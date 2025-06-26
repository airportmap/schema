-- ========================================================================
-- TABLE tz
-- ------------------------------------------------------------------------
-- Stores supported timezones with their common label and UTC offset.
-- ========================================================================

CREATE TABLE tz (

    -- Internal ID
    _id INT( 10 ) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,

    -- Ident code / time zone abbreviation (e.g. "CET", "PST")
    ident VARBINARY( 32 ) NOT NULL UNIQUE,
    code VARBINARY( 8 ) NOT NULL,

    -- Canonical timezone label and optional multilingual names
    label VARBINARY( 64 ) NOT NULL,
    names JSON NULL,

    -- UTC offset in minutes (e.g. 60 for +01:00, -480 for -08:00)
    offset SMALLINT NOT NULL,

    -- Index for common filtering operations
    KEY tz_code ( code )

);
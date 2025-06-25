-- ========================================================================
-- TABLE tz
-- ------------------------------------------------------------------------
-- Stores supported timezones with their common label and UTC offset.
-- ========================================================================

CREATE TABLE tz (

    -- Internal ID
    _id INT( 10 ) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,

    -- Common code / abbreviation (e.g. "CET", "PST")
    code VARBINARY( 8 ) NOT NULL UNIQUE,

    -- Canonical timezone label and optional multilingual names
    label VARBINARY( 64 ) NOT NULL,
    names JSON NULL,

    -- UTC offset in minutes (e.g. 60 for +01:00, -480 for -08:00)
    offset SMALLINT NOT NULL,

    -- Custom options and meta data
    _options JSON NULL,

    -- Index for common filtering operations
    KEY tz_code ( code )

);
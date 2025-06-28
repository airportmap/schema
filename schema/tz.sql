-- ========================================================================
-- TABLE tz
-- ------------------------------------------------------------------------
-- Stores supported timezones with their common label and UTC offset.
--
-- References child to parent timezones (e.g. daylight to standard).
-- ========================================================================

CREATE TABLE tz (

    -- Internal ID
    _id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,

    -- Ident code & time zone abbreviation (e.g. "CET", "PST")
    ident VARBINARY( 32 ) NOT NULL,
    short VARBINARY(  8 ) NOT NULL,

    -- Canonical timezone label and optional multilingual names
    label TINYBLOB NOT NULL,
    i18n  JSON NULL,

    -- UTC offset in minutes (e.g. 60 for +01:00, -480 for -08:00)
    offset SMALLINT NOT NULL,

    -- Optional parent (used for standard timezone)
    parent INT UNSIGNED NULL,

    -- Geographical boundaries (WGS84)
    poly MULTIPOLYGON SRID 4326 NOT NULL,

    -- Indexes
    UNIQUE KEY region_ident ( ident ),
    KEY tz_short ( short ),
    KEY tz_offset ( offset ),
    SPATIAL KEY region_poly ( poly ),

    -- Foreign key to parent timezone (if any)
    FOREIGN KEY ( parent ) REFERENCES tz ( _id ),

    -- Integrity checks
    CHECK ( JSON_VALID( i18n ) OR i18n IS NULL ),
    CHECK ( ST_SRID( poly ) = 4326 AND ST_IsValid( poly ) )

);

-- ========================================================================
-- TABLE tz
-- ------------------------------------------------------------------------
-- Stores supported timezones with their common label and UTC offset.
-- ========================================================================

CREATE TABLE tz (

    -- Internal ID
    _id INT( 10 ) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,

    -- Ident code / time zone abbreviation (e.g. "CET", "PST")
    ident VARBINARY( 32 ) NOT NULL,
    code  VARBINARY( 8 ) NOT NULL,

    -- Canonical timezone label and optional multilingual names
    label TINYBLOB NOT NULL,
    i18n  JSON NULL,

    -- UTC offset in minutes (e.g. 60 for +01:00, -480 for -08:00)
    offset SMALLINT NOT NULL,

    -- Optional parent (used for standard timezone)
    parent INT( 10 ) UNSIGNED NULL,

    -- Geographical boundaries (WGS84)
    poly MULTIPOLYGON SRID 4326 NOT NULL,

    -- Indexes
    UNIQUE KEY region_ident ( ident ),
    KEY tz_code ( code ),
    KEY tz_offset ( offset ),
    SPATIAL KEY region_poly ( poly ),

    -- Foreign key to parent timezone (if any)
    FOREIGN KEY ( parent ) REFERENCES tz ( _id ),

    -- Integrity checks
    CHECK ( i18n IS NULL OR JSON_VALID( i18n ) ),
    CHECK ( ST_SRID( poly ) = 4326 AND ST_IsValid( poly ) )

);

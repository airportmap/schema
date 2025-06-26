-- ========================================================================
-- TABLE tz
-- ------------------------------------------------------------------------
-- Stores supported timezones with their common label and UTC offset.
-- ========================================================================

CREATE TABLE tz (

    -- Internal ID
    _id INT( 10 ) UNSIGNED NOT NULL AUTO_INCREMENT,

    -- Ident code / time zone abbreviation (e.g. "CET", "PST")
    ident VARBINARY( 32 ) NOT NULL,
    code VARBINARY( 8 ) NOT NULL,

    -- Canonical timezone label and optional multilingual names
    label VARBINARY( 64 ) NOT NULL,
    names JSON NULL,

    -- UTC offset in minutes (e.g. 60 for +01:00, -480 for -08:00)
    offset SMALLINT NOT NULL,

    -- Geographical boundaries (WGS84)
    poly MULTIPOLYGON SRID 4326 NOT NULL,

    -- Indexes for searching / filtering operations
    PRIMARY KEY ( _id ),
    UNIQUE KEY region_ident ( ident ),
    KEY tz_code ( code ),
    KEY tz_offset ( offset ),
    SPATIAL KEY region_poly ( poly ),

    -- Geographical consistency check
    CHECK ( ST_IsValid( poly ) )

);
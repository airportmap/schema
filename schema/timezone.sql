-- --------------------------------------------------------------------------------
-- Table `timezone`
-- 
-- Stores time zones with hierarchical relationships and geographical boundaries.
-- Uses offset in minutes relative to UTC.
-- -------------------------------------------------------------------------------

CREATE TABLE timezone (

    -- Internal ID
    _id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,

    -- Ident code & time zone abbreviation (e.g. "CET", "PST")
    ident VARBINARY( 32 ) NOT NULL,
    short VARBINARY(  8 ) NOT NULL,

    -- Canonical timezone label and optional multilingual names
    label TINYBLOB NOT NULL,
    i18n  JSON NULL,

    -- UTC offset in minutes (e.g. 60 for +01:00, -480 for -08:00)
    _offset SMALLINT NOT NULL,

    -- Optional parent (used for standard timezone)
    parent INT UNSIGNED NULL,

    -- Geographical boundaries (WGS84)
    poly MULTIPOLYGON SRID 4326 NULL,

    -- Indexes
    UNIQUE KEY region_ident ( ident ),

    KEY tz_short ( short ),
    KEY tz_offset ( _offset ),
    KEY tz_parent ( parent ),

    -- Foreign keys
    FOREIGN KEY ( parent ) REFERENCES timezone ( _id ),

    -- Constraints
    CONSTRAINT tz_i18n CHECK (
        JSON_VALID( i18n ) OR
        i18n IS NULL
    ),

    CONSTRAINT tz_poly CHECK (
        poly IS NULL OR (
            ST_SRID( poly ) = 4326 AND
            ST_IsValid( poly )
        )
    )

);

-- --------------------------------------------------------------------------------
-- Table `region`
-- 
-- Stores countries and regions with hierarchical relationships and
-- geographical boundaries.
-- -------------------------------------------------------------------------------

CREATE TABLE region (

    -- Internal ID
    _id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,

    -- Type of region: 'country' or 'region'
    _type ENUM ( 'country', 'region' ) NOT NULL,

    -- Common ISO code (e.g. "US", "EU", "DE", "US-NY")
    ident VARBINARY( 8 ) NOT NULL,

    -- Canonical region label and optional multilingual names
    label TINYBLOB NOT NULL,
    i18n  JSON NULL,

    -- Optional parent (region -> country)
    parent INT UNSIGNED NULL,

    -- Geographical boundaries (WGS84)
    poly MULTIPOLYGON SRID 4326 NULL,

    -- Indexes
    UNIQUE KEY region_ident ( ident ),

    KEY region_parent ( parent ),

    -- Foreign keys
    FOREIGN KEY ( parent ) REFERENCES region ( _id ),

    -- Constraints
    CONSTRAINT region_i18n CHECK (
        JSON_VALID( i18n ) OR
        i18n IS NULL
    ),

    CONSTRAINT region_poly CHECK (
        poly IS NULL OR (
            ST_SRID( poly ) = 4326 AND
            ST_IsValid( poly )
        )
    )

);

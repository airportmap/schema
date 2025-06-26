-- ========================================================================
-- TABLE region
-- ------------------------------------------------------------------------
-- Stores global geographic units including continents, countries,
-- and administrative subregions. Hierarchical with ISO codes and
-- optional multilingual labels.
-- ========================================================================

CREATE TABLE region (

    -- Internal ID
    _id INT( 10 ) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,

    -- Type of region: 'continent', 'country', 'region'
    _type ENUM ( 'continent', 'country', 'region' ) NOT NULL,

    -- Common ISO code (e.g. "US", "EU", "DE", "US-NY")
    ident VARBINARY( 8 ) NOT NULL,

    -- Canonical region label and optional multilingual names
    label TINYBLOB NOT NULL,
    i18n  JSON NULL,

    -- Optional parent (e.g. continent or country)
    parent INT( 10 ) UNSIGNED NULL,

    -- Geographical boundaries (WGS84)
    poly MULTIPOLYGON SRID 4326 NOT NULL,

    -- Indexes
    UNIQUE KEY region_ident ( ident ),
    SPATIAL KEY region_poly ( poly ),
    KEY region_parent ( parent ),

    -- Foreign key to parent region (if any)
    FOREIGN KEY ( parent ) REFERENCES region ( _id ),

    -- Integrity checks
    CHECK ( i18n IS NULL OR JSON_VALID( i18n ) ),
    CHECK ( ST_SRID( poly ) = 4326 AND ST_IsValid( poly ) )

);

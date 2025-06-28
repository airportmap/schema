-- ========================================================================
-- TABLE region
-- ------------------------------------------------------------------------
-- Stores global geographic units including countries and administrative
-- subregions.
--
-- Hierarchical with ISO codes and optional multilingual labels.
-- ========================================================================

CREATE TABLE region (

    -- Internal ID
    _id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,

    -- Type of region: 'country', 'region'
    _type ENUM ( 'country', 'region' ) NOT NULL,

    -- Common ISO code (e.g. "US", "EU", "DE", "US-NY")
    ident VARBINARY( 8 ) NOT NULL,

    -- Canonical region label and optional multilingual names
    label TINYBLOB NOT NULL,
    i18n  JSON NULL,

    -- Optional parent (region -> country)
    parent INT UNSIGNED NULL,

    -- Geographical boundaries (WGS84)
    poly MULTIPOLYGON SRID 4326 NOT NULL,

    -- Indexes
    UNIQUE KEY region_ident ( ident ),
    SPATIAL KEY region_poly ( poly ),
    KEY region_parent ( parent ),

    -- Foreign key to parent region (if any)
    FOREIGN KEY ( parent ) REFERENCES region ( _id ),

    -- Integrity checks
    CHECK ( JSON_VALID( i18n ) OR i18n IS NULL ),
    CHECK ( ST_SRID( poly ) = 4326 AND ST_IsValid( poly ) )

);

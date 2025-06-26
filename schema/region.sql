-- ========================================================================
-- TABLE region
-- ------------------------------------------------------------------------
-- Stores global geographic units including continents, countries,
-- and administrative subregions. Hierarchical with ISO codes and
-- optional multilingual labels.
-- ========================================================================

CREATE TABLE region (

    -- Internal ID
    _id INT( 10 ) UNSIGNED NOT NULL AUTO_INCREMENT,

    -- Type of region: 'continent', 'country', 'region'
    _type ENUM( 'continent', 'country', 'region' ) NOT NULL,

    -- Common ISO code (e.g. "US", "EU", "DE", "US-NY")
    ident VARBINARY( 16 ) NOT NULL,

    -- Canonical region label and optional multilingual names
    label VARBINARY( 64 ) NOT NULL,
    names JSON DEFAULT NULL,

    -- Optional parent (e.g. continent or country)
    parent INT( 10 ) UNSIGNED NULL,

    -- Geographical boundaries (WGS84)
    poly MULTIPOLYGON SRID 4326 NOT NULL,

    -- Indexes for searching / filtering operations
    PRIMARY KEY ( _id ),
    UNIQUE KEY region_ident ( ident ),
    SPATIAL KEY region_poly ( poly ),
    KEY region_parent ( parent ),

    -- Foreign key to parent region (if any)
    FOREIGN KEY ( parent ) REFERENCES region ( _id ),

    -- Geographical consistency check
    CHECK ( ST_IsValid( poly ) )

);
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
    _type ENUM( 'continent', 'country', 'region' ) NOT NULL,

    -- Common ISO code (e.g. "US", "EU", "DE", "US-NY")
    code VARBINARY( 16 ) NOT NULL UNIQUE,

    -- Canonical region label and optional multilingual names
    label VARBINARY( 64 ) NOT NULL,
    names JSON NULL,

    -- Optional parent (e.g. continent or country)
    parent INT( 10 ) UNSIGNED NULL,

    -- Custom options and meta data
    _options JSON NULL,

    -- Foreign key to parent region (if any)
    FOREIGN KEY ( parent ) REFERENCES region ( _id )

);
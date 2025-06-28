-- ========================================================================
-- TABLE airway
-- ------------------------------------------------------------------------
-- Stores global airways as a set of directional segments between
-- waypoints. Supports classification (e.g. high/low, RNAV, conditional),
-- directionality, altitude constraints, route codes, and FIR/region
-- attribution.
--
-- Each row represents a segment (leg) between two waypoints.
-- ========================================================================

CREATE TABLE airway (

    -- Internal ID
    _id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,

    -- Airway name/code (e.g. "UL601", "T50", "M851")
    ident VARBINARY( 32 ) NOT NULL,

    -- Optional classification
    _class ENUM ( 'low', 'high', 'rnav', 'special' ) NOT NULL DEFAULT 'high',

    -- Directionality (uni- or bidirectional)
    _dir ENUM ( 'both', 'fwd', 'rev' ) NOT NULL DEFAULT 'both',

    -- Start and end waypoint references (foreign keys)
    wp_from INT UNSIGNED NOT NULL,
    wp_to   INT UNSIGNED NOT NULL,

    -- Optional minimum and maximum altitude (in feet)
    fl_min SMALLINT UNSIGNED NULL,
    fl_max SMALLINT UNSIGNED NULL,

    -- Optional structured meta data (source, usage, conditions, etc.)
    _meta JSON NULL,

    -- Indexes
    KEY airway_ident ( ident ),
    KEY airway_class ( _class ),
    KEY airway_dir ( _dir ),
    KEY airway_from ( wp_from ),
    KEY airway_to ( wp_to ),

    -- Foreign key constraints
    FOREIGN KEY ( wp_from ) REFERENCES waypoint ( _id ),
    FOREIGN KEY ( wp_to ) REFERENCES waypoint ( _id ),

    -- Integrity checks
    CHECK ( _meta IS NULL OR JSON_VALID( _meta ) )

);

-- ========================================================================
-- TABLE airway
-- ------------------------------------------------------------------------
-- Stores global airways as a set of directional segments between
-- waypoints. Supports classification (e.g. upper/lower, RNAV, conditional),
-- directionality, altitude constraints, route codes, and FIR/region
-- attribution.
--
-- Each row represents a segment (leg) between two waypoints.
-- ========================================================================

CREATE TABLE airway (

    -- Internal ID
    _id INT( 10 ) UNSIGNED NOT NULL AUTO_INCREMENT,

    -- Airway name/code (e.g. "UL601", "T50", "M851")
    ident VARBINARY( 16 ) NOT NULL,

    -- Optional classification
    _class ENUM( 'lower', 'upper', 'rnav', 'special' ) NOT NULL DEFAULT 'upper',

    -- Directionality (uni- or bidirectional)
    _dir ENUM( 'both', 'fwd', 'rev' ) NOT NULL DEFAULT 'both',

    -- Start and end waypoint references (foreign keys)
    wp_from INT( 10 ) UNSIGNED NOT NULL,
    wp_to INT( 10 ) UNSIGNED NOT NULL,

    -- Optional minimum and maximum altitude (in feet)
    level_min SMALLINT UNSIGNED NULL,
    level_max SMALLINT UNSIGNED NULL,

    -- Optional structured metadata (source, usage, conditions, etc.)
    _data JSON DEFAULT NULL,

    -- Indexes for searching / filtering operations
    PRIMARY KEY ( _id ),
    KEY airway_ident ( ident ),
    KEY airway_class ( _class ),
    KEY airway_dir ( _dir ),
    KEY airway_from ( wp_from ),
    KEY airway_to ( wp_to ),

    -- Foreign key constraints
    FOREIGN KEY ( wp_from ) REFERENCES waypoint( _id ),
    FOREIGN KEY ( wp_to ) REFERENCES waypoint( _id )

);
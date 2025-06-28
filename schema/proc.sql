-- ========================================================================
-- TABLE: proc
-- ------------------------------------------------------------------------
-- Stores standard flight procedures such as STARs, SIDs, and instrument
-- approaches (e.g. ILS). Each procedure is assigned to an airport and
-- may optionally reference a specific runway.
--
-- Contains waypoints, chart data, and course/frequency information for
-- ILS-based approaches.
-- ========================================================================

CREATE TABLE proc (

    -- Internal ID
    _id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,

    -- Referenced airport ID
    airport INT UNSIGNED NOT NULL,

    -- Optional runway reference (may be NULL for general procedures)
    runway INT UNSIGNED NULL,

    -- Procedure type
    _type ENUM ( 'sid', 'star', 'iap' ) NOT NULL,

    -- Subtype (e.g. for approach category or routing style)
    _category ENUM (
      'conventional', 'rnnav', 'rnp', 'visual', 'circling',
      'ils', 'loc', 'vfr'
    ) NULL,

    -- Procedure name / ident (e.g. "LAXX8", "ILS RWY 25L")
    ident VARBINARY( 32 ) NOT NULL,

    -- Multilingual label / description
    label TINYBLOB NOT NULL,
    i18n  JSON NULL,

    -- Optional chart URL (external or internal)
    chart BLOB NULL,

    -- List of route legs
    legs JSON NULL,

    -- Optional geographic polyline (visualized route on map)
    poly MULTILINESTRING SRID 4326 NULL,

    -- Optional ILS/LOC data (for approach procedures)
    ils_freq  MEDIUMINT UNSIGNED NULL,  -- in kHz, e.g. 10990
    ils_hdg   FLOAT NULL,               -- LOC heading in degrees
    ils_slope FLOAT NULL,               -- glideslope (e.g. 3.0°)

    -- Optional metadata block (altitude constraints, minimas, etc.)
    _meta JSON NULL,

    -- Last update timestamp
    _touched DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    -- Indexes
    KEY proc_airport ( airport ),
    KEY proc_runway ( runway ),
    KEY proc_type ( _type ),
    KEY proc_category ( _category ),
    KEY proc_ident ( ident ),
    FULLTEXT KEY proc_search ( label, i18n ),

    -- Foreign key constraints
    FOREIGN KEY ( airport ) REFERENCES airport ( _id ),
    FOREIGN KEY ( runway ) REFERENCES runway ( _id ),

    -- Integrity checks
    CHECK ( i18n IS NULL OR JSON_VALID( i18n ) ),
    CHECK ( legs IS NULL OR JSON_VALID( legs ) ),
    CHECK ( poly IS NULL OR ( ST_SRID( poly ) = 4326 AND ST_IsValid( poly ) ) ),
    CHECK ( ils_freq IS NULL OR ( ils_freq BETWEEN 10800 AND 11200 ) ),
    CHECK ( ils_hdg IS NULL OR ( ils_hdg BETWEEN 0 AND 360 ) ),
    CHECK ( ils_slope IS NULL OR ( ils_slope BETWEEN 2.0 AND 4.0 ) ),
    CHECK ( _meta IS NULL OR JSON_VALID( _meta ) )

);

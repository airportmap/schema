-- ========================================================================
-- TABLE: navaid
-- ------------------------------------------------------------------------
-- Stores ground-based navigation aids including VOR, VORTAC, NDB, DME,
-- TACAN etc. Supports paired DME data, bearing offsets, power ratings,
-- and optional airport association. Geometry stored as POINT for mapping.
-- ========================================================================

CREATE TABLE navaid (

    -- Internal ID
    _id INT( 10 ) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,

    -- Identifier code (e.g. "EDDF", "VORX", "NDB1")
    ident VARBINARY( 8 ) NOT NULL,

    -- Aid type
    _type ENUM ( 'vor', 'vortac', 'ndb', 'dme', 'tacan' ) NOT NULL,

    -- Official name
    label TINYBLOB NULL,

    -- Primary frequency / channel (in kHz)
    freq INT UNSIGNED NOT NULL,

    -- Location (WGS84)
    coord POINT SRID 4326 NOT NULL,
    alt   INT UNSIGNED NULL,

    -- Country and optional associated airport
    country INT( 10 ) UNSIGNED NOT NULL,
    airport INT( 10 ) UNSIGNED NULL,

    -- DME specifics (if not standalone DME)
    dme_freq    INT UNSIGNED NULL,
    dme_channel VARBINARY( 32 ) NULL,
    dme_coord   POINT SRID 4326 NULL,
    dme_alt     INT UNSIGNED NULL,

    -- Course/bearing offsets
    magnetic_deg DOUBLE NULL,                  -- magnetic orientation
    slaved_deg   DOUBLE NULL,                  -- slaved bearing (if applicable)

    -- Power and range data
    power_watts INT UNSIGNED NULL,
    range_nm    DOUBLE NULL,                   -- nominal service range in nautical miles

    -- Optional structured meta data
    _meta JSON NULL,

    -- Indexes
    KEY navaid_ident ( ident ),
    KEY navaid_type ( _type ),
    SPATIAL KEY navaid_coord ( coord ),
    KEY navaid_country ( country ),
    KEY navaid_airport ( airport ),

    -- Foreign key constraints
    FOREIGN KEY ( country ) REFERENCES region ( _id ),
    FOREIGN KEY ( airport ) REFERENCES airport ( _id ),

    -- Integrity checks
    CHECK (
      ST_SRID( coord ) = 4326 AND
      ST_Y( coord ) BETWEEN  -90 AND  90 AND
      ST_X( coord ) BETWEEN -180 AND 180
    ),
    CHECK ( dme_coord IS NULL OR (
      ST_SRID( dme_coord ) = 4326 AND
      ST_Y( dme_coord ) BETWEEN  -90 AND  90 AND
      ST_X( dme_coord ) BETWEEN -180 AND 180
    ) ),
    CHECK ( magnetic_deg IS NULL OR magnetic_deg BETWEEN 0 AND 360 ),
    CHECK ( slaved_deg IS NULL OR slaved_deg BETWEEN 0 AND 360 ),
    CHECK ( range_nm IS NULL OR range_nm >= 0 ),
    CHECK ( _meta IS NULL OR JSON_VALID( _meta ) )

);

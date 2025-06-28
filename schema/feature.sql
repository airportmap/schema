-- ========================================================================
-- TABLE: feature
-- ------------------------------------------------------------------------
-- Stores technical and visual features related to airports, such as
-- control towers, parking stands, radar, visual aids, obstacles, etc.
-- ========================================================================

CREATE TABLE feature (

    -- Internal ID
    _id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,

    -- Associated airport ID
    airport INT UNSIGNED NOT NULL,

    -- Feature type / classification
    _type ENUM (
      'tower',        -- ATC tower
      'radar',        -- Radar antenna
      'stand',        -- Parking stand / gate
      'papi',         -- Precision approach path indicator
      'obstacle',     -- Terrain or man-made obstacle
      'windsock',     -- Windsock position
      'firestation',  -- Emergency services
      'terminal',     -- Terminal building (location only)
      'fuel',         -- Fuel station / tank
      'hangar',       -- Maintenance facility
      'helipad'       -- Separate helipad position
    ) NOT NULL,

    -- Optional subtype / specifier (free form or ENUM)
    _subtype VARBINARY( 32 ) NULL,

    -- Geographical position (WGS84)
    coord POINT SRID 4326 NOT NULL,

    -- Optional height or elevation (e.g. for obstacles)
    alt SMALLINT UNSIGNED NULL,

    -- Optional name / label (e.g. “GATE A22”) and multilingual titles
    label TINYBLOB NULL,
    i18n  JSON NULL,

    -- Optional geometry (e.g. stand area, obstacle volume)
    geom GEOMETRY SRID 4326 NULL,

    -- Optional meta data or configuration values
    _meta JSON NULL,

    -- Optional display priority (e.g. for visual sorting)
    _sort DOUBLE NOT NULL DEFAULT 0,

    -- Indexes
    KEY feature_airport ( airport ),
    KEY feature_type ( _type ),
    SPATIAL KEY feature_coord ( coord ),

    -- Foreign key constraints
    FOREIGN KEY ( airport ) REFERENCES airport ( _id ),

    -- Integrity checks
    CHECK ( JSON_VALID( i18n ) OR i18n IS NULL ),
    CHECK ( JSON_VALID( _meta ) OR _meta IS NULL ),
    CHECK ( ST_SRID( geom ) = 4326 OR geom IS NULL ),
    CHECK ( ST_SRID( coord ) = 4326 AND (
      ST_X( coord ) BETWEEN -180 AND 180 AND
      ST_Y( coord ) BETWEEN  -90 AND  90
    ) )

);

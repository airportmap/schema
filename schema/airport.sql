-- --------------------------------------------------------------------------------
-- Table `airport`
-- 
-- Store information about airports, heliports, seaports and other landing sites.
-- Includes location, identifiers, classification, status flags, timezone, region
-- and meta data.
-- 
-- Coordinates and geometries are stored in WGS84 (SRID 4326).
-- -------------------------------------------------------------------------------

CREATE TABLE airport (

    -- Internal ID
    _id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,

    -- Common airport identifier codes
    ICAO VARBINARY(  4 ) NOT NULL,              -- e.g. "KLAX"
    IATA VARBINARY(  3 ) NULL,                  -- e.g. "LAX"
    GPS  VARBINARY(  4 ) NULL,                  -- GPS code, often same as ICAO
    WMO  VARBINARY(  5 ) NULL,                  -- WMO weather station ID
    LOC  VARBINARY( 16 ) NULL,                  -- Local identifier

    -- Classification: operational usage and airport type / size
    _type  ENUM ( 'airport', 'heliport', 'altiport', 'seaport', 'balloon', 'rc' ) NULL,
    _usage ENUM ( 'civil', 'military', 'mixed' ) NULL,
    _size  ENUM ( 'national', 'regional', 'local', 'basic' ) NULL,

    -- Flags: status indicators
    _active    BOOLEAN NOT NULL DEFAULT TRUE,   -- Operational status
    _controled BOOLEAN NOT NULL DEFAULT FALSE,  -- Controled by ATC
    _rest      BOOLEAN NOT NULL DEFAULT FALSE,  -- Restricted airport
    _service   BOOLEAN NOT NULL DEFAULT FALSE,  -- Airline service available

    -- Airport label in default language and optional multilingual names
    label TINYBLOB NOT NULL,                    -- Primary display name
    i18n  JSON NULL,                            -- Translations

    -- Geographical position (WGS84)
    coord POINT SRID 4326 NOT NULL,             -- Longitude / latitude
    alt   SMALLINT UNSIGNED NOT NULL,           -- Altitude in feet above sea level

    -- Geographical boundaries (WGS84)
    poly MULTIPOLYGON SRID 4326 NULL,

    -- Timezone reference IDs (foreign keys)
    tz  INT UNSIGNED NOT NULL,                  -- Standard timezone
    dtz INT UNSIGNED NULL,                      -- Daylight timezone (optional)

    -- Regional classification
    country INT UNSIGNED NOT NULL,              -- Country
    region  INT UNSIGNED NULL,                  -- Optional region / province

    -- Structured meta data (e.g. municipality, operator, passenger volume etc.)
    meta JSON NULL,

    -- Indexes
    UNIQUE KEY airport_ICAO ( ICAO ),

    KEY airport_IATA ( IATA ),
    KEY airport_lookup ( ICAO, IATA, GPS ),
    KEY airport_type ( _type ),
    KEY airport_usage ( _usage ),
    KEY airport_size ( _size ),
    KEY airport_status ( _active ),
    KEY airport_controled ( _controled ),
    KEY airport_rest ( _rest ),
    KEY airport_service ( _service ),
    KEY airport_alt ( alt ),
    KEY airport_tz ( tz ),
    KEY airport_country ( country ),

    SPATIAL KEY airport_coord ( coord ),

    -- Foreign keys
    FOREIGN KEY ( tz )      REFERENCES tz ( _id ),
    FOREIGN KEY ( dtz )     REFERENCES tz ( _id ),
    FOREIGN KEY ( country ) REFERENCES region ( _id ),
    FOREIGN KEY ( region )  REFERENCES region ( _id ),

    -- Constraints
    CONSTRAINT airport_i18n CHECK (
        JSON_VALID( i18n ) OR
        i18n IS NULL
    ),

    CONSTRAINT airport_meta CHECK (
        JSON_VALID( meta ) OR
        meta IS NULL
    ),

    CONSTRAINT airport_coord CHECK (
        ST_SRID( coord ) = 4326 AND (
            ST_X( coord ) BETWEEN  -90 AND  90 AND
            ST_Y( coord ) BETWEEN -180 AND 180
        )
    ),

    CONSTRAINT airport_poly CHECK (
        poly IS NULL OR (
            ST_SRID( poly ) = 4326 AND
            ST_IsValid( poly )
        )
    )

);

-- ========================================================================
-- TABLE airport
-- ------------------------------------------------------------------------
-- Stores metadata for global airports, bases etc., including ICAO/IATA
-- codes, geographical coordinates, timezone information, and classification
-- such as size, usage restrictions, and operational status.
--
-- Supports multilingual labels, regional affiliation and optional meta
-- data for structured payload.
-- ========================================================================

CREATE TABLE airport (

    -- Internal database ID
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
    poly MULTIPOLYGON SRID 4326 NOT NULL,

    -- Timezone reference IDs (foreign keys)
    tz  INT UNSIGNED NOT NULL,                  -- Standard timezone
    dtz INT UNSIGNED NULL,                      -- Daylight timezone (optional)

    -- Regional classification
    country INT UNSIGNED NOT NULL,              -- Country
    region  INT UNSIGNED NULL,                  -- Optional region / province

    -- Structured meta data (e.g. municipality, operator, passenger volume etc.)
    _meta JSON NULL,

    -- Data quality / completeness (0..1)
    _quality DOUBLE NOT NULL,

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
    SPATIAL KEY airport_coord ( coord ),
    SPATIAL KEY airport_poly ( poly ),
    KEY airport_tz ( tz ),
    KEY airport_country ( country ),

    -- Foreign key constraints
    FOREIGN KEY ( tz ) REFERENCES tz ( _id ),
    FOREIGN KEY ( dtz ) REFERENCES tz ( _id ),
    FOREIGN KEY ( country ) REFERENCES region ( _id ),
    FOREIGN KEY ( region ) REFERENCES region ( _id ),

    -- Integrity checks
    CHECK ( JSON_VALID( i18n ) OR i18n IS NULL ),
    CHECK ( JSON_VALID( _meta ) OR _meta IS NULL ),
    CHECK ( ST_SRID( poly ) = 4326 AND ST_IsValid( poly ) ),
    CHECK ( ST_SRID( coord ) = 4326 AND (
      ST_X( coord ) BETWEEN -180 AND 180 AND
      ST_Y( coord ) BETWEEN  -90 AND  90
    ) )

);

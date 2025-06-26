-- ========================================================================
-- TABLE airport
-- ------------------------------------------------------------------------
-- Stores metadata for global airports, bases etc., including ICAO/IATA
-- codes, geographical coordinates, timezone information, and classification
-- such as size, usage restrictions, and operational status.
--
-- Supports multilingual labels, regional affiliation and sorting priority
-- for optimized map rendering and user interfaces.
-- ========================================================================

CREATE TABLE airport (

    -- Internal database ID
    _id INT( 10 ) UNSIGNED NOT NULL AUTO_INCREMENT,

    -- Common airport identifier codes
    ICAO VARBINARY( 4 ) NOT NULL,             -- e.g. "KLAX"
    IATA VARBINARY( 3 ) NULL,                 -- e.g. "LAX"
    GPS VARBINARY( 4 ) NULL,                  -- GPS code, often same as ICAO
    FAA VARBINARY( 5 ) NULL,                  -- FAA location code (mainly US)
    WMO VARBINARY( 5 ) NULL,                  -- WMO weather station ID

    -- Classification: operational usage and airport type
    _rest ENUM( 'civil', 'restricted', 'military', 'mixed' ) NOT NULL,
    _type ENUM( 'large', 'medium', 'small', 'heliport', 'altiport', 'seaport', 'balloonport' ) NOT NULL,

    -- Operational status (open or closed)
    _closed BOOLEAN NOT NULL DEFAULT FALSE,

    -- Airline service available
    _service BOOLEAN NOT NULL DEFAULT FALSE,

    -- Airport label in default language and optional multilingual names
    label VARBINARY( 255 ) NOT NULL,          -- Primary display name
    names JSON NULL,                          -- Translations (e.g. { "en": "...", "fr": "..." })

    -- Geographical position (WGS84)
    coord POINT SRID 4326 NOT NULL,           -- Latitude / longitude
    alt SMALLINT NOT NULL,                    -- Altitute in feet above sea level

    -- Geographical boundaries (WGS84)
    poly MULTIPOLYGON SRID 4326 NOT NULL,

    -- Timezone reference IDs (foreign keys)
    tz INT( 10 ) UNSIGNED NOT NULL,           -- Standard timezone
    dtz INT( 10 ) UNSIGNED NULL,              -- Daylight/alternate TZ (optional)

    -- Regional classification (continent, country, region/province)
    continent INT( 10 ) UNSIGNED NOT NULL,
    country INT( 10 ) UNSIGNED NOT NULL,
    region INT( 10 ) UNSIGNED NULL,

    -- Structured data (e.g. municipality, operator, passenger volume, size, dates, etc.)
    _data JSON NULL,

    -- Priority value for sorting (e.g. on map layers or in result lists)
    _sort DOUBLE NOT NULL,

    -- Indexes for searching / filtering operations
    PRIMARY KEY ( _id ),
    UNIQUE KEY airport_ICAO ( ICAO ),
    KEY airport_IATA ( IATA ),
    KEY airport_lookup ( ICAO, IATA, GPS ),
    KEY airport_rest ( _rest ),
    KEY airport_type ( _type ),
    KEY airport_status ( _closed ),
    KEY airport_service ( _service ),
    SPATIAL KEY airport_coord ( coord ),
    SPATIAL KEY airport_poly ( poly ),
    KEY airport_tz ( tz ),
    KEY airport_continent ( continent ),
    KEY airport_country ( country ),

    -- Foreign key constraints
    FOREIGN KEY ( tz ) REFERENCES tz ( _id ),
    FOREIGN KEY ( dtz ) REFERENCES tz ( _id ),
    FOREIGN KEY ( continent ) REFERENCES region ( _id ),
    FOREIGN KEY ( country ) REFERENCES region ( _id ),
    FOREIGN KEY ( region ) REFERENCES region ( _id ),

    -- Geographical consistency check
    CHECK (
      ST_Y( coord ) BETWEEN  -90 AND  90 AND
      ST_X( coord ) BETWEEN -180 AND 180 AND
      ST_IsValid( poly )
    )

);
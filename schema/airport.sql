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
    _id INT( 10 ) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,

    -- Common airport identifier codes
    ICAO VARBINARY( 4 ) NOT NULL UNIQUE,      -- e.g. "KLAX"
    IATA VARBINARY( 3 ) NULL UNIQUE,          -- e.g. "LAX"
    GPS VARBINARY( 4 ) NULL UNIQUE,           -- GPS code, often same as ICAO
    FAA VARBINARY( 5 ) NULL UNIQUE,           -- FAA location code (mainly US)
    WMO VARBINARY( 5 ) NULL UNIQUE,           -- WMO weather station ID

    -- Classification: operational usage and airport type
    _restriction ENUM( 'civil', 'restricted', 'military', 'joint_use' ) NOT NULL,
    _type ENUM( 'large', 'medium', 'small', 'heliport', 'altiport', 'seaport', 'balloonport' ) NOT NULL,

    -- Operational status (open or closed)
    _closed BOOLEAN NOT NULL DEFAULT 'false',

    -- Airport label in default language and optional multilingual names
    label VARBINARY( 255 ) NOT NULL,          -- Primary display name
    names JSON NULL,                          -- Translations (e.g. { "en": "...", "fr": "..." })

    -- Geographical position (WGS84)
    lat DOUBLE NOT NULL,                      -- Geographical latitude
    lon DOUBLE NOT NULL,                      -- Geographical longitude
    alt DOUBLE NOT NULL,                      -- Altitute in meters above sea level

    -- Timezone reference IDs (foreign keys)
    tz INT( 10 ) UNSIGNED NOT NULL,           -- Standard timezone
    dtz INT( 10 ) UNSIGNED NULL,              -- Daylight/alternate TZ (optional)

    -- Regional classification (continent, country, region/province)
    continent INT( 10 ) UNSIGNED NOT NULL,
    country INT( 10 ) UNSIGNED NOT NULL,
    region INT( 10 ) UNSIGNED NULL,

    -- Local administrative city or municipality
    municipality VARBINARY( 255 ) NULL,

    -- Custom meta data (e.g. passenger volume, size, dates, etc.)
    _options JSON NULL,

    -- Priority value for sorting (e.g. on map layers or in result lists)
    _sort FLOAT NOT NULL,

    -- Indexes for common filtering operations
    KEY airport_restriction ( _restriction ),
    KEY airport_type ( _type ),
    KEY airport_status ( _closed ),
    KEY airport_tz ( tz ),
    KEY airport_continent ( continent ),
    KEY airport_country ( country ),

    -- Foreign key constraints
    FOREIGN KEY ( tz ) REFERENCES tz ( _id ),
    FOREIGN KEY ( dtz ) REFERENCES tz ( _id ),
    FOREIGN KEY ( continent ) REFERENCES region ( _id ),
    FOREIGN KEY ( country ) REFERENCES region ( _id ),
    FOREIGN KEY ( region ) REFERENCES region ( _id )

);
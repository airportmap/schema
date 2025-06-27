-- ========================================================================
-- TABLE: traffic
-- ------------------------------------------------------------------------
-- Stores recent live aircraft data as imported from OpenSky Network or
-- similar sources. Updated regularly (e.g. every two minutes).
--
-- Not suitable for historical tracking — only last known state is kept.
-- ========================================================================

CREATE TABLE traffic (

    -- Unique aircraft identifier (ICAO24, e.g. "4CA123")
    ident VARBINARY( 24 ) NOT NULL PRIMARY KEY,

    -- Optional flight number / callsign (e.g. "DLH456")
    callsign VARBINARY( 8 ) NULL,

    -- Aircraft type / category (e.g. 0 = unknown, 1 = No ADS-B Emitter Category, ...)
    _type TINYINT UNSIGNED NOT NULL DEFAULT 0,

    -- Time of last known message from source (UTC)
    ts DATETIME NULL,

    -- Last contact (UTC) — when last seen in datafeed
    contact DATETIME NOT NULL,

    -- Country of origin
    origin INT( 10 ) UNSIGNED NULL,

    -- Last known position (WGS84)
    coord POINT SRID 4326 NOT NULL,

    -- Altitude in feet (geometric and barometric, if available)
    alt     SMALLINT UNSIGNED NULL,
    alt_geo SMALLINT UNSIGNED NULL,

    -- Heading, speed and vertical rate
    hdg   FLOAT NULL,                         -- Heading in degrees (0–360)
    spd   FLOAT NULL,                         -- Ground speed in knots
    vrate FLOAT NOT NULL DEFAULT 0,           -- Vertical rate (ft/min)

    -- Status flags
    _ground  BOOLEAN NOT NULL DEFAULT FALSE,  -- Airplane on ground
    _spi     BOOLEAN NOT NULL DEFAULT FALSE,  -- Special purpose indicator

    -- Squawk (transponder) code
    squawk VARBINARY( 8 ) NULL,

    -- Source of the reported position
    _source ENUM ( 'ads-b', 'asterix', 'mlat', 'flarm' ) NOT NULL,

    -- Priority value for sorting (e.g. on map layers)
    _sort DOUBLE NOT NULL,

    -- Indexes
    KEY traffic_type ( _type ),
    KEY traffic_origin ( origin ),
    SPATIAL KEY traffic_coord ( coord ),
    KEY traffic_contact ( contact ),
    KEY traffic_source ( source ),
    KEY traffic_sort ( _sort ),

    -- Foreign key constraints
    FOREIGN KEY ( origin ) REFERENCES region ( _id )

    -- Integrity checks
    CHECK (
      ST_SRID( coord ) = 4326 AND
      ST_Y( coord ) BETWEEN  -90 AND  90 AND
      ST_X( coord ) BETWEEN -180 AND 180
    ),
    CHECK ( hdg IS NULL OR ( hdg BETWEEN 0 AND 360 ) ),
    CHECK ( spd IS NULL OR spd >= 0 )

);

-- ========================================================================
-- TABLE metar
-- ------------------------------------------------------------------------
-- Stores latest METAR weather reports per ICAO station, including raw
-- data, parsed meteorological fields, visibility, wind, precipitation,
-- pressure, and up to four cloud layers.
--
-- Data is pulled via NOAA feeds (https://aviationweather.gov)
-- ========================================================================

CREATE TABLE metar (

    -- ICAO station code (e.g. "EDDF", "KJFK")
    station VARBINARY( 8 ) NOT NULL PRIMARY KEY,

    -- Optional related airport
    airport INT( 10 ) UNSIGNED NULL,

    -- Full raw METAR string
    _raw BLOB NOT NULL,

    -- Time when the METAR was officially reported (UTC)
    reported DATETIME NOT NULL,

    -- Weather phenomena (e.g. "RA", "TSRA", "BR")
    wx VARBINARY( 32 ) DEFAULT NULL,

    -- Flight category (VFR, MVFR, IFR, LIFR) or unknown
    cat ENUM ( 'vfr', 'mvfr', 'ifr', 'lifr', 'unk' ) NOT NULL DEFAULT 'unk',

    -- Temperature and dew point (in °C)
    temp DOUBLE NOT NULL,                     -- Air temperature
    dewp DOUBLE NOT NULL,                     -- Dew point temperature

    -- Altimeter pressure (in hPa)
    altim DOUBLE NULL,                        -- Station pressure
    altim_sea DOUBLE NULL,                    -- Sea-level pressure (optional)

    -- Wind data
    wind_dir SMALLINT NULL,                   -- Direction in degrees (true)
    wind_speed SMALLINT NULL,                 -- Sustained speed (knots)
    wind_gust SMALLINT NULL,                  -- Gust speed (knots, optional)

    -- Precipitation data (if known)
    precip DOUBLE NOT NULL DEFAULT 0,         -- Rainfall amount (mm)
    snow DOUBLE NOT NULL DEFAULT 0,           -- Snowfall amount (mm)

    -- Visibility (in statute miles or meters)
    vis_hori DOUBLE NULL,                     -- Horizontal visibility
    vis_vert SMALLINT NULL,                   -- Vertical visibility (ceiling, ft AGL)

    -- Cloud layers
    clouds JSON NULL,

    -- Timestamp of last update (updated automatically)
    _touched DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    -- Indexes
    KEY metar_airport ( airport ),
    KEY metar_cat ( cat ),

    -- Foreign key constraints
    FOREIGN KEY ( airport ) REFERENCES airport ( _id )

);

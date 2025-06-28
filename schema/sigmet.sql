-- ========================================================================
-- TABLE sigmet
-- ------------------------------------------------------------------------
-- Stores aviation weather warnings (SIGMETs), including hazard type,
-- affected FIRs, flight levels, motion vectors, validity period,
-- and optionally a geographic polygon for display.
--
-- Data is sourced from international aviation meteorological services,
-- typically via NOAA.
-- ========================================================================

CREATE TABLE sigmet (

    -- Internal unique identifier
    _id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,

    -- Raw report (original textual source)
    _raw BLOB NOT NULL,

    -- Related FIR (Flight Information Region) or Airport (optional)
    fir VARBINARY( 32 ) NULL,

    -- Optional related airport
    airport INT UNSIGNED NULL,

    -- Source identification
    label  TINYBLOB NULL,                     -- meteorological office
    series VARBINARY( 8 ) NULL,               -- SIGMET label in FIR

    -- Main hazard characteristics
    hazard ENUM (
      'cld',    -- Cloud
      'conv',   -- Convective
      'ds',     -- Duststorm
      'fc',     -- Funnel cloud
      'gr',     -- Hail
      'ice',    -- Ice
      'ifr',    -- Mountain Obscuration
      'mtw',    -- Mountain wave
      'ss',     -- Sandstorm
      'tc',     -- Tropical storm
      'tdo',    -- Tornado
      'ts',     -- Thunderstorm
      'tsgr',   -- Thunderstorm with hail
      'turb',   -- Turbulence
      'va',     -- Volcanic ash
      'wtspt'   -- Waterspout
    ) NULL,
    qualifier ENUM (
      'area',   -- area-wide
      'embd',   -- embedded
      'frq',    -- frequent
      'hvy',    -- heavy
      'isol',   -- isolated
      'obsc',   -- obscured
      'ocnl',   -- occasional
      'rdoact', -- radioactive
      'sev',    -- severe
      'sql'     -- squall line
    ) NULL,

    -- Optional severity scale (if numeric)
    severity TINYINT UNSIGNED NULL,

    -- Validity window
    valid_from DATETIME NOT NULL,             -- Start of SIGMET validity
    valid_to   DATETIME NOT NULL,             -- End of SIGMET validity

    -- Flight level range affected (in feet)
    fl_min SMALLINT UNSIGNED NULL,
    fl_max SMALLINT UNSIGNED NULL,

    -- Motion vector (optional)
    dir ENUM (
      'n', 'nne', 'ne', 'ene', 'e', 'ese', 'se', 'sse',
      's', 'ssw', 'sw', 'wsw', 'w', 'wnw', 'nw', 'nnw'
    ) NULL,
    spd SMALLINT UNSIGNED NULL,
    cng ENUM ( 'nc', 'intsf', 'wkn' ) NULL,

    -- Affected area polygon (WGS84)
    poly MULTIPOLYGON SRID 4326 NOT NULL,

    -- Last update timestamp
    _touched DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    -- Indexes
    KEY sigmet_fir ( fir ),
    KEY sigmet_airport ( airport ),
    KEY sigmet_hazard ( hazard ),
    KEY sigmet_qualifier ( qualifier ),
    KEY sigmet_severity ( severity ),
    KEY sigmet_valid ( valid_from, valid_to ),
    SPATIAL KEY sigmet_poly ( poly ),

    -- Foreign key constraints
    FOREIGN KEY ( airport ) REFERENCES airport ( _id ),

    -- Integrity checks
    CHECK ( ST_SRID( poly ) = 4326 AND ST_IsValid( poly ) )

);

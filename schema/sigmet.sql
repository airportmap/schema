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
    _id INT( 10 ) UNSIGNED NOT NULL AUTO_INCREMENT,

    -- Raw report (original textual source)
    _raw BLOB NOT NULL,

    -- Related FIR (Flight Information Region) or Airport (optional)
    fir VARBINARY( 32 ) DEFAULT NULL,

    -- Optional related airport
    airport INT( 10 ) DEFAULT NULL,

    -- Source identification
    label TINYBLOB DEFAULT NULL,              -- meteorological office
    series VARBINARY( 8 ) DEFAULT NULL,       -- SIGMET label in FIR

    -- Main hazard characteristics
    hazard VARBINARY( 8 ) NOT NULL,           -- e.g. "TURB", "ICE", "TS", "ASH"
    qualifier VARBINARY( 16 ) NULL,           -- e.g. "OBS", "FCST"
    severity TINYINT UNSIGNED NULL,           -- Optional severity scale (if numeric)

    -- Validity window
    valid_from DATETIME NOT NULL,             -- Start of SIGMET validity
    valid_to   DATETIME NOT NULL,             -- End of SIGMET validity

    -- Flight level range affected (in feet)
    fl_min SMALLINT UNSIGNED DEFAULT NULL,
    fl_max SMALLINT UNSIGNED DEFAULT NULL,

    -- Motion vector (optional)
    dir VARBINARY( 4 ) DEFAULT NULL,          -- Cardinal (e.g. "E", "NE")
    spd SMALLINT UNSIGNED DEFAULT NULL,       -- In knots
    cng VARBINARY( 8 ) DEFAULT NULL,          -- e.g. "WKN", "NC", "INTSF"

    -- Affected area polygon (WGS84)
    poly MULTIPOLYGON SRID 4326 NOT NULL,

    -- Last update timestamp
    _touched DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    -- Indexes
    PRIMARY KEY ( _id ),
    KEY sigmet_fir ( fir ),
    KEY sigmet_airport ( airport ),
    KEY sigmet_hazard ( hazard ),
    KEY sigmet_qualifier ( qualifier ),
    KEY sigmet_severity ( severity ),
    KEY sigmet_valid ( valid_from, valid_to ),
    SPATIAL KEY sigmet_poly ( poly ),

    -- Foreign key constraints
    FOREIGN KEY ( airport ) REFERENCES airport ( _id )

);

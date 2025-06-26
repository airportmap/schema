-- ========================================================================
-- TABLE airspace
-- ------------------------------------------------------------------------
-- Stores controlled and special-use airspaces, including FIRs, TMAs,
-- CTRs, danger areas, prohibited zones, restricted regions, and more.
--
-- Includes geographic boundaries, altitude limits and usage class.
-- ========================================================================

CREATE TABLE airspace (

    -- Internal ID
    _id INT( 10 ) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,

    -- ICAO-compliant identifier or label (e.g. "EDGG", "DANGER EDR401", "LOWW TMA 1")
    ident VARBINARY( 32 ) NOT NULL,

    -- Official or human-readable name and optional multilingual names
    label TINYBLOB NOT NULL,
    i18n  JSON NULL,

    -- Type of airspace (FIR, UIR, TMA, CTR, ...)
    _type ENUM (
      'fir',         -- Flight Information Region
      'uir',         -- Upper Information Region
      'tma',         -- Terminal Control Area
      'ctr',         -- Control Zone
      'atz',         -- Aerodrome Traffic Zone
      'danger',      -- Danger Area
      'restricted',  -- Restricted Area
      'prohibited',  -- Prohibited Area
      'military',    -- Military Zone
      'special',     -- Special Use Airspace (SUA)
      'other'        -- Reserved / Unknown
    ) NOT NULL,

    -- Airspace class (A–G, or U for unknown/unclassified)
    _class ENUM ( 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'U' ) NOT NULL DEFAULT 'U',

    -- Controlled usage or purpose
    _usage ENUM ( 'civil', 'military', 'mixed', 'special' ) NOT NULL DEFAULT 'civil',

    -- Polygonal geometry (WGS84)
    poly MULTIPOLYGON SRID 4326 NOT NULL,

    -- Vertical extent (in feet)
    fl_min INT UNSIGNED NULL,
    fl_max INT UNSIGNED NULL,

    -- Structured data
    _data JSON NULL,

    -- Indexes
    KEY airspace_ident ( ident ),
    KEY airspace_type ( _type ),
    KEY airspace_class ( _class ),
    SPATIAL KEY airspace_poly ( poly ),

    -- Integrity checks
    CHECK ( ST_SRID( poly ) = 4326 AND ST_IsValid( poly ) )

);

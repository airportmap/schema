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
    _id INT( 10 ) UNSIGNED NOT NULL AUTO_INCREMENT,

    -- ICAO-compliant identifier or label (e.g. "EDGG", "DANGER EDR401", "LOWW TMA 1")
    ident VARBINARY( 32 ) NOT NULL,

    -- Official or human-readable name and optional multilingual names
    label VARBINARY( 255 ) NOT NULL,
    names JSON NULL,

    -- Type of airspace (FIR, TMA, CTR, TSA, TRA, P, R, D, ATZ, AWY ...)
    _type ENUM(
        'fir', 'uir', 'tma', 'ctr', 'atz', 'awa', 'awy',
        'danger', 'prohibited', 'restricted', 'military', 'special',
        'other'
    ) NOT NULL,

    -- Airspace class (A–G, or U for unknown/unclassified)
    _class ENUM( 'A','B','C','D','E','F','G','U' ) NOT NULL DEFAULT 'U',

    -- Controlled usage or purpose
    _usage ENUM( 'civil', 'military', 'mixed', 'special' ) NOT NULL DEFAULT 'civil',

    -- Polygonal geometry (WGS84)
    poly MULTIPOLYGON SRID 4326 NOT NULL,

    -- Vertical extent (ft AMSL or FL)
    level_min SMALLINT UNSIGNED NULL,      -- e.g. 1500 ft
    level_max SMALLINT UNSIGNED NULL,      -- e.g. 66000 ft (FL660), or NULL = unlimited

    -- Structured data
    _data JSON NULL,

    -- Indexes for searching / filtering operations
    PRIMARY KEY ( _id ),
    KEY airspace_ident ( ident ),
    KEY airspace_type ( _type ),
    KEY airspace_class ( _class ),
    SPATIAL KEY airspace_poly ( poly ),

    -- Geographical consistency check
    CHECK ( ST_IsValid( poly ) )

);

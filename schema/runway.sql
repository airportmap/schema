-- ========================================================================
-- TABLE: runway
-- ------------------------------------------------------------------------
-- Stores runway definitions for each airport, including endpoints,
-- dimensions, surface type, lighting, bearing, threshold details,
-- and a polygon for map rendering.
-- ========================================================================

CREATE TABLE runway (

    -- Internal ID
    _id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,

    -- Referenced airport
    airport INT UNSIGNED NOT NULL,

    -- Runway identifiers (e.g. "09L/27R")
    designator_from VARBINARY( 8 ) NOT NULL,  -- lower-numbered end (e.g. "09L")
    designator_to   VARBINARY( 8 ) NOT NULL,  -- opposite end (e.g. "27R")

    -- Physical dimensions in meters
    len   SMALLINT UNSIGNED NULL,
    width SMALLINT UNSIGNED NULL,

    -- Surface and usage
    surface ENUM (
      'asp',  -- Asphalt
      'bit',  -- Bituminous asphalt or tarmac
      'bri',  -- Bricks (no longer in use, covered with asphalt or concrete now)
      'cla',  -- Clay
      'com',  -- Composite
      'con',  -- Concrete
      'cor',  -- Coral (fine crushed coral reef structures)
      'gre',  -- Graded or rolled earth, grass on graded earth
      'grs',  -- Grass or earth not graded or rolled
      'gvl',  -- Gravel
      'ice',  -- Ice
      'lat',  -- Laterite
      'mac',  -- Macadam
      'pem',  -- Partially concrete, asphalt or bitumen-bound macadam
      'per',  -- Permanent surface, details unknown
      'psp',  -- Marston Matting (derived from pierced/perforated steel planking)
      'rof',  -- Rooftop (Heliport)
      'san',  -- Sand
      'smt',  -- Sommerfeld Tracking
      'sno',  -- Snow
      'unk',  -- Unknown surface
      'wat'   -- Water
    ) NOT NULL DEFAULT 'unk',

    -- Runway condition
    active  BOOLEAN NOT NULL DEFAULT TRUE,    -- active/inactive flag
    lighted BOOLEAN NOT NULL DEFAULT FALSE,   -- lighting system present

    -- Endpoints as geospatial points (WGS84)
    coord_from POINT SRID 4326 NOT NULL,
    coord_to   POINT SRID 4326 NOT NULL,

    -- Threshold elevations in feet MSL
    alt_from SMALLINT UNSIGNED NULL,
    alt_to   SMALLINT UNSIGNED NULL,

    -- Displaced threshold distances in feet (if any)
    dthr_from SMALLINT UNSIGNED NULL,
    dthr_to   SMALLINT UNSIGNED NULL,

    -- Runway centerline bearing (degrees true) from each side
    hdg_from FLOAT NULL,
    hdg_to   FLOAT NULL,

    -- Slope gradient (if available)
    slope FLOAT NULL,

    -- Runway body polygon
    poly POLYGON SRID 4326 NOT NULL,

    -- Optional structured meta data (e.g. lighting type, remarks)
    _meta JSON NULL,

    -- Indexes
    UNIQUE KEY runway_ident ( airport, designator_from, designator_to ),
    KEY runway_airport ( airport ),
    KEY runway_surface ( surface ),
    SPATIAL KEY runway_poly ( poly ),

    -- Foreign key constraints
    FOREIGN KEY ( airport ) REFERENCES airport ( _id ),

    -- Integrity checks
    CHECK ( ( hdg_from BETWEEN 0 AND 360 ) OR hdg_from IS NULL ),
    CHECK ( ( hdg_to BETWEEN 0 AND 360 ) OR hdg_to IS NULL ),
    CHECK ( ( slope BETWEEN -1 AND 1 ) OR slope IS NULL ),
    CHECK ( ST_SRID( poly ) = 4326 AND ST_IsValid( poly ) ),
    CHECK ( JSON_VALID( _meta ) OR _meta IS NULL ),
    CHECK (
      ST_SRID( coord_from ) = 4326 AND
      ST_X( coord_from ) BETWEEN -180 AND 180 AND
      ST_Y( coord_from ) BETWEEN  -90 AND  90
    ),
    CHECK (
      ST_SRID( coord_to ) = 4326 AND
      ST_X( coord_to ) BETWEEN -180 AND 180 AND
      ST_Y( coord_to ) BETWEEN  -90 AND  90
    )

);

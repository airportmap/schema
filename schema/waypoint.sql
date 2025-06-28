-- ========================================================================
-- TABLE waypoint
-- ------------------------------------------------------------------------
-- Stores global navigation waypoints used in air traffic routes and
-- procedures. These may be enroute, terminal, or FIR-specific points,
-- and are identified by a short textual code (e.g. "ADESO", "EK451").
-- ========================================================================

CREATE TABLE waypoint (

    -- Internal ID
    _id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,

    -- Waypoint identifier (usually 3–7 characters)
    ident VARBINARY( 8 ) NOT NULL,

    -- Geographical location (WGS84)
    coord POINT SRID 4326 NOT NULL,

    -- Optional codes / prefixes
    code   VARBINARY( 8 ) NULL,
    prefix VARBINARY( 2 ) NULL,

    -- Indexes
    KEY waypoint_ident ( ident ),
    SPATIAL KEY waypoint_coord ( coord ),
    KEY waypoint_code ( code ),
    KEY waypoint_prefix ( prefix ),

    -- Integrity checks
    CHECK (
      ST_SRID( coord ) = 4326 AND
      ST_X( coord ) BETWEEN -180 AND 180 AND
      ST_Y( coord ) BETWEEN  -90 AND  90
    )

);

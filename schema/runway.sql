-- ========================================================================
-- TABLE: runway
-- ------------------------------------------------------------------------
-- Stores runway definitions for each airport, including endpoints,
-- dimensions, surface type, lighting, bearing, threshold details,
-- and a polygon for map rendering.
-- ========================================================================

CREATE TABLE runway (

    -- Internal ID
    _id INT( 10 ) UNSIGNED NOT NULL AUTO_INCREMENT,

    -- Referenced airport
    airport INT( 10 ) UNSIGNED NOT NULL,

    -- Runway identifiers (e.g. "09L/27R")
    designator_from VARBINARY( 8 ) NOT NULL, -- lower-numbered end (e.g. "09L")
    designator_to VARBINARY( 8 ) NOT NULL,   -- opposite end (e.g. "27R")

    -- Physical dimensions in meters
    len INT UNSIGNED DEFAULT NULL,           -- runway length
    width INT UNSIGNED DEFAULT NULL,         -- runway width

    -- Surface and usage
    surface VARBINARY( 32 ) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,    -- active/inactive flag
    lighted BOOLEAN NOT NULL DEFAULT FALSE,  -- lighting system present

    -- Endpoints as geospatial points (WGS84)
    coord_from POINT SRID 4326 NOT NULL,     -- threshold at designator_from
    coord_to POINT SRID 4326 NOT NULL,       -- threshold at designator_to

    -- Threshold elevations in feet MSL
    alt_from INT UNSIGNED DEFAULT NULL,
    alt_to INT UNSIGNED DEFAULT NULL,

    -- Displaced threshold distances in meters (if any)
    dthr_from INT UNSIGNED DEFAULT NULL,
    dthr_to INT UNSIGNED DEFAULT NULL,

    -- Runway centerline bearing (degrees true) from each threshold
    hdg_from DOUBLE DEFAULT NULL,
    hdg_to DOUBLE DEFAULT NULL,

    -- Slope gradient (percent) if available
    slope DOUBLE DEFAULT NULL,

    -- Runway body polygon
    poly POLYGON SRID 4326 DEFAULT NULL,

    -- Optional structured data (e.g. lighting type, arrestor gear, remarks)
    _data JSON NULL,

    -- Indexes
    PRIMARY KEY ( _id ),
    UNIQUE KEY runway_ident ( airport, designator_from, designator_to ),
    KEY runway_airport ( airport ),
    KEY runway_surface ( surface ),
    SPATIAL KEY runway_coord ( coord_from, coord_to ),
    SPATIAL KEY runway_poly ( poly ),

    -- Foreign key constraints
    FOREIGN KEY ( airport ) REFERENCES airport( _id ),

    -- Integrity checks

    CHECK ( len >= 0 AND width >= 0 AND alt_from >= 0 AND alt_to >= 0 ),
    CHECK ( ST_SRID( coord_from ) = 4326 AND ST_SRID( coord_to ) = 4326 ),
    CHECK ( hdg_from BETWEEN 0 AND 360 AND hdg_to BETWEEN 0 AND 360 )

);

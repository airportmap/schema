-- ========================================================================
-- TABLE: mapdata
-- ------------------------------------------------------------------------
-- Stores static spatial data used for base map rendering and interaction.
-- Includes airports, navaids, waypoints, airways, airspaces etc.
-- Not used for volatile data (weather, traffic, etc.).
-- ========================================================================

CREATE TABLE mapdata (

    -- Internal ID
    _id INT(10) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,

    -- Object type (for layer control)
    _type ENUM (
        'airport',     -- main airport locations
        'runway',      -- simplified outline if separate
        'navaid',      -- VOR/DME/NDB
        'waypoint',    -- named fix
        'airway',      -- air route segment
        'airspace'     -- FIR, CTR etc.
    ) NOT NULL,

    -- Referenced ID in source table (if applicable)
    ref_id INT(10) UNSIGNED NULL,

    -- Airport association (e.g. for runways, obstacles, parking areas)
    airport INT(10) UNSIGNED NULL,

    -- Label or name (e.g. waypoint ident or airport ICAO)
    label VARBINARY(64) NULL,

    -- Optional i18n names
    i18n JSON NULL,

    -- Optional sort priority (0–1), used for map rendering thresholds
    _sort DOUBLE NOT NULL DEFAULT 0.5,

    -- Optional zoom visibility constraints
    zmin TINYINT UNSIGNED NULL,  -- Minimum zoom level
    zmax TINYINT UNSIGNED NULL,  -- Maximum zoom level

    -- Geometrical shape (POINT, LINESTRING, POLYGON, etc.)
    geom GEOMETRY NOT NULL SRID 4326,

    -- Layer styling information (e.g. color, opacity, class)
    style JSON NULL,

    -- Update timestamp
    _touched DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    -- Indexes
    SPATIAL KEY map_geom ( geom ),
    KEY map_type ( _type ),
    KEY map_ref ( ref_id ),
    KEY map_airport ( airport ),
    KEY map_zoom ( zmin, zmax ),
    KEY map_sort ( _sort ),

    -- Integrity checks
    CHECK ( ST_SRID( geom ) = 4326 ),
    CHECK ( zmin IS NULL OR zmin <= zmax )

);

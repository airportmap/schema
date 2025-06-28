-- ========================================================================
-- TABLE: mapdata
-- ------------------------------------------------------------------------
-- Stores static spatial data used for base map rendering and interaction.
-- Includes airports, navaids, waypoints, airways, airspaces etc.
--
-- Not used for volatile data (weather, traffic, etc.).
-- ========================================================================

CREATE TABLE mapdata (

    -- Internal ID
    _id INT( 10 ) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,

    -- Layer control
    layer ENUM (
      'ap.civ',     -- Civil airports
      'ap.mil',     -- Military / joint-use airports
      'ap.spi',     -- Special airports
      'ap.rw',      -- Runways
      'ap.obj',     -- Airport objects
      'nav.aid',    -- Navaids (DME, VOR, NDB ...)
      'nav.wp',     -- Waypoints
      'nav.high',   -- Airways (high)
      'nav.low',    -- Airways (low)
      'nav.spi',    -- Special airways
      'sp.ctrl',    -- Controls airspaces
      'sp.rest',    -- Restricted airspaces
      'sp.spi',     -- Special airspaces
    ) NOT NULL,

    -- Entity type / source table
    entity_type ENUM (
      'airport', 'runway', 'navaid', 'waypoint',
      'airway', 'airspace', 'feature'
    ) NOT NULL,

    -- Referenced ID in source table
    entity_id INT( 10 ) UNSIGNED NOT NULL,

    -- Label or name (e.g. waypoint ident or airport ICAO) / optional i18n names
    label TINYBLOB NULL,
    i18n  JSON NULL,

    -- Optional zoom visibility constraints
    _zmin TINYINT UNSIGNED NOT NULL DEFAULT 0,
    _zmax TINYINT UNSIGNED NULL,

    -- Optional sort priority (0–1), used for map rendering thresholds
    _sort DOUBLE NOT NULL DEFAULT 0.5,

    -- Geometrical shape (POINT, LINESTRING, POLYGON, etc.)
    geom GEOMETRY SRID 4326 NOT NULL,

    -- Structured meta data
    _meta JSON NULL,

    -- Update timestamp
    _touched DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    -- Indexes
    KEY map_layer ( layer ),
    KEY map_entity ( entity_type, entity_id ),
    KEY map_zoom ( _zmin, _zmax ),
    KEY map_sort ( _sort ),
    SPATIAL KEY map_geom ( geom ),

    -- Integrity checks
    CHECK ( _zmax IS NULL OR _zmax >= _zmin ),
    CHECK ( ST_SRID( geom ) = 4326 ),
    CHECK ( _meta IS NULL OR JSON_VALID( _meta ) )

);

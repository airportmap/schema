-- ========================================================================
-- TABLE: trash
-- ------------------------------------------------------------------------
-- Stores deleted records from any table as JSON backup for recovery
-- or audit purposes. Used for soft-deletes and undo functionality.
-- ========================================================================

CREATE TABLE trash (

    -- Internal trash entry ID
    _id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,

    -- Entity table from which the data were deleted
    entity_type ENUM (
      'airport', 'airspace', 'airway', 'feature', 'frequency', 'image',
      'navaid', 'proc', 'region', 'runway', 'tz', 'waypoint'
    ) NOT NULL,

    -- The original record ID
    entity_id INT UNSIGNED NULL,

    -- User who deleted the record (may be NULL for system actions)
    actor INT UNSIGNED NULL,

    -- Deletion timestamp
    ts DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- Full record data as JSON
    content JSON NOT NULL,

    -- Optional comment
    comment TINYBLOB NULL,

    -- Optional structured meta data
    _meta JSON NULL,

    -- Indexes
    KEY trash_entity ( entity_type ),
    KEY trash_lookup ( entity_type, entity_id ),
    KEY trash_actor ( actor ),
    KEY trash_ts ( ts ),

    -- Foreign key constraints
    FOREIGN KEY ( actor ) REFERENCES user ( _id ),

    -- Integrity checks
    CHECK ( JSON_VALID( content ) ),
    CHECK ( _meta IS NULL OR JSON_VALID( _meta ) )

);
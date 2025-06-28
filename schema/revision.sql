-- ========================================================================
-- TABLE: revision
-- ------------------------------------------------------------------------
-- Records all edits made through the Airportmap editor: who changed
-- what, when, on which entity, and with what data.
--
-- Allows for review workflow and rollback.
-- ========================================================================

CREATE TABLE revision (

    -- Revision ID
    _id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,

    -- User submitting the edit
    user INT UNSIGNED NOT NULL,

    -- User who approved / rejected the edit
    reviewer INT UNSIGNED NULL,

    -- Which table was edited (e.g. airport, runway, navaid, proc)
    entity_type ENUM (
      'airport', 'airspace', 'airway', 'feature', 'freq', 'image',
      'navaid', 'proc', 'region', 'runway', 'tz', 'waypoint'
    ) NOT NULL,

    -- Primary key of the affected entity row
    -- NULL if new entity
    entity_id INT UNSIGNED NULL,

    -- Workflow status
    _status ENUM (
      'pending', 'approved', 'rejected', 'rollback'
    ) NOT NULL DEFAULT 'pending',

    -- Edit flags
    _bot      BOOLEAN NOT NULL DEFAULT FALSE,  -- Bot edit
    _conflict BOOLEAN NOT NULL DEFAULT FALSE,  -- Edit conflict
    _new      BOOLEAN NOT NULL DEFAULT FALSE,  -- New entity

    -- When the edit was made and reviewed
    edited_at   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    reviewed_at DATETIME NULL,

    -- Full JSON diff or patched data
    edit JSON NOT NULL,

    -- Optional edit & reviewer comments
    edit_comment   TINYBLOB NULL,
    review_comment TINYBLOB NULL,

    -- Size of the edit in bytes
    _size INT UNSIGNED NOT NULL,

    -- Indexes
    KEY rev_user ( user ),
    KEY rev_entity ( entity_type ),
    KEY rev_lookup ( entity_type, entity_id ),
    KEY rev_status ( _status ),
    KEY rev_botedit ( _bot ),
    KEY rev_conflict ( _conflict ),
    KEY rev_newedit ( _new ),
    KEY rev_edited ( edited_at ),
    KEY rev_reviewed ( reviewed_at ),

    -- Foreign key constraints
    FOREIGN KEY ( user ) REFERENCES user ( _id ),
    FOREIGN KEY ( reviewer ) REFERENCES user ( _id ),

    -- Integrity checks
    CHECK ( reviewed_at IS NULL OR reviewed_at >= edited_at ),
    CHECK ( JSON_VALID( edit ) )

);
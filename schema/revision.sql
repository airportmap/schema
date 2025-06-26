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
    _id INT( 10 ) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,

    -- User submitting the edit
    user INT( 10 ) UNSIGNED NOT NULL,
    is_bot BOOLEAN NOT NULL DEFAULT FALSE,

    -- User who approved / rejected the edit
    reviewer INT( 10 ) UNSIGNED NULL,

    -- Which table was edited (e.g. airport, runway, navaid, proc)
    entity_type ENUM (
      'airport', 'airspace', 'airway', 'frequency', 'image',
      'navaid', 'proc', 'runway', 'waypoint'
    ) NOT NULL,

    -- Primary key of the affected entity row
    entity_id INT( 10 ) UNSIGNED NOT NULL,

    -- Workflow status
    _status ENUM (
      'pending', 'approved', 'rejected', 'rollback'
    ) NOT NULL DEFAULT 'pending',

    -- Conflict flag, e.g. if newer edit exists or data was changed meanwhile
    has_conflict BOOLEAN NOT NULL DEFAULT FALSE,

    -- When the edit was made and reviewed
    edited_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    reviewed_at DATETIME NULL,

    -- Full JSON diff or patched data
    change JSON NOT NULL,

    -- Optional reviewer comment
    comment TINYBLOB NULL,

    -- Indexes
    KEY rev_user ( user ),
    KEY rev_botedit ( is_bot ),
    KEY rev_entity ( entity_type, entity_id ),
    KEY rev_status ( _status ),
    KEY rev_conflict ( has_conflict ),
    KEY rev_edited ( edited_at ),
    KEY rev_reviewed ( reviewed_at ),

    -- Foreign key constraints
    FOREIGN KEY ( user ) REFERENCES user ( _id ),
    FOREIGN KEY ( reviewer ) REFERENCES user ( _id ),

    -- Integrity checks
    CHECK ( reviewed_at >= edited_at ),
    CHECK ( change IS NULL OR JSON_VALID( change ) )

);
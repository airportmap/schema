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
    _status ENUM ( 'pending', 'approved', 'rejected' ) NOT NULL DEFAULT 'pending',

    -- When the edit was made and reviewed
    edited_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    reviewed_at DATETIME NULL,

    -- Full JSON diff or patched data
    change JSON NOT NULL,

    -- Optional reviewer comment
    comment TINYBLOB NULL,

    -- Indexes
    KEY rev_user ( user ),
    KEY rev_entity ( entity_type, entity_id ),
    KEY rev_status ( _status ),

    -- Foreign key constraints
    FOREIGN KEY ( user ) REFERENCES user ( _id ),
    FOREIGN KEY ( reviewer ) REFERENCES user ( _id )

);
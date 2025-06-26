-- ========================================================================
-- TABLE frequency
-- ------------------------------------------------------------------------
-- Stores operational radio frequencies for airports, including
-- tower, ground, ATIS, approach, and other services.
--
-- All values are stored in kilohertz (kHz).
-- ========================================================================

CREATE TABLE frequency (

    -- Internal ID
    _id INT( 10 ) UNSIGNED NOT NULL AUTO_INCREMENT,

    -- Associated airport (foreign key)
    airport INT( 10 ) UNSIGNED NOT NULL,

    -- Function or service type (e.g. TWR, GND, ATIS, APP, etc.)
    _type VARBINARY( 16 ) NOT NULL,

    -- Frequency in kilohertz (kHz), e.g. 118550 = 118.550 MHz
    freq_khz INT UNSIGNED NOT NULL,

    -- Optional label (e.g. "Tower North", "Approach East")
    label TINYBLOB DEFAULT NULL,

    -- Optional structured metadata (e.g. service hours, remarks)
    _data JSON DEFAULT NULL,

    -- Indexes
    PRIMARY KEY ( _id ),
    KEY freq_airport ( airport ),
    KEY freq_type ( _type ),

    -- Foreign key constraints
    FOREIGN KEY ( airport ) REFERENCES airport ( _id )

);

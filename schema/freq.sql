-- ========================================================================
-- TABLE freq
-- ------------------------------------------------------------------------
-- Stores operational radio frequencies for airports, including
-- tower, ground, ATIS, approach, and other services.
--
-- All values are stored in kilohertz (kHz).
-- ========================================================================

CREATE TABLE freq (

    -- Internal ID
    _id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,

    -- Associated airport (foreign key)
    airport INT UNSIGNED NOT NULL,

    -- Function or service type
    _type ENUM (
      'aa',       -- Air-To-Air
      'ad',       -- Analog/Digital
      'ag',       -- Air-To-Ground
      'aas',      -- Airport Advisory Service
      'acc',      -- Area Control Center
      'acp',      -- ACP
      'afis',     -- Aerodrome Flight Information Service
      'app',      -- Approach
      'apron',    -- Apron
      'arcal',    -- Aircraft Radio Control of Aerodrome Lighting
      'artc',     -- Air Route Traffic Control (USA)
      'asos',     -- Automated Surface Observing System
      'asow',     -- ASOW
      'atf',      -- Aerodrome Traffic Frequency
      'atis',     -- Automatic Terminal Information Service
      'cld',      -- CLD
      'ctaf',     -- Common Traffic Advisory Frequency
      'dep',      -- Departure
      'dir',      -- Director
      'fcc',      -- Federal Communications Commission
      'fss',      -- Flight Service Station
      'gca',      -- Ground Controlled Approach
      'ground',   -- Ground
      'info',     -- Info
      'misc',     -- Misc
      'ops',      -- Operations
      'pal',      -- Pilot Activated Lighting
      'radar',    -- Radar
      'radio',    -- Radio
      'rco',      -- Remote Communications Outlet
      'tiba',     -- Traffic Information Broadcast by Aircraft
      'tma',      -- Terminal Control Area
      'tower',    -- Tower
      'traffic',  -- Traffic
      'unicom'    -- Aeronautical Advisory Service
    ) NOT NULL,

    -- Frequency in kilohertz (kHz), e.g. 118550 = 118.550 MHz
    freq MEDIUMINT UNSIGNED NOT NULL,

    -- Optional label (e.g. "Tower North", "Approach East")
    label TINYBLOB NULL,

    -- Optional structured meta data (e.g. service hours, remarks)
    _meta JSON NULL,

    -- Indexes
    KEY freq_airport ( airport ),
    KEY freq_type ( _type ),

    -- Foreign key constraints
    FOREIGN KEY ( airport ) REFERENCES airport ( _id ),

    -- Integrity checks
    CHECK ( JSON_VALID( _meta ) OR _meta IS NULL )

);

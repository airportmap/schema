-- ========================================================================
-- TABLE: wiki
-- ------------------------------------------------------------------------
-- Holds introductory texts (usually from Wikipedia) per airport,
-- keyed by language.
--
-- This table will be populated automatically.
-- ========================================================================

CREATE TABLE wiki (

    -- Internal ID
    _id INT( 10 ) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,

    -- Referenced airport ID
    airport INT( 10 ) UNSIGNED NOT NULL,

    -- Language code
    lang VARBINARY( 4 ) NOT NULL,

    -- The lead paragraph / summary
    content BLOB NOT NULL,

    -- Last update timestamp
    _touched DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    -- Indexes
    UNIQUE KEY wiki_lang ( airport, lang ),
    FULLTEXT KEY wiki_search ( content ),

    -- Foreign key constraints
    FOREIGN KEY ( airport ) REFERENCES airport ( _id )

);
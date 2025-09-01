-- --------------------------------------------------------------------------------
-- Table `wiki`
-- 
-- Holds introductory texts (extracted from the Wikipedia) for airports in
-- different languages.
-- 
-- This table will be populated automatically.
-- --------------------------------------------------------------------------------

CREATE TABLE wiki (

    -- Internal ID
    _id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,

    -- Referenced airport ID
    airport INT UNSIGNED NOT NULL,

    -- Language code
    lang VARBINARY( 4 ) NOT NULL,

    -- The lead paragraph / summary (UTF-8 encoded)
    content TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,

    -- Last update timestamp
    _touched DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    -- Indexes
    UNIQUE KEY wiki_lang ( airport, lang ),
    FULLTEXT KEY wiki_search ( content ),

    -- Foreign keys
    FOREIGN KEY ( airport ) REFERENCES airport ( _id )

);
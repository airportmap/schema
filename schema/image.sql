-- ========================================================================
-- TABLE: image
-- ------------------------------------------------------------------------
-- Stores references to externally hosted images (e.g. Wikimedia Commons).
-- No binary content is stored locally — only URLs and metadata.
--
-- Will be used on airport pages, galleries, embed service and the map.
-- ========================================================================

CREATE TABLE image (

    -- Internal ID
    _id INT( 10 ) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,

    -- Referenced airport ID
    airport INT( 10 ) UNSIGNED NOT NULL,

    -- Full-size image URL (e.g. from Wikimedia)
    image_url VARBINARY( 512 ) NOT NULL,

    -- Image meta (e.g. dimensions and size)
    image_meta JSON NULL,

    -- Optional thumbnail URL (small preview image)
    thumb_url VARBINARY( 512 ) NULL,

    -- Thumbnail meta (e.g. dimensions and size)
    thumb_meta JSON NULL,

    -- Caption or image title
    caption TINYBLOB NULL,

    -- License type (e.g. "CC-BY-SA-4.0")
    license TINYBLOB NOT NULL,

    -- Author / attribution (if required by license)
    credit BLOB NULL,

    -- User or system reference (nullable)
    user INT( 10 ) UNSIGNED NULL,

    -- Last update timestamp
    _touched DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    -- Indexes
    KEY image_airport ( airport ),
    KEY image_license ( license ),
    KEY image_user ( user ),

    -- Foreign key constraints
    FOREIGN KEY ( airport ) REFERENCES airport ( _id ),
    FOREIGN KEY ( user ) REFERENCES user ( _id )

);

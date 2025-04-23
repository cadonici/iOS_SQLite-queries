-- Query to extract metadata from the Photos.sqlite database
-- Typical in forensic analysis of Apple devices (e.g., iPhone, iPad)
-- Converts Apple Core Data timestamps (seconds since 2001-01-01) to UTC

SELECT 
    ZASSET.ZFILENAME AS "Filename", -- The name of the file stored on the device
    ZADDITIONALASSETATTRIBUTES.ZORIGINALFILENAME AS "Original file name", -- The original name before import
    ZADDITIONALASSETATTRIBUTES.ZEXIFTIMESTAMPSTRING AS "EXIF timestamp", -- The timestamp from EXIF metadata
    datetime('2001-01-01', ZASSET.ZADDEDDATE || ' seconds', 'utc') AS "Added time", -- Time the file was added to the library
    datetime('2001-01-01', ZASSET.ZDATECREATED || ' seconds', 'utc') AS "Creation time", -- When the asset was created
    ZADDITIONALASSETATTRIBUTES.ZIMPORTEDBYBUNDLEIDENTIFIER AS "Bundle ID", -- App bundle ID used for import
    ZADDITIONALASSETATTRIBUTES.ZIMPORTEDBYDISPLAYNAME AS "Imported by" -- App display name used for import
FROM 
    ZADDITIONALASSETATTRIBUTES
INNER JOIN 
    ZASSET ON ZADDITIONALASSETATTRIBUTES.Z_PK = ZASSET.ZADDITIONALATTRIBUTES;

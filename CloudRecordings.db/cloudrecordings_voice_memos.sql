-- iOS Voice Memos – Cloud Recordings Extraction
-- Database: CloudRecordings.db
-- Description:
--   Extracts Voice Memo records stored in iCloud, including:
--   - Custom label (voice memo name)
--   - File path
--   - Recording duration formatted as HH:MM:SS
--   - Creation date converted to UTC
--
-- Notes:
--   ZDATE is stored as Apple Absolute Time (seconds since 2001-01-01)
--   and is converted to Unix Epoch for readability.
--
-- Table:
--   ZCLOUDRECORDING
--
-- Author: Luca Cadonici

SELECT
    ZCUSTOMLABELFORSORTING AS "Voice Memo",
    ZPATH AS "File Path",
    printf(
        '%02d:%02d:%02d',
        CAST(ZDURATION / 3600 AS INTEGER),
        CAST((ZDURATION % 3600) / 60 AS INTEGER),
        CAST(ZDURATION % 60 AS INTEGER)
    ) AS "Duration (HH:MM:SS)",
    datetime(ZDATE + 978307200, 'unixepoch') AS "Creation Date (UTC)"
FROM ZCLOUDRECORDING
ORDER BY ZDATE ASC;

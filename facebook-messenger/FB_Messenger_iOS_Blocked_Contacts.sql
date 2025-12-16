
Purpose
This SQLite query is intended for the forensic analysis of the
Facebook Messenger database extracted from an iOS device.

The database file name corresponds to the Facebook User ID (UID)
of the logged-in account.

Example
- Facebook User ID (UID) 61568138441033
- Database file name    61568138441033.db

This naming convention allows Facebook Messenger to maintain
separate local databases for each user account that has logged
into the application on the same device.

Database description
The database contains Messenger-specific contact metadata,
including internal Facebook identifiers, display names, and
relationship status information (e.g., blocked contacts).
Despite the generic structure, this database is not related to
the iOS system address book and is exclusively used by
Facebook Messenger.

Query focus
This query identifies contacts blocked by the user, normalizes
the block status into a human-readable value, and converts the
block timestamp into UTC for timeline analysis.

Use case
- iOS Mobile Forensics
- Facebook Messenger artifact analysis
- Identification of blocked contacts
- Timeline reconstruction and evidentiary reporting

Notes
- blocked_by_viewer_status = 2 indicates a blocked contact
- blocked_since_timestamp_ms is stored as Unix epoch in milliseconds


SELECT
  id   AS "Facebook ID",
  name AS "Contact",
  CASE
    WHEN blocked_by_viewer_status = 2 THEN 'Blocked'
    ELSE CAST(blocked_by_viewer_status AS TEXT)
  END AS "Status",
  datetime(blocked_since_timestamp_ms / 1000, 'unixepoch') AS "Blocked since (UTC)"
FROM contacts
WHERE blocked_by_viewer_status = 2
   OR blocked_since_timestamp_ms IS NOT NULL
ORDER BY blocked_since_timestamp_ms DESC;

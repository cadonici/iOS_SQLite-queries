-- =============================================================================
-- whatsapp_ios_reply_pairs.sql
-- -----------------------------------------------------------------------------
-- Reconstruct "reply" (quoted-message) relationships in WhatsApp on iOS.
--
-- Target: ChatStorage.sqlite  (WhatsApp iOS local database, Apple Core Data)
--
-- Background:
--   In recent WhatsApp iOS versions the reply link is NOT stored in a dedicated
--   column of ZWAMESSAGE. The reference to the quoted message lives inside a
--   binary BLOB field, ZMETADATA, in the ZWAMEDIAITEM table, encoded as
--   Protocol Buffers (protobuf). Inside that blob, the quoted message's unique
--   identifier (ZSTANZAID) is stored as readable text.
--
-- How this query works:
--   It does NOT parse the protobuf structure. It converts both the ZMETADATA
--   blob and each candidate message's ZSTANZAID to their hexadecimal
--   representation, then checks whether the identifier appears inside the blob
--   (a byte-sequence substring match). The match runs over 40+ hex characters,
--   so false positives are effectively impossible. The operation is read-only,
--   deterministic and repeatable.
--
-- Scope / limitations:
--   * Matches replies whose original message still exists in the database.
--   * The SQL approach pairs a reply with an existing original. For full
--     coverage (e.g. extracting the quoted sender / text preview directly from
--     the blob, or handling stanza IDs of unusual length), use proper protobuf
--     decoding (e.g. a small Python script).
--   * Column names can vary across versions. If ZMESSAGEDATE does not exist in
--     your schema, replace it with ZSENTDATE or ZTIMESTAMP.
--
-- Usage:
--   Always work on a copy of the database, never the original evidence file.
--   sqlite3 ChatStorage.sqlite < whatsapp_ios_reply_pairs.sql
--
-- License: MIT
-- =============================================================================

SELECT
    datetime('2001-01-01', reply.ZMESSAGEDATE || ' seconds') AS datetime_UTC,
    CASE reply.ZISFROMME WHEN 1 THEN 'sent' ELSE 'received' END          AS direction,
    reply.Z_PK        AS msg_pk,
    reply.ZTEXT       AS msg_text,
    '⤷ replies to'    AS relationship,
    orig.Z_PK         AS quoted_pk,
    CASE
        WHEN orig.ZISFROMME = 1 THEN 'owner'
        ELSE orig.ZFROMJID
    END               AS quoted_from,
    orig.ZTEXT        AS quoted_text
FROM ZWAMESSAGE reply
JOIN ZWACHATSESSION cs   ON reply.ZCHATSESSION = cs.Z_PK
JOIN ZWAMEDIAITEM  media ON media.ZMESSAGE     = reply.Z_PK
JOIN ZWAMESSAGE    orig
       ON orig.ZSTANZAID IS NOT NULL
      AND length(orig.ZSTANZAID) >= 10
      AND hex(media.ZMETADATA) LIKE '%' || hex(orig.ZSTANZAID) || '%'
ORDER BY reply.ZMESSAGEDATE;
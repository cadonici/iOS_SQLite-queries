/*
    iOS Call History Analysis Query
    --------------------------------

    This SQL query is designed to be executed on the iOS CallHistory.storedata SQLite
    database, which stores records of incoming, outgoing, and missed calls.

    The query converts Apple Cocoa timestamps into human-readable date and time format
    and formats call duration values into hh:mm:ss for clarity. It also retrieves
    relevant metadata such as the contact name, phone number, and the service provider.

    The "ZSERVICE_PROVIDER" field is particularly useful for digital forensic analysis:
    it indicates which application handled the call. This allows investigators to
    differentiate between traditional cellular calls (Phone app) and VoIP calls made
    through applications such as FaceTime, WhatsApp, Instagram, Messenger, and others
    that integrate with CallKit.

    This differentiation helps determine where additional artefacts should be examined
    (e.g., WhatsApp ChatStorage.sqlite, FaceTime logs, Instagram Direct message database).

    -------------
*/

SELECT
    datetime(ZDATE + 978307200, 'unixepoch') AS CALL_DATE,
    printf('%02d:%02d:%02d',
           ZDURATION/3600,
           (ZDURATION%3600)/60,
           (ZDURATION%60)) AS CALL_DURATION,
    ZNAME,
    ZSERVICE_PROVIDER,
    ZADDRESS
FROM ZCALLRECORD;

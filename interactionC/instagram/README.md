iOS Instagram Interactions Forensic Query
This repository contains an SQLite queries designed for forensic analysis of iOS interactions, specifically focusing on file sharing between the Apple Photos app and Instagram via the Share Extension. The query provides valuable insights into the nature of interactions, including details such as source and target applications, contact information, direction, and timestamps.


Query Output Columns:
Source App: Identifies the source application, with 'Apple Photos' as the default if the bundle ID matches.
Target App: Identifies the target application, with 'Instagram' as the default if the bundle ID matches.
Contact: Represents the contact information associated with the interaction.
Direction: Indicates whether the interaction is 'Outgoing' or 'Incoming.'
Creation Date (UTC): Displays the creation date in Coordinated Universal Time (UTC).
Start Date (UTC): Displays the start date in Coordinated Universal Time (UTC).
End Date (UTC): Displays the end date in Coordinated Universal Time (UTC).
Creation Date (Local): Displays the creation date converted to the local time zone.
Start Date (Local): Displays the start date converted to the local time zone.
End Date (Local): Displays the end date converted to the local time zone.




Usage Instructions
Execute the provided query on your SQLite database, ensuring that the database supports time zone conversions.
Review the query output to gain insights into iOS interactions involving file sharing between Apple Photos and Instagram.
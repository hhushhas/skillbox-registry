# Email, push, and notifications

This is UI rendered by someone else's client, on settings you don't control. It's cheap to skip and expensive to get wrong, because the mistake ships to everyone at once.

**Front door.** A real message to a real address or device, sent through the code path production uses. Then open it where the user opens it: the phone, the actual mail app, the lock screen. A rendered preview in your own dev tool isn't the artifact under test.

**Worth considering.** Dark mode. Images blocked, which is the default in plenty of clients. A long subject line and where it truncates in the list view. The plain-text fallback. Narrow mobile width. Gmail clipping a long message, and Outlook rendering unlike everything else. For push: the lock screen, permission never granted, permission revoked later, the app foregrounded against killed, a badge count that has to stay right, and a deep link that has to land somewhere sensible from a cold start. Client behaviour shifts constantly, so check whatever your audience actually uses rather than only what's listed here.

**The boring parts count.** Sender name, reply-to, unsubscribe link, and preheader text are all part of the message and all easy to ship wrong.

**Capture.** Screenshots from each client that matters, light and dark. For push, a short screen recording showing the notification arrive and the tap land.

**Findings that often show up.** White-on-white text in dark mode, a layout that only holds when images load, a subject truncating before the useful word, a deep link opening the home screen from cold start, a test address left in the sender field.

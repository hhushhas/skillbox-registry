# Screens

Web and mobile UI. The user is a person looking at a screen, so anything that only shows up in motion (timing, transitions, jank) counts as much as a wrong number.

**Front door.** A fresh app launch or a fresh browser session. Avoid deep links straight to the screen under test, pre-seeded local storage, and an already-signed-in state, unless the flow you're testing genuinely starts there.

**Move like a human.** This is the part worth holding to. Act only on what a user can see and touch: scroll to reach things instead of jumping, wait out loading and animations rather than racing them, type at typing speed, and navigate with the app's own buttons and back gestures rather than JS clicks or taps on hidden elements. Pause a beat where a user would read. If you outrun the app you skip the jank, and the capture becomes an unwatchable blur.

**States worth considering.** Empty, loading, error, and overflow are the usual suspects, along with whatever hides behind toggles and settings combinations. Beyond those, think about slow and offline networks, rotation, small screens, dark mode, text scaled up for accessibility, and interrupting a flow halfway with the back gesture. Ask what this particular screen can be in, rather than working down this list.

**Capture.** Video, every pass, using the recording skill's capture commands. Screenshots miss the timing problems that make an app feel bad. Working recordings stay local: the driver hands back the file path, and you watch it or pull frames to judge findings and confirm fixes.

**Findings that often show up.** A spinner with no bound, a tap target that does nothing for a second, text clipping at the second line, an error toast gone before it can be read, a form that drops input on back. Yours will differ.

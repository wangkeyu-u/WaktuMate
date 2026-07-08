# WaktuMate Malaysia

WaktuMate Malaysia is a SwiftUI prayer companion app for Muslims in Malaysia. It shows JAKIM/e-Solat based prayer times by Malaysia zone, highlights the next prayer, runs a live countdown, schedules local reminders, tracks daily prayer completion, and includes a Tasbih Counter.

## Features

- Today tab with selected zone, Gregorian date, Hijri date, next prayer, countdown, and all daily prayer times.
- First-run faith profile selection for Islam, Christianity, Buddhism, Hinduism, Taoism, Sikhism, and a neutral General mode.
- Profile-specific app versions: Islam keeps Today and Tracker, while other profiles use a simpler Home, Tools, and Settings structure.
- GPT-generated faith-specific background images for each profile, bundled in `Assets.xcassets`.
- Three app languages: English, Bahasa Melayu, and Chinese, switchable from Settings.
- Malaysia zone picker with MVP zones from Kuala Lumpur, Selangor, Johor, Penang, Melaka, Perak, Sabah, and Sarawak.
- Waktu Solat API integration using `https://api.waktusolat.app/v2/solat/{zone}` with `year` and `month` query parameters.
- Offline fallback through `MockPrayerTimes.json` so the demo never opens to a blank state.
- Tracker tab for the five daily prayers, excluding Syuruk.
- Weekly completion percentage and current full-day streak.
- Tasbih Counter with 33, 99, and 100 targets, local persistence, and target haptic feedback.
- Nearby place search that opens Google Maps for mosques, churches, temples, gurdwaras, or general places of worship depending on profile.
- Qibla Compass for the Islam profile using CoreLocation heading and location-based bearing to Makkah.
- Practice Timer for prayer, meditation, reflection, puja, paath, simran, or general quiet practice.
- Reference Library links that adapt to the selected faith profile.
- Local personal profile storage for each faith profile, including community/place, practice goal, preferred time, and private prompts.
- Practice stats in Settings: active days, prayer completion days, Tasbih total, and timer minutes.
- Faith-specific holiday reminders with system notifications.
- Apple Calendar export for selected holidays.
- Settings for zone, notification toggle, per-prayer notification toggles, reminder offset, time format, and clearing local data.
- Local notifications using `UserNotifications`.
- Dark mode friendly card-based SwiftUI UI.

## Tech Stack

- iOS 17+
- SwiftUI
- MVVM
- URLSession
- Codable
- UserDefaults
- UserNotifications
- CoreLocation
- EventKit
- Google Maps URL scheme / web fallback
- Foundation Date / Calendar

## Architecture

```text
WaktuMate/
  App/
  Models/
  Services/
  ViewModels/
  Views/
  Resources/
```

Core services:

- `PrayerTimeService`: fetches Waktu Solat v2 monthly data and falls back to bundled mock data.
- `NotificationService`: requests permission, cancels old prayer notifications, and schedules today's enabled prayer reminders.
- `StorageService`: stores selected zone, language, settings, tracker records, faith profiles, practice stats, holiday reminder preferences, and Tasbih state in `UserDefaults`.
- `LocationService`: requests location, reads compass heading, prepares Google Maps URLs, and calculates the Qibla bearing.
- `CalendarService`: writes selected faith holidays to Apple Calendar when the user chooses to export them.

Profile behavior:

- `FaithOnboardingView` appears on first launch and saves the user's selected faith profile locally.
- Islam profile shows `Today`, `Tracker`, `Tools`, and `Settings`.
- Other profiles show `Home`, `Tools`, and `Settings`, with profile-specific nearby places and references.
- Settings exposes faith attributes, private profile questions, language, holiday reminders, and Apple Calendar export.

## API Data Source

The app uses the Malaysia Waktu Solat API, which provides prayer times from JAKIM e-Solat data. The implemented endpoint is:

```text
GET https://api.waktusolat.app/v2/solat/{zone}?year=2026&month=7
```

The v2 API returns daily prayer times as epoch seconds in the `prayers` array. The app maps those into display-ready Malaysia-time strings.

## How To Run

1. Open `WaktuMate.xcodeproj` in Xcode 26 or newer.
2. Select the `WaktuMate` scheme.
3. Choose an iOS 17+ simulator.
4. Run the app.

Command-line build:

```bash
xcodebuild -project WaktuMate.xcodeproj -scheme WaktuMate -destination 'generic/platform=iOS Simulator' build
```

## Completed MVP

- TabView foundation
- Today UI
- Mock prayer time fallback
- Prayer models
- Next-prayer calculation
- Live countdown
- Zone picker
- Waktu Solat API service
- Tracker persistence
- Weekly stats and streak
- Tasbih Counter
- Faith profile onboarding
- Google Maps nearby place search
- Qibla Compass
- Practice Timer
- Profile-aware reference library
- Faith-specific generated backgrounds
- English / Bahasa Melayu / Chinese UI language switcher
- Faith-specific holiday notifications
- Apple Calendar holiday export
- Private profile and faith attribute settings
- Local notification scheduling
- Dark mode friendly UI polish

## Screenshot Placeholders

- Today: next prayer countdown and prayer time list.
- Tracker: daily checklist and weekly stats.
- Onboarding: faith profile selection.
- Tools: nearby places, compass, timer, Tasbih Counter, and references.
- Settings: language, faith profile, private profile, stats, attributes, holidays, zone, notifications, and display preferences.

## Interview Talking Points

- I started with a working offline path, then layered the remote API on top. That keeps the demo stable even when the network or API fails.
- The app uses MVVM so the SwiftUI views stay focused on rendering state, while view models own countdown, tracker stats, and settings behavior.
- Date handling is centralized around the Malaysia time zone, which matters because prayer times are local and the API returns epoch timestamps.
- Local notifications are intentionally scheduled from today's loaded prayer times, so reminders match the selected zone and user offset.
- UserDefaults is enough for the MVP because the data is small and local-only, but the service boundary makes SwiftData migration straightforward.
- Faith profiles let the app support different versions without incorrectly applying Islamic prayer-time screens to every user.
- Google Maps is opened through a URL scheme first, with a browser fallback, so the feature works even if Google Maps is not installed.
- Holiday reminders are filtered by the selected faith profile before scheduling notifications or creating Calendar events.
- Generated backgrounds are used as app assets and softened with a readability overlay so the interface remains usable.

## Future Work

- Qibla compass using CoreLocation heading.
- Mosque / Surau finder using MapKit.
- Home Screen Widget for next prayer countdown.
- Ramadan mode with Imsak and Iftar countdown.
- Full Malaysia zone list.
- Multi-language support: English, Malay, Chinese.
- Offline monthly cache.

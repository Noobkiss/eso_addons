## 2024.03.14 - @m00nyONE
- add LibGroupBroadcast as dependency
- LibDataShare will still work with map pings until U46 arrives and then auto switch to compatibility mode for everyone!
  - this is to avoid incompatibilities between players who have LGB installed and those who do not

## 2024.02.10 - @m00nyONE
- introducing compatibility layer to LibGroupBroadcast
- fix handler bleeding to global

## 0.0.6 - @m00nyONE
- adjust PING_RATE for U46 because ZoS extended the time before limiting the MapPingAPI until U46 launches.
- addon will now disable itself on U46 except on PTS -- So Addon devs still have a chance to do a last minute patch of their addons if they missed it.

## 0.0.5 - @m00nyONE
- ZoS will limit the mapPing API in U46 - this addon should no longer be used for creating new projects and all existing projects should migrate to LibGroupBroadcast by @sirinister when it's released. Don't worry, this does not mean the end of data sharing! ZoS introduced a new dedicated sharing api for addons in U45. This Library will still work, but only every 10s instead of every 2s.
- automatically change PING_RATE to every 10s after U45

## 0.0.4 - m00nyONE
- API bump to 101044
- add comments for some maps already being used by addons

## 0.0.3 - m00nyONE
- API bump to 101037 101038
- resolve more conflicts

## 0.0.2 - m00nyONE
- API bump to 101035 101034

## 0.0.1
- initial release
# !DEPRECATED! DO NOT USE THIS LIBRARY TO CREATE NEW PROJECTS
**ZoS will limit the MapPing API in Update 46!** And this is a good thing! This addon should no longer be used for creating new projects, and all existing projects should migrate to `LibGroupBroadcast` by `@sirinsidiator` when it's released around the end of Update 45 PTS.

Don't worry, this does not mean the end of data sharing! ZoS introduced a new dedicated sharing API for addons in Update 45. This library will still work, but only every 10 seconds instead of every 2 seconds. However, you may get kicked for exceeding the rate limit.

In Update 46, the library disables itself and will print warnings in chat to remind you to remove it.

---

This library is primarily intended to be used by [Hodor Reflexes](https://www.esoui.com/downloads/info2311-HodorReflexes-DPSampUltimateShare.html), but addon authors can utilize its functionality to occasionally share small pieces of numeric data between players without worrying about conflicts with other addons.

The library's directory contains a simple example of an addon that can play sounds for group members. Obviously, all group members must have this library and the addon installed, just like with Hodor Reflexes.

When Hodor Reflexes is enabled, this library **must not** be used to share data at a high frequency, because Hodor does that (~every 2 seconds). You can share data based on some rare game event or every 10+ seconds (though it's not recommended, because other addons might also want to do that).

## How to use

```lua
local function HandleData(tag, data)
    d(string.format("Player: %s. Data: %d.", GetUnitDisplayName(tag), data))
end

local share = LibDataShare:RegisterMap("MyAddon", 2, HandleData)
```

Line 5 registers a map with id `2` (which is Glenumbra map) to share data. Whenever the player receives data from another group member, `HandleData` is called. Note: the player doesn't receive his own data. The first parameter is just a string to know which addon has registered the map.

After this you can use "share" object to send data to group members:


```lua
share:QueueData(12345)
-- ^This function queues data for sending.
-- It'll be sent as soon as it's safe to send the next map ping
-- (ideally there should a minimum time between two pings).

-- OR
share:SendData(12345)
-- ^This function sends data instantly without checking if it's safe to do so.
-- Only use it for something really urgent (players shouldn't be kicked
-- from server when sending 2 pings quickly, if it doesn't happen too often).

-- Alternatively you can manually check if it's safe to send data.
-- If Hodor Reflexes is enabled, then this check probably will never succeed.
if share:IsSendWindow() then
share:SendData(12345)
end
```

Each map allows different maximum amount of data you can share (a number between 0 and X). Check Maps.lua for more details.
**Important note**: two addons can not register the same map! If they attempt to do so, then an error will occur. There is no workaround for it, so addon authors will have to communicate and decide who uses which map. Hopefully it won't be an issue, because it's a bad idea to have many data sharing addons active anyway.

You can also notice that there are only few maps available in Maps.lua. This is due to the fact that not all maps are "good" for this purpose and their coordinates can conflict (all map coordinates in the library are relative to Vvardenfell).

Finally it's time to define `data` (better later than never!):
Data is an integer number between 0 and (map size)^2. Map size is basically a number of unique points on its x or y axis, therefore a total amount of (x, y) points is map size squared. It can be a pretty big number like 100 billion, so you can "pack" multiple smaller numbers in it: 130,250,320. Here we have 3 numbers (130, 250 and 320) that easily fit in the range of a billion. I hope I don't need to explain how to "extract" 250 from a number 130250320 ;)

**Final note:** I haven't thoroughly tested all the available maps. Sometimes it's possible that some big random number might not be encoded/decoded properly, but all the maps should work fine for sharing small numbers. Let me know if you run into this issue!
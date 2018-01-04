# Kthura Maps

All these maps were written with the [Kthura Map System](https://github.com/Tricky1975/Kthura).
Kthura is an open-sourced object oriented map system, named after the protagonist of the game Morker (which was never completed at the time this document was written).
In order to make Love2D load the maps faster, a Lua exporter has been put in the Kthura Map Editor, so Lua doesn't have to parse the maps from Kthura Script into Lua tables, since Kthura did that itself, so Lua can just use its own parser and get on the roll immediately.

Please note, Kthura Map Exports tend to create pretty large scripts, as a lot of objects are often present in maps, specifically in larger or more complex dungeons or cities.

ALL these maps are only put into this repository for viewing purposes, to get some idea how the Kthura system actually works. The actual content of ALL Kthura Map Files used in this particular project is property of Jeroen P. Broks, as they are basically part of the story line behind 63 Fires of Lung.

Also note, these files are exports of map files written in Kthura's native system. In other words they are all generated, and not created by human hands. I guess it goes without saying that therefore pull requests are completely senseless, and even if you did bring in a very brilliant fix or improvement, I'll have to reject the request. After all, the chance is quite big that if I have to make changes to the map using the Kthura editor (which does not read these scripts, it only generates them so they can be easily read in Love), the entire script will be regenerated.



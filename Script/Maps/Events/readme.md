# Map Events

Watch out! These are NOT regular .lua files even though they have the same extention. That was only done to get syntax highlighters and parse checkers (which the IDE I used both has) in friends.
It may look inefficient, but the reader for these map events will not read these events as a whole, but line by line, unless some statements set in remarks which must be both prefixed and suffixed by "--" signs.
Why this approach?

Because the game is written in Love and Love can only be used on a CallBack basis which is a killer in story event scripting. Therefore I must make sure every callback cycle only one action is taken or stuff would either only be shown half, or stuff would wait forever since new events are not registered when the cycle doesn't end.
Needless to say that defining locals can be pretty useless here, as they are only registered in the line in which they are defined. Each line is basically a function on its own and parsed on the moment it's needed. Don't blame me for that. Blame the morons who only believe in callback approaches.

Of course sometimes some actions MUST be packed together, or it would be smarter to do so (when taking care of calculations for example. For those matters blocks or groups have been put in place. For conditional events, I had no other option, but to rely on the forbidden "goto" instruction. It's far from ideal, but at least it does the job, as while statements or for statements are not gonna work here... At least mostly not (unless you know what you are doing, as I might have used some).





Allow me to explain commands the event parser will respond to

~~~Lua
--- event: xxx ---
~~~
Start of the event. All code before the first block will be ignored. This will be used to tie all event blocks to the story events. For example if speaking to a person causes a bossfight you can put all code for speaking to that person under this event.


~~~Lua
--- begin ---
--- end ---
~~~
Sometimes using multiple lines in one go is either unavoidable or more efficient. For these cases the "--- begin ---" and "--- end --" statements have been put in. They'll consider everything in between as 'one line'.
These should only be used for stuff not calling to the 'outer event features' like starting fights or showing scenario text, unless there is only one such command (which will then only be fully executed once the end of the block has been reached.


~~~Lua
--- :label: ---
~~~
Like I said I will need goto instructions. The command "jump" will allow me to make this happen.


Also note, that these files are basically all set up to make the story telling possible, so they are all my property and are only shown here for insight purposes.
They may only be distributed with an unmodified copy for the game.



EchoElement is a basic addon that, using react, takes a single argument (spell element) and returns it to the chat in the format:

[Absorbs]x --> [Weak to]y

The main use is to assist with procs in Hades/Plouton fights. To load automatically, add at the end of init.txt:
lua load echoelement

Note that "react showcmds" can be turned off to remove the debug-type messages.
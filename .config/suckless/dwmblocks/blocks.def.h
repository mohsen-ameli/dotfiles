//Modify this file to change what commands output to your statusbar, and recompile using the make command.
static const Block blocks[] = {
	/*Icon*/	/*Command*/		/*Update Interval*/	/*Update Signal*/
	{"  ", "memory --text-icon", 2, 1},
  {"", "cpu --text-icon", 2, 2},
  {"", "volume --get-full", 0, 3},
	{"", "date '+%b %d (%a) %I:%M%p'", 60, 4},
};

//sets delimiter between status commands. NULL character ('\0') means no delimiter.
static char delim[] = " | ";
static unsigned int delimLen = 5;

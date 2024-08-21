//Modify this file to change what commands output to your statusbar, and recompile using the make command.
static const Block blocks[] = {
	/*Icon*/	/*Command*/		/*Update Interval*/	/*Update Signal*/
  {" ", "temperature --text-icon", 2, 5},
	{"", "memory --text-icon", 2, 11},
  {"", "cpu --text-icon", 4, 20}, 
  {"", "weather --icon", 1800, 21},
  {"", "volume --get-full", 0, 3},
  {"", "volume --get-mic-full", 0, 7},
  {"", "network --icon", 5, 12},
  {"", "bluetooth --icon", 20, 13},
  {"", "battery --text-icon", 10, 16},
	{"", "date '+%_I:%M%p'", 60, 4},
  {"", "echo \"$(updates --count)  \"", 1800, 19},
};

//sets delimiter between status commands. NULL character ('\0') means no delimiter.
static char delim[] = " | ";
static unsigned int delimLen = 5;

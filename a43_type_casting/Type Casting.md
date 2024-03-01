implicit: automatic, small to big

byte
short
int   <---- char
long
float
double


=====================================================================


explicit: big to small

long x = 100_000_000_000_000L; // 100000000000000
int n = (int) x;               // 276447232

type overflow
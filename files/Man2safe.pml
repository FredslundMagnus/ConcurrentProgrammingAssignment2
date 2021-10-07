#define N 4
#define split 2

#define P(S) atomic {S > 0 -> S = S - 1}
#define V(S) atomic {S = S + 1}

#define dec(var) {temp = var; var = temp -1;}
#define inc(var) {temp = var; var = temp + 1;}

int up = 0;
int down = 0;
int upSem = 1;
int downSem = 1;
int mutex = 1;
int avoidDeadLock = 1;

int upCrit = 0;
int downCrit = 0;

active [N] proctype Car()
{
	short temp;
	do
	::	/* First statement is a dummy to allow a label at start */
		skip; 

entry:	
		P(avoidDeadLock);
		if
		:: (_pid < split) -> {
			P(downSem);
			P(mutex);
			if
			:: (down == 0) -> {P(upSem);}
			:: (down != 0) -> {skip;}
			fi;
			inc(down);
			V(mutex);
            V(downSem);
			
		}
		:: !(_pid < split) -> {
			P(upSem);
			P(mutex);
			if
			:: (up == 0) -> {P(downSem);}
			:: (up != 0) -> {skip;}
			fi;
			inc(up);
			V(mutex);
            V(upSem);
		}
		fi;
		V(avoidDeadLock);

crit:	/* Critical section */
		if 
		:: (_pid < split) -> {
			downCrit++;
		}
		:: !(_pid < split) -> {
			upCrit++;
		}
		fi;
		
		assert(!(upCrit > 0 && downCrit > 0));
		
		if 
		:: (_pid < split) -> {
			downCrit--;
		}
		:: !(_pid < split) -> {
			upCrit--;
		}
		fi;
  	
leave: 
		if
		:: (_pid < split) -> {
			P(mutex);
			dec(down);
			if
			:: (down == 0) -> {V(upSem);}
			:: (down != 0) -> {skip;}
			fi;
			V(mutex);
		}
		:: !(_pid < split) -> {
			P(mutex);
			dec(up);
			if
			:: (up == 0) -> {V(downSem);}
			:: (up != 0) -> {skip;}
			fi;
			V(mutex);
		}
		fi;

	od;
}

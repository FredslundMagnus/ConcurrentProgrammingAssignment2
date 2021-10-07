#define N 8
#define split 4

#define P(S) atomic {S > 0 -> S = S - 1}
#define V(S) atomic {S = S + 1}

#define dec(var) {temp = var; var = temp -1;}
#define inc(var) {temp = var; var = temp + 1;}

int up = 0;
int down = 0;
int upSem = 1;
int downSem = 1;

int upCrit = 0;
int downCrit = 0;

active [N] proctype Car()
{
	short temp;
	do
	::	/* First statement is a dummy to allow a label at start */
		skip; 

entry:	
		if
		:: (_pid < split) -> {
			P(downSem);
			if
			:: (down == 0) -> {P(upSem);}
			:: (down != 0) -> {skip;}
			fi;
			inc(down);
            V(downSem);
			
		}
		:: !(_pid < split) -> {
			P(upSem);
			if
			:: (up == 0) -> {P(downSem);}
			:: (up != 0) -> {skip;}
			fi;
			inc(up);
            V(upSem);
		}
		fi;

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
			dec(down);
			if
			:: (down == 0) -> {V(upSem);}
			:: (down != 0) -> {skip;}
			fi;
		}
		:: !(_pid < split) -> {
			dec(up);
			if
			:: (up == 0) -> {V(downSem);}
			:: (up != 0) -> {skip;}
			fi;
		}
		fi;

	od;
}




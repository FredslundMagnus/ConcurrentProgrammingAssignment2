/* DTU Course 02158 Concurrent Programming
 *   Lab 2
 *   spin5.pml
 *     Skeleton PROMELA model of mutual exlusion by coordinator
 */

#define N 5

bool enter[N];  /* Request to enter flags */
bool ok[N];     /* Entry granted flags    */

int incrit = 0; /* For easy statement of mutual exlusion */
int cur = 0;

/*
 * Below it is utilised that the first N process instances will get 
 * pids from 0 to (N-1).  Therefore, the pid can be directly used as 
 * an index in the flag arrays.
 */

active [N] proctype P()
{
	do
	::	/* First statement is a dummy to allow a label at start */
		skip; 

entry:	
		enter[_pid] = true;
		/*await*/ ok[_pid] -> 

crit:	/* Critical section */
		incrit++;
		assert(incrit == 1);
		incrit--;
  	
exit: 
		/* Your code here */
		ok[_pid] = false;

		/* Non-critical setion (may or may not terminate) */
		do :: true -> skip :: break od

	od;
}

active proctype Coordinator()
{
	
	do
	::	
		cur = 0;
		do
		::
			if
			:: enter[cur] -> {enter[cur] = false; ok[cur] = true; /*await*/ !ok[cur] -> }
			:: !enter[cur] -> skip
			fi;
			cur++;
			if 
			:: cur == N -> break
			:: !(cur == N) -> skip
			fi;
		od;
	od
}


ltl fair1 { [] ( (P[0]@entry) -> <>  (P[0]@crit) ) } 

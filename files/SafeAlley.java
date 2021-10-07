//Skeleton implementation of a safe Alley class
//Mandatory assignment 2
//Course 02158 Concurrent Programming, DTU, Fall 2021

//Hans Henrik Lovengreen     Sep 29, 2021

public class SafeAlley extends Alley {

    int up, down;
    Semaphore upSem, downSem, mutex, avoidDeadLock;

    protected SafeAlley() {
        up = 0;
        down = 0;
        upSem = new Semaphore(1);
        downSem = new Semaphore(1);
        mutex = new Semaphore(1);
        avoidDeadLock = new Semaphore(1);
    }

    /* Block until car no. may enter alley */
    public void enter(int no) throws InterruptedException {
        avoidDeadLock.P();
        if (no < 5) {
            downSem.P();
            mutex.P();
            if (down == 0) {
                upSem.P(); // block for up-going cars
            }
            down++;
            mutex.V();
            downSem.V();
        } else {
            upSem.P();
            mutex.P();
            if (up == 0)
                downSem.P(); // block for down-going cars
            up++;
            mutex.V();
            upSem.V();
        }
        avoidDeadLock.V();
    }

    /* Register that car no. has left the alley */
    public void leave(int no) {
        try {
            if (no < 5) {
                mutex.P();
                down--;
                if (down == 0)
                    upSem.V();
                mutex.V();
            } else {
                mutex.P();
                up--;
                if (up == 0)
                    downSem.V();
                mutex.V();
            }
        } catch (InterruptedException e) {
        }
    }

}

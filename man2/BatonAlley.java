//Skeleton implementation of an Alley class  using passing-the-baton
//Mandatory assignment 2
//Course 02158 Concurrent Programming, DTU, Fall 2021

//Hans Henrik Lovengreen     Sep 29, 2021

public class BatonAlley extends Alley {

    int up, down;
    Semaphore upSem, downSem, mutex;

    protected BatonAlley() {
        up = 0;
        down = 0;
        upSem = new Semaphore(1);
        downSem = new Semaphore(1);
        mutex = new Semaphore(1);
    }

    /* Block until car no. may enter alley */
    public void enter(int no) throws InterruptedException {
        if (no < 5) {
            downSem.P();
            // Thread.sleep(1000); // Multi1
            if (down == 0) {
                upSem.P(); // block for up-going cars
            }
            // Thread.sleep(1000); // Multi2
            down++;
            downSem.V();
        } else {
            upSem.P();
            // Thread.sleep(1000); // Multi1
            if (up == 0)
                downSem.P(); // block for down-going cars
            up++;
            upSem.V();
        }

    }

    /* Register that car no. has left the alley */
    public void leave(int no) {
        if (no < 5) {

        } else {

        }
    }

}

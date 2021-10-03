//Prototype implementation of Field class
//Mandatory assignment 2
//Course 02158 Concurrent Programming, DTU, Fall 2021

//Hans Henrik Lovengreen     Sep 29, 2021

public class Field {

    Semaphore[][] tiles = new Semaphore[11][12];;

    public Field() {
        for (int row = 0; row < 11; row++) {
            for (int col = 0; col < 12; col++) {
                this.tiles[row][col] = new Semaphore(1);
            }
        }
    }

    /* Block until car no. may safely enter tile at pos */
    public void enter(int no, Pos pos) throws InterruptedException {
        this.tiles[pos.row][pos.col].P();

    }

    /* Release tile at position pos */
    public void leave(Pos pos) {
        this.tiles[pos.row][pos.col].V();
    }

}

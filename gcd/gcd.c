#include <stdio.h>

int gcd_imp (int x, int y) {
    while (y>0) { int z = x%y; x = y; y = z; }
    return x;
}

int gcd_func (int x, int y) {
    return y > 0 ? gcd_func (y,x % y) : x;
}

int main (int argc, char** argv) {
    printf ("%d\n", gcd_func (21, 36));
    printf ("%d\n", gcd_imp (21, 36));
}

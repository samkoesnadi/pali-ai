extern "C" {
    __attribute__((visibility("default")))
    __attribute((used))
    int sum(int a, int b) {
        return a + b;
    }
}
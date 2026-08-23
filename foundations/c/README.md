# Linux and C foundations

Selected work from the introductory systems-programming laboratories.

## Development workflow

- Ubuntu running in UTM on macOS
- Bash and standard Linux file operations
- Nano for source editing
- GCC for compilation
- terminal-based execution and debugging

## Topics covered

- processes and memory separation with `fork()`;
- thread creation and shared global variables with `pthread_create()`;
- blocked access and resource coordination with semaphores;
- race conditions and mutex-protected critical sections;
- pointers, `malloc()` and allocation checks;
- linked-list data structures; and
- wall-clock time compared with CPU-intensive busy waiting.

The `concurrency/` directory contains compact versions of the process, thread
and mutex examples from the submitted work.

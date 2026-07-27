**STUB — no content yet. Do not rely on this file.**

# Modules
## buffers
Module: buffers
Description: **experimental** buffer data structures
Targets: c64,c128,cx16,pet32,virtual
Usage: `%import buffers`

Key subroutines:

| Namespace | Function | Purpose |
| --------- | -------- | ------- |
|smallringbuffer||A 256 byte FIFO queue ringbuffer for storing & retrieving bytes and words|
||init|(re)initialize the buffer|
||size|Returns how much of the buffer is used|
||free|Returns how many bytes of the buffer are free|
||isfull|Returns true if the buffer is too full to add a word|
||isempty|Returns true if the buffer is empty|
||put|Stores a byte in the buffer|
||putw|Stores a word in the buffer|
||get|Retrieves a byte from the buffer|
||getw|Retrieves a word from the buffer|
|smallstack||A small 256 byte stack (LIFO queue) unrelated to the CPU stack|
||init|Reset the stack pointer to the top|
||size|Report how many bytes on the stack are in use|
||free|Report how many free bytes in the stack|
||isfull|Returns true if the stack is too full to add a word|
||isempty|Returns true if the stack is empty|
||push_b|Stores a byte on the stack|
||push_w|Stores a word on the stack|
||pop_b|Retrieves a byte from the stack|
||pop_w|Retrieves a word from the stack|
|stack||A 8KB stack (LIFO queue) growing downward from the top of the buffer|
||init|Reset the stack pointer to the top|
||size|Report how many bytes on the stack are in use|
||free|Report how many free bytes in the stack|
||isfull|Returns true if the stack is too full to add a word|
||isempty|Returns true if the stack is empty|
||push_b|Stores a byte on the stack|
||push_w|Stores a word on the stack|
||pop_b|Retrieves a byte from the stack|
||pop_w|Retrieves a word from the stack|
|ringbuffer||A 8KB FIFO queue ringbuffer for storing & retrieving bytes and words|
||init|(re)initialize the buffer|
||size|Returns how much of the buffer is used|
||free|Returns how many bytes of the buffer are free|
||isfull|Returns true if the buffer is too full to add a word|
||isempty|Returns true if the buffer is empty|
||put|Stores a byte in the buffer|
||putw|Stores a word in the buffer|
||get|Retrieves a byte from the buffer|
||getw|Retrieves a word from the buffer|
||inc_head|Internal routine that increments (& resets if it exceeds 8KB) the head pointer|
||inc_tail|Internal routine that increments (& resets if it exceeds 8KB) the tail pointer|

# All modules

| Modules | Function | Key Routines | Targets |
| --------| -------- | ------- | ------- |
|compression|||c64,c128,cx16,pet32,virtual|
|conv|||c64,c128,cx16,pet32,virtual|
|cx16logo|||c64,c128,cx16,pet32,virtual|
|diskio|||c64,c128,cx16,pet32,virtual|
|lineclip|||c64,c128,cx16,pet32,virtual|
|prog8_lib|||c64,c128,cx16,pet32,virtual|
|sorting|||c64,c128,cx16,pet32,virtual|
|strings|||c64,c128,cx16,pet32,virtual|
|syslib|||c64,c128,cx16,pet32,virtual|
|test_stack|||c64,c128,cx16,pet32,virtual|
|textio|||c64,c128,cx16,pet32,virtual|
|wavfile|||c64,c128,cx16,pet32,virtual|
|bcd|||c64,c128,cx16,pet32|
|coroutines|||c64,c128,cx16,pet32|
|floats|||c64,c128,cx16,pet32,virtual|
|petgfx|||c64,c128,pet32|
|emudbg|||cx16,virtual|
|graphics|||c64,cx16|
|monogfx|||cx16,virtual|
|adpcm|||cx16|
|bmx|||cx16|
|gfx_hires|||cx16|
|gfx_lores|||cx16|
|palette|||cx16|
|petsnd|||pet32|
|psg|||cx16|
|psg2|||cx16|
|serial|||cx16|
|sprites|||cx16|
|verafx|||cx16|


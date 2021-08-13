#include "frame_buffer.h"
#include "serial_port.h"
#include "memory_seg.h"


    int main(){

           char ptr2[] = "welcome YmeOS";


    serial_write(0x3F8, ptr2, 13);
    fb_write(ptr2, 13);
    segments_install_gdt();

    }

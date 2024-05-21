.option norvc

.section .data
welcome: .ascii "Welcome to PseudOS\n\0"
iamhart: .ascii "I am HART \0"
newline: .ascii "\n\0"

_scratchpad:
    .skip 1024

.section .text.init
.global _start

_start:
    csrr t0, mhartid
    bnez t0, _wait
    call _setup_uart
    la a0, welcome
    call _write_uart
    la a0, welcome
    call _write_uart
    la a0, iamhart
    call _write_uart

    # Grab the HART ID -> t0
    csrr t0, mhartid
    # Add 0x30 to the HART ID to get ASCII Number
    li t1, 0x30
    add t0, t1, t2

    # Loading our scratchpad ram to a0
    la a0, _scratchpad

    # Store '0' into scratchpad
    sb t0, 0(a0)
    call _writeln
    wfi

# a0 should contain the addr of a string to print
_writeln:
    call _write_uart
    la a0, newline
    call _write_uart
    ret

_setup_uart:
    # Disable Interupts on the UART
    li t1, 0x10000001
    sb x0, 0(t1)
    # Write out to the UART line control register at UART+3
    li t1, 0x10000003
    li t2, 0x03 # set the output to 8 bits
    ret

_write_uart:
    li t1, 0x10000000
    lb t2, 0(a0)
    beqz t2, _write_uart_end
    sb t2, 0(t1)
    li t2, 1
    add a0, t2, a0
    j _write_uart
    ret

_write_uart_end:
    ret

_wait:
    wfi

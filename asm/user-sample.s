    .org 0x0
    .global _start
    .section text
_start:
.text
    lu12i.w     $a0, -0x7fc00   # a0 = 0x80400000
    #st.w       $a0, $a0, 0x0
    lu12i.w     $t0, 0x300
    add.w       $a1, $a0,$t0    # a1 = 0x80700000
    #st.w       $a1, $a0, 0x0
    addi.w      $a2, $a1, -0x4  # a2 = 0x806ffffc

    addi.w      $t0, $a0, 0x0   # i = 0
    ld.w        $t1, $t0, 0x0   # 读数
    addi.w      $t2, $t1, 0x0   # max = t1
    addi.w      $t0, $t0, 0x4   # i++
loop1:
    ld.w        $t1, $t0, 0x0   # 读数
    bge         $t2, $t1, loop2  # max >= t1
    addi.w      $t2, $t1, 0x0   # max = t1
loop2:
    addi.w      $t0, $t0, 0x4   # i++
    bge         $a2, $t0, loop1  # end >= i, loop1
    st.w        $t2, $a1, 0x0

    jirl        $zero,$ra,0x0
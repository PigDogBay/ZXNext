; Assembler: SjASMPlus 
                DEVICE ZXSPECTRUMNEXT

CodeStart:      EQU 59990
                ORG CodeStart

                include "scroll.asm"
                SAVE3DOS "next.bin", CodeStart,200
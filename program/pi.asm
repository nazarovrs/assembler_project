format pe console 4.0

include 'win32a.inc'

  .start:
        finit
; pi = 3 + 4/(2*3*4) - 4/(4*5*6) + 4/(6*7*8) - 4/(8*9*10) + 4/(10*11*12) - (4/(12*13*14)

        xor     eax,eax
        fld     qword [_err]    ; ST0=0.001
        fld1
        fld         ST0             ; ST0=1        ST1=1        ST2=0.001
        fadd    ST1,ST0         ; ST0=1        ST1=2        ST0=0.001
        fld     ST1             ; ST0=2        ST1=1        ST2=2        ST3=0.001
        fadd    ST2,ST0         ; ST0=2        ST1=1        ST2=4        ST3=0.001
        fadd    ST1,ST0         ; ST0=2        ST1=3        ST2=4        ST3=0.001
        fld1                    ; ST0=1        ST1=2        ST2=3        ST3=4        ST4=0.001
; ST0 - 1
; ST1 - ������ �������� (��)
; ST2 - �������� ���������� �������� (���)
; ST3 - 4
; ST4 - ��������� ����������� (��)
  .next:
        fld     ST3
        fld     ST2             ; ST0=��       ST1=4        ST2(0)=1     ST3(1)=��    ST4(2)=���   ST5(3)=4     ST6(4)=��
        fdiv    ST1,ST0
        fadd    ST0,ST2
        fdiv    ST1,ST0
        fadd    ST0,ST2
        fdiv    ST1,ST0
        fxch    ST3             ; �������� �������� ������� �������� ��� ��������� �������� �� �������� ���������� �������� ��� ������� ��������
        fstp    ST0             ; ST0 - ���������� ������� 4 �� ��������� ������ ����
                                ;              ST1(0)=1     ST2(1)=��    ST3(2)=���   ST4(3)=4     ST5(4)=��
        fld     ST3             ; ST0 - ���    ST1 - ���������� ������� 4 �� ��������� ������ ����
                                ;                           ST2(0)=1     ST3(1)=��    ST4(2)=���   ST5(3)=4     ST6(4)=��
        inc     eax
        jz      .end            ; ������ �� ������� ������� ����������
        test    al,1            ; ������� ���� ������
        jz      @f
        faddp
        jmp     .eoo
  @@:
        fsubrp
  .eoo:
; ST0 - �������� ������� �������� (���)
                                ;              ST1(0)=1     ST2(1)=��    ST3(2)=���   ST4(3)=4     ST5(4)=��
; ������� �����������
        fld     ST0             ; ST0=���      ST1=���      ST2(0)=1     ST3(1)=��    ST4(2)=���   ST5(3)=4     ST6(4)=��
        fsub    ST0,ST4
        fdiv    ST0,ST4
        fabs                    ; ST0=�����������
                                ;              ST1=���      ST2(0)=1     ST3(1)=��    ST4(2)=���   ST5(3)=4     ST6(4)=��
        fcomp   ST6             ; ST0=���      ST1(0)=1     ST2(1)=��    ST3(2)=���   ST4(3)=4     ST5(4)=��
        fnstsw  word [_fsw]     ; ��������� ������� sw, � ��� ���������� ����� �� ����������� ���������.
        fxch    ST3
        fstp    ST0             ; ST0=1        ST1=��       ST2=���      ST3=4        ST4=��
        and     byte [_fsw+1],45h
        jnz     @f              ; ����������� ������ �������

        jmp     .next
  .end:
        fstp    ST0                             ; ������� ���� FPU �� ������ ��������
        fstp    ST0                             ; ������� ���� FPU �� ������ ��������
  @@:
        fstp    ST0                             ; ������� ���� FPU �� ������ ��������
        fstp    ST0                             ; ������� ���� FPU �� ������ ��������
        fstp    qword [_pi]
        cinvoke printf, _format, dword [_pi], dword [_pi+4]
        fstp    ST0                             ; ������� ���� FPU �� ������ ��������
        fstp    ST0                             ; ������� ���� FPU �� ������ ��������
  .exit:
        cinvoke getchar                 ; ���� ����� ����-������
        invoke ExitProcess,0
_fsw    dw      ?
_err    dq      0.001
_pi     dq      3.0
_message db     1024 dup (0)
_format db      'Pi=%.16f',13,10,0

data import

 library kernel32,'KERNEL32.DLL',\
         mscvrt,'msvcrt.DLL'

 import kernel32,\
         ExitProcess,'ExitProcess'

 import mscvrt,\
        printf,'printf',\
        getchar,'getchar'

end data

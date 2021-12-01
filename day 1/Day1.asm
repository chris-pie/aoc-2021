extern CreateFileA : PROC
extern GetLastError : PROC
extern ReadFile : PROC
extern WriteFile : PROC
extern GetStdHandle : PROC
extern ExitProcess : PROC
.data
handle dq 0
file_name db "Day1.txt"
bufin db 100 dup(0)
numread dq 0
sliding_window dq 3 dup(0)

.CODE
Day1 PROC
push rbx
push r12
push r13
push r14
push r15
push rsi
push rdi
pushfq


xor rbx, rbx

mov r14, 0
mov rcx, OFFSET file_name
mov rdx, 80000000h
mov r8, 1
mov r9, 0

push 0
push 128
push 3
sub rsp, 8*4
call CreateFileA
add rsp, 8*7

mov handle, rax
ReadFromFile:

mov rcx, handle
mov rdx, OFFSET bufin
mov r8, 100
mov r9, OFFSET numread
push 0
sub rsp, 8*4

call ReadFile
add rsp, 8*5
cmp numread, 0
je DoneReadingFile
sub r15, 100
cmp r12, 10
je ReadNumber

xor r15, r15
mov r12, 10
mov r13, OFFSET bufin
push 0

ReadNumber:
pop rax

ReadChar:
cmp r15, numread
jge ReadFromFileBis
mov cl, [r13+r15]
cmp cl, 0Dh
je DoneReadingNumber
add r15, 1
sub cl, '0'
mul r12
add rax, rcx
jmp ReadChar

ReadFromFileBis:
push rax
jmp ReadFromFile


DoneReadingFile:
pop rax

DoneReadingNumber:
add r15, 2

CalculateIncreases:

mov rsi, sliding_window + 2*8
cmp rax, rsi
jle NoInc
inc rbx
NoInc:
std
mov rsi, OFFSET sliding_window + 1*8
mov rdi, OFFSET sliding_window + 2*8
movsq
movsq
mov sliding_window, rax


push 0
cmp numread, 0
jne ReadNumber

sub rbx, 3
mov rax, rbx
mov r14, OFFSET bufin
add r14, 99
mov r13, r14
MakeAsciiCharacter:
xor rdx, rdx
mov rcx, 10
idiv rcx
add rdx, '0'
mov [r14], dl
dec r14
cmp rax, 0
jne MakeAsciiCharacter
mov r12, OFFSET bufin

MoveToBeginning:
inc r14
mov al, [r14]
mov [r12], al
inc r12
cmp r14, r13
jne MoveToBeginning
xor rax, rax
mov [r12], rax


mov rcx, -11
sub rsp, 8*4
call GetStdHandle
mov rcx, rax
mov r13, OFFSET bufin
sub r12, r13
mov rdx, r13
mov r8, r12
add r12, r13
add r12, 1
mov r9, r14
push 0
call WriteFile

add rsp, 8*6
mov rcx, 0
popfq
pop rdi
pop rsi
pop r15
pop r14
pop r13
pop r12
pop rbx
call ExitProcess

Day1 ENDP
END
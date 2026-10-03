	.file	"gameover.c"
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"B: saw game over, going home"
	.text
	.p2align 4
	.globl	keeper_b
	.type	keeper_b, @function
keeper_b:
.LFB36:
	.cfi_startproc
	endbr64
	movl	game_over(%rip), %eax
	testl	%eax, %eax
	jne	.L2
.L3:
	jmp	.L3
	.p2align 4,,10
	.p2align 3
.L2:
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	leaq	.LC0(%rip), %rdi
	call	puts@PLT
	xorl	%eax, %eax
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE36:
	.size	keeper_b, .-keeper_b
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC1:
	.string	"A: flipped the sign to game over"
	.section	.rodata.str1.1
.LC2:
	.string	"done"
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	main
	.type	main, @function
main:
.LFB37:
	.cfi_startproc
	endbr64
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	xorl	%ecx, %ecx
	leaq	keeper_b(%rip), %rdx
	xorl	%esi, %esi
	movq	%fs:40, %rax
	movq	%rax, 8(%rsp)
	xorl	%eax, %eax
	movq	%rsp, %rdi
	call	pthread_create@PLT
	movl	$100000, %edi
	call	usleep@PLT
	leaq	.LC1(%rip), %rdi
	movl	$1, game_over(%rip)
	call	puts@PLT
	movq	(%rsp), %rdi
	xorl	%esi, %esi
	call	pthread_join@PLT
	leaq	.LC2(%rip), %rdi
	call	puts@PLT
	movq	8(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L10
	xorl	%eax, %eax
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L10:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE37:
	.size	main, .-main
	.globl	game_over
	.bss
	.align 4
	.type	game_over, @object
	.size	game_over, 4
game_over:
	.zero	4
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:

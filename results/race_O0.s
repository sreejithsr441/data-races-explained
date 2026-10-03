	.file	"race.c"
	.text
	.globl	counter
	.bss
	.align 8
	.type	counter, @object
	.size	counter, 8
counter:
	.zero	8
	.globl	acounter
	.align 8
	.type	acounter, @object
	.size	acounter, 8
acounter:
	.zero	8
	.globl	m
	.align 32
	.type	m, @object
	.size	m, 40
m:
	.zero	40
	.globl	mode
	.align 4
	.type	mode, @object
	.size	mode, 4
mode:
	.zero	4
	.text
	.globl	work
	.type	work, @function
work:
.LFB0:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	$0, -8(%rbp)
	jmp	.L2
.L6:
	movl	mode(%rip), %eax
	testl	%eax, %eax
	jne	.L3
	movq	counter(%rip), %rax
	addq	$1, %rax
	movq	%rax, counter(%rip)
	jmp	.L4
.L3:
	movl	mode(%rip), %eax
	cmpl	$1, %eax
	jne	.L5
	leaq	m(%rip), %rax
	movq	%rax, %rdi
	call	pthread_mutex_lock@PLT
	movq	counter(%rip), %rax
	addq	$1, %rax
	movq	%rax, counter(%rip)
	leaq	m(%rip), %rax
	movq	%rax, %rdi
	call	pthread_mutex_unlock@PLT
	jmp	.L4
.L5:
	lock addq	$1, acounter(%rip)
.L4:
	addq	$1, -8(%rbp)
.L2:
	cmpq	$999999, -8(%rbp)
	jle	.L6
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	work, .-work
	.globl	now
	.type	now, @function
now:
.LFB1:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-32(%rbp), %rax
	movq	%rax, %rsi
	movl	$1, %edi
	call	clock_gettime@PLT
	movq	-32(%rbp), %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	movsd	.LC0(%rip), %xmm0
	mulsd	%xmm0, %xmm1
	movq	-24(%rbp), %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	movsd	.LC1(%rip), %xmm2
	divsd	%xmm2, %xmm0
	addsd	%xmm1, %xmm0
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L10
	call	__stack_chk_fail@PLT
.L10:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	now, .-now
	.section	.rodata
.LC2:
	.string	"%ld %.1fms\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB2:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movl	%edi, -52(%rbp)
	movq	%rsi, -64(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-64(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	movzbl	(%rax), %eax
	movsbl	%al, %eax
	subl	$48, %eax
	movl	%eax, mode(%rip)
	movl	$0, %eax
	call	now
	movq	%xmm0, %rax
	movq	%rax, -16(%rbp)
	leaq	-40(%rbp), %rax
	movl	$0, %ecx
	leaq	work(%rip), %rdx
	movl	$0, %esi
	movq	%rax, %rdi
	call	pthread_create@PLT
	leaq	-32(%rbp), %rax
	movl	$0, %ecx
	leaq	work(%rip), %rdx
	movl	$0, %esi
	movq	%rax, %rdi
	call	pthread_create@PLT
	movq	-40(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	pthread_join@PLT
	movq	-32(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	pthread_join@PLT
	movl	$0, %eax
	call	now
	movq	%xmm0, %rax
	movq	%rax, %xmm1
	subsd	-16(%rbp), %xmm1
	movq	%xmm1, %rdx
	movl	mode(%rip), %eax
	cmpl	$2, %eax
	jne	.L12
	movq	acounter(%rip), %rax
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	jmp	.L13
.L12:
	movq	counter(%rip), %rax
.L13:
	movq	%rdx, %xmm0
	movq	%rax, %rsi
	leaq	.LC2(%rip), %rax
	movq	%rax, %rdi
	movl	$1, %eax
	call	printf@PLT
	movl	$0, %eax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L15
	call	__stack_chk_fail@PLT
.L15:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	main, .-main
	.section	.rodata
	.align 8
.LC0:
	.long	0
	.long	1083129856
	.align 8
.LC1:
	.long	0
	.long	1093567616
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

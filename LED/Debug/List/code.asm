
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega328P
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega328P
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x08FF
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _counter=R3
	.DEF _counter_msb=R4
	.DEF _last_face=R6

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_DICE_FACES:
	.DB  0x8,0x1,0x9,0x5,0xD,0x7

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0


__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  0x03
	.DW  __REG_VARS*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x300

	.CSEG
;#include <io.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;#include <delay.h>
;
;// Define CPU frequency (8 MHz, as per build configuration)
;#define F_CPU 8000000UL
;
;// Pin definitions for LEDs, button, and buzzer (ATmega328P registers)
;#define GROUP_1_PIN 0  // PC0 (Arduino pin A0)
;#define GROUP_2_PIN 1  // PC1 (Arduino pin A1)
;#define GROUP_3_PIN 2  // PC2 (Arduino pin A2)
;#define LED_4_PIN   3  // PC3 (Arduino pin A3)
;#define RND_BTN     1  // PB1 (with external pull-up)
;// Alternative: Use PC6 (requires RSTDISBL fuse)
;// #define RND_BTN     6  // PC6 (with external pull-up, requires RSTDISBL fuse)
;#define BUZZER      0  // PB0 (Arduino pin 8)
;
;// Timing constants
;#define ROLL_STEPS    10    // Number of steps in the rolling phase
;#define BLINK_DELAY   500   // ms (time per step during rolling)
;#define DISPLAY_TIME  1500  // ms (time to display final face)
;#define DEBOUNCE_TIME 50    // ms
;
;// Dice faces (bit patterns for LEDs, adjusted for correct pin mapping)
;const unsigned char DICE_FACES[6] = {
;    (1 << LED_4_PIN),                    // Face 1: LED_4 (PC3)
;    (1 << GROUP_1_PIN),                  // Face 2: GROUP_1 (PC0)
;    (1 << GROUP_1_PIN) | (1 << LED_4_PIN), // Face 3: GROUP_1 (PC0) + LED_4 (PC3)
;    (1 << GROUP_1_PIN) | (1 << GROUP_3_PIN), // Face 4: GROUP_1 (PC0) + GROUP_3 (PC2)
;    (1 << GROUP_1_PIN) | (1 << GROUP_3_PIN) | (1 << LED_4_PIN), // Face 5: GROUP_1 (PC0) + GROUP_3 (PC2) + LED_4 (PC3)
;    (1 << GROUP_1_PIN) | (1 << GROUP_2_PIN) | (1 << GROUP_3_PIN) // Face 6: GROUP_1 (PC0) + GROUP_2 (PC1) + GROUP_3 (PC2 ...
;};
;
;unsigned int counter = 0; // Free-running counter for random seed
;unsigned char last_face = 0; // Track the last displayed face
;
;// Simple random number generator (using a seed)
;unsigned char simple_rand(unsigned int seed) {
; 0000 0025 unsigned char simple_rand(unsigned int seed) {

	.CSEG
_simple_rand:
; .FSTART _simple_rand
; 0000 0026     // Linear congruential generator with modified parameters for better variation
; 0000 0027     unsigned int next = (seed * 251 + 179) % 256; // Adjusted parameters for better randomness
; 0000 0028     return (next % 6); // Return 0-5 for 6 faces
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	seed -> Y+2
;	next -> R16,R17
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(251)
	CALL __MULB1W2U
	SUBI R30,LOW(-179)
	SBCI R31,HIGH(-179)
	ANDI R31,HIGH(0xFF)
	MOVW R16,R30
	MOVW R26,R16
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CALL __MODW21U
	RJMP _0x2000003
; 0000 0029 }
; .FEND
;
;// Generate a random face, ensuring it's different from the last face
;unsigned char get_random_face(unsigned int seed) {
; 0000 002C unsigned char get_random_face(unsigned int seed) {
_get_random_face:
; .FSTART _get_random_face
; 0000 002D     unsigned char face;
; 0000 002E     unsigned char attempts = 0;
; 0000 002F     do {
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	seed -> Y+2
;	face -> R17
;	attempts -> R16
	LDI  R16,0
_0x4:
; 0000 0030         face = simple_rand(seed + attempts) + 1; // Face 1-6
	MOV  R30,R16
	LDI  R31,0
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R26,R30
	ADC  R27,R31
	RCALL _simple_rand
	SUBI R30,-LOW(1)
	MOV  R17,R30
; 0000 0031         attempts++;
	SUBI R16,-1
; 0000 0032     } while (face == last_face && attempts < 10); // Avoid repeating the last face
	CP   R6,R17
	BRNE _0x6
	CPI  R16,10
	BRLO _0x7
_0x6:
	RJMP _0x5
_0x7:
	RJMP _0x4
_0x5:
; 0000 0033     return face;
	MOV  R30,R17
_0x2000003:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
; 0000 0034 }
; .FEND
;
;void init_io(void) {
; 0000 0036 void init_io(void) {
_init_io:
; .FSTART _init_io
; 0000 0037     // Set PC0, PC1, PC2, PC3 as outputs for LEDs
; 0000 0038     DDRC.0 = 1;
	SBI  0x7,0
; 0000 0039     DDRC.1 = 1;
	SBI  0x7,1
; 0000 003A     DDRC.2 = 1;
	SBI  0x7,2
; 0000 003B     DDRC.3 = 1;
	SBI  0x7,3
; 0000 003C 
; 0000 003D     // Set PB1 as input for button (external pull-up, so no internal pull-up needed)
; 0000 003E     DDRB.1 = 0;
	CBI  0x4,1
; 0000 003F     PORTB.1 = 0; // No internal pull-up (relying on external pull-up)
	CBI  0x5,1
; 0000 0040 
; 0000 0041     // Alternative: Use PC6 (requires RSTDISBL fuse)
; 0000 0042     // DDRC.6 = 0;
; 0000 0043     // PORTC.6 = 0;
; 0000 0044 
; 0000 0045     // Set PB0 as output for buzzer
; 0000 0046     DDRB.0 = 1;
	SBI  0x4,0
; 0000 0047 
; 0000 0048     // Initialize outputs to OFF
; 0000 0049     PORTC.0 = 0;
	CBI  0x8,0
; 0000 004A     PORTC.1 = 0;
	CBI  0x8,1
; 0000 004B     PORTC.2 = 0;
	CBI  0x8,2
; 0000 004C     PORTC.3 = 0;
	CBI  0x8,3
; 0000 004D     PORTB.0 = 0;
	RJMP _0x2000002
; 0000 004E }
; .FEND
;
;void clear_leds(void) {
; 0000 0050 void clear_leds(void) {
_clear_leds:
; .FSTART _clear_leds
; 0000 0051     PORTC.0 = 0;
	CBI  0x8,0
; 0000 0052     PORTC.1 = 0;
	CBI  0x8,1
; 0000 0053     PORTC.2 = 0;
	CBI  0x8,2
; 0000 0054     PORTC.3 = 0;
	CBI  0x8,3
; 0000 0055 }
	RET
; .FEND
;
;void set_face(unsigned char face_idx) {
; 0000 0057 void set_face(unsigned char face_idx) {
_set_face:
; .FSTART _set_face
; 0000 0058     unsigned char pattern = DICE_FACES[face_idx];
; 0000 0059     PORTC.0 = (pattern & (1 << GROUP_1_PIN)) ? 1 : 0;
	ST   -Y,R26
	ST   -Y,R17
;	face_idx -> Y+1
;	pattern -> R17
	LDD  R30,Y+1
	LDI  R31,0
	SUBI R30,LOW(-_DICE_FACES*2)
	SBCI R31,HIGH(-_DICE_FACES*2)
	LPM  R30,Z
	MOV  R17,R30
	SBRS R17,0
	RJMP _0x28
	LDI  R30,LOW(1)
	RJMP _0x29
_0x28:
	LDI  R30,LOW(0)
_0x29:
	CPI  R30,0
	BRNE _0x2B
	CBI  0x8,0
	RJMP _0x2C
_0x2B:
	SBI  0x8,0
_0x2C:
; 0000 005A     PORTC.1 = (pattern & (1 << GROUP_2_PIN)) ? 1 : 0;
	SBRS R17,1
	RJMP _0x2D
	LDI  R30,LOW(1)
	RJMP _0x2E
_0x2D:
	LDI  R30,LOW(0)
_0x2E:
	CPI  R30,0
	BRNE _0x30
	CBI  0x8,1
	RJMP _0x31
_0x30:
	SBI  0x8,1
_0x31:
; 0000 005B     PORTC.2 = (pattern & (1 << GROUP_3_PIN)) ? 1 : 0;
	SBRS R17,2
	RJMP _0x32
	LDI  R30,LOW(1)
	RJMP _0x33
_0x32:
	LDI  R30,LOW(0)
_0x33:
	CPI  R30,0
	BRNE _0x35
	CBI  0x8,2
	RJMP _0x36
_0x35:
	SBI  0x8,2
_0x36:
; 0000 005C     PORTC.3 = (pattern & (1 << LED_4_PIN)) ? 1 : 0;
	SBRS R17,3
	RJMP _0x37
	LDI  R30,LOW(1)
	RJMP _0x38
_0x37:
	LDI  R30,LOW(0)
_0x38:
	CPI  R30,0
	BRNE _0x3A
	CBI  0x8,3
	RJMP _0x3B
_0x3A:
	SBI  0x8,3
_0x3B:
; 0000 005D }
	LDD  R17,Y+0
	ADIW R28,2
	RET
; .FEND
;
;void funny_beep_pattern(void) {
; 0000 005F void funny_beep_pattern(void) {
_funny_beep_pattern:
; .FSTART _funny_beep_pattern
; 0000 0060     unsigned char i;
; 0000 0061     for (i = 0; i < 3; i++) {
	ST   -Y,R17
;	i -> R17
	LDI  R17,LOW(0)
_0x3D:
	CPI  R17,3
	BRSH _0x3E
; 0000 0062         PORTB.0 = 1; // Buzzer ON
	SBI  0x5,0
; 0000 0063         delay_ms(10 * (3 + i * 2)); // 30, 50, 70 ms
	LDI  R30,LOW(2)
	MUL  R30,R17
	MOVW R30,R0
	ADIW R30,3
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	MOVW R26,R30
	CALL _delay_ms
; 0000 0064         PORTB.0 = 0; // Buzzer OFF
	CBI  0x5,0
; 0000 0065         delay_ms(50); // 50ms pause
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay_ms
; 0000 0066     }
	SUBI R17,-1
	RJMP _0x3D
_0x3E:
; 0000 0067 }
	LD   R17,Y+
	RET
; .FEND
;
;void short_beep(void) {
; 0000 0069 void short_beep(void) {
_short_beep:
; .FSTART _short_beep
; 0000 006A     PORTB.0 = 1; // Buzzer ON
	SBI  0x5,0
; 0000 006B     delay_ms(100); // Short 100ms beep
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 006C     PORTB.0 = 0; // Buzzer OFF
_0x2000002:
	CBI  0x5,0
; 0000 006D }
	RET
; .FEND
;
;void rolling_effect(unsigned int seed) {
; 0000 006F void rolling_effect(unsigned int seed) {
_rolling_effect:
; .FSTART _rolling_effect
; 0000 0070     unsigned int steps = ROLL_STEPS;
; 0000 0071     unsigned int i;
; 0000 0072     unsigned int local_seed = seed;
; 0000 0073     for (i = 0; i < steps; i++) {
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR6
;	seed -> Y+6
;	steps -> R16,R17
;	i -> R18,R19
;	local_seed -> R20,R21
	__GETWRN 16,17,10
	__GETWRS 20,21,6
	__GETWRN 18,19,0
_0x48:
	__CPWRR 18,19,16,17
	BRSH _0x49
; 0000 0074         unsigned char temp_face = simple_rand(local_seed);
; 0000 0075         set_face(temp_face);
	SBIW R28,1
;	seed -> Y+7
;	temp_face -> Y+0
	MOVW R26,R20
	RCALL _simple_rand
	ST   Y,R30
	LD   R26,Y
	RCALL _set_face
; 0000 0076         delay_ms(BLINK_DELAY);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 0077         clear_leds();
	RCALL _clear_leds
; 0000 0078         local_seed = (local_seed * 251 + 179) % 256; // Update seed for next iteration
	__MULBNWRU 20,21,251
	SUBI R30,LOW(-179)
	SBCI R31,HIGH(-179)
	ANDI R31,HIGH(0xFF)
	MOVW R20,R30
; 0000 0079     }
	ADIW R28,1
	__ADDWRN 18,19,1
	RJMP _0x48
_0x49:
; 0000 007A }
	CALL __LOADLOCR6
	ADIW R28,8
	RET
; .FEND
;
;void show_face(unsigned char face) {
; 0000 007C void show_face(unsigned char face) {
_show_face:
; .FSTART _show_face
; 0000 007D     if (face < 1 || face > 6) return;
	ST   -Y,R26
;	face -> Y+0
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRLO _0x4B
	CPI  R26,LOW(0x7)
	BRLO _0x4A
_0x4B:
	RJMP _0x2000001
; 0000 007E     set_face(face - 1);
_0x4A:
	LD   R26,Y
	SUBI R26,LOW(1)
	RCALL _set_face
; 0000 007F     funny_beep_pattern(); // Play buzzer sound when final result is displayed
	RCALL _funny_beep_pattern
; 0000 0080     last_face = face; // Store the last displayed face
	LDD  R6,Y+0
; 0000 0081     // Keep displaying until the next button press (handled in main loop)
; 0000 0082 }
_0x2000001:
	ADIW R28,1
	RET
; .FEND
;
;void main(void) {
; 0000 0084 void main(void) {
_main:
; .FSTART _main
; 0000 0085     init_io();
	RCALL _init_io
; 0000 0086 
; 0000 0087     while (1) {
_0x4D:
; 0000 0088         // Declare variables at the start of the block
; 0000 0089         unsigned int roll_seed;
; 0000 008A         unsigned char final_face;
; 0000 008B         unsigned int seed_modifier = 0;
; 0000 008C 
; 0000 008D         // Increment counter continuously to provide a varying seed
; 0000 008E         counter++;
	SBIW R28,5
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
;	roll_seed -> Y+3
;	final_face -> Y+2
;	seed_modifier -> Y+0
	RCALL SUBOPT_0x0
; 0000 008F         if (counter > 65535) counter = 0;
	BRSH _0x50
	CLR  R3
	CLR  R4
; 0000 0090 
; 0000 0091         // Accumulate seed_modifier while waiting for button press
; 0000 0092         seed_modifier = (seed_modifier + counter) ^ (counter << 3); // Non-linear combination
_0x50:
	RCALL SUBOPT_0x1
	CALL __LSLW3
	EOR  R30,R26
	EOR  R31,R27
	ST   Y,R30
	STD  Y+1,R31
; 0000 0093 
; 0000 0094         // Wait for button press (PB1 goes LOW due to pull-up)
; 0000 0095         // Alternative: Use PINC.6 if using PC6 with RSTDISBL fuse
; 0000 0096         if (!PINB.1) {
	SBIC 0x3,1
	RJMP _0x51
; 0000 0097             // Debounce: Wait and confirm button state
; 0000 0098             delay_ms(DEBOUNCE_TIME);
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay_ms
; 0000 0099             if (!PINB.1) {
	SBIC 0x3,1
	RJMP _0x52
; 0000 009A                 // Short beep to confirm button press
; 0000 009B                 short_beep();
	RCALL _short_beep
; 0000 009C 
; 0000 009D                 // Accumulate counter increments during button press to vary the seed
; 0000 009E                 while (!PINB.1) {
_0x53:
	SBIC 0x3,1
	RJMP _0x55
; 0000 009F                     counter++;
	RCALL SUBOPT_0x0
; 0000 00A0                     if (counter > 65535) counter = 0;
	BRSH _0x56
	CLR  R3
	CLR  R4
; 0000 00A1                     seed_modifier = (seed_modifier + counter) ^ (counter >> 2); // Further vary the seed
_0x56:
	RCALL SUBOPT_0x1
	CALL __LSRW2
	EOR  R30,R26
	EOR  R31,R27
	ST   Y,R30
	STD  Y+1,R31
; 0000 00A2                     delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
; 0000 00A3                 }
	RJMP _0x53
_0x55:
; 0000 00A4                 roll_seed = (counter ^ seed_modifier) + (seed_modifier >> 1); // Combine for better variation
	LD   R26,Y
	LDD  R27,Y+1
	EOR  R26,R3
	EOR  R27,R4
	LD   R30,Y
	LDD  R31,Y+1
	LSR  R31
	ROR  R30
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+3,R30
	STD  Y+3+1,R31
; 0000 00A5                 rolling_effect(roll_seed);
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	RCALL _rolling_effect
; 0000 00A6                 final_face = get_random_face(roll_seed + (seed_modifier << 2));
	LD   R30,Y
	LDD  R31,Y+1
	CALL __LSLW2
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	ADD  R26,R30
	ADC  R27,R31
	RCALL _get_random_face
	STD  Y+2,R30
; 0000 00A7                 show_face(final_face);
	LDD  R26,Y+2
	RCALL _show_face
; 0000 00A8             }
; 0000 00A9         }
_0x52:
; 0000 00AA     }
_0x51:
	ADIW R28,5
	RJMP _0x4D
; 0000 00AB }
_0x57:
	RJMP _0x57
; .FEND

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 3,4,30,31
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R3
	CPC  R31,R4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	__GETW1R 3,4
	LD   R26,Y
	LDD  R27,Y+1
	ADD  R26,R30
	ADC  R27,R31
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__LSRW2:
	LSR  R31
	ROR  R30
	LSR  R31
	ROR  R30
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULB1W2U:
	MOV  R22,R30
	MUL  R22,R26
	MOVW R30,R0
	MUL  R22,R27
	ADD  R31,R0
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:

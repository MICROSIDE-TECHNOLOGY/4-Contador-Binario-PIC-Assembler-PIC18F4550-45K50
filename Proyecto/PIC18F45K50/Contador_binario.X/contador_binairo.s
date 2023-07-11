/*******************************************************************************
Company:
Microside Technology Inc.
File Name:
contador_binario.s
Product Revision  :  1
Device            :  X-TRAINER
Driver Version    :  1.0
*******************************************************************************/

/*******************************************************************************
Para usar el codigo con bootloader, configurar como lo indica MICROSIDE:
1) File->Project Properties->Conf:->pic-as Global Options->pic-as Linker
2) En el campo "Additional Options" agregar:
     -mrom=2000-7F00
*******************************************************************************/
    
;Indica que el codigo solo es compatible con el uC PIC18F45K50
PROCESSOR 18F45K50
    
; PIC18F45K50 Bits de configuracion

; CONFIG1L
  CONFIG  PLLSEL = PLL3X        ; PLL Selection (3x clock multiplier)
  CONFIG  CFGPLLEN = ON         ; PLL Enable Configuration bit (PLL Enabled)
  CONFIG  CPUDIV = NOCLKDIV     ; CPU System Clock Postscaler (CPU uses system clock (no divide))
  CONFIG  LS48MHZ = SYS48X8     ; Low Speed USB mode with 48 MHz system clock (System clock at 48 MHz, USB clock divider is set to 8)

; CONFIG1H
  CONFIG  FOSC = INTOSCIO       ; Oscillator Selection (Internal oscillator)
  CONFIG  PCLKEN = ON           ; Primary Oscillator Shutdown (Primary oscillator enabled)
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor (Fail-Safe Clock Monitor disabled)
  CONFIG  IESO = OFF            ; Internal/External Oscillator Switchover (Oscillator Switchover mode disabled)

; CONFIG2L
  CONFIG  nPWRTEN = ON          ; Power-up Timer Enable (Power up timer enabled)
  CONFIG  BOREN = SBORDIS       ; Brown-out Reset Enable (BOR enabled in hardware (SBOREN is ignored))
  CONFIG  BORV = 250            ; Brown-out Reset Voltage (BOR set to 2.5V nominal)
  CONFIG  nLPBOR = ON           ; Low-Power Brown-out Reset (Low-Power Brown-out Reset enabled)

; CONFIG2H
  CONFIG  WDTEN = OFF           ; Watchdog Timer Enable bits (WDT disabled in hardware (SWDTEN ignored))
  CONFIG  WDTPS = 32768         ; Watchdog Timer Postscaler (1:32768)

; CONFIG3H
  CONFIG  CCP2MX = RC1          ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
  CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<5:0> pins are configured as digital I/O on Reset)
  CONFIG  T3CMX = RC0           ; Timer3 Clock Input MUX bit (T3CKI function is on RC0)
  CONFIG  SDOMX = RB3           ; SDO Output MUX bit (SDO function is on RB3)
  CONFIG  MCLRE = ON            ; Master Clear Reset Pin Enable (MCLR pin enabled; RE3 input disabled)

; CONFIG4L
  CONFIG  STVREN = ON           ; Stack Full/Underflow Reset (Stack full/underflow will cause Reset)
  CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
  CONFIG  ICPRT = OFF           ; Dedicated In-Circuit Debug/Programming Port Enable (ICPORT disabled)
  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled)

; CONFIG5L
  CONFIG  CP0 = OFF             ; Block 0 Code Protect (Block 0 is not code-protected)
  CONFIG  CP1 = OFF             ; Block 1 Code Protect (Block 1 is not code-protected)
  CONFIG  CP2 = OFF             ; Block 2 Code Protect (Block 2 is not code-protected)
  CONFIG  CP3 = OFF             ; Block 3 Code Protect (Block 3 is not code-protected)

; CONFIG5H
  CONFIG  CPB = OFF             ; Boot Block Code Protect (Boot block is not code-protected)
  CONFIG  CPD = OFF             ; Data EEPROM Code Protect (Data EEPROM is not code-protected)

; CONFIG6L
  CONFIG  WRT0 = OFF            ; Block 0 Write Protect (Block 0 (0800-1FFFh) is not write-protected)
  CONFIG  WRT1 = OFF            ; Block 1 Write Protect (Block 1 (2000-3FFFh) is not write-protected)
  CONFIG  WRT2 = OFF            ; Block 2 Write Protect (Block 2 (04000-5FFFh) is not write-protected)
  CONFIG  WRT3 = OFF            ; Block 3 Write Protect (Block 3 (06000-7FFFh) is not write-protected)

; CONFIG6H
  CONFIG  WRTC = OFF            ; Configuration Registers Write Protect (Configuration registers (300000-3000FFh) are not write-protected)
  CONFIG  WRTB = OFF            ; Boot Block Write Protect (Boot block (0000-7FFh) is not write-protected)
  CONFIG  WRTD = OFF            ; Data EEPROM Write Protect (Data EEPROM is not write-protected)

; CONFIG7L
  CONFIG  EBTR0 = OFF           ; Block 0 Table Read Protect (Block 0 is not protected from table reads executed in other blocks)
  CONFIG  EBTR1 = OFF           ; Block 1 Table Read Protect (Block 1 is not protected from table reads executed in other blocks)
  CONFIG  EBTR2 = OFF           ; Block 2 Table Read Protect (Block 2 is not protected from table reads executed in other blocks)
  CONFIG  EBTR3 = OFF           ; Block 3 Table Read Protect (Block 3 is not protected from table reads executed in other blocks)

; CONFIG7H
  CONFIG  EBTRB = OFF           ; Boot Block Table Read Protect (Boot block is not protected from table reads executed in other blocks)

;INCLUYE DIRECTIVAS DEL ENSAMBLADOR PIC-AS
#include <xc.inc>

;SECCION DE PROGRAMA EN EL BANCO ACCESS, ALMACENA VARIABLES
PSECT  udata_acs
REG1:	    ;ETIQUETA PARA EL OBJETO EN RAM
    DS	1   ;RESERVA 1 BYTE DE DATOS
REG2:
    DS	1
REG3:
    DS	1
CONT:
    DS	1
    
;VECTORES DE INTERRUPCION REMAPEADOS
PSECT interruptRemap, class=CODE, reloc=2, abs 
org 0x2008h
RETFIE
org 0x2018h
RETFIE

;SECCION DE PROGRAMA PARA LA FUNCION DELAY_100MS
PSECT delayGen, class=CODE, reloc=2
DELAY_100MS:
    MOVLW   0x11    ;MUEVE LITERAL A WREG
    MOVWF   REG1,a  ;MUEVE WREG A REG1, ARGUMENTO "a" INDICA BANCO ACCESS
LOOP1:
    MOVLW   0xCC
    MOVWF   REG2,a
LOOP2:
    MOVLW   0x72
    MOVWF   REG3,a
LOOP3:
    DECFSZ  REG3,a  ;DECREMENTA REG3, OMITE "GOTO LOOP3" SI REG3 = 0
    GOTO    LOOP3
    DECFSZ  REG2,a
    GOTO    LOOP2
    DECFSZ  REG1,a
    GOTO    LOOP1
    RETURN

;PUNTO DE ENTRADA DEL PROGRAMA EN REINICIO, POSICION ABSOLUTA 0x2000h
PSECT resetVec,class=CODE,reloc=2, abs
org 0x2000h
resetVec:
    goto main

;SECCION DE PROGRAMA PRINCIPAL
PSECT code
main:
    MOVLW   0x70
    MOVWF   OSCCON  ;CONFIGURA OSCILADOR
    BANKSEL(ANSELA) ;SELECCIONA EL BANCO PARA ANSELA
    CLRF    ANSELA  ;PUERTO A SE CONFIGURA COMO DIGITAL
    SETF    TRISA   ;PUERTO A SE CONFIGURA COMO ENTRADAS
    CLRF    TRISB   ;PUERTO B SE CONFIGURA COMO SALIDAS
    CLRF    LATB    ;LIMPIA EL PUERTO B
    BANKSEL(CONT)
    CLRF    CONT    ;LIMPIA CONT
loop:
    BTFSS   PORTA,2 ;OMITE SIGUIENTE INSTRUCCION SI RA2 ES 1
    goto    loop
increase:
    BANKSEL(CONT)
    INCF    CONT    ;INCREMENTA CONT
    MOVFF   CONT,LATB;DESPLIEGA EL VALOR A PORTB
debounce:
    CALL    DELAY_100MS
    BTFSC   PORTA,2 ;OMITE SIGUIENTE INSTRUCCION SI RA2 ES 0
    goto    debounce
    goto loop
END resetVec
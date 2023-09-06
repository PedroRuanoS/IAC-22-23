; *********************************************************************
;
;
;
;
;
; *********************************************************************

; **********************************************************************
; * Constantes
; **********************************************************************

COMANDOS			EQU	6000H			; endereço de base dos comandos do MediaCenter

DEFINE_LINHA    	EQU COMANDOS + 0AH		; endereço do comando para definir a linha
DEFINE_COLUNA   	EQU COMANDOS + 0CH		; endereço do comando para definir a coluna
DEFINE_PIXEL    	EQU COMANDOS + 12H		; endereço do comando para escrever um pixel
APAGA_AVISO     	EQU COMANDOS + 40H		; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRÃ	 	EQU COMANDOS + 02H		; endereço do comando para apagar todos os pixels já desenhados
SELECIONA_CENARIO_FUNDO  EQU COMANDOS + 42H		; endereço do comando para selecionar uma imagem de fundo
APAGA_CENARIO_FUNDO EQU COMANDOS + 44H
SELECIONA_ECRA EQU COMANDOS + 04H
REPRODUCAO_MEDIA EQU COMANDOS + 5AH
LOOP_REPRODUCAO_MEDIA EQU COMANDOS + 5CH
CORTA_VOLUME_SOM EQU COMANDOS + 4CH
CORTA_VOLUME EQU COMANDOS + 50H
RETOMA_VOLUME EQU COMANDOS + 52H
PAUSA_VOLUME_SOM EQU COMANDOS + 5EH
ECRA_NAVE EQU 0
ECRA_ASTEROIDE EQU 1



INTRO_BACKGROUND EQU 1
INTRO_OST EQU 0
IN_GAME_BACKGROUND EQU 1
IN_GAME_OST EQU 2
ASTEROID_SOUND_EFFECT EQU 3

MAXIMO_MOVIMENTOS EQU 12
TRUE EQU 1
FALSE EQU 0

LARGURA_NAVE EQU 15
ALTURA_NAVE EQU 8
LINHA_REF_NAVE EQU 31
COLUNA_REF_NAVE EQU 25

LARGURA_ASTEROIDE EQU 7
ALTURA_ASTEROIDE EQU 7
LINHA_REF_ASTEROIDE_ESQ  EQU 2
COLUNA_REF_ASTEROIDE_ESQ EQU -4

LARGURA_SONDA EQU 1
ALTURA_SONDA EQU 1
LINHA_REF_SONDA_FR EQU 24
COLUNA_REF_SONDA_FR EQU 31

RED EQU 0DF00H			; cor do pixel: vermelho em ARGB (opaco e vermelho no máximo, verde e azul a 0)
DARK_RED EQU 0DF20H
BROWN EQU 0D811H
YELLOW EQU 0DFF0H
LIGHT_LIGHT_GRAY EQU 0D0CFH
WHITE EQU 0DFFFH
GREEN EQU 0D0F0H
LIGHT_GRAY EQU 0DAAEH
GRAY EQU 0D558H
PURPLE EQU 0D0FFH
COR_APAGADO		EQU 0000H		; cor para apagar um pixel: todas as componentes a 0

DISPLAYS   EQU 0A000H  ; endere�o dos displays de 7 segmentos (perif�rico POUT-1)
TEC_LIN    EQU 0C000H  ; endere�o das linhas do teclado (perif�rico POUT-2)
TEC_COL    EQU 0E000H  ; endere�o das colunas do teclado (perif�rico PIN)
MASCARA    EQU 0FH     ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
ULTIMA_LINHA_TECLADO EQU 8
PRIMEIRA_LINHA_TECLADO EQU 1

DISPARO_FRONTAL EQU 1
ASTEROIDE_ESQ_CAIR EQU 0CH
START_GAME EQU 0AH


; *********************************************************************************
; * Código
; *********************************************************************************

    PLACE 0400H
inicio_pilha:       ;inicialização da pilha no endereço 16
    STACK 200H      ;reserva-se lugar para 16 words(32 bytes)
    SP_init:        ;


    PLACE 1000H
DEF_NAVE:
    WORD LARGURA_NAVE, ALTURA_NAVE      ; Medidas da nave
    WORD GRAY, 0, 0, 0, 0, 0, GRAY, 0, GRAY, 0, 0, 0, 0, 0, GRAY
    WORD GRAY, GRAY, GRAY, 0, 0, GRAY, GRAY, 0, GRAY, GRAY, 0, 0, GRAY, GRAY, GRAY
    WORD GRAY, LIGHT_GRAY, LIGHT_GRAY, GRAY, GRAY, LIGHT_GRAY, GRAY, GRAY, GRAY, LIGHT_GRAY, GRAY, GRAY, LIGHT_GRAY, LIGHT_GRAY, GRAY
    WORD 0, GRAY, LIGHT_GRAY, LIGHT_GRAY, LIGHT_GRAY, LIGHT_GRAY, LIGHT_GRAY, GRAY, LIGHT_GRAY, LIGHT_GRAY, LIGHT_GRAY, LIGHT_GRAY, LIGHT_GRAY, GRAY, 0
    WORD 0, 0, GRAY, GRAY, LIGHT_GRAY, LIGHT_GRAY, RED, YELLOW, GREEN, LIGHT_GRAY, LIGHT_GRAY, GRAY, GRAY, 0, 0
    WORD 0, GRAY, 0, 0, GRAY, YELLOW, GREEN, PURPLE, RED, PURPLE, GRAY, 0, 0, GRAY, 0
    WORD 0, 0, 0, 0, 0, GRAY, GRAY, GRAY, GRAY, GRAY, 0, 0 ,0 ,0 ,0
    WORD 0, 0, 0, 0, 0, 0, 0, LIGHT_LIGHT_GRAY, 0, 0, 0, 0, 0, 0, 0
DEF_MINERAVEL:
    WORD LARGURA_ASTEROIDE, ALTURA_ASTEROIDE
    WORD 0, 0, DARK_RED, GREEN, DARK_RED, 0, 0
    WORD 0, BROWN, DARK_RED, DARK_RED, DARK_RED, DARK_RED, 0
    WORD BROWN, BROWN, GREEN, GREEN, GREEN, DARK_RED, DARK_RED
    WORD BROWN, BROWN, GREEN, GREEN, GREEN, DARK_RED, DARK_RED
    WORD BROWN, BROWN, GREEN, GREEN, GREEN, DARK_RED, DARK_RED
    WORD 0, BROWN, BROWN, BROWN, DARK_RED, BROWN, 0
    WORD 0, 0, GREEN, BROWN, BROWN, 0, 0
DEF_ASTEROIDE:
    WORD LARGURA_ASTEROIDE, ALTURA_ASTEROIDE
    WORD 0, 0, DARK_RED, DARK_RED, DARK_RED, 0, 0
    WORD 0, BROWN, DARK_RED, DARK_RED, DARK_RED, DARK_RED, 0
    WORD BROWN, BROWN, BROWN, DARK_RED, DARK_RED, DARK_RED, DARK_RED
    WORD DARK_RED, BROWN, BROWN, BROWN, BROWN, DARK_RED, DARK_RED
    WORD BROWN, BROWN, DARK_RED, BROWN, BROWN, BROWN, DARK_RED
    WORD 0, BROWN, BROWN, BROWN, DARK_RED, BROWN, 0
    WORD 0, 0, DARK_RED, BROWN, BROWN, 0, 0
DEF_SONDA:
    WORD LARGURA_SONDA, ALTURA_SONDA
    WORD LIGHT_GRAY
REFERENCIA_SONDA:
    WORD LINHA_REF_SONDA_FR, COLUNA_REF_SONDA_FR, 0
REFERENCIA_ASTEROIDE_ESQ:
    WORD LINHA_REF_ASTEROIDE_ESQ, COLUNA_REF_ASTEROIDE_ESQ

    PLACE 0

inicializar_pilha: 
    MOV SP, SP_init ;registamos o SP com o começo da pilha

inicializa_ecrã:
    CALL reinicia_jogo
    MOV [RETOMA_VOLUME], R1
    MOV [APAGA_AVISO], R1
    MOV [APAGA_ECRÃ], R1
    MOV R1, INTRO_BACKGROUND
    MOV [SELECIONA_CENARIO_FUNDO], R1
    MOV R1, INTRO_OST
    MOV [LOOP_REPRODUCAO_MEDIA], R1

inicializar_comandos_teclado:		
; inicializa��es
    MOV  R2, TEC_LIN   ; endereço do periférico das linhas
    MOV  R3, TEC_COL   ; endereço do periférico das colunas
    MOV  R4, DISPLAYS  ; endereço do periférico dos displays
    MOV  R5, MASCARA   ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado

; corpo principal do programa
main:
    ; Utilizacao dos registos
    ; R1 - Guardar a primeira_linha do teclado
    ; R6 - Guardar a ultima linha do teclado
    MOV  R1, 0         ;
    MOV  R6, ULTIMA_LINHA_TECLADO   ;guardamos a ultima linha
    MOV R1, PRIMEIRA_LINHA_TECLADO  ;guardamos a primeira linha

    espera_tecla:          ; neste ciclo espera-se ate uma tecla ser premida
        MOVB [R2], R1      ; escrever no periferico de saida (linhas)
        MOVB R0, [R3]      ; ler do periferico de entrada (colunas)
        AND  R0, R5        ; elimina bits para alem dos bits 0-3
        CMP  R0, 0         ; ha tecla premida?
        JZ proxima_linha_teclado    ; se não houve tecla premida, passemos para a proxima linha a varrer
        CALL calcula_tecla  ; se houver tecla premida, calculamos o valor da tecla
        CALL realiza_acao
        MOV [R4], R7
        JMP ha_tecla    ; salta-se para funcao que verifica se a tecla ainda está premida

    proxima_linha_teclado:
        CMP R1, R6  ;comparamos a linha atual com a ultima linha do teclado
        JZ reset_linha_teclado  ; se a linha atual for a ultima voltamos a primeira linha
        SHL R1, 1   ; senão incrementamos a linha para a proxima
        JMP espera_tecla    ;   funcao para varrer a linha

        reset_linha_teclado:
            SHR R1, 3   ; descolamos o bit representante da 4 linha para a 1 linha
            JMP espera_tecla    ; funcao para varrer a linha

    ha_tecla:
        MOVB [R2], R1      ; escrever no periférico de saída (linhas)
        MOVB R0, [R3]      ; ler do periférico de entrada (colunas)
        AND  R0, R5        ; elimina bits para além dos bits 0-3
        CMP  R0, 0         ; há tecla premida?
        JNZ  ha_tecla      ; se ainda houver uma tecla premida, espera até não haver
        JMP  main         ; repete ciclo


fim:
    JMP fim


calcula_tecla:              ; neste ciclo espera-se at� NENHUMA tecla estar premida
    PUSH R1
    PUSH R2
    PUSH R6

    converte_linha_coluna:
        MOV R6, 4      ; usado para multiplicar o valor da linha por 4 
        MOV R7, 0      ; usado para calcular o valor da tecla (inicializado a 0)
        converte_linha:
            ADD R7, 1       ; incrementamos a linha em 1
            SHR R1, 1       ; deslocamos o bit da linha para a esquerda
            JNZ converte_linha  ; se não for 0 repetimos o ciclo

        SUB R7, 1       ; convertemos a linha para um valor de 0 - 3             
        MUL R7, R6      ; multiplica-se o valor da coluna por 4
        converte_coluna:
            ADD R7, 1   ; incrementos a coluna em 1
            SHR R0, 1   ; deslocamos o bit da coluna para a esquerda
            JNZ converte_coluna ; se nao for 0 repetimos o ciclo
        SUB R7, 1   ; convertemos a coluna para um valor de 0 - 3

    POP R6
    POP R2
    POP R1
    RET

realiza_acao:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4

    MOV R0, DISPARO_FRONTAL
    MOV R1, ASTEROIDE_ESQ_CAIR
    MOV R2, START_GAME

    entry_game:
        CMP R7, R2
        JNZ disparo_frontal
        CALL init_game
        JMP end_of_action
    disparo_frontal:
        CMP R7, R0
        JNZ asteroide_esq
        CALL sonda_frontal
        JMP end_of_action
    asteroide_esq:
        CMP R7, R1
        JNZ end_of_action
        CALL move_asteroide_esq
        JMP end_of_action

    end_of_action:
        POP R4
        POP R3
        POP R2
        POP R1
        POP R0
        RET

init_game:
    PUSH R0

    MOV R0, INTRO_OST
    MOV [CORTA_VOLUME_SOM], R0
    MOV R0, IN_GAME_OST
    MOV [LOOP_REPRODUCAO_MEDIA], R0

    MOV [APAGA_CENARIO_FUNDO], R0   ; Apaga o cenario de fundo o valor de R0 não e importante
    MOV R0, IN_GAME_BACKGROUND
    MOV [LOOP_REPRODUCAO_MEDIA], R0

    CALL desenha_nave
    CALL desenha_asteroide
    POP R0
    RET

reinicia_jogo:
    CALL reinicia_asteroide_esq
    CALL reinicia_sonda
    RET

reinicia_asteroide_esq:
    PUSH R0
    PUSH R1

    MOV R0, REFERENCIA_ASTEROIDE_ESQ
    MOV R1, LINHA_REF_ASTEROIDE_ESQ
    MOV [R0], R1
    ADD R0, 2
    MOV R1, COLUNA_REF_ASTEROIDE_ESQ
    MOV [R0], R1

    POP R1
    POP R0
    RET

reinicia_sonda:
    PUSH R0
    PUSH R1

    MOV R0, REFERENCIA_SONDA
    MOV R1, LINHA_REF_SONDA_FR
    MOV [R0], R1
    ADD R0, 2
    MOV R1, COLUNA_REF_SONDA_FR
    MOV [R0], R1

    POP R1
    POP R0
    RET
    
obtem_pos_sonda_frontal:
    MOV R0, REFERENCIA_SONDA
    MOV R1, [R0]
    ADD R0, 2
    MOV R2, [R0]
    SUB R0, 2 
    RET

obtem_medidas_sonda:
    MOV R3, DEF_SONDA
    MOV R4, [R3]
    ADD R3, 2
    MOV R5, [R3]
    RET

inc_sonda_frontal:
    PUSH R3
    PUSH R4

    MOV R3, MAXIMO_MOVIMENTOS
    ADD R0, 4
    MOV R4, [R0]
    CMP R4, R3
    JZ reset_sonda_frontal

    incrementa_vertical:
        ADD R4, 1
        MOV [R0], R4
        SUB R0, 4
        MOV R3, [R0]
        SUB R3, 1
        MOV [R0], R3
        MOV R1, R3
        JMP fim_incremento


    reset_sonda_frontal:
        MOV R4 , 0
        MOV [R0], R4
        SUB R0, 4
        MOV R3, LINHA_REF_SONDA_FR
        MOV [R0], R3
        MOV R1, R3
        JMP fim_incremento

    fim_incremento:
        POP R4
        POP R3
        RET

sonda_frontal:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5

    CALL obtem_pos_sonda_frontal
    CALL obtem_medidas_sonda


    CALL apaga_objeto
    CALL inc_sonda_frontal
    CALL desenha_objeto
    
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    POP R0
    RET

obtem_pos_asteroide_esq:
    MOV R0, REFERENCIA_ASTEROIDE_ESQ
    MOV R1, [R0]
    ADD R0, 2
    MOV R2, [R0]
    SUB R0, 2 
    RET

obtem_medidas_asteroide:
    MOV R3, DEF_ASTEROIDE    ;obter o endereço com as informações da nave
    MOV R4, [R3]        ;guardar a largura da nave
    ADD R3, 2           ;obter o endereço com a altura da nave
    MOV R5, [R3]        ;guardar a altura da nave
    RET

obtem_medidas_mineravel:
    MOV R3, DEF_MINERAVEL    ;obter o endereço com as informações do asteroide mineravel
    MOV R4, [R3]        ;guardar a largura da nave
    ADD R3, 2           ;obter o endereço com a altura da nave
    MOV R5, [R3]        ;guardar a altura da nave
    RET

decrementa_vertical:
    PUSH R3
    MOV R3, [R0]
    ADD R3, 1
    MOV [R0], R3
    MOV R1, R3
    POP R3
    RET

incrementa_horizontal:
    PUSH R3
    ADD R0, 2
    MOV R3, [R0]
    ADD R3, 1
    MOV [R0], R3
    MOV R2, R3
    SUB R0, 2
    POP R3
    RET

inc_asteroide_esq:
    CALL decrementa_vertical
    CALL incrementa_horizontal
    RET

move_asteroide_esq:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6

    MOV R6, ECRA_ASTEROIDE
    MOV [SELECIONA_ECRA], R6

    CALL obtem_pos_asteroide_esq
    CALL obtem_medidas_asteroide

    CALL apaga_objeto

    CALL inc_asteroide_esq
    CALL desenha_objeto
    
    MOV R6, ASTEROID_SOUND_EFFECT
    MOV [REPRODUCAO_MEDIA], R6

    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    POP R0
    RET

obtem_posicao_nave:
    MOV R1, LINHA_REF_NAVE
    MOV R2, COLUNA_REF_NAVE
    RET

obtem_medidas_nave:
    MOV R3, DEF_NAVE    ; obter o endereço com as informações da nave
    MOV R4, [R3]        ; guardar a largura da nave
    ADD R3, 2           ; obter o endereço com a altura da nave
    MOV R5, [R3]        ; guardar a altura da nave
    RET

desenha_nave:
    PUSH R0
    PUSH R1 
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5 

    MOV R0, ECRA_NAVE
    MOV [SELECIONA_ECRA], R0

    CALL obtem_posicao_nave
    CALL obtem_medidas_nave
    CALL desenha_objeto

    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    POP R0
    RET

apaga_nave:
    PUSH R0
    PUSH R1 
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5 

    MOV R0, ECRA_NAVE
    MOV [SELECIONA_ECRA], R0

    CALL obtem_posicao_nave
    CALL obtem_medidas_nave
    CALL apaga_objeto

    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    POP R0
    RET

desenha_asteroide:
    PUSH R0
    PUSH R1 
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5 

    MOV R0, ECRA_ASTEROIDE
    MOV [SELECIONA_ECRA], R0

    CALL obtem_pos_asteroide_esq
    CALL obtem_medidas_asteroide
    CALL desenha_objeto

    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    POP R0
    RET

inicializa_iterador:
    MOV R8, R2      ;obtém-se a coluna de referencia
    CALL proxima_linha
    RET

proxima_linha:
    MOV [DEFINE_LINHA], R1      ;seleciona a linha
    MOV R7, R4                  ;da reset no numero de colunas a desenhar
    MOV R2, R8     ;da-se reset na coluna a desenhar
    SUB R1, 1               ;reduz o número da linha a desenhar
    SUB R5, 1               ;reduz o numero de linhas a desenhar
    RET

proxima_cor:
    ADD R3, 2           ; endereço da cor do 1º pixel
    MOV R6, [R3]
    RET
    
desenha_objeto:
    ; Utilização dos registos
    ; R2 - Coluna de Referencia
    ; R1 - linha de Referencia
    ; R3 - Obter as informacoes acerca do objeto
    ; R4 - Largura do objeto
    ; R5 - Altura do Objeto
    ; R6 - Cor do pixel 
    PUSH R6
    PUSH R7
    PUSH R8

    CALL inicializa_iterador
    desenha_linha:
        CALL proxima_cor
        MOV [DEFINE_COLUNA], R2     ;seleciona a coluna
        MOV [DEFINE_PIXEL], R6      ;altera a cor do pixel, nas linhas e colunas seleciondas
        ADD R2, 1           ;obtém proxima coluna
        SUB R7, 1           ;reduz o número de colunas a desenhar
        JNZ desenha_linha   ;se não se tiver desenhado as colunas todas passa-se para a proxima coluna
        CALL proxima_linha
        CMP R5, -1              ;verifica se já se desenhou todas as linhas
        JNZ desenha_linha

    POP R8
    POP R7 
    POP R6
    RET


apaga_objeto:
    ; Utilização dos registos
    ; R2 - Coluna de Referencia
    ; R1 - linha de Referencia
    ; R3 - Obter as informacoes acerca do objeto
    ; R4 - Largura do objeto
    ; R5 - Altura do Objeto e iterador da altura 
    ; R6 - Cor do pixel 
    ; R7 - Iterador das colunas
    PUSH R1
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8

    CALL inicializa_iterador
    MOV R6, COR_APAGADO ; Obtem a cor usada para apagar os pixels
    apaga_linha:
        MOV [DEFINE_COLUNA], R2     ;seleciona a coluna
        MOV [DEFINE_PIXEL], R6      ;altera a cor do pixel, nas linhas e colunas seleciondas
        ADD R2, 1           ;obtém proxima coluna
        SUB R7, 1           ;reduz o número de colunas a desenhar
        JNZ apaga_linha   ;se não se tiver desenhado as colunas todas passa-se para a proxima coluna
        CALL proxima_linha
        CMP R5, -1              ;verifica se já se desenhou todas as linhas
        JNZ apaga_linha

    POP R8
    POP R7 
    POP R6
    POP R5
    POP R1
    RET
; *********************************************************************
;   Projeto BeyondMars - Versão Intermédia 
;   grupo10
;   Autores:
;   - Rafael Pedro Augusto Garcia - ist1106379
;   - Pedro Ruano Pinto Malta da Silveira - ist1106642
;   - André Hasse de Oliveira Vital Melo - ist1106937
; *********************************************************************


; *********************************************************************
; * Constantes
; *********************************************************************

COMANDOS			EQU	6000H			; endereço de base dos comandos do MediaCenter

DEFINE_LINHA    	EQU COMANDOS + 0AH		; endereço do comando para definir a linha
DEFINE_COLUNA   	EQU COMANDOS + 0CH		; endereço do comando para definir a coluna
DEFINE_PIXEL    	EQU COMANDOS + 12H		; endereço do comando para escrever um pixel
APAGA_AVISO     	EQU COMANDOS + 40H		; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRÃ	 	EQU COMANDOS + 02H		; endereço do comando para apagar todos os pixels já desenhados
SELECIONA_CENARIO_FUNDO  EQU COMANDOS + 42H		; endereço do comando para selecionar uma imagem de fundo
APAGA_CENARIO_FUNDO EQU COMANDOS + 44H  ; apaga o cenário de fundo 
SELECIONA_ECRA EQU COMANDOS + 04H   ; seleciona o ecrã de pixels a usar para o desenho de objetos
REPRODUCAO_MEDIA EQU COMANDOS + 5AH     ; reproduz um video/som selecionado
LOOP_REPRODUCAO_MEDIA EQU COMANDOS + 5CH    ; reproduz um video/som selecionado em loop
CORTA_VOLUME_SOM EQU COMANDOS + 4CH     ; corta o volume de um som/video indicado
CORTA_VOLUME EQU COMANDOS + 50H     ; corta o volume de todos os sons/videos a reproduzir
RETOMA_VOLUME EQU COMANDOS + 52H    ; retoma o volume de todos os sons/videos pausados
ECRA_NAVE EQU 0     ; seleciona qual ecra vai ser usado para desenhar a nave e a sonda
ECRA_ASTEROIDE EQU 1    ; seleciona qual ecra vai ser usado para desenhar os asteroides

ENERGIA_NAVE EQU 0100H  ; inicializa a energia da nave a 100H
MIN_ENERGIA EQU 0H 

INTRO_BACKGROUND EQU 0  ; seleciona o fundo a ser usado como introducao da pagina inicial do jogo
INTRO_OST EQU 0 ; seleciona a musica a ser usada como introducao da pagina inicial do jogo
IN_GAME_BACKGROUND EQU 1    ; seleciona o fundo a ser usado enquanto se joga
IN_GAME_OST EQU 2   ; seleciona a musica a ser usada enquanto se joga
ASTEROID_SOUND_EFFECT EQU 3     ; seleciona o efeito sonoro reproduzido quando se move o asteroide

MAXIMO_MOVIMENTOS EQU 12    ; indica o maximo numer o de movimentos de um sonda

LARGURA_NAVE EQU 15 ; representa a largura da nave
ALTURA_NAVE EQU 8   ; representa a altura da nave
LINHA_REF_NAVE EQU 31   ; linha do ponto de referencia da nave 
COLUNA_REF_NAVE EQU 25  ; coluna do ponto de ferencia da nave
LARGURA_ASTEROIDE EQU 7 ; representa a largura do asteroide
ALTURA_ASTEROIDE EQU 7  ; representa a altura do asteroide
LINHA_REF_ASTEROIDE_ESQ  EQU 2  ; linha do ponto de referencia do asteroide esquerdo 
COLUNA_REF_ASTEROIDE_ESQ EQU -4 ; coluna do ponto de referencia do asteroide esquerdo
LARGURA_SONDA EQU 1 ; representa a largura da sonda
ALTURA_SONDA EQU 1  ; representa a altura da sonda
LINHA_REF_SONDA_FR EQU 24   ; linha do ponto de referencia da sonda frontal
COLUNA_REF_SONDA_FR EQU 32  ; coluna do ponto de referencia da sonda frontal

RED EQU 0DF00H			; cor do pixel: vermelho em ARGB (opaco e vermelho no máximo, verde e azul a 0)
DARK_RED EQU 0DF20H     ; representa vermelho escuro em ARBG
BROWN EQU 0D811H        ; representa castanho em ARGB
YELLOW EQU 0DFF0H       ; representa amarelo em ARGB
BLUE EQU 0D0CFH         ; representa azul em ARGB
WHITE EQU 0DFFFH        ; representa branco em ARGB
GREEN EQU 0D0F0H        ; representa verde em ARGB
LIGHT_GRAY EQU 0DAAEH   ; representa cinzento claro em ARGB
GRAY EQU 0D558H         ; representa cinzento em ARGB
PURPLE EQU 0D0FFH       ; representa roxo em ARGB
COR_APAGADO		EQU 0000H		; cor para apagar um pixel: todas as componentes a 0

DISPLAYS   EQU 0A000H  ; endereco dos displays de 7 segmentos (periferico POUT-1)
TEC_LIN    EQU 0C000H  ; endereco das linhas do teclado (periferico POUT-2)
TEC_COL    EQU 0E000H  ; endereco das colunas do teclado (periferico PIN)
MASCARA    EQU 0FH     ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
ULTIMA_LINHA_TECLADO EQU 8H  ; representa a ultima linha do teclado
PRIMEIRA_LINHA_TECLADO EQU 1H   ; representa a primeira linha do teclado

DISPARO_FRONTAL EQU 1 ; tecla para subir sonda
ASTEROIDE_ESQ_CAIR EQU 0CH ; tecla para asteróide descer na diagonal
START_GAME EQU 0AH ; tecla para começar o jogo
AUMENTAR_DISPLAY EQU 0EH ; tecla para aumentar unidade (hexadecimal) no display
DIMINUIR_DISPLAY EQU 0DH ; tecla para diminuir unidade (hexadecimal) no display

LOGIN_SCREEN EQU 0
IN_GAME EQU 1

TAMANHO_PILHA EQU 200H
; *********************************************************************
; * Código
; *********************************************************************

    PLACE 0400H

    STACK TAMANHO_PILHA     ; reserva-se lugar para 16 words(32 bytes)
SP_init:

    STACK TAMANHO_PILHA
SP_inicial_teclado:

    STACK TAMANHO_PILHA
SP_inicial_sonda:

    STACK TAMANHO_PILHA
SP_inicial_asteroide

tecla_carregada:
	LOCK 0				; LOCK para o teclado comunicar aos restantes processos que tecla detetou
							
evento_int_0:
	LOCK 0				; LOCK para a rotina de interrupção comunicar ao processo boneco que a interrupção ocorreu
							
; Tabela das rotinas de interrupção
tab:
	WORD rot_int_0
    WORD 0
    WORD 0
    WORD 0

DEF_NAVE:
    WORD LARGURA_NAVE, ALTURA_NAVE      ; Medidas da nave
    WORD GRAY, 0, 0, 0, 0, 0, GRAY, 0, GRAY, 0, 0, 0, 0, 0, GRAY
    WORD GRAY, GRAY, GRAY, 0, 0, GRAY, GRAY, 0, GRAY, GRAY, 0, 0, GRAY, GRAY, GRAY
    WORD GRAY, LIGHT_GRAY, LIGHT_GRAY, GRAY, GRAY, LIGHT_GRAY, GRAY, GRAY, GRAY, LIGHT_GRAY, GRAY, GRAY, LIGHT_GRAY, LIGHT_GRAY, GRAY
    WORD 0, GRAY, LIGHT_GRAY, LIGHT_GRAY, LIGHT_GRAY, LIGHT_GRAY, LIGHT_GRAY, GRAY, LIGHT_GRAY, LIGHT_GRAY, LIGHT_GRAY, LIGHT_GRAY, LIGHT_GRAY, GRAY, 0
    WORD 0, 0, GRAY, GRAY, LIGHT_GRAY, LIGHT_GRAY, RED, YELLOW, GREEN, LIGHT_GRAY, LIGHT_GRAY, GRAY, GRAY, 0, 0
    WORD 0, GRAY, 0, 0, GRAY, YELLOW, GREEN, PURPLE, RED, PURPLE, GRAY, 0, 0, GRAY, 0
    WORD 0, 0, 0, 0, 0, GRAY, GRAY, GRAY, GRAY, GRAY, 0, 0 ,0 ,0 ,0
    WORD 0, 0, 0, 0, 0, 0, 0, BLUE, 0, 0, 0, 0, 0, 0, 0
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
    WORD BLUE
REFERENCIA_SONDA:
    WORD LINHA_REF_SONDA_FR, COLUNA_REF_SONDA_FR, MAXIMO_MOVIMENTOS
REFERENCIA_ASTEROIDES:
    WORD LINHA_REF_ASTEROIDE_ESQ, COLUNA_REF_ASTEROIDE_ESQ
REFERENCIA_NAVE:
    WORD LINHA_REF_NAVE, COLUNA_REF_NAVE
DISPLAY:
    WORD ENERGIA_NAVE
GAME_STATE:
    WORD LOGIN_SCREEN
TAB:
    WORD excecao_energia



    PLACE 0

; *****************************************************
;   INICIALIZA(...):   
;       - funcoes que inicializam o jogo
; *****************************************************

inicializar_registos: 
    MOV SP, SP_init 
    MOV BTE, tab
inicializar_interrupcoes:
    EI0
    EI1
    EI2
    EI3
    EI

inicializar_comandos_teclado:		
    MOV  R2, TEC_LIN   ; endereço do periférico das linhas
    MOV  R3, TEC_COL   ; endereço do periférico das colunas
    MOV  R4, DISPLAYS  ; endereço do periférico dos displays
    MOV  R5, MASCARA   ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado

inicializa_ecrã:
    CALL reinicia_jogo  ; reinicia o jogo no caso de um interrupçao repentina do mesmo
    MOV [RETOMA_VOLUME], R1 ; retome o volume do jogo no caso de uma interrupçao repentina do mesmo, no qual se cortou o som
    MOV [APAGA_AVISO], R1   ; apaga o aviso de "No background" do media center
    MOV [APAGA_ECRÃ], R1    ; apaga todos os pixels de todos os ecras 
    MOV R1, INTRO_BACKGROUND    ; guarda o valor do background da pagina inicial do jogo
    MOV [SELECIONA_CENARIO_FUNDO], R1   ; seleciona e reproduz o fundo
    MOV R1, INTRO_OST   ; guarda o valor da musica da pagina inicial do jogo
    MOV [LOOP_REPRODUCAO_MEDIA], R1 ; seleciona e reproduz em loop a musica 

inicializa_display:
    PUSH R0
    MOV R1, DISPLAY     ; guarda o enderenco com a informacao dos displays em R1
    MOV R0, [R1]    ; guarda o valor da energia inicial da nave
    MOV [R4], R0    ; representa o valor da energia inicial da nave
    POP R0

linhas_teclado:
    MOV  R1, ULTIMA_LINHA_TECLADO   ; guardamos a ultima linha

main: ; corpo principal do programa
    CALL espera_tecla
    CALL calcula_tecla
    CALL realiza_acao
    CALL ha_tecla
    JMP main

espera_tecla:          ; neste ciclo espera-se ate uma tecla ser premida
    MOVB [R2], R1      ; escrever no periferico de saida (linhas)
    MOVB R0, [R3]      ; ler do periferico de entrada (colunas)
    AND  R0, R5        ; elimina bits para alem dos bits 0-3
    CMP  R0, 0         ; ha tecla premida?
    JZ proxima_linha_teclado    ; se não houve tecla premida, passemos para a proxima linha a varrer
    RET

proxima_linha_teclado:
    SHR R1, 1
    CMP R1, 0
    JNZ espera_tecla
    MOV R1, ULTIMA_LINHA_TECLADO
    JMP espera_tecla

ha_tecla:
    MOVB [R2], R1      ; escrever no periférico de saída (linhas)
    MOVB R0, [R3]      ; ler do periférico de entrada (colunas)
    AND  R0, R5        ; elimina bits para além dos bits 0-3
    CMP  R0, 0         ; há tecla premida?
    JNZ  ha_tecla      ; se ainda houver uma tecla premida, espera até não haver
    RET

fim:
    JMP fim     ; fim do programa 

; *****************************************************
;   CALCULA_TECLA:
;       - funcao que calcula o valor da tecla ( 0 - F )
; *****************************************************

calcula_tecla:              ; neste ciclo espera-se até NENHUMA tecla estar premida
    PUSH R1
    PUSH R2         ; usado em calculos intermedios

    MOV R2, 4      ; usado para multiplicar o valor da linha por 4 
    CALL converte_linha_coluna  ; converte a linha em (0 - 3)
    MUL R2, R7      ;   guarda-se o resultado num registo intermedio     
    MOV R1, R0
    CALL converte_linha_coluna
    ADD R7, R2

    POP R2
    POP R1
    RET

converte_linha_coluna:
    PUSH R1

    MOV R7, 0
    converte_aux:
        ADD R7, 1
        SHR R1, 1
        JNZ converte_aux
    SUB R7, 1

    POP R1
    RET
    
; *****************************************************
;   REALIZA_ACAO:
;       - funcao que realiza uma acao de acordo com o comando pressionado
; *****************************************************

realiza_acao:
    PUSH R0

    MOV R0, [GAME_STATE]
    CMP R0, LOGIN_SCREEN
    JZ login_actions
    JNZ in_game_actions

    end_of_action:
        POP R0
        RET

login_actions:
    MOV R0, START_GAME
    CMP R0, R7
    JNZ end_of_action
    CALL init_game
    JMP end_of_action

in_game_actions:
    PUSH R0
    PUSH R6
    PUSH R8

    MOV R6, DISPLAY     ; guardamos em R6 o enderenco com as informacoes relacionadas com o Display
    MOV R8, [R6]    ; guardamos em R8 o valor representado no display

    disparo_frontal:
        MOV R0, DISPARO_FRONTAL  ; guardamos em R0 o valor do comando para disparar a sonda frontal
        CMP R7, R0  ; comparamos o valor da tecla pressionada com o comando para dispara a sonda frontal
        JNZ asteroide_esq   ; se a tecla pressionada nao for o comando para comecar passa-se para o proximo comando
        CALL sonda_frontal  ; caso contrario chama-se uma funcao que move a sonda frontal
        JMP no_commands   ; acaba-se a acao relacionada com a tecla pressionada
    asteroide_esq:
        MOV R0, ASTEROIDE_ESQ_CAIR  ; guardamos em R1 o valor do comando para mover o asteroide esquerdo na diagonal
        CMP R7, R0  ; comparamos o valor da tecla pressionada com o comando para mover o asteroide esquerdo
        JNZ aumentar_display    ; se a tecla pressionada nao for o comando para mover o asteroide passa-se para o proximo comando
        CALL move_asteroide_esq     ; caso contrario chama-se uma funcao que move o asteroide
        JMP no_commands   ; acaba-se a acao relacionada com a tecla pressionada
    aumentar_display:
        MOV R0, AUMENTAR_DISPLAY    ; guardamos em R3 o valor do comando para aumentar o valor do display em 1 unidade
        CMP R7, R0  ; comparamos o valor da tecla pressionada com o comando para aumentar o valor do display
        JNZ diminuir_display    ; se a tecla pressionada não for o comando para aumentar o valor passa-se para o proximo comando
        CALL aumentar_unidade   ; caso contraio chama-se um funcao para aumentar em 1 unidade o valor do display
        JMP no_commands   ; acaba-se a acao relacionada com a tecla pressionada
    diminuir_display:
        MOV R0, DIMINUIR_DISPLAY    ; guardamos em R5 o valor do comando para diminuir o valor do display em 1 unidade
        CMP R7, R0  ; comparamos o valor da tecla pressionada com o comando para diminuir o valor do display
        JNZ no_commands   ; se a tecla pressionada não for o comando para diminuir o valor acaba-se a acao (não ha mais comandos)
        CALL diminuir_unidade   ; caso contrario chama-se uma funcao para diminuir o valor do display em 1 unidade
        JMP no_commands   ; acaba-se a acao relacionada com a tecla pressionada
    no_commands:  ; endrenco do fim da funcao para relizar acao
        POP R8
        POP R6
        POP R0
        JMP end_of_action


; *****************************************************
;   AUMENTAR_UNIDADE e DIMINUIR_UNIDADE
;       - funcoes que alteram em 1 unidade o valor do display
; *****************************************************


aumentar_energia:
    PUSH R6
    PUSH R8
    MOV R6, DISPLAY     ; guardamos em R6 o enderenco com as informacoes relacionadas com o Display
    MOV R8, [R6]    ; guardamos em R8 o valor representado no display
    ADD R8, 25   ; adicionamos ao valor do display uma unidade
    CALL hexa_para_decimal 
    MOV [R6], R8    ; atualizamos a variavel com o numero do display
    MOV [R4], R8    ; atualizamos o display
    RET

diminuir_unidade:
    PUSH R6
    PUSH R7
    PUSH R8
    MOV R6, DISPLAY     ; guardamos em R6 o enderenco com as informacoes relacionadas com o Display
    MOV R8, [R6]    ; guardamos em R8 o valor representado no display
    MOV R7, MIN_ENERGIA
    CMP R8, R7
    JZ ret_diminuir_energia
    SUB R8, 5   ; retiramos ao valor do display uma unidade
    MOV [R6], R8   ; atualizamos a variavel com o numero do display
    MOV [R4], R8    ; atualizamos o display
    RET
    ret_diminuir_energia:
        POP R10
        POP R8
        POP R7
        POP R2
        RET

hexa_para_decimal:
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R8
    PUSH R10
  
    MOV R1, 1000
    MOV R2, 10
    MOV R10, 0
  
    hexa_para_decimal_loop:
        MOD R8, R1 
        DIV R1, R2 
        CMP R1, 0 
        JZ ret_hexa_para_decimal
        MOV R3, R10 
        DIV R3, R1
        SHL R8, 4 
        OR R8, R3 
        JMP hexa_to_decimal_loop

    ret_hexa_para_decimal:
        POP R10
        POP R3
        POP R2
        POP R1
        RET

; *****************************************************
;   INIT_GAME:
;       - funcao que comeca o jogo
; *****************************************************
init_game:
    PUSH R0
    MOV R0, INTRO_OST   ; guarda-se em R0 a musica a ser reproduzida na pagina inicial do jogo
    MOV [CORTA_VOLUME_SOM], R0  ; corta-se o volume da musica 
    MOV R0, IN_GAME_OST ; guarda-se em R0 a musica que ira ser reproduzida no jogo
    MOV [LOOP_REPRODUCAO_MEDIA], R0 ; reproduz-se a musica registada em R0 em loop
    MOV [APAGA_CENARIO_FUNDO], R0   ; Apaga o cenario de fundo atual o valor de R0 não e importante
    MOV R0, IN_GAME_BACKGROUND  ; guarda em R0 o valor do fundo ( em formato de video ) a ser usado no jogo
    MOV [LOOP_REPRODUCAO_MEDIA], R0 ; reproduz-se o video, usado como fundo, em loop
    CALL desenha_nave   ; chama-se uma funcao para desenhar a nave
    CALL move_asteroide_esq
    MOV R0, IN_GAME
    MOV [GAME_STATE], R0
    POP R0
    RET

; *****************************************************
;   REINICIA_JOGO:
;       - funcao que reinicia o jogo
; *****************************************************

reinicia_jogo:
    CALL reinicia_asteroide_esq ; reiniciamos a posicao do asteroide_esq
    CALL reinicia_sonda     ; reiniciamos a posicao da sonda
    RET

; *****************************************************
;   REINICIA_ASTEROIDE_ESQ e REINICIA_SONDA:
;       - reiniciam a posicao do objetos
; *****************************************************
reinicia_asteroide_esq:
    PUSH R0
    PUSH R1
    MOV R0, REFERENCIA_ASTEROIDES    ; guarda-se o enderenco com a informacao relacionada com a posicao do asteroide esquerdo
    MOV R1, LINHA_REF_ASTEROIDE_ESQ     ; guarda-se o valor da linha do ponto de referencia inicial do asteroide
    MOV [R0], R1    ; resetamos a linha de referencia do asteroide para a inicial
    ADD R0, 2   ; obtemos o enderenco com a coluna atual de referencia do asteroide esquerdo
    MOV R1, COLUNA_REF_ASTEROIDE_ESQ    ; guarda-se o valor da coluna do ponto de referencia inicial do asteroide
    MOV [R0], R1    ; resetamos a coluna de referencia do asteroide para o inicial
    POP R1
    POP R0
    RET

reinicia_sonda:
    PUSH R0
    PUSH R1
    MOV R0, REFERENCIA_SONDA    ; guarda-se o endereço com a informaco relacionada com a posicao da sonda
    MOV R1, LINHA_REF_SONDA_FR  ; guarda-se o valor da linha do ponto de referencia inicial da sonda
    MOV [R0], R1    ; atualizamos a linha do ponto de referencia da posicao da sonda para a inicial
    ADD R0, 2   ; obtemos o endereço com a informacao relacionada com a coluna atual do ponto de referencia da sonda
    MOV R1, COLUNA_REF_SONDA_FR ; guarda-se o valor da coluna do ponto de referencia inicial da sonda
    MOV [R0], R1    ; atualizamos a coluna do ponto de referencia da posicao da sonda para a inicial
    POP R1
    POP R0
    RET


; ************************************************************************************
; Utilizacao dos registos (geral) para as proximas funcoes de desenhar/apagar
; R0 - Endereço com as informacoes relacionadas com o ponto de referencia do objeto
; R1 - Linha do ponto de referencia do objeto
; R2 - Coluna do ponto de referencia do objeto
; R3 - Endereço com as informacoes acerca do formato do objeto (largura, altura, cor)
; R4 - Largura do objeto
; R5 - Altura  do objeto
; ************************************************************************************

; *****************************************************
;   SONDA_FRONTAL e MOVE_ASTEROIDE_ESQ:
;       - funcoes responsaveis por movimentar a sonda/ o asteroide
; *****************************************************
sonda_frontal:
    PUSH R0
    PUSH R3

    MOV R0, ECRA_NAVE  ; guardamos o ecra onde sera desenhado o asteroide
    MOV [SELECIONA_ECRA], R0    ; selecionamos o ecra
    MOV R0, REFERENCIA_SONDA
    MOV R3, DEF_SONDA
    CALL apaga_objeto
    CALL inc_sonda_frontal
    CALL desenha_objeto     ; desenhamos o asteroide 

    POP R3
    POP R0
    RET

move_asteroide_esq:
    PUSH R0
    PUSH R3

    MOV R0, ECRA_ASTEROIDE  ; guardamos o ecra onde sera desenhado o asteroide
    MOV [SELECIONA_ECRA], R0    ; selecionamos o ecra
    MOV R0, REFERENCIA_ASTEROIDES
    MOV R3, DEF_ASTEROIDE
    CALL apaga_objeto
    CALL inc_asteroide_esq
    CALL desenha_objeto     ; desenhamos o asteroide 

    POP R3
    POP R0
    RET

; ****************************************************************************
;   INC_SONDA_FRONTAL e INC_ASTEROIDE_ESQ:
;       - funcoes responveis por incrementar a posicao da sonda/ do asteroide
; ****************************************************************************

inc_sonda_frontal:
    PUSH R0
    PUSH R1
    
    ADD R0, 4
    MOV R1, [R0]
    SUB R1, 1
    JZ reset_sonda_frontal
    MOV [R0], R1
    SUB R0, 4
    CALL incrementa_vertical
    JMP fim_incremento

    reset_sonda_frontal:
        MOV R1, MAXIMO_MOVIMENTOS
        MOV [R0], R1
        CALL reinicia_sonda

    fim_incremento:
        POP R1
        POP R0
        RET

inc_asteroide_esq:
    CALL decrementa_vertical    ; chama-se uma funcao que move o asteroide para baixo
    CALL incrementa_horizontal  ; chama-se uma funcao que move o asteroide para a diretia
    RET

; *****************************************************
;   DECREMENTA_VERTICAL e INCREMENTA_HORIZONTAL:
;       - funcoes que in/decrementam a posicao do objeto
;           no respetivo sentido
; *****************************************************

incrementa_vertical:
    PUSH R1
    MOV R1, [R0]    ; guardamos o valor da linha de referencia dum ponto de referencia
    SUB R1, 1   ; incrementamos em 1 unidade, dando o efeito visual que o objeto está a descer
    MOV [R0], R1    ; atualizamos o valor na memoria
    POP R1
    RET

decrementa_vertical:
    PUSH R1
    MOV R1, [R0]    ; guardamos o valor da linha de referencia dum ponto de referencia
    ADD R1, 1   ; incrementamos em 1 unidade, dando o efeito visual que o objeto está a descer
    MOV [R0], R1    ; atualizamos o valor na memoria
    POP R1
    RET

incrementa_horizontal:
    PUSH R3
    ADD R0, 2   ; obtemos o endereco com a coluna do ponto de referencia do objeto
    MOV R3, [R0]    ; guardamos a coluna do ponto de referencia do objeto
    ADD R3, 1   ; incrementamos em 1 unidade, dando o efeito visual que o objeto está "ir" para a direita
    MOV [R0], R3    ; atualizamos o valor na memoria
    SUB R0, 2   ; resetamos o endereco para o inicial com as informacao da posicao do objeto
    POP R3
    RET

; ********************************************************
;   DESENHA_NAVE e APAGA_NAVE
;       - funcoes responsaveis por desenhar/apagar a nave
; ********************************************************

desenha_nave:
    PUSH R0
    PUSH R3

    MOV R0, ECRA_NAVE  ; guardamos o ecra onde sera desenhado o asteroide
    MOV [SELECIONA_ECRA], R0    ; selecionamos o ecra
    MOV R0, REFERENCIA_NAVE
    MOV R3, DEF_NAVE
    CALL desenha_objeto     ; desenhamos o asteroide 

    POP R3
    POP R0
    RET

apaga_nave:
    PUSH R0
    PUSH R3

    MOV R0, ECRA_NAVE  ; guardamos o ecra onde sera desenhado o asteroide
    MOV [SELECIONA_ECRA], R0    ; selecionamos o ecra
    MOV R0, REFERENCIA_NAVE
    MOV R3, DEF_NAVE
    CALL apaga_objeto     ; desenhamos o asteroide 

    POP R3
    POP R0
    RET

; *****************************************************
;   DESENHA_ASTEROIDE_ESQ:
;       - funcao responsavel por desenhar o asteroide
;           no canto superior esquerdo
; *****************************************************
    
; *****************************************************
;   DESENHA_OBJETO e APAGA_OBJETO:
;       - funcoes responsaveis por desenhar/apagar um
;       objeto generico dadas as suas medidas e formato
; *****************************************************

desenha_objeto:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R4
    PUSH R5

    MOV R1, [R0]
    ADD R0, 2
    MOV R2, [R0]

    MOV R4, [R3]
    ADD R3, 2
    MOV R5, [R3]

    MOV [DEFINE_LINHA], R1 ;seleciona a linha

    desenha_linha:
        CALL pinta_linha
        CALL proxima_linha
        CMP R5, 0
        JNZ desenha_linha

    POP R5
    POP R4
    POP R2
    POP R1
    POP R0
    RET

apaga_objeto:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R4
    PUSH R5

    MOV R1, [R0]
    ADD R0, 2
    MOV R2, [R0]

    MOV R4, [R3]
    ADD R3, 2
    MOV R5, [R3]
    SUB R3, 2

    MOV R0, COR_APAGADO
    MOV [DEFINE_LINHA], R1 ;seleciona a linha
    
    apaga_linha:
        CALL remove_linha
        CALL proxima_linha
        CMP R5, 0
        JNZ apaga_linha

    POP R5
    POP R4
    POP R2
    POP R1
    POP R0
    RET

remove_linha:
    PUSH R2
    PUSH R4

    MOV R0, COR_APAGADO
    remove_auxiliar:
        MOV [DEFINE_COLUNA], R2     ;seleciona a coluna
        MOV [DEFINE_PIXEL], R0      ;altera a cor do pixel, nas linhas e colunas seleciondas
        ADD R2, 1           ;obtém proxima coluna
        SUB R4, 1           ;reduz o número de colunas a desenhar
        JNZ remove_auxiliar   ;se não se tiver desenhado as colunas todas passa-se para a proxima coluna

    POP R4
    POP R2
    RET

pinta_linha:
    PUSH R2
    PUSH R4

    pinta_auxiliar:
        CALL proxima_cor
        MOV [DEFINE_COLUNA], R2     ;seleciona a coluna
        MOV [DEFINE_PIXEL], R0      ;altera a cor do pixel, nas linhas e colunas seleciondas
        ADD R2, 1           ;obtém proxima coluna
        SUB R4, 1           ;reduz o número de colunas a desenhar
        JNZ pinta_auxiliar   ;se não se tiver desenhado as colunas todas passa-se para a proxima coluna

    POP R4
    POP R2
    RET

proxima_linha:
    SUB R1, 1 ;reduz o número da linha a desenhar
    SUB R5, 1 ;reduz o numero de linhas a desenhar
    MOV [DEFINE_LINHA], R1 ;seleciona a linha
    RET

proxima_cor:
    ADD R3, 2
    MOV R0, [R3]
    RET

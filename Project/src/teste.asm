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
TERMINA_MEDIA EQU COMANDOS + 66H     ; corta o volume de um som/video indicado
TERMINA_TODA_MEDIA EQU COMANDOS + 68H
CORTA_VOLUME EQU COMANDOS + 50H     ; corta o volume de todos os sons/videos a reproduzir
RETOMA_VOLUME EQU COMANDOS + 52H    ; retoma o volume de todos os sons/videos pausados
PAUSA_MEDIA EQU COMANDOS + 5EH
RETOME_MEDIA EQU COMANDOS + 60H
ECRA_NAVE EQU 0     ; seleciona qual ecra vai ser usado para desenhar a nave e a sonda
ECRA_ASTEROIDE EQU 1    ; seleciona qual ecra vai ser usado para desenhar os asteroides

ENERGIA_NAVE EQU 100  ; inicializa a energia da nave a 100H

INTRO_BACKGROUND EQU 0  ; seleciona o fundo a ser usado como introducao da pagina inicial do jogo
INTRO_OST EQU 0 ; seleciona a musica a ser usada como introducao da pagina inicial do jogo
IN_GAME_BACKGROUND EQU 1    ; seleciona o fundo a ser usado enquanto se joga
END_GAME_BACKGROUND EQU 2   ; seleciona o fundo quando se termina o jogo
LOSS_COLISION_BACKGROUND EQU 1
IN_GAME_OST EQU 2   ; seleciona a musica a ser usada enquanto se joga
END_GAME_OST EQU 3     ; seleciona o efeito sonoro reproduzido quando se move o asteroide
COLLISION_EFFECT EQU 4
GAME_OVER EQU 5
EXPLOSION_EFFECT EQU 6
CONSOME_EFFECT EQU 7

MAXIMO_MOVIMENTOS EQU 12    ; indica o maximo numer o de movimentos de um sonda

LARGURA_NAVE EQU 15 ; representa a largura da nave
ALTURA_NAVE EQU 8   ; representa a altura da nave
LINHA_REF_NAVE EQU 31   ; linha do ponto de referencia da nave 
COLUNA_REF_NAVE EQU 25  ; coluna do ponto de ferencia da nave

LINHA_REF_PAINEL EQU 27 ; linha do ponto de referencia do painel    
COLUNA_REF_PAINEL EQU 30    ; coluna do ponto de referencia do painel
LARGURA_PAINEL EQU 5
ALTURA_PAINEL EQU 2
N_ANIMACOES_NAVE EQU 2
N_ANIMACOES_CONSOME EQU 2

LARGURA_ASTEROIDE EQU 7 ; representa a largura do asteroide
ALTURA_ASTEROIDE EQU 7  ; representa a altura do asteroide
N_ASTEROIDES EQU 4

LARGURA_EXPLOSAO EQU 9
ALTURA_EXPLOSAO EQU 9

LINHA_INICIAL_ASTEROIDES  EQU 2  ; linha do ponto de referencia do asteroide esquerdo 
COLUNA_REF_ASTEROIDE_ESQ EQU -4 ; coluna do ponto de referencia do asteroide esquerdo
COLUNA_REF_ASTEROIDE_MEIO EQU 29
COLUNA_REF_ASTEROIDE_DIR EQU 62

LARGURA_SONDA EQU 1 ; representa a largura da sonda
ALTURA_SONDA EQU 1  ; representa a altura da sonda
N_SONDAS EQU 3

LINHA_REF_SONDA_FR EQU 24   ; linha do ponto de referencia da sonda frontal
COLUNA_REF_SONDA_FR EQU 32  ; coluna do ponto de referencia da sonda frontal
LINHA_REF_SONDA_ESQ EQU 26
COLUNA_REF_SONDA_ESQ EQU 26
LINHA_REF_SONDA_DIR EQU 26
COLUNA_REF_SONDA_DIR EQU 38

; Representam a linha da respetiva sonda
; nas respetivas tabelas referentes às sondas
LINHA_SONDA_ESQUERDA EQU 0
LINHA_SONDA_FRONTAL EQU 1
LINHA_SONDA_DIREITA EQU 2


MIN_COLUNA		EQU  0		; número da coluna mais à esquerda que o objeto pode ocupar
MAX_COLUNA		EQU  63        ; número da coluna mais à direita que o objeto pode ocupar
MAX_LINHA EQU 31
MIN_LINHA EQU 0

TRUE EQU 1
FALSE EQU 0

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

DISPARO_ESQUERDO EQU 0
DISPARO_FRONTAL EQU 1 ; tecla para subir sonda
DISPARO_DIREITO EQU 2
PAUSE_GAME EQU 0CH ; tecla para asteróide descer na diagonal
START_GAME EQU 0AH ; tecla para começar o jogo
END_GAME EQU 0EH

DIRECAO_INF_DIREITO EQU 0
DIRECAO_INF_ESQUERDO EQU 2
DIRECAO_INF_MEIO EQU 1

TAMANHO_PILHA EQU 200H

LOGIN_SCREEN EQU 0
IN_GAME EQU 1
PAUSED_GAME EQU -1
ENDED_GAME EQU 2

; *********************************************************************
; * Código
; *********************************************************************

    PLACE 0800H

    STACK TAMANHO_PILHA     ; reserva-se lugar para 16 words(32 bytes)
SP_init:

    STACK TAMANHO_PILHA
SP_inicial_teclado:

    STACK TAMANHO_PILHA * N_SONDAS
SP_inicial_sonda:

    STACK TAMANHO_PILHA * N_ASTEROIDES
SP_inicial_asteroide:

    STACK TAMANHO_PILHA
SP_inicial_displays:

    STACK TAMANHO_PILHA
SP_inicial_nave:

tecla_carregada:
	LOCK 0				; LOCK para o teclado comunicar aos restantes processos que tecla detetou
							
; Tabela das rotinas de interrupção
tab:
	WORD rot_int_0
    WORD rot_int_1
    WORD rot_int_2
    WORD rot_int_3

eventos_int:
    LOCK 0
    LOCK 0
    LOCK 0
    LOCK 0

DEF_NAVE:
    WORD LARGURA_NAVE, ALTURA_NAVE      ; Medidas da nave
    WORD GRAY, 0, 0, 0, 0, 0, GRAY, 0, GRAY, 0, 0, 0, 0, 0, GRAY
    WORD GRAY, GRAY, GRAY, 0, 0, GRAY, GRAY, 0, GRAY, GRAY, 0, 0, GRAY, GRAY, GRAY
    WORD GRAY, LIGHT_GRAY, LIGHT_GRAY, GRAY, GRAY, LIGHT_GRAY, GRAY, GRAY, GRAY, LIGHT_GRAY, GRAY, GRAY, LIGHT_GRAY, LIGHT_GRAY, GRAY
    WORD 0, GRAY, LIGHT_GRAY, LIGHT_GRAY, LIGHT_GRAY, LIGHT_GRAY, LIGHT_GRAY, GRAY, LIGHT_GRAY, LIGHT_GRAY, LIGHT_GRAY, LIGHT_GRAY, LIGHT_GRAY, GRAY, 0
    WORD 0, 0, GRAY, GRAY, LIGHT_GRAY, LIGHT_GRAY, RED, YELLOW, GREEN, LIGHT_GRAY, LIGHT_GRAY, GRAY, GRAY, 0, 0
    WORD 0, 0, 0, 0, GRAY, YELLOW, GREEN, PURPLE, RED, PURPLE, GRAY, 0, 0, 0, 0
    WORD 0, 0, 0, 0, 0, GRAY, GRAY, GRAY, GRAY, GRAY, 0, 0 ,0 ,0 ,0
    WORD 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

DEF_NAVE1:
    WORD LARGURA_NAVE, ALTURA_NAVE      ; Medidas da nave
    WORD GRAY, 0, 0, 0, 0, 0, GRAY, 0, GRAY, 0, 0, 0, 0, 0, GRAY
    WORD GRAY, GRAY, GRAY, 0, 0, GRAY, GRAY, 0, GRAY, GRAY, 0, 0, GRAY, GRAY, GRAY
    WORD GRAY, LIGHT_GRAY, LIGHT_GRAY, GRAY, GRAY, LIGHT_GRAY, GRAY, GRAY, GRAY, LIGHT_GRAY, GRAY, GRAY, LIGHT_GRAY, LIGHT_GRAY, GRAY
    WORD 0, GRAY, LIGHT_GRAY, LIGHT_GRAY, LIGHT_GRAY, LIGHT_GRAY, LIGHT_GRAY, GRAY, LIGHT_GRAY, LIGHT_GRAY, LIGHT_GRAY, LIGHT_GRAY, LIGHT_GRAY, GRAY, 0
    WORD 0, 0, GRAY, GRAY, LIGHT_GRAY, LIGHT_GRAY, RED, PURPLE, GREEN, LIGHT_GRAY, LIGHT_GRAY, GRAY, GRAY, 0, 0
    WORD 0, 0, 0, 0, GRAY, YELLOW, BLUE, GREEN, PURPLE, RED, GRAY, 0, 0, 0, 0
    WORD 0, 0, 0, 0, 0, GRAY, GRAY, GRAY, GRAY, GRAY, 0, 0 ,0 ,0 ,0
    WORD 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

DEF_NAVE2:
    WORD LARGURA_NAVE, ALTURA_NAVE      ; Medidas da nave
    WORD GRAY, 0, 0, 0, 0, 0, GRAY, 0, GRAY, 0, 0, 0, 0, 0, GRAY
    WORD GRAY, GRAY, GRAY, 0, 0, GRAY, GRAY, 0, GRAY, GRAY, 0, 0, GRAY, GRAY, GRAY
    WORD GRAY, LIGHT_GRAY, LIGHT_GRAY, GRAY, GRAY, LIGHT_GRAY, GRAY, GRAY, GRAY, LIGHT_GRAY, GRAY, GRAY, LIGHT_GRAY, LIGHT_GRAY, GRAY
    WORD 0, GRAY, LIGHT_GRAY, LIGHT_GRAY, LIGHT_GRAY, LIGHT_GRAY, LIGHT_GRAY, GRAY, LIGHT_GRAY, LIGHT_GRAY, LIGHT_GRAY, LIGHT_GRAY, LIGHT_GRAY, GRAY, 0
    WORD 0, 0, GRAY, GRAY, LIGHT_GRAY, LIGHT_GRAY, YELLOW, GREEN, BLUE, LIGHT_GRAY, LIGHT_GRAY, GRAY, GRAY, 0, 0
    WORD 0, 0, 0, 0, GRAY, RED, PURPLE, BLUE, RED, YELLOW, GRAY, 0, 0, 0, 0
    WORD 0, 0, 0, 0, 0, GRAY, GRAY, GRAY, GRAY, GRAY, 0, 0 ,0 ,0 ,0
    WORD 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

ANIMACOES_NAVE:
    WORD DEF_NAVE2, DEF_NAVE1, DEF_NAVE

DEF_ASTEROIDE:
    WORD LARGURA_ASTEROIDE, ALTURA_ASTEROIDE
    WORD 0, 0, DARK_RED, DARK_RED, DARK_RED, 0, 0
    WORD 0, BROWN, DARK_RED, DARK_RED, DARK_RED, DARK_RED, 0
    WORD BROWN, BROWN, BROWN, DARK_RED, DARK_RED, DARK_RED, DARK_RED
    WORD DARK_RED, BROWN, BROWN, BROWN, BROWN, DARK_RED, DARK_RED
    WORD BROWN, BROWN, DARK_RED, BROWN, BROWN, BROWN, DARK_RED
    WORD 0, BROWN, BROWN, BROWN, DARK_RED, BROWN, 0
    WORD 0, 0, DARK_RED, BROWN, BROWN, 0, 0
DEF_MINERAVEL:
    WORD LARGURA_ASTEROIDE, ALTURA_ASTEROIDE
    WORD 0, 0, DARK_RED, GREEN, DARK_RED, 0, 0
    WORD 0, BROWN, DARK_RED, DARK_RED, DARK_RED, DARK_RED, 0
    WORD BROWN, BROWN, GREEN, GREEN, GREEN, DARK_RED, DARK_RED
    WORD BROWN, BROWN, GREEN, GREEN, GREEN, DARK_RED, DARK_RED
    WORD BROWN, BROWN, GREEN, GREEN, GREEN, DARK_RED, DARK_RED
    WORD 0, BROWN, BROWN, BROWN, DARK_RED, BROWN, 0
    WORD 0, 0, GREEN, BROWN, BROWN, 0, 0

DEF_EXPLOSAO:
    WORD LARGURA_EXPLOSAO, ALTURA_EXPLOSAO
    WORD 0, YELLOW, 0, 0, DARK_RED, 0, 0, 0, 0
    WORD 0, 0, 0, DARK_RED, RED, DARK_RED, 0, 0, 0
    WORD 0, 0, 0, DARK_RED, RED, DARK_RED, 0, 0, 0
    WORD 0, DARK_RED, DARK_RED, RED, YELLOW, RED, DARK_RED, DARK_RED, 0
    WORD DARK_RED, RED, RED, YELLOW, WHITE, YELLOW, RED, RED, DARK_RED
    WORD 0, DARK_RED, DARK_RED, RED, YELLOW, RED, DARK_RED, DARK_RED, 0
    WORD 0, 0, 0, DARK_RED, RED, DARK_RED, 0, 0, 0
    WORD 0, YELLOW, 0, DARK_RED, RED, DARK_RED, 0, 0, 0
    WORD 0, 0, 0, 0, DARK_RED, 0, 0, YELLOW, 0

DEF_CONSOME0:
    WORD LARGURA_ASTEROIDE, ALTURA_ASTEROIDE
    WORD 0, 0, BLUE, BLUE, BLUE, 0, 0
    WORD 0, BLUE, DARK_RED, DARK_RED, DARK_RED, BLUE, 0
    WORD BLUE, BROWN, GREEN, GREEN, GREEN, DARK_RED, BLUE
    WORD BLUE, BROWN, GREEN, GREEN, GREEN, DARK_RED, BLUE
    WORD BLUE, BROWN, GREEN, GREEN, GREEN, DARK_RED, BLUE
    WORD 0, BLUE, BROWN, BROWN, DARK_RED, BLUE, 0
    WORD 0, 0, BLUE, BLUE, BLUE, 0, 0
DEF_CONSOME1:
    WORD LARGURA_ASTEROIDE, ALTURA_ASTEROIDE
    WORD 0, 0, 0, 0, 0, 0, 0
    WORD 0, 0, BLUE, BLUE, BLUE, 0, 0
    WORD 0, BLUE, GREEN, GREEN, BLUE, BLUE, 0
    WORD 0, BLUE, GREEN, GREEN, GREEN, BLUE, 0
    WORD 0, BLUE, BLUE, GREEN, GREEN, BLUE, 0
    WORD 0, 0, BLUE, BLUE, BLUE, 0, 0
    WORD 0, 0, 0, 0, 0, 0, 0
DEF_CONSOME2:
    WORD LARGURA_ASTEROIDE, ALTURA_ASTEROIDE
    WORD 0, 0, 0, 0, 0, GREEN, 0
    WORD 0, 0, BLUE, 0, 0, 0, 0
    WORD BLUE, 0, 0, 0, 0, 0, 0
    WORD 0, 0, 0, GREEN, 0, BLUE, 0
    WORD 0, 0, 0, 0, 0, 0, 0
    WORD GREEN, 0, 0, BLUE, 0, 0, 0
    WORD 0, 0, 0, 0, 0, 0, GREEN
ANIMACOES_CONSOME:
    WORD DEF_CONSOME2, DEF_CONSOME1, DEF_CONSOME0

DEF_SONDA:
    WORD LARGURA_SONDA, ALTURA_SONDA
    WORD BLUE
; Nas proximas tabelas relativas à sonda, a primeira linha
; é referente à sonda da esquerda, a segunda linha é referente
; à sonda do meio e por ultimo a ultima linha é referente à sonda
; da direita
REFERENCIA_SONDAS:  ; Contem as referencias atuais de cada sonda
    WORD LINHA_REF_SONDA_ESQ, COLUNA_REF_SONDA_ESQ
    WORD LINHA_REF_SONDA_FR, COLUNA_REF_SONDA_FR
    WORD LINHA_REF_SONDA_DIR, COLUNA_REF_SONDA_DIR
direcoes_sondas:
    WORD -1, -1     ; A sonda move-se para a diagonal esquerda
    WORD -1, 0      ; A sonda move-se na vertical para cima
    WORD -1, 1      ; A sonda move-se para a diagonal direita
posicoes_iniciais_sondas:   ; Contem as posicoes iniciais de cada sonda
    WORD LINHA_REF_SONDA_ESQ, COLUNA_REF_SONDA_ESQ
    WORD LINHA_REF_SONDA_FR, COLUNA_REF_SONDA_FR
    WORD LINHA_REF_SONDA_DIR, COLUNA_REF_SONDA_DIR
MOVIMENTOS_SONDA:   ; guarda o numero de movimentos possiveis das sondas 
    WORD MAXIMO_MOVIMENTOS
    WORD MAXIMO_MOVIMENTOS
    WORD MAXIMO_MOVIMENTOS

REFERENCIA_ASTEROIDES:  ; Contem os pontos de referencia atuais de cada asteroide
    WORD LINHA_INICIAL_ASTEROIDES, 0
    WORD LINHA_INICIAL_ASTEROIDES, 0
    WORD LINHA_INICIAL_ASTEROIDES, 0
    WORD LINHA_INICIAL_ASTEROIDES, 0

DIRECOES_ASTEROIDES:    ; guarda as posiveis direcoes que um asteroide pode tomar
                        ; a primeira coluna é o incremento da linha do asteroide
                        ; a segunda coluna é o incremento na coluna do asteroide
    WORD 1, 1       ; efeito de descer e mover-se para a direita num angulo de 45º
    WORD 1, 0       ; efeito de descer, apenas
    WORD 1, -1      ; efeito de descer e mover-se para a esquerda num angulo de 45º

par_direcao_coluna: ; guarda as posicoes posicoes e direcoes iniciais dos asteroides
                    ; 1ª Coluna guarda a direcao possivel, 2ª a coluna inicial possivel
    WORD DIRECAO_INF_ESQUERDO, COLUNA_REF_ASTEROIDE_MEIO
    WORD DIRECAO_INF_MEIO, COLUNA_REF_ASTEROIDE_MEIO
    WORD DIRECAO_INF_DIREITO, COLUNA_REF_ASTEROIDE_MEIO
    WORD DIRECAO_INF_DIREITO, COLUNA_REF_ASTEROIDE_ESQ
    WORD DIRECAO_INF_ESQUERDO, COLUNA_REF_ASTEROIDE_DIR

posicao_generica_asteroide:     ; posicao generica dos asteroides ( comecam sempre da mesma linha )
    WORD LINHA_INICIAL_ASTEROIDES, 0

REFERENCIA_NAVE:
    WORD LINHA_REF_NAVE, COLUNA_REF_NAVE
REFERENCIA_PAINEL:
    WORD LINHA_REF_PAINEL, COLUNA_REF_PAINEL
DISPLAY:
    WORD ENERGIA_NAVE
COMANDOS_DISPARO:   ;  vetor com os comandos de disparo para o processo "sondas"
                    ;  A respetiva coluna, corresponde à respetiva sonda
                    ;  Ex: Disparo_esquerdo corresponde à sonda esquerda
    WORD DISPARO_ESQUERDO, DISPARO_FRONTAL, DISPARO_DIREITO
GAME_STATE:
    WORD LOGIN_SCREEN

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

inicializa_ecrã:
    MOV [RETOMA_VOLUME], R1 ; retome o volume do jogo no caso de uma interrupçao repentina do mesmo, no qual se cortou o som
    MOV [APAGA_AVISO], R1   ; apaga o aviso de "No background" do media center
    MOV [APAGA_ECRÃ], R1    ; apaga todos os pixels de todos os ecras 
    MOV R1, INTRO_BACKGROUND    ; guarda o valor do background da pagina inicial do jogo
    MOV [SELECIONA_CENARIO_FUNDO], R1   ; seleciona e reproduz o fundo
    MOV R1, INTRO_OST   ; guarda o valor da musica da pagina inicial do jogo
    MOV [LOOP_REPRODUCAO_MEDIA], R1 ; seleciona e reproduz em loop a musica 

main: ; corpo principal do programa
    CALL teclado

    CALL desenha_nave 
    MOV R0, N_SONDAS
    loop_sondas:
        SUB R0, 1
        CALL sondas
        CMP R0, 0
        JNZ loop_sondas

    MOV R0, N_ASTEROIDES
    loop_asteroides:
        SUB R0, 1
        CALL asteroides
        CMP R0, 0
        JNZ loop_asteroides
    CALL energia_nave 

    CALL login_actions

fim:
    JMP fim     ; fim do programa 
    
; *****************************************************
;   REALIZA_ACAO:
;       - funcao que realiza uma acao de acordo com o comando pressionado
; *****************************************************

login_actions:
    MOV R0, [tecla_carregada]
    MOV R1, START_GAME
    CMP R0, R1
    JNZ login_actions
    CALL init_game
    in_game:
        MOV R0, [tecla_carregada]
        MOV R1, PAUSE_GAME
        CMP R1, R0
        JZ pausa_jogo
        MOV R1, END_GAME
        CMP R1, R0
        JZ termina_jogo
        JMP in_game

pausa_jogo:
    MOV R2, GAME_STATE
    MOV R3, PAUSED_GAME
    MOV [R2], R3
    MOV R3, IN_GAME_BACKGROUND
    MOV [PAUSA_MEDIA], R3
    MOV R3, IN_GAME_OST
    MOV [PAUSA_MEDIA], R3

    pausa_aux:
        MOV R0, [tecla_carregada]
        MOV R1, END_GAME
        CMP R1, R0
        JZ termina_jogo
        MOV R1, PAUSE_GAME
        CMP R1, R0
        JNZ pausa_aux
    unpause:
        MOV R3, IN_GAME
        MOV [R2], R3
        MOV R3, IN_GAME_BACKGROUND
        MOV [RETOME_MEDIA], R3
        MOV R3, IN_GAME_OST
        MOV [RETOME_MEDIA], R3
        JMP in_game

termina_jogo:
    MOV R2, GAME_STATE
    MOV R3, ENDED_GAME
    MOV [R2], R3
    MOV R3, IN_GAME_BACKGROUND
    MOV [TERMINA_MEDIA], R3
    MOV R3, IN_GAME_OST
    MOV [TERMINA_MEDIA], R3
    MOV R3, END_GAME_BACKGROUND
    MOV [SELECIONA_CENARIO_FUNDO], R3
    MOV R3, GAME_OVER
    MOV [REPRODUCAO_MEDIA], R3
    JMP login_actions

loss_by_colision:
    MOV R2, GAME_STATE
    MOV R3, ENDED_GAME
    MOV [R2], R3
    MOV R3, IN_GAME_BACKGROUND
    MOV [TERMINA_MEDIA], R3
    MOV R3, IN_GAME_OST
    MOV [TERMINA_MEDIA], R3
    MOV R3, LOSS_COLISION_BACKGROUND
    MOV [SELECIONA_CENARIO_FUNDO], R3
    MOV R3, COLLISION_EFFECT
    MOV [REPRODUCAO_MEDIA], R3
    JMP login_actions

;*********************************************************
;   
;
;*********************************************************

aumentar_energia:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R5

    MOV R0, DISPLAYS  ; endereço do periférico dos displays
    MOV R1, DISPLAY     ; guardamos em R6 o enderenco com as informacoes relacionadas com o Display
    MOV R2, [R1]
    MOV [R0], R2

    ADD R2, 5 ; adicionamos ao valor do display uma unidade
    ADD R2, 5 ; adicionamos ao valor do display uma unidade
    ADD R2, 5 ; adicionamos ao valor do display uma unidade
    ADD R2, 5 ; adicionamos ao valor do display uma unidade
    ADD R2, 5 ; adicionamos ao valor do display uma unidade
    CALL hexa_para_decimal 
    MOV [R1], R2    ; atualizamos a variavel com o numero do display
    MOV [R0], R5    ; atualizamos o display

    POP R5
    POP R2
    POP R1
    POP R0
    RET

diminuir_energia:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R5

    MOV R0, DISPLAYS  ; endereço do periférico dos displays
    MOV R1, DISPLAY     ; guardamos em R6 o enderenco com as informacoes relacionadas com o Display
    MOV R2, [R1]
    MOV [R0], R2

    SUB R2, 5   ; retiramos ao valor do display uma unidade
    CALL hexa_para_decimal
    MOV [R1], R2  ; atualizamos a variavel com o numero do display
    MOV [R0], R5    ; atualizamos o display

    POP R5
    POP R2
    POP R1
    POP R0
    RET


;*********************************************************
;   
;
;*********************************************************

hexa_para_decimal:
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    
    MOV R1, 1000
    MOV R4, 10
    MOV R5, 0

    hexa_para_decimal_loop:
        MOD R2, R1
        DIV R1, R4
        CMP R1, 0 
        JZ ret_hexa_para_decimal
        MOV R3, R2
        DIV R3, R1
        SHL R5, 4 
        OR R5, R3 
        JMP hexa_para_decimal_loop

    ret_hexa_para_decimal:
        POP R4
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
    PUSH R1


    MOV [TERMINA_TODA_MEDIA], R0
    MOV R0, IN_GAME_OST ; guarda-se em R0 a musica que ira ser reproduzida no jogo
    MOV [LOOP_REPRODUCAO_MEDIA], R0 ; reproduz-se a musica registada em R0 em loop
    MOV [APAGA_CENARIO_FUNDO], R0   ; Apaga o cenario de fundo atual o valor de R0 não e importante
    MOV R0, IN_GAME_BACKGROUND  ; guarda em R0 o valor do fundo ( em formato de video ) a ser usado no jogo
    MOV [LOOP_REPRODUCAO_MEDIA], R0 ; reproduz-se o video, usado como fundo, em loop
    MOV R0, GAME_STATE
    MOV R1, IN_GAME
    MOV [R0], R1

    POP R1
    POP R0
    RET

verifica_pausa:
    PUSH R0
    PUSH R1

    MOV R0, GAME_STATE
    verifica_pausado:
        MOV R1, [R0]
        CMP R1, PAUSED_GAME
        JNZ fim_verificacao
        pausado:
            MOV R0, [tecla_carregada]
            MOV R1, END_GAME
            CMP R1, R0
            JZ fim_verificacao
            MOV R1, PAUSE_GAME
            CMP R1, R0
            JNZ pausado
    fim_verificacao:
        POP R1
        POP R0
        RET

verifica_fim:
    PUSH R0
    MOV R8, FALSE
    MOV R0, [GAME_STATE]
    CMP R0, ENDED_GAME
    JNZ verifica_aux
    MOV R8, TRUE
    verifica_aux:
        POP R0
        RET

; *****************************************************
;   INIT_GAME:
;       - funcao que comeca o jogo
; *****************************************************
reinicia_posicao:
    PUSH R0
    PUSH R1
    PUSH R7

    MOV R1, [R7]  ; guarda-se o valor da linha do ponto de referencia inicial da sonda
    MOV [R0], R1    ; atualizamos a linha do ponto de referencia da posicao da sonda para a inicial
    ADD R0, 2   ; obtemos o endereço com a informacao relacionada com a coluna atual do ponto de referencia da sonda
    ADD R7, 2
    MOV R1, [R7] ; guarda-se o valor da coluna do ponto de referencia inicial da sonda
    MOV [R0], R1    ; atualizamos a coluna do ponto de referencia da posicao da sonda para a inicial

    POP R7
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
;   DECREMENTA_VERTICAL e INCREMENTA_HORIZONTAL:
;       - funcoes que in/decrementam a posicao do objeto
;           no respetivo sentido
; *****************************************************

incrementa_posicao:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R5

    MOV R1, [R5]
    MOV R2, [R0]
    ADD R1, R2
    MOV [R0], R1

    ADD R0, 2
    ADD R5, 2

    MOV R1, [R5]
    MOV R2, [R0]
    ADD R1, R2
    MOV [R0], R1

    POP R5
    POP R2
    POP R1
    POP R0
    RET
    
; *****************************************************
;   DESENHA_OBJETO e APAGA_OBJETO:
;       - funcoes responsaveis por desenhar/apagar um
;       objeto generico dadas as suas medidas e formato
; *****************************************************

desenha_objeto:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3
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
    POP R3
    POP R2
    POP R1
    POP R0
    RET

apaga_objeto:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3
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
    POP R3
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

; *****************************************************
;   DESENHA_OBJETO e APAGA_OBJETO:
;       - funcoes responsaveis por desenhar/apagar um
;       objeto generico dadas as suas medidas e formato
; *****************************************************

aleatoriedade_asteroides: 
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R4

    MOV  R2, TEC_COL   ; endereço do periférico das colunas
    MOVB R1, [R2] 
    SHR R1, 4       ; Isolamos os 4 bits de maior peso
    MOV R2, R1      ; guardamos um resultado num registo intermedio
    cria_tipo:
        SHR R2, 2       ; obtemos um numero com apenas os 2 bits ( 0 - 3 ) de menor peso (25% de calhar cada numero)
        CMP R2, 0       ; Verificamos se o numero obtido corresponde ao numero do mineravel ( 25% chance de calhar )
        JZ cria_mineravel
        MOV R3, DEF_ASTEROIDE
        JMP cria_direcao
        cria_mineravel:
            MOV R3, DEF_MINERAVEL

    cria_direcao:
        MOV R4, 5
        MOD R1, R4       ; obtemos um valor de ( 0 - 4 ), pseudo-aleatorio (20% de calhar cada numero)
        SHL R1, 2
        MOV R2, par_direcao_coluna
        ADD R2, R1
        atualiza_direcao:
            MOV R4, [R2]
            SHL R4, 2
            MOV R5, DIRECOES_ASTEROIDES
            ADD R5, R4
        atualiza_coluna:
            ADD R2, 2
            ADD R0, 2
            MOV R4, [R2]
            MOV [R0], R4
    SUB R0, 2

    POP R4
    POP R2
    POP R1
    POP R0
    RET


confirma_estado:
    PUSH R9
    confirma_aux:
        YIELD
        MOV R9, [GAME_STATE]
        CMP R9, IN_GAME
        JNZ confirma_aux
    POP R9
    RET
; *****************************************************
;   DESENHA_OBJETO e APAGA_OBJETO:
;       - funcoes responsaveis por desenhar/apagar um
;       objeto generico dadas as suas medidas e formato
; *****************************************************

; **********************************************************************
; Processo
;
; TECLADO - Processo que deteta quando se carrega numa tecla na 4ª linha
;		  do teclado e escreve o valor da coluna num LOCK.
;
; **********************************************************************

PROCESS SP_inicial_teclado

teclado:	
    MOV  R1, ULTIMA_LINHA_TECLADO   ; guardamos a ultima linha	
    MOV  R2, TEC_LIN   ; endereço do periférico das linhas
    MOV  R3, TEC_COL   ; endereço do periférico das colunas
    MOV  R5, MASCARA   ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado

espera_tecla:          ; neste ciclo espera-se ate uma tecla ser premida

    WAIT

    MOVB [R2], R1      ; escrever no periferico de saida (linhas)
    MOVB R0, [R3]      ; ler do periferico de entrada (colunas)
    AND  R0, R5        ; elimina bits para alem dos bits 0-3
    CMP  R0, 0         ; ha tecla premida?
    JZ proxima_linha_teclado    ; se não houve tecla premida, passemos para a proxima linha a varrer
    CALL calcula_tecla
    MOV [tecla_carregada], R7
    JMP ha_tecla

proxima_linha_teclado:
    SHR R1, 1
    CMP R1, 0
    JNZ espera_tecla
    MOV R1, ULTIMA_LINHA_TECLADO
    JMP espera_tecla

ha_tecla:

    YIELD

    MOVB [R2], R1      ; escrever no periférico de saída (linhas)
    MOVB R0, [R3]      ; ler do periférico de entrada (colunas)
    AND  R0, R5        ; elimina bits para além dos bits 0-3
    CMP  R0, 0         ; há tecla premida?
    JNZ  ha_tecla      ; se ainda houver uma tecla premida, espera até não haver
    JMP espera_tecla

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

; **********************************************************************
; Processo
;
; sonda_frontal - Processo que deteta quando se carrega numa tecla na 4ª linha
;		  do teclado e escreve o valor da coluna num LOCK.
;
; **********************************************************************

PROCESS SP_inicial_sonda

sondas:
    MOV R1, TAMANHO_PILHA
    MUL R1, R0
    SUB SP, R1
    
    MOV R6, R0
    SHL R6, 1
    MOV R8, R6     ; guardamos a iteracao para uma tabela de 1 word por linha
    MOV R9, COMANDOS_DISPARO
    MOV R10, [R9 + R6]
    SHL R6, 1
    MOV R7, posicoes_iniciais_sondas
    ADD R7, R6

    move_sonda:
        MOV R4, ECRA_NAVE  ; guardamos o ecra onde sera desenhado o asteroide
        MOV R0, REFERENCIA_SONDAS
        ADD R0, R6
        MOV R5, direcoes_sondas
        ADD R5, R6
        MOV R3, DEF_SONDA
        MOV R11, MOVIMENTOS_SONDA
    espera_disparo:
        CALL confirma_estado
        MOV R9, [tecla_carregada]
        CMP R9, R10
        JNZ espera_disparo
        MOV [SELECIONA_ECRA], R4    ; selecionamos o ecra
        MOV R1, [R11 + R8]
        CALL diminuir_energia
    desenha_sonda:
        MOV [R11 + R8], R1
        CALL desenha_objeto
        MOV R2, [eventos_int + 2]

        CALL verifica_pausa

        PUSH R8
        CALL verifica_fim
        CMP R8, TRUE
        POP R8
        JZ reinicia_sonda

        MOV [SELECIONA_ECRA], R4    ; selecionamos o ecra
        CALL apaga_objeto
        CALL incrementa_posicao
        MOV R1, [R11 + R8]
        SUB R1, 1
        JNZ desenha_sonda
        reinicia_sonda:
            CALL apaga_objeto
            MOV R9, MAXIMO_MOVIMENTOS
            MOV [R11 + R8], R9
            CALL reinicia_posicao
            MOV [SELECIONA_ECRA], R4    ; selecionamos o ecra
            CALL desenha_objeto
            JZ espera_disparo

; **********************************************************************
; Processo
;
; sonda_frontal - Processo que deteta quando se carrega numa tecla na 4ª linha
;		  do teclado e escreve o valor da coluna num LOCK.
;
; **********************************************************************

PROCESS SP_inicial_asteroide

asteroides:
    MOV R1, TAMANHO_PILHA   ; Guardamos o tamanha de cada pilha
    MUL R1, R0      ; multiplicamos pela instancio do asteroide
    SUB SP, R1      ; obtemos um registo SP de cada processo instanciado
    
    MOV R4, ECRA_ASTEROIDE  ; guardamos o numero do ecra inicial do asteroide
    ADD R4, R0  ; obtemos o numero do ecra a ser usado para devida instancia do asteroide
    MOV R7, posicao_generica_asteroide  ; guardamos a referencia à posicao generica de cada asteroide ( comecam na mesma linha )
    MOV R6, R0  ; guardamos o numero da instancia
    SHL R6, 2   ; multiplicamos por 4 porque cada tabela tem 2 colunas de WORDS ( 4 bytes )
        
    move_asteroide:
        CALL confirma_estado
        MOV R8, FALSE   ; registo usado para detetar colisoes/desfazamentos da tela
        MOV [SELECIONA_ECRA], R4    ; selecionamos o ecra onde iremos desenhar cada instancia de asteroide
        MOV R5, DIRECOES_ASTEROIDES ; obtemos a referencia das direcoes e posicoes possiveis de cada asteroide
        MOV R0, REFERENCIA_ASTEROIDES   ; obtemos o enderenco onde se guarda as posicoes dos asteroides
        ADD R0, R6  ;   obtemos o enderenco onde iremos guardar a posicao desta instancia de asteroide
        CALL aleatoriedade_asteroides   ; "baralhamos" a posicao e direcao inicial desta instancia de asteroide

    desenha_asteroide:
        CALL desenha_objeto 
        MOV R2, [eventos_int + 0]
        CALL verifica_pausa
        MOV [SELECIONA_ECRA], R4    ; selecionamos o ecra
        CALL apaga_objeto

        CALL verifica_fim
        CMP R8, TRUE
        JZ reseta_asteroide

        CALL incrementa_posicao

        CALL testa_colisao
        CMP R8, TRUE
        JZ direciona_explosao

        CALL testa_limites
        CMP R8, TRUE
        JNZ desenha_asteroide

        JMP reseta_asteroide
        direciona_explosao:
            PUSH R1
            MOV R1, DEF_MINERAVEL
            CMP R1, R3
            JZ consome
            JNZ explosao
            POP R1
        reseta_asteroide:
            CALL reinicia_posicao
            JMP move_asteroide

explosao:
    PUSH R3

    MOV R3, EXPLOSION_EFFECT
    MOV [REPRODUCAO_MEDIA], R3
    MOV R3, DEF_EXPLOSAO
    CALL desenha_objeto
    MOV R2, [eventos_int + 0]
    MOV [SELECIONA_ECRA], R4    ; selecionamos o ecra
    CALL apaga_objeto
    POP R3

    JMP reseta_asteroide

consome:
    PUSH R3
    PUSH R5
    PUSH R6

    MOV R5, CONSOME_EFFECT
    MOV [REPRODUCAO_MEDIA], R5
    loop_consome:
        MOV R6, ANIMACOES_CONSOME
        MOV R5, N_ANIMACOES_CONSOME
        SHL R5, 1
        loop_aux:
            MOV R3, [R6 + R5]
            CALL desenha_objeto
            MOV R2, [eventos_int + 0]
            CALL verifica_pausa
            MOV [SELECIONA_ECRA], R4    ; selecionamos o ecra
            CALL apaga_objeto
            SUB R5, 2
            CMP R5, 0
            JGE loop_aux

    CALL aumentar_energia

    POP R6
    POP R5
    POP R3
    JMP reseta_asteroide

; **********************************************************************
; Processo
;
; sonda_frontal - Processo que deteta quando se carrega numa tecla na 4ª linha
;		  do teclado e escreve o valor da coluna num LOCK.
;
; **********************************************************************

PROCESS SP_inicial_displays

energia_nave:
    MOV R0, DISPLAYS  ; endereço do periférico dos displays
    MOV R1, DISPLAY     ; guardamos em R6 o enderenco com as informacoes relacionadas com o Display
    MOV R2, [R1]
    CALL hexa_para_decimal
    MOV [R0], R5
    espera_interrupcao:
        CALL confirma_estado
        MOV R4, [eventos_int + 4]
        CALL verifica_pausa
        CALL verifica_fim
        CMP R8, TRUE
        JZ espera_interrupcao
    diminuir_unidade:
        MOV R2, [R1]
        SUB R2, 3   ; adicionamos ao valor do display uma unidade 
        CALL hexa_para_decimal
        MOV [R1], R2    ; atualizamos a variavel com o numero do display
        MOV [R0], R5    ; atualizamos o display
        JMP espera_interrupcao

; **********************************************************************
; Processo
;
; sonda_frontal - Processo que deteta quando se carrega numa tecla na 4ª linha
;		  do teclado e escreve o valor da coluna num LOCK.
;
; **********************************************************************

PROCESS SP_inicial_nave

desenha_nave:
    MOV R4, ECRA_NAVE  ; guardamos o ecra onde sera desenhado o asteroide
    MOV R0, REFERENCIA_NAVE
    loop_painel:
        CALL confirma_estado
        MOV [SELECIONA_ECRA], R4    ; selecionamos o ecra
        MOV R3, DEF_NAVE
        MOV R6, ANIMACOES_NAVE
        MOV R5, N_ANIMACOES_NAVE
        SHL R5, 1
        painel_instrumentos:
            MOV R3, [R6 + R5]
            MOV R2, [eventos_int + 6]
            CALL verifica_pausa

            CALL verifica_fim
            CMP R8, TRUE
            JZ apaga_nave

            MOV [SELECIONA_ECRA], R4    ; selecionamos o ecra
            CALL desenha_objeto
            SUB R5, 2
            CMP R5, 0
            JGE painel_instrumentos
            JMP loop_painel

    apaga_nave:
        MOV [SELECIONA_ECRA], R4    ; selecionamos o ecra
        MOV R0, REFERENCIA_NAVE
        MOV R3, DEF_NAVE
        CALL apaga_objeto
        JMP loop_painel
    
; *****************************************************
;   DESENHA_OBJETO e APAGA_OBJETO:
;       - funcoes responsaveis por desenhar/apagar um
;       objeto generico dadas as suas medidas e formato
; *****************************************************  	

testa_limites:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3

    MOV R8, FALSE
    teste_limite_inferior:
        ADD R3, 2
        MOV R1, [R0]
        MOV R2, [R3]
        SUB R1, R2
        MOV R2, MAX_LINHA
        CMP R1, R2
        JGT reseta
    testa_limite_direito:		; vê se o boneco chegou ao limite direito
        ADD R0, 2
        MOV R1, [R0]
        MOV	R2, MAX_COLUNA
        CMP R1, R2
        JGT	reseta	; entre limites. Mantém o valor do R7
    testa_limite_esquerdo:		; vê se o boneco chegou ao limite esquerdo
        SUB R3, 2
        MOV R2, [R3]
        ADD R1, R2
        MOV	R2, MIN_COLUNA
        CMP R1, R2
        JLE	reseta
        JMP sai_testa_limites
    reseta:
        MOV R8, TRUE
    sai_testa_limites:	
        POP R3
        POP	R2
        POP	R1
        POP R0
        RET

; *****************************************************
;   DESENHA_OBJETO e APAGA_OBJETO:
;       - funcoes responsaveis por desenhar/apagar um
;       objeto generico dadas as suas medidas e formato
; ***************************************************** 

testa_colisao:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R4
    PUSH R6
    PUSH R9

    MOV R4, COLUNA_REF_ASTEROIDE_MEIO   ; guardamos a coluna "a meio " da tela
    MOV R1, [R0]    ; guardamos a linha do ponto de referencia da instancia do asteroide
    ADD R0, 2       ; obtemos o enderenco para a coluna de referencia da instancia do asteroide
    MOV R2, [R0]    ; guardamos a coluna de referencia do asteroide
    CMP R2, R4      ; comparamamos com a coluna do meio
    JLT colide_sonda_esquerda   ; se o asteroide encontra-se no lado esquerdo do ecra
                                ; então so pode colidir com a sonda da esquerda
    JGT colide_sonda_direita    ; se o asteroide encontrar-se no lado direito do ecra
                                ; entao so pode colidr com a sonda da direita
    colide_sonda_meio:       ; caso contrario pode colidir com as 3 sondas depende da direcao
        ADD R5, 2   ; obtemos a referencia do incremento na coluna do asteroide
        MOV R4, [R5]    ; guardamos o incremnto na coluna do asteroide
        SUB R5, 2   ; resetamos o enderenço
        CMP R4, 0   ; comparamos o incremento na coluna com o "sem incremento"
        JLT colide_sonda_esquerda   ; se o resultado for menor quer dizer
                                    ; que o asteroide está se a mover para a esquerda
                                    ; logo so pode ser atingido pelo sonda esquerda
        JGT colide_sonda_direita    ; pelo contrario se for maior o asteroide ta a ir para a direita
                                    ; logo so pode ser atingido pela sonda direita
        ; caso contrario so pode ser atingido pelo coluna do meio
        MOV R4, REFERENCIA_SONDAS   ; obtemos as referencias das sondas
        MOV R6, LINHA_SONDA_FRONTAL ; obtemos a linha da tabela da sonda frontal
        SHL R6, 2   ; Multiplicamos por 4 porque cada tabela tem 2 colunas ( 2 WORDS - 4 Bytes )
        ADD R4, R6  ; Obtemos a referencia da sonda frontal
        MOV R9, LINHA_SONDA_FRONTAL
        JMP testa_e_sai
    colide_sonda_direita:   ; so pode colidir com a sonda da esquerda
        MOV R4, REFERENCIA_SONDAS   ; obtemos as referencias das sondas
        MOV R6, LINHA_SONDA_DIREITA ; obtemos a linha da tabela da sonda direita
        SHL R6, 2 ; Multiplicamos por 4 porque cada tabela tem 2 colunas ( 2 WORDS - 4 Bytes )
        ADD R4, R6  ; Obtemos a referencia da sonda da direita
        MOV R9, LINHA_SONDA_DIREITA
        JMP testa_e_sai
    colide_sonda_esquerda:    ; so pode colidir com a sonda da direita
        MOV R4, REFERENCIA_SONDAS   ; obtemos as referencias da sonda esquerda
        MOV R6, LINHA_SONDA_ESQUERDA ; obtemos a linha da tabela da sonda esquerda
        SHL R6, 2 ; Multiplicamos por 4 porque cada tabela tem 2 colunas ( 2 WORDS - 4 Bytes )
        ADD R4, R6  ; Obtemos a referencia da sonda da esquerda
        MOV R9, LINHA_SONDA_ESQUERDA
    testa_e_sai:
        CALL testa_colisao_aux
        POP R9
        POP R6
        POP R4
        POP R2
        POP R1
        POP R0
        RET

testa_colisao_aux:
    PUSH R0
    PUSH R3
    PUSH R4
    PUSH R6
    PUSH R7

    MOV R8, FALSE
    testa_linhas:
        MOV R0, [R4]
        CMP R0, R1
        JGT fim_teste_aux
        ADD R3, 2
        MOV R6, [R3]
        SUB R1, R6
        CMP R0, R1
        JLT fim_teste_aux
    testa_colunas:
        ADD R4, 2
        MOV R0, [R4]
        SUB R4, 2
        CMP R0, R2
        JLT fim_teste_aux
        SUB R3, 2
        MOV R6, [R3]
        ADD R2, R6
        CMP R0, R2
        JGT fim_teste_aux
        MOV R8, TRUE
        CALL testa_colisao_nave
        MOV R0, MOVIMENTOS_SONDA
        SHL R9, 1       ; iremos trabalhar com tabelas de 1 coluna ( 1 WORD )
        ADD R0, R9
        MOV R3, 1
        MOV [R0], R3     ; reseta os movimentos da sonda ( 1 porque o ultimo movimento e o resetar da sonda )

    fim_teste_aux:
        POP R7
        POP R6
        POP R4
        POP R3
        POP R0
        RET

testa_colisao_nave:
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R9

    SHL R9, 2   ; Multiplicamos por 4 porque iremoas trabalhar com tabelas de 2 colunas
    MOV R1, posicoes_iniciais_sondas
    ADD R1, R9
    MOV R2, [R1]
    MOV R3, [R4] 
    CMP R2, R3
    JZ call_loss
    JNZ end_test
    call_loss:
        CALL loss_by_colision
    end_test:
        POP R9
        POP R3
        POP R2
        POP R1
        RET


; **********************************************************************
; ROT_INT_0 - 	Rotina de atendimento da interrupção 0
;			Faz simplesmente uma escrita no LOCK que o processo boneco lê.
;			Como basta indicar que a interrupção ocorreu (não há mais
;			informação a transmitir), basta a escrita em si, pelo que
;			o registo usado, bem como o seu valor, é irrelevante
; **********************************************************************

rot_int_0:
	PUSH R1
	MOV  R1, eventos_int
	MOV	[R1+0], R0	; desbloqueia processo boneco (qualquer registo serve) 
	POP	R1
	RFE

; **********************************************************************
; ROT_INT_1 - 	Rotina de atendimento da interrupção 1
;			Faz simplesmente uma escrita no LOCK que o processo boneco lê.
;			Como basta indicar que a interrupção ocorreu (não há mais
;			informação a transmitir), basta a escrita em si, pelo que
;			o registo usado, bem como o seu valor, é irrelevante
; **********************************************************************

rot_int_1:
	PUSH	R1
	MOV  R1, eventos_int
	MOV	[R1+2], R0	; desbloqueia processo boneco (qualquer registo serve)
					; O valor a somar ao R1 (base da tabela dos LOCKs) é
					; o dobro do número da interrupção, pois a tabela é de WORDs
	POP	R1
	RFE

; **********************************************************************
; ROT_INT_2 - 	Rotina de atendimento da interrupção 2
;			Faz simplesmente uma escrita no LOCK que o processo boneco lê.
;			Como basta indicar que a interrupção ocorreu (não há mais
;			informação a transmitir), basta a escrita em si, pelo que
;			o registo usado, bem como o seu valor, é irrelevante
; **********************************************************************

rot_int_2:
	PUSH	R1
	MOV  R1, eventos_int
	MOV	[R1+4], R0	; desbloqueia processo boneco (qualquer registo serve)
					; O valor a somar ao R1 (base da tabela dos LOCKs) é
					; o dobro do número da interrupção, pois a tabela é de WORDs
	POP	R1
	RFE

; **********************************************************************
; ROT_INT_3 - 	Rotina de atendimento da interrupção 3
;			Faz simplesmente uma escrita no LOCK que o processo boneco lê.
;			Como basta indicar que a interrupção ocorreu (não há mais
;			informação a transmitir), basta a escrita em si, pelo que
;			o registo usado, bem como o seu valor, é irrelevante
; **********************************************************************

rot_int_3:
	PUSH	R1
	MOV  R1, eventos_int
	MOV	[R1+6], R0	; desbloqueia processo boneco (qualquer registo serve)
					; O valor a somar ao R1 (base da tabela dos LOCKs) é
					; o dobro do número da interrupção, pois a tabela é de WORDs
	POP	R1
	RFE
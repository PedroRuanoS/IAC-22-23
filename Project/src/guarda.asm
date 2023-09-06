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
APAGA_CENARIO_FRONTAL EQU COMANDOS + 44H        ; endereço do comando para apagar o cenario frontal
SELECIONA_CENARIO_FRONTAL EQU COMANDOS + 46H    ; endereço do comando para selecionar um cenario frontal
APAGA_CENARIO_FUNDO EQU COMANDOS + 44H  ; apaga o cenário de fundo 
SELECIONA_ECRA EQU COMANDOS + 04H   ; seleciona o ecrã de pixels a usar para o desenho de objetos
REPRODUCAO_MEDIA EQU COMANDOS + 5AH     ; reproduz um video/som selecionado
LOOP_REPRODUCAO_MEDIA EQU COMANDOS + 5CH    ; reproduz um video/som selecionado em loop
TERMINA_MEDIA EQU COMANDOS + 66H     ; corta o volume de um som/video indicado
TERMINA_TODA_MEDIA EQU COMANDOS + 68H
CORTA_VOLUME EQU COMANDOS + 50H     ; corta o volume de todos os sons/videos a reproduzir
RETOMA_VOLUME EQU COMANDOS + 52H    ; retoma o volume de todos os sons/videos pausados
PAUSA_MEDIA EQU COMANDOS + 5EH      ; pausa um video/som 
RETOME_MEDIA EQU COMANDOS + 60H     ; retome um video/som
ECRA_NAVE EQU 0     ; seleciona qual ecra vai ser usado para desenhar a nave e a sonda
ECRA_ASTEROIDE EQU 1    ; seleciona qual ecra vai ser usado para desenhar os asteroides

ENERGIA_NAVE EQU 100  ; inicializa a energia da nave a 100H

INTRO_BACKGROUND EQU 0  ; seleciona o fundo a ser usado como introducao da pagina inicial do jogo
INTRO_OST EQU 0 ; seleciona a musica a ser usada como introducao da pagina inicial do jogo
IN_GAME_BACKGROUND EQU 1    ; seleciona o fundo a ser usado enquanto se joga
END_GAME_BACKGROUND EQU 1   ; seleciona o fundo quando se termina o jogo

LOSS_COLISION_BACKGROUND EQU 4  ; seleciona o background a ser usada apos a colisao de um asteroide com a nave
LOSS_ENERGY_BACKGROUND EQU 2    ;sdleciona o backgorund a ser usado apos perder-se por falta de energia
IN_GAME_OST EQU 2   ; seleciona a musica a ser usada enquanto se joga
END_GAME_OST EQU 3     ; seleciona o efeito sonoro reproduzido quando se move o asteroide
COLLISION_EFFECT EQU 4  ; seleciona o efeito sonoro quando a nave explode
GAME_OVER EQU 5     ; seleciona o efeito sonoro "GAME OVER"
EXPLOSION_EFFECT EQU 6  ; seleciona o efeito sonoro quando se destroi um asteroide normal
CONSOME_EFFECT EQU 7    ; seleciona o efeito sonoro quando se destroi um asteroide mineravel
ELETRIC_EFFECT EQU 8    ; seleciona o efeito sonoro quando se perde por falta de energia
SHOOTING_SOUND EQU 9    ; seleciona o efeito sonoro quando se dispara um sonda
PAUSA_SOUND_EFFECT EQU 10   ; seleciona o efeito sonoro para pausar
UNPAUSE_SOUND_EFFECT EQU 11 ; seleciona o efeito sonoro para despausar
PAUSE_ICON EQU 3    ; seleciona o ICON usado para representar o jogo em pausa

MAXIMO_MOVIMENTOS EQU 12    ; indica o numero de movimentos possiveis de cada sonda

LARGURA_NAVE EQU 15 ; representa a largura da nave
ALTURA_NAVE EQU 8   ; representa a altura da nave
LINHA_REF_NAVE EQU 31   ; linha do ponto de referencia da nave 
COLUNA_REF_NAVE EQU 25  ; coluna do ponto de ferencia da nave

N_ANIMACOES_NAVE EQU 2  ; numero de animacoes da nave
N_ANIMACOES_CONSOME EQU 2   ; numero de animacoes da explosao de um asteroide mineravel

LARGURA_ASTEROIDE EQU 7 ; representa a largura do asteroide
ALTURA_ASTEROIDE EQU 7  ; representa a altura do asteroide
N_ASTEROIDES EQU 4      ; numero total de asteroides

LARGURA_EXPLOSAO EQU 9  ; largura de uma explosao
ALTURA_EXPLOSAO EQU 9   ; altura de uma explosao

LINHA_INICIAL_ASTEROIDES  EQU 2  ; linha inicial generica do ponto de referencia dum asteroide
COLUNA_REF_ASTEROIDE_ESQ EQU -4 ; coluna do ponto de referencia do asteroide esquerdo
COLUNA_REF_ASTEROIDE_MEIO EQU 29    ; coluna do ponto de referencia do asteroide do meio
COLUNA_REF_ASTEROIDE_DIR EQU 62     ; coluna do ponto de referencia do asteroide da direita

LARGURA_SONDA EQU 1 ; representa a largura da sonda
ALTURA_SONDA EQU 1  ; representa a altura da sonda
N_SONDAS EQU 3  ; numero total de sondas

LINHA_REF_SONDA_FR EQU 24   ; linha do ponto de referencia da sonda frontal
COLUNA_REF_SONDA_FR EQU 32  ; coluna do ponto de referencia da sonda frontal
LINHA_REF_SONDA_ESQ EQU 26  ; linha do ponto de referencia da sonda esquerda
COLUNA_REF_SONDA_ESQ EQU 26 ; coluna do ponto de referencia da sonda esquerda
LINHA_REF_SONDA_DIR EQU 26  ; linha do ponto de referencia da sonda direita
COLUNA_REF_SONDA_DIR EQU 38 ; coluna do ponto de referencia da sonda direita

; Representam a linha da respetiva sonda
; nas respetivas tabelas referentes às sondas
LINHA_SONDA_ESQUERDA EQU 0  ; representa o numero da linha da sonda esquerda
LINHA_SONDA_FRONTAL EQU 1   ; representa o numero da linha da sonda frontal
LINHA_SONDA_DIREITA EQU 2   ; representa o numero da linha da sonda direita

MIN_COLUNA		EQU  0		; número da coluna mais à esquerda que o objeto pode ocupar
MAX_COLUNA		EQU  63        ; número da coluna mais à direita que o objeto pode ocupar
MAX_LINHA EQU 31        ; representa o numero da linha maxima
MIN_LINHA EQU 0         ; representa o numero da linha minima 

TRUE EQU 1  ; representa o valor booleano TRUE
FALSE EQU 0 ; representa o valor booleano FALSE

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

DISPARO_ESQUERDO EQU 0  ; tecla para disparar para a esquerda
DISPARO_FRONTAL EQU 1 ; tecla para disparar para a frente
DISPARO_DIREITO EQU 2   ; tecla para dispara para a direita
PAUSE_GAME EQU 0CH ; tecla para asteróide descer na diagonal
START_GAME EQU 0AH ; tecla para começar o jogo
END_GAME EQU 0EH   ; tecla para acabar o jogo

DIRECAO_INF_DIREITO EQU 0   ; representa a direcao para baixo a para a direita
DIRECAO_INF_ESQUERDO EQU 2  ; representa a direcao para baixo e para a esquerda
DIRECAO_INF_MEIO EQU 1  ; representa a direcao para baixo

TAMANHO_PILHA EQU 200H  ; representa o tamanho de cada pilha


IN_GAME EQU 1   ; representa o estado de jogo, in_game
PAUSED_GAME EQU -1  ; repsetna o estado de jogo pausado
ENDED_GAME EQU 2    ; representa o estado de jogo quando se forca o fim
LOSS_COLLISION EQU -2   ; represnta o estado de jogo quando se perde por colisao
NO_ENERGY EQU 3 ; representa o estado de jogo quando se perde por energia

; *********************************************************************
; * Código
; *********************************************************************

    PLACE 0800H

    ; cada pilha irá reservar 512 words

    STACK TAMANHO_PILHA     
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
	WORD rot_int_0  ; representa a interrupcao 
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

ANIMACOES_NAVE: ; contem os enderencos para os bonecos que formarâo a animacao da nave
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

ANIMACOES_CONSOME: ; contem os enderencos para os bonecos que formarâo a animacao
                    ; da explosao de um mineravel
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

DISPLAY:
    WORD ENERGIA_NAVE
COMANDOS_DISPARO:   ;  vetor com os comandos de disparo para o processo "sondas"
                    ;  A respetiva coluna, corresponde à respetiva sonda
                    ;  Ex: Disparo_esquerdo corresponde à sonda esquerda
    WORD DISPARO_ESQUERDO, DISPARO_FRONTAL, DISPARO_DIREITO
GAME_STATE:
    WORD ENDED_GAME

    PLACE 0

; *****************************************************
;   INICIALIZA(...):   
;       - funcoes que inicializam o jogo
; *****************************************************

inicializar_registos: 
    MOV SP, SP_init 
    MOV BTE, tab

inicializar_interrupcoes:   ; Permitimos todas as interrupcoes
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

inicializa_estado:
    MOV R1, ENDED_GAME  ; ao inicializar o estado como ENDED_GAME certificamo-nos
                        ; que no caso de um interrupcao forcado do jogo, os processo
                        ; resetam para o estado inicial
    MOV [GAME_STATE], R1

main: ; corpo principal do programa
    CALL teclado    ; criamos o processo que le o teclado
    CALL desenha_nave   ; criamos o processo que desenha a nave
    MOV R0, N_SONDAS    ; inicializamos o nosso iterador com o numero de sondas
    loop_sondas:    ; por cada sonda existente vamos criar um processo independente
        SUB R0, 1   ; reduzimos o numero de sondas a criar
        CALL sondas ; criamos um processo 
        CMP R0, 0   ; verificamos se já criamos todas as sondas
        JNZ loop_sondas ; senao repete-se o ciclo

    MOV R0, N_ASTEROIDES ; inicializamos o nosso iterador com o numero de asteroides
    loop_asteroides:    ; por cada asteroide vamos criar um processo independente
        SUB R0, 1   ; reduzimos o numero de asteroides a criar
        CALL asteroides ; criamos um processo
        CMP R0, 0   ; verificamos se já criamos todos os asteroides
        JNZ loop_asteroides ; senâo repete-se o ciclo

    CALL energia_nave ; criamos um processo para contar a energia da nave
    CALL login_actions  ; chamamos a rotina que vai realizar as acoes pedidas

fim:
    JMP fim     ; fim do programa 
    
; *****************************************************
;   login_actions:
;       - rotina que realiza uma acao de acordo com a tecla pressionada
; *****************************************************

login_actions:
    MOV R0, [tecla_carregada]   ; espera um tecla do teclado
    MOV R1, START_GAME  ; registamos o comando para comecar o jogo
    CMP R0, R1      ; comparamos a tecla carregado com o comando para iniciar
    JNZ login_actions   ; no caso de a tecla carregada ser diferente do comando
                        ; nao acontece nada, e volta-se a esperar pela tecla
    CALL init_game  ; caso contrario comeca-se o jogo

    in_game:    ; realiza as acoes que podem acontecer dentro do jogo
        MOV R0, [tecla_carregada]   ; espera um tecla do teclado
        MOV R1, PAUSE_GAME  ; registamos o comando para pausar o jogo
        CMP R1, R0  ; comparamos com a tecla carregada
        JZ pausa_jogo   ; caso sejam iguais, pausa-se o jogo
        MOV R1, END_GAME    ; caso contrario registamos o comando para terminar o jogo
        CMP R1, R0  ; comparaos com a tecla carregada
        JZ termina_jogo ; caso sejam iguais
        JMP in_game ; caso a tecla carregada não seja nenhuma dos comandos mencionados anteriormente
                    ; nao acontece nada e o ciclo repete-se

; *****************************************************
;   pausa_jogo:
;       - rotina que realiza uma acao de acordo com a tecla pressionada
;       - Tem em conta o estado de jogo "EM PAUSA"
; *****************************************************

pausa_jogo: ; pausa o jogo
    MOV R1, PAUSE_ICON  ; selecionamos o numero icone que representa a pausa
    MOV [SELECIONA_CENARIO_FRONTAL], R1 ; selecionamos o respetivo icone como cenario frontal
    MOV R2, PAUSA_SOUND_EFFECT  ; seleciona o numero que representa o som para pausar
    MOV [REPRODUCAO_MEDIA], R2  ; reproduzimos o som
    MOV R2, GAME_STATE  ; guardamos o endereço com os estados de jogo
    MOV R3, PAUSED_GAME ; guardamos o estado de jogo "pausado"
    MOV [R2], R3    ; atualiza-se o estado de jogo na memoria
    MOV R3, IN_GAME_BACKGROUND  ; selecionamos o numero do video que representa o video "in game"
    MOV [PAUSA_MEDIA], R3   ; pausamos o video
    MOV R3, IN_GAME_OST ; selecionamos a musica reproduzida "in game"
    MOV [PAUSA_MEDIA], R3   ; pausamos a musica in game

    pausa_aux:  ; le a tecla carregada e realiza-se uma acao tendo em conta o estado de jogo atual
        MOV R0, [tecla_carregada]   ; le uma tecla carregada
        MOV R1, END_GAME    ; guardamos o comando para acabar o jogo
                            ; ( unico comando com excecao do despausar que pode ser executado )
        CMP R1, R0  ; comparamos com a tecla carregada
        JZ termina_jogo ; no caso se serem iguais termina-se o jogo
        MOV R1, PAUSE_GAME  ; guardamos o comando para pausar o jogo
        CMP R1, R0  ; compara-se com a tecla carregado
        JNZ pausa_aux   ; caso não sejam iguais nâo acontece nada e repete-se o ciclo
    unpause:    ; responsavel por despausar o jogo
        MOV [APAGA_CENARIO_FRONTAL], R3 ; apaga o icon da pausa
        MOV R3, UNPAUSE_SOUND_EFFECT    ; seleciona o efeito sonoro para despausar
        MOV [REPRODUCAO_MEDIA], R3  ; reproduz o efeito sonoro
        MOV R3, IN_GAME ; guardamos o estado de jogo, em jogo
        MOV [R2], R3    ; atualziamos o estado de jogo
        MOV R3, IN_GAME_BACKGROUND  ; selecionamos o video que representa o backgorund em jogo
        MOV [RETOME_MEDIA], R3  ; retomamos o video
        MOV R3, IN_GAME_OST ; selecionamos a musica reproduzida em jogo
        MOV [RETOME_MEDIA], R3  ; retomamos a musica
        JMP in_game ; volta-se a funcao que verifica os comandos em jogo

; *****************************************************
;   termina_jogo:
;       - rotina que realiza uma acao de acordo com a tecla pressionada
;       - Tem em conta o estado de jogo "JOGO ACABADO"
;       - direciona para os possiveis cenarios responsaveis por terminar o jogo
; *****************************************************

termina_jogo:   ; funcao responsavel por terminar o jogo e direcionar
                ; para os possiveis cenarios responsaveis por terminar
    MOV R3, IN_GAME_BACKGROUND  ; selecionamos o cenario de fundo que aparece em jogo
    MOV [TERMINA_MEDIA], R3     ; Terminamos a reproducao do video
    MOV R3, IN_GAME_OST     ; selecionamos a musica reproduzida em jogo
    MOV [TERMINA_MEDIA], R3 ; Terminamos a reproducao da musica
    MOV [APAGA_CENARIO_FRONTAL], R2 ; apaga o cenario frontal caso se tenha acabado o jogo na pausa
    MOV [APAGA_ECRÃ], R2    ; apagamos todos os pixeis do ecra
    MOV R2, [GAME_STATE]    ; guardamos o estado de jogo, para analisar a casa do terminar
    CMP R2, LOSS_COLLISION  ; comparamos com a explosao da nave
    JZ loss_by_colision     ; caso a nave tenha explodido direciona para um certo cenario
    CMP R2, NO_ENERGY       ; caso contrario comparamos com a perda total de energia
    JZ loss_by_energy       ; caso se tenha perdido toda a energia direciona para o
                            ; "termina jogo por perda de energia"
    JNZ forced_ending       ; caso contrario forcou-se o terminar jogo
    
; *****************************************************
;   forced_ending / loss_by_colison / loss_by_energy:
;       - funcoes responsaveis por representar os possiveis cenarios
;       - correspondentes aos possiveis eventos que leveram o jogo a terminar
; *****************************************************

forced_ending:  ; caso tenha-se forcado o jogo a termianr
    MOV R2, GAME_STATE  ; guardamos o enderco com o estado de jogo
    MOV R3, ENDED_GAME  ; guarmos o estado de jogo quando se perde
    MOV [R2], R3    ; atualizamos o endereco
    MOV R3, IN_GAME_BACKGROUND  ; selecionamos o cenario de fundo que aparece em jogo
    MOV [TERMINA_MEDIA], R3     ; Terminamos a reproducao do video
    MOV R3, IN_GAME_OST     ; selecionamos a musica reproduzida em jogo
    MOV [TERMINA_MEDIA], R3 ; Terminamos a reproducao da musica
    MOV R3, END_GAME_BACKGROUND ; selecionamos o cenario de fundo quando se forca o terminar jogo
    MOV [SELECIONA_CENARIO_FUNDO], R3   ; representamos o cenrio de fundo
    MOV R3, GAME_OVER   ; seleciona-se o efeito sonoro "GAME OVER"
    MOV [REPRODUCAO_MEDIA], R3  ; reproduz-se o efeito sonoro
    JMP login_actions   ; volta-se as acoes iniciais

loss_by_colision:   ; caso tenha-se perdido por colisao dum asteroide com a nave
    MOV R2, GAME_STATE
    MOV R3, ENDED_GAME
    MOV [R2], R3
    MOV R3, LOSS_COLISION_BACKGROUND    ; selciona o cenario de fundo quando se perde por colisao
    MOV [SELECIONA_CENARIO_FUNDO], R3   ; representa-se o cenario de fundo
    MOV R3, COLLISION_EFFECT    ; seleciona o efeito sonoro de colisao com a nave
    MOV [REPRODUCAO_MEDIA], R3  ; representa-se o efeito sonoro
    JMP login_actions   ; volta-se as acoes inicais

loss_by_energy: ; caso tenha-se perdido por perdido por energia
    MOV R2, GAME_STATE
    MOV R3, ENDED_GAME
    MOV [R2], R3
    MOV R3, LOSS_ENERGY_BACKGROUND  ; selecionamos o cenario de fundo quando se perde por energia
    MOV [SELECIONA_CENARIO_FUNDO], R3   ; representa-se o cenario de fundo
    MOV R3, ELETRIC_EFFECT  ; seleciona-se o efeito sonoro quando se perde por falta de nergia
    MOV [REPRODUCAO_MEDIA], R3  ; representa-se o efeito sonoro
    JMP login_actions   ; volta-se às açôes iniciais


;*********************************************************
;   aumentar_energia / diminuir energia
;       - Funcoes responsaveis por aumentar ou diminuir o
;       - valor do display ( aumentar em 25, diminuir em 5 )
;*********************************************************

aumentar_energia:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R5

    MOV R0, DISPLAYS  ; endereço do periférico dos displays
    MOV R1, DISPLAY     ; guardamos em R1 o enderenco com as informacoes relacionadas com o Display
    MOV R2, [R1]        ; R2 é o valor que está agora no display

    ADD R2, 5 ; adicionamos ao valor do display 5 unidades
    ADD R2, 5 ; adicionamos ao valor do display 5 unidades
    ADD R2, 5 ; adicionamos ao valor do display 5 unidades
    ADD R2, 5 ; adicionamos ao valor do display 5 unidades
    ADD R2, 5 ; adicionamos ao valor do display 5 unidades
    CALL hexa_para_decimal 
    MOV [R1], R2    ; atualizamos a variavel com o numero do display (hexa)
    MOV [R0], R5    ; atualizamos o display (decimal)

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
    PUSH R6

    MOV R6, 0
    MOV R0, DISPLAYS  ; endereço do periférico dos displays
    MOV R1, DISPLAY     ; guardamos em R1 o enderenco com as informacoes relacionadas com o Display
    MOV R2, [R1]        ; R2 é o valor que está agora no display

    CMP R2, 5 ; se R2 for menor que 5, então a energia é zerada
    JLE set_energia_zero_cinco
    SUB R2, 5   ; se não, retiramos ao valor do display 5 unidades
    CALL hexa_para_decimal
    MOV [R1], R2  ; atualizamos a variavel com o numero do display (hexa)
    MOV [R0], R5    ; atualizamos o display (decimal)
    JMP return_diminuir_energia 

    set_energia_zero_cinco:
        MOV [R0], R6    ; zerar display
        MOV [R1], R6    ; zerar varial com o numero do display
        CALL change_no_energy ;perde o jogo

    return_diminuir_energia:
        POP R6
        POP R5
        POP R2
        POP R1
        POP R0
        RET


;*********************************************************
;   hexa_para_decimal:
;       - função que converte um valor hexadécimal para décimal
;       - Argumentos:
;               R2 tem o valor em hexadécimal
;               R5 tem o resultado
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
        MOD R2, R1 ; número = número MOD fator; número é o valor a converter
        DIV R1, R4 ; fator = fator DIV 10; fator de divisão (começar em 1000 decimal)
        CMP R1, 0  ; se fator for 0, termina o loop
        JZ ret_hexa_para_decimal
        MOV R3, R2 ; dígito = número DIV fator; mais um dígito do valor decimal
        DIV R3, R1
        SHL R5, 4 ; resultado = resultado SHL 4; desloca, para dar espaço ao novo dígito
        OR R5, R3 ; resultado = resultado OR dígito; vai compondo o resultado
        JMP hexa_para_decimal_loop

    ret_hexa_para_decimal:
        POP R4
        POP R3
        POP R2
        POP R1
        RET


; *****************************************************
;   INIT_GAME:
;       - funcao que inicializa-se o jogo
; *****************************************************

init_game:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R5

    MOV [TERMINA_TODA_MEDIA], R0    ; Terminamos todos os videos/sons a ser reproduzidos
    MOV R0, IN_GAME_OST ; guarda-se em R0 a musica que ira ser reproduzida no jogo
    MOV [LOOP_REPRODUCAO_MEDIA], R0 ; reproduz-se a musica registada em R0 em loop
    MOV [APAGA_CENARIO_FUNDO], R0   ; Apaga o cenario de fundo atual o valor de R0 não e importante
    MOV R0, IN_GAME_BACKGROUND  ; guarda em R0 o valor do fundo ( em formato de video ) a ser usado no jogo
    MOV [LOOP_REPRODUCAO_MEDIA], R0 ; reproduz-se o video, usado como fundo, em loop
    MOV R1, IN_GAME ; guarda-se o estado de jogo, em jogo
    MOV [GAME_STATE], R1    ; atualize-se o estado de jogo na memoria
    MOV R2, ENERGIA_NAVE    ; guarda-se a energia da nave inicial
    MOV [DISPLAY], R2       ; guarda-se num endereco com a informacao do display
    CALL hexa_para_decimal  ; convertemos a energia em hexadecimal para decimal
    MOV [DISPLAYS], R5      ; represetamos e energia

    POP R5
    POP R2
    POP R1
    POP R0
    RET

; *****************************************************
;   verifica_pausa / verifica_fim / confirma_estado:
;       - funcoes utilizados nos proximos processos
;       - Que verificam o estado de jogo e realizam
;       - acoes depedendo do mesmo
; *****************************************************

verifica_pausa: ; verifica se o jogo esta em pausa
    PUSH R0
    PUSH R1

    MOV R0, GAME_STATE  ; guarda-se o endereço com o estado de jogo
    verifica_pausado:   ; funcao auxiliar para verificar a pausa
        MOV R1, [R0]    ; guarda-se o estado de jogo
        CMP R1, PAUSED_GAME ; compara-se com o estado quando o jogo esta em pausa
        JNZ fim_verificacao ; caso não esteja acaba-se a verificacao
        pausado:    ; caso contario prende-se o processo num ciclo infinito até
                    ; que se despause ou force-se o acabar jogo
            MOV R0, [tecla_carregada]   ; lê a tecla carregada ( BLOQUEIA O PROCESSO ATÉ SE CARREGAR NUMA TECLA )
            MOV R1, END_GAME    ; guardamos o comando para acabar o jogo
            CMP R1, R0          ; verificamos se a tecla carregada é para acabar o jogo
            JZ fim_verificacao  ; caso seja acaba-se a verificacao
                                ; isto acontece porque permite-se acabar o jogo em pausa
            MOV R1, PAUSE_GAME  ; guardamos o comando para pausar/despausar o jogo
            CMP R1, R0      ; comparamos com a tecla carregada
            JNZ pausado     ; caso não sejam iguais recomeça-se o ciclo

    fim_verificacao:    ; acaba-se a verificacao
        POP R1
        POP R0
        RET

verifica_fim:   ; verifica-se o jogo acabou
;-----------------------------------------------------------------------
;    OUTPUT NO R8 -> TRUE se o jogo tiver acabdo ? False, caso contrario
;   Cada processo é que realizará uma certa funcao depedendo do output
;   esta funcao apenas verifica o estado
;-----------------------------------------------------------------------
    PUSH R0

    MOV R8, FALSE   ; Guardamos o resultado inicial como False
    MOV R0, [GAME_STATE]    ; guardamos o estado de jogo atual
    CMP R0, ENDED_GAME  ; verificamos se o jogo acabou
    JNZ verifica_aux    ; caso não, acaba-se a verificacao
    MOV R8, TRUE    ; caso tenha acabado retorna-se TRUE 

    verifica_aux:   ; Funcao auxiliar para acabar o jogo
        POP R0
        RET

confirma_estado:    ; verifica o estado de jogo e caso o jogo não esteja a decorrer
                    ; prende o processo num ciclo infinito ate o estado mudar
    PUSH R9

    confirma_aux:   ; funcao auxiliar para prender o processo
        YIELD   ; permite comutar para outros processos
        MOV R9, [GAME_STATE]    ; guardamos o estado de jogo
        CMP R9, IN_GAME ; verificamos se o jogo está a decorrer
        JNZ confirma_aux    ; caso não esteja repete-se o ciclo

    POP R9
    RET

; *****************************************************
;   Reinicia_posicao:
;       - Funcao que reinicia a posicao de um objeto generico
;       - Argumentos:
;               R7 - Enderenco com o ponto de referencia
;                   onde o objeto será reiniciado
;               R0 - Enderenco com o ponto de referencia
;                   atual do objeto
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


; ********************************************************************************
;   incrementa_posicao:
;       - Funcao que incrementa a posicao de um objeto generico numa certa direcao
;       - Argumentos:
;               R5 - Enderenco com os niveis a incrementar no ponto de referencia
;                   ( Tabela onde a primeira coluna é o incremento na linha e a segunda
;                   coluna o incremento na coluna do objeto generico )
;               R0 - Enderenco com o ponto de referencia
;                   atual do objeto
; ***********************************************************************************

incrementa_posicao:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R5

    MOV R1, [R5]    ; guarda-se o valor a incrementar na linha
    MOV R2, [R0]    ; guarda-se a linha relativo ao ponto de referencia atual do objeto
    ADD R1, R2  ; incrementa-se o  valor
    MOV [R0], R1    ; atualizamos o valor no endereco 

    ADD R0, 2   ; obtemos o endereco para coluna atual do ponto de referencia
    ADD R5, 2   ; obtemos o incremento na coluna atual do ponto de referencia

    MOV R1, [R5]    ; guarda-se o valor a incrementar na coluna
    MOV R2, [R0]    ; obtemos a coluna relativa ao ponto de referencia atual do objeto
    ADD R1, R2  ; incrementa-se o valor
    MOV [R0], R1    ; atualizamos o valor no endereco

    POP R5
    POP R2
    POP R1
    POP R0
    RET
    
; *****************************************************
;   DESENHA_OBJETO e APAGA_OBJETO:
;       - funcoes responsaveis por desenhar/apagar um
;       objeto generico dadas as suas medidas e formato
;       - Argumentos:
;               R3 - Endereco com o formato do objeto
;               R0 - Enderenco com o ponto de referencia
;                   atual do objeto
; *****************************************************

desenha_objeto:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5

    MOV R1, [R0]    ; obtemos a linha do ponto de referencia do objeto
    ADD R0, 2   ; obtemos o endereco para a coluna do ponto de referencia do objeto
    MOV R2, [R0]    ; guardamos a coluna do ponto de referencia do objeto

    MOV R4, [R3]    ; guardamos a largura do objeto
    ADD R3, 2   ; obtemos o enderco para a altura do objeto 
    MOV R5, [R3]    ; guardamos a altura do objeto

    MOV [DEFINE_LINHA], R1 ; seleciona a linha inicial onde será desenhado o objeto

    desenha_linha:
        CALL pinta_linha    ; pinta-se uma linha do objeto
        CALL proxima_linha  ; chama-se a proxima linha a pintar
        CMP R5, 0   ; verificamos se há mais linhas para pintar
        JNZ desenha_linha   ; caso haja mais linhas repete-se o processo

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

    MOV R1, [R0]    ; obtemos a linha do ponto de referencia do objeto
    ADD R0, 2   ; obtemos o endereco para a coluna do ponto de referencia do objeto
    MOV R2, [R0]    ; guardamos a coluna do ponto de referencia do objeto

    MOV R4, [R3]    ; guardamos a largura do objeto
    ADD R3, 2   ; obtemos o enderco para a altura do objeto 
    MOV R5, [R3]    ; guardamos a altura do objeto
    SUB R3, 2   ; resetamos o endereco de para a largura ( nao relevante )

    MOV R0, COR_APAGADO ; guardamos a cor de um pixel "apagado"
    MOV [DEFINE_LINHA], R1 ;seleciona a linha inicial onde irá se apagar o objeto
    
    apaga_linha:
        CALL remove_linha   ; apaga-se uma linha do objeto
        CALL proxima_linha  ; obtem-se a proxima linha a apagar
        CMP R5, 0   ; verifica-se há mais linhas a apagar
        JNZ apaga_linha ; caso haja repete-se o ciclo

    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    POP R0
    RET


; *****************************************************
;   remove_linha / pinta_linha / proxima_linha / proxima_cor:
;       - Funcoes auxiliares usadas pelas funcoes para
;       desenhar/apagar um objeto generico
; *****************************************************

remove_linha:
    PUSH R2
    PUSH R4

    MOV R0, COR_APAGADO     ; guardamos a cor de um pixel "apagado"
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
        CALL proxima_cor        ; chama a proxima cor
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
    ADD R3, 2   ; obtemos o endereco para a cor do proximo pixel
    MOV R0, [R3]    ; guardamos a cor do proximo pixel
    RET

; ********************************************************************************
;   aleatoriedade_asteroides:
;       - Funcao que randomiza o tipo do asteroide ( mineravel ou normal ) e
;         e o direcao e posicao inicial do asteroide
;       ( 25% chance de ser mineravel e 20% chance de cada possibilidade direcao/posicao inicial )
;       - Argumentos:
;               R0 - Enderenco com o ponto de referencia inicial ( generico ) do asteroide
;                       ( os asteroides comecam sempre na mesma linha entao o ponto de referencia generico
;                       é uma linha constante e a coluna a 0 [ vai ser alterada ] )
; ***********************************************************************************

aleatoriedade_asteroides: 
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R4

    MOV  R2, TEC_COL   ; endereço do periférico das colunas
    MOVB R1, [R2]   ; le-mos do periferico ( o bits high nibble são aleatorios )
    SHR R1, 4       ; Isolamos os 4 bits de maior peso
    MOV R2, R1      ; guardamos um resultado num registo intermedio
    cria_tipo:      ; cria o tipo do asteroide ( mineravel ou normal )
        SHR R2, 2       ; obtemos um numero com apenas os 2 bits ( 0 - 3 ) de menor peso (25% de calhar cada numero)
        CMP R2, 0       ; Verificamos se o numero obtido corresponde ao numero do mineravel ( 25% chance de calhar )
        JZ cria_mineravel   ; caso corresponde guardamos o tipo do asteroide como mineravel
        MOV R3, DEF_ASTEROIDE   ; caso contrario é um asteroide normal
        JMP cria_direcao    ; Passamos a randomizar a direcao do asteroide

        cria_mineravel:
            MOV R3, DEF_MINERAVEL

    cria_direcao:   ; cria a posicao inicial e a direcao do asteroide
        MOV R4, 5        ; guardamos o valor de 5, para uso num calculo intermédio
        MOD R1, R4       ; obtemos um valor de ( 0 - 4 ), pseudo-aleatorio (20% de calhar cada numero)
        SHL R1, 2        ; Iremos trabalhar com tabelas de words de 2 colunas
        MOV R2, par_direcao_coluna  ; obtemos a tabela com os pares de direcao/coluna iniciais possiveis
        ADD R2, R1  ; obtemos uma linha aleatoria
        atualiza_direcao:   ; atualizamos a direcao de acordo com a tabela par/direcao ( 1 coluna )
            MOV R4, [R2]    ; guardamos uma linha aleatoria da tabela de direcoes
            SHL R4, 2       ; Iremos trabalhar com tabelas de words de 2 colunas
            MOV R5, DIRECOES_ASTEROIDES ; Endereco para uma tabela com as direcoes linha/coluna possiveis
            ADD R5, R4  ; Obtemos a linha da tabela aleatoriamente
        atualiza_coluna:    ; atualizamos a coluna inicial de acordo com a tabela par/direcao ( 2 coluna )
            ADD R2, 2   ; Obtemos o enderenco para coluna inicial do asteroide
            ADD R0, 2   ; Obtemos o enderenco para coluna atual do asteroide
            MOV R4, [R2]    ; guardamos a coluna gerada aleatoriamente
            MOV [R0], R4    ; atualizamos a coluna   
    SUB R0, 2   ; resetamos o endereco com o ponto de referencia atual

    POP R4
    POP R2
    POP R1
    POP R0
    RET

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

    WAIT                ; Permite comutar para outros processos 

    MOVB [R2], R1      ; escrever no periferico de saida (linhas)
    MOVB R0, [R3]      ; ler do periferico de entrada (colunas)
    AND  R0, R5        ; elimina bits para alem dos bits 0-3
    CMP  R0, 0         ; ha tecla premida?
    JZ proxima_linha_teclado    ; se não houve tecla premida, passemos para a proxima linha a varrer
    CALL calcula_tecla  ; caso tenha-se premido uma tecla, calcula-se o valor da respetiva tecla
    MOV [tecla_carregada], R7   ; atualizamos o endereco com a tecla carregada ( Escreve-se no lock
                                ; entao também desbloqueia-se processos bloqueados )
    JMP ha_tecla    ; verificamos quando o utilizador para de premir a tecla

proxima_linha_teclado:
    SHR R1, 1   ; Passa para outra linha
    CMP R1, 0   ; Verifica-se se ja se varreu todas as linhas
    JNZ espera_tecla    ; caso ainda não se tenha verificado volta-se a esperar pela tecla
    MOV R1, ULTIMA_LINHA_TECLADO    ; caso contrario reseta-se a linha a varrer
    JMP espera_tecla    ; voltamos a esperar pela tecla

ha_tecla:   ; verifica quando o utilizador desprime a tecla

    YIELD               ; permite comutar para outros processos

    MOVB [R2], R1      ; escrever no periférico de saída (linhas)
    MOVB R0, [R3]      ; ler do periférico de entrada (colunas)
    AND  R0, R5        ; elimina bits para além dos bits 0-3
    CMP  R0, 0         ; há tecla premida?
    JNZ  ha_tecla      ; se ainda houver uma tecla premida, espera até não haver
    JMP espera_tecla

; ********************************************************************************
;   calcula_tecla:
;       - Funcao que calcula o valor da tecla premida
;       - Argumentos:
;               R0 - Numero que representa a coluna
;               R1 - Numero que representa a linha
;       - Output:
;               R7 - Contem o valor a tecla em hexadecimal ( 0 - F )
; ***********************************************************************************

calcula_tecla:              ; neste ciclo espera-se até NENHUMA tecla estar premida
    PUSH R1         ; contem o numero que representa a linha
    PUSH R2         ; usado em calculos intermedios

    MOV R2, 4      ; usado para multiplicar o valor da linha por 4 
    CALL converte_linha_coluna  ; converte a linha em (0 - 3)
    MUL R2, R7      ;   guarda-se o resultado num registo intermedio     
    MOV R1, R0      ;   Guarda-se o valor da coluna em R1 para ser passado
                    ;   como argumento para a rotina chamada a seguir
    CALL converte_linha_coluna  ; converte a coluna num valor de ( 0 - 3 )
    ADD R7, R2      ;   Ao resultado dado adiciona-se o resultado dado anteriormente

    POP R2
    POP R1
    RET

; ********************************************************************************
;   converte_linha_coluna:
;       - Funcao que converte a linha/coluna num valor de 0 a 3
;       - Argumentos:
;               R0 - Numero que representa a linha/coluna
;       - Output:
;               R7 - Valor da linha/coluna convertida
; ***********************************************************************************

converte_linha_coluna:
    PUSH R1

    MOV R7, 0       ; inicializamos o output a 0
    converte_aux:   ; funcao auxiliar para converter
        ADD R7, 1   ; incrementamos o numero da linha ( 1 - 4 )
        SHR R1, 1   ; mudamos de linha para a "anterior" ( Ex: 4 linhas -> 3 linhas )
        JNZ converte_aux    ; Caso não se tenha verificado todas as linhas
                            ; repete-se o ciclo

    SUB R7, 1   ; Convertemos o resultado de ( 1 - 4 ) para ( 0 - 3 ). Ex: 4 -> 3 ; 3 -> 2 ....

    POP R1
    RET

; ***************************************************************************************
;
;   NOTA: ( APENAS PARA OS PROCESSOS DAS SONDAS E DOS ASTEROIDES )
;		    Os devidos processos estao preparados para ter várias instâncias (vários
;		    processos serem criados com o mesmo código), com o argumento (R0)
;		    a indicar o número de cada instância. Esse número é usado para
;		    indexar tabelas com informação para cada uma das instâncias,
;		    nomeadamente o valor inicial do SP (que tem de ser único para cada instaância)
;		    e o LOCK que lê à espera que a interrupção respetiva ocorra
;           No caso do processo sondas, as varias instancias sao as três sondas da nave
;           No caso do processo asteroides são os 4 asteroides
;
; **************************************************************************************


; **********************************************************************
; Processo
;
; sondas - Processo responsavel pelas animacoes e acoes relacionadas
;          com as sondas disparadas pela nave. Movimentos das sondas
;          sao marcados por uma interrupcao.
;
; Argumento: R0 - Numero da instancia da sonda
;
; **********************************************************************


PROCESS SP_inicial_sonda

sondas:
    ; Nesta parte iremos instaciar cada objeto com as suas respetivas tabelas e stacks
    MOV R1, TAMANHO_PILHA   ; tamanho em WORDS de cada stack
    MUL R1, R0  ; tamanho da pilha vezes o numero da instancia da sonda
    SUB SP, R1  ; obtem-se a parte respetiva do stack para a dada instancia
    
    ; Cada instancia terá referencias diferentes dependendo do seu número
    MOV R6, R0  ; Guarda-se o valor da instancia 
    SHL R6, 1   ; Iremos trabalhar com tabelas de words de 1 coluna
    MOV R9, COMANDOS_DISPARO    ; guardamos o endereco com os comandos associados a cada instancia
    MOV R10, [R9 + R6]      ; Obtemos o valor do comando respetivo à instancia
    MOV R11, MOVIMENTOS_SONDA   ; obtemos o enderenco com as informacoes dos movimentos das sondas
    ADD R11, R6 ; obtemos o endereco com a informacoes do movimento das respetiva instancia de sonda
    SHL R6, 1   ; Iremos trabalhar com tabelas de words de 2 colunas 
    MOV R7, posicoes_iniciais_sondas    ; guardamos o endereco com as posicoes iniciais
                                        ; de cada instancia da sonda
    ADD R7, R6  ; obtemos o endereco com a posicao inicial da respetiva sonda

    MOV R4, ECRA_NAVE  ; guardamos o ecra onde sera desenhado a sonda
    MOV R0, REFERENCIA_SONDAS   ; obtemos o endereco onde será guardado as posicoes de cada sonda
    ADD R0, R6  ; obtemos o endereco onde será guardado a posicao da respetiva instancia de sonda
    MOV R5, direcoes_sondas ; obtemos o enderenco onde será guardado as direcoes possiveis das sondas
    ADD R5, R6  ; obtemos o endereco com a informacao sobre a direcao tomada pela resptiva instacia de sonda
    MOV R3, DEF_SONDA   ; obtemos o endereco com as informacoes sobre o formato de um sonda ( generico )

    espera_disparo:     ; funcao responsavel por verificar as açoes do utilizador
                        ; e verificar o estado do jogo ( A sonda apenas podes ser disparada
                        ; quando o jogo esta a decorrer ) 

        CALL confirma_estado    ; confirmamos se o jogo está a decorrer
        MOV R9, [tecla_carregada]   ; esperamos input do utilizador
        CMP R9, R10 ; comparamos o input com o comando respetivo para disparar
        JNZ espera_disparo  ; caso seja diferente repete-se o ciclo

        MOV R9, SHOOTING_SOUND  ; caso se dispare uma sonda, seleciona-se um som
        MOV [REPRODUCAO_MEDIA], R9  ; e reproduz-se esse som

        MOV [SELECIONA_ECRA], R4    ; selecionamos o ecra
        MOV R1, [R11]   ; obtemos o maximo de movimentos possiveis da sonda
        CALL diminuir_energia   ; Ao disparar um sonda a nave perde energia

    desenha_sonda:
    
        MOV [R11], R1   ; Atualizamos os movimentos possiveis da sonda
        CALL desenha_objeto ; desenhamos a sonda
        MOV R2, [eventos_int + 2]   ; esperamos a interrupcao ( para realizar o proximo movimento )
        CALL verifica_pausa ; verificamos se o jogo está em pausa

        MOV [SELECIONA_ECRA], R4    ; selecionamos o ecra
        CALL apaga_objeto   ; apagamos a sonda desenhada anteriormente

        CALL verifica_fim   ; verificamos se o jogo acabou ( por colisao, forcado ... )
        CMP R8, TRUE    ; se o jogo estiver acabado ( R8 -> TRUE )
        JZ reinicia_sonda   ; reinicia-se a sonda
        ; caso contrario...
        CALL incrementa_posicao ; incrementamos a sua posicao para a proxima iteracao

        MOV R1, [R11]   ; obtemos o numero de movimentos possiveis
        SUB R1, 1       ; reduzimos o numero de movimentos possveis
        JNZ desenha_sonda   ; repetimos o ciclo se ainda houver mais movimentos

        reinicia_sonda:
            MOV R9, MAXIMO_MOVIMENTOS   ; Guardamos o numero de movimentos que uma sonda pode tomar
            MOV [R11], R9   ; Atualizamos o numero de movimentos possiveis no respetivo endereco
            CALL reinicia_posicao   ; reiniciamos a posicao da sonda para a inicial
            JMP espera_disparo  ; Volta-se a esperar input do utilizador

; **********************************************************************
; Processo
;
; asteroides - Processo responsavel pelas animacoes e acoes relacionadas
;          com os asteroides. Os movimentos dos asteroides
;          sao marcados por uma interrupcao.
;
; Argumento: R0 - Numero da instancia do asteroides
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

    MOV R0, REFERENCIA_ASTEROIDES   ; obtemos o enderenco onde se guarda as posicoes dos asteroides
    ADD R0, R6  ;   obtemos o enderenco onde iremos guardar a posicao desta instancia de asteroide
    CALL reinicia_posicao       ; reiniciamos a posicao de cada asteroide na criacao no caso
                                ; de ter havido um interrupcao repentina do programa que o tenha 
                                ; levado a reiniciar

    move_asteroide:     ; Responsavel por inicializar cada asteroide
                        ; Verificar o estado do jogo ( A sonda apenas podes ser disparada
                        ; quando o jogo esta a decorrer )

        CALL confirma_estado    ; confirmamos se o jogo está a decorrer
        MOV R8, FALSE   ; registo usado para detetar colisoes/desfazamentos da tela
        MOV [SELECIONA_ECRA], R4    ; selecionamos o ecra onde iremos desenhar cada instancia de asteroide
        MOV R5, DIRECOES_ASTEROIDES ; obtemos a referencia das direcoes e posicoes possiveis de cada asteroide
        CALL aleatoriedade_asteroides   ; "baralhamos" a posicao e direcao inicial desta instancia de asteroide

    desenha_asteroide:  ; desenha o movimento do asteroide
        CALL desenha_objeto ; desenha o asteroide
        MOV R2, [eventos_int + 0]   ; esperamos a interrupcao ( para realizar o proximo movimento )
        CALL verifica_pausa ; verificamos se o jogo está em pausa

        MOV [SELECIONA_ECRA], R4    ; selecionamos o ecra
        CALL apaga_objeto   ; apagamos o asteroide

        CALL verifica_fim   ; verificamos se o jogo acabou
        CMP R8, TRUE    ; caso o jogo tenha acabado ( R8 -> TRUE )
        JZ reseta_asteroide ; resetamos o astreroide caso tenha acabado
        ; caso contrario
        CALL incrementa_posicao ; incrementamos a posicao do asteroide para a proxima iteracao
        CALL testa_colisao  ; testamos se na proxima iteracao o asteroide colide
                            ; ( verificando na proxima iteracao reduzimos o delay da explosao
                            ; caso haja colisao, pois "preve" o que vai acontecer )
        CMP R8, TRUE        ; verificamos se há colisao 
        JZ direciona_explosao   ; caso haja explodimos o asteroides

        CALL testa_limites  ; Caso não tenha explodido, verificamos se
                            ; na proxima iteracao o asteroide vai "desaparecer" da tela
        CMP R8, TRUE        ; verificamos se vai desaparecer
        JNZ desenha_asteroide   ; caso não desapareca passa-se para a proxima iteracao
        JMP reseta_asteroide    ; caso contrario reseta-se o asteroide

        direciona_explosao: ; depedendo da colisao ( com a sonda ou com a nave )
                            ; esta funcao vai fazer "desaparecer" o asteroide
            PUSH R1

            MOV R1, [GAME_STATE]    ; guardamos o estado de jogo
            CMP R1, LOSS_COLLISION  ; verificamos se o asteroide tenha colidido com a nave
            JZ reseta_asteroide ; caso se verifique não se gera efeito visual e apenas reseta-se o asteroide
            MOV R1, DEF_MINERAVEL   ; caso contrario, vamos verificar o tipo do asteroide
            CMP R1, R3  ; verificamos se o asteroide é mineravel
            JZ consome  ; caso seja consome-se o asteroide
            JNZ explosao    ; caso contrario explode-se o asteroide

            POP R1

        reseta_asteroide:
            CALL reinicia_posicao   ; resetamos a posicao do asteroide ( para uma posicao generica sem ser aleatoria )
            JMP move_asteroide  ; repetimos o ciclo


; ********************************************************************************
;   explosao / consome :
;       - Funcao responsavel pela animacao de quando se destroi um asteroide
;       - A animacoes depende do tipo de asteroide
;       - Argumentos:
;               R0 - Enderenco com o ponto de referencia do asteroide
; ***********************************************************************************

explosao:
    PUSH R3

    MOV R3, EXPLOSION_EFFECT    ; selecionamos o efeito sonoro responsavel pela explosao do asteroide
    MOV [REPRODUCAO_MEDIA], R3  ; reproduzimos o efeito sonoro
    MOV R3, DEF_EXPLOSAO    ; guardamos o formato da explosao
    MOV [SELECIONA_ECRA], R4    ; selecionamos o ecra
    CALL desenha_objeto ; desenhamos a explosao
    MOV R2, [eventos_int + 0]   ; esperamos a interrupcao ( de modo a que a explosao note-se )
    MOV [SELECIONA_ECRA], R4    ; selecionamos o ecra
    CALL apaga_objeto   ; apagamos a explosao

    POP R3
    JMP reseta_asteroide    ; resetamos o asteroide

consome:
    PUSH R3
    PUSH R5
    PUSH R6

    CALL aumentar_energia   ; no final da energia consome-se a energia do mineravel
    MOV R5, CONSOME_EFFECT  ; selecionamos o efeito sonoro de consumir um asteroide
    MOV [REPRODUCAO_MEDIA], R5  ; reproduzimos esse efeito sonoro
    loop_consome:
        MOV R6, ANIMACOES_CONSOME   ; guardamos um endereco com os formatos dos bonecos
                                    ; associados a consumir um mineravel
        MOV R5, N_ANIMACOES_CONSOME ; guardamos o numero de animacoes de consumir um mineravel
        SHL R5, 1   ; Iremos trabalhar com tabelas de WORDS de 1 coluna
        loop_aux:
            MOV R3, [R6 + R5]   ; Obtemos o boneco a desenhar
            MOV [SELECIONA_ECRA], R4    ; selecionamos o ecra
            CALL desenha_objeto ; desenhamos um frame de consumir
            MOV R2, [eventos_int + 0]   ; esperamos um interrupcao ate realizar a proxima acao
            CALL verifica_pausa ; verificamos se se pausou o jogo enquanto se consomia o mineravel
            MOV [SELECIONA_ECRA], R4    ; selecionamos o ecra
            CALL apaga_objeto   ; apagamos o frame desenhado
            SUB R5, 2   ; reduzimos o numero do frame da animacao
            CMP R5, 0   ; verifica-se se há mais frames a desenhar
            JGE loop_aux    ; caso hajo repete-se o ciclo

    POP R6
    POP R5
    POP R3
    JMP reseta_asteroide    ; resetamos a posicao do asteroide

; **********************************************************************
; Processo
;
; energia_nave - Processo responsavel pelas acoes relacionadas energia da nave
;                A queda da energia periodicamente é marcada por uma interrupcao
;
; **********************************************************************

PROCESS SP_inicial_displays

energia_nave:
    MOV R0, DISPLAYS  ; endereço do periférico dos displays
    MOV R1, DISPLAY     ; guardamos em R6 o enderenco com as informacoes relacionadas com o Display
    MOV R2, [R1]    ; lemos o valor inicial do display
    CALL hexa_para_decimal  ; convertemos o valor em decimal
    MOV [R0], R5    ; Atualizamos o valor nos displays

    espera_interrupcao:
        CALL confirma_estado    ; verifica se o jogo está a decorrer
        MOV R4, [eventos_int + 4]   ; espera pela interrupcao
        CALL verifica_pausa ; verifica se o jogo está em pausa
        CALL verifica_fim   ; verifica se o jogo termina
        CMP R8, TRUE    ; obtem o output da chamada anteroir em R8 e verifica o resultado
        JZ espera_interrupcao   ; caso o jogo tenha acabado repete-se o ciclo e nâo se altera o valor

    diminuir_unidade:   
        MOV R2, [R1]    ; obtemos o valor do atual em hexadecimal 
        CMP R2, 3   ; comparaoms com o ultimo decremento possivel
        JLT set_energia_zero_tres   ; caso o valor seja menor o jogo acaba
        SUB R2, 3   ; caso contrario retiramos ao valor o decremento periodico
        CALL hexa_para_decimal  ; convertemos o valor em decimal
        MOV [R1], R2    ; atualizamos a variavel com o numero do display
        MOV [R0], R5    ; atualizamos o display
        CMP R2, 0   ; verificamos se a energia ao decrementar acabou
        JZ call_no_energy   ; caso a energia tenha acabado acaba-es o jogo
        JMP espera_interrupcao

    set_energia_zero_tres:
        MOV R6, 0   ; guardamos a energia minima 
        MOV [R1], R6    ; atualiamos no endereco com as informacoes do display
        MOV [R0], R6    ; atualizamos o valor no display
        JZ call_no_energy   ; acabmos o jogo

    call_no_energy:
        CALL change_no_energy   ; mudamos o estado para "PERDEU POR ENERGIA"
        CALL waits_for_refuel   ; espera que o jogo comece de novo
        JMP energia_nave        ; resetamos o ciclo


; *****************************************************
;   change_no_energy:
;       - Funcao responsavel por mudar o estado de jogo
;       para PERDEU POR FALTA DE ENERGIA    
; ***************************************************** 

change_no_energy:
    PUSH R0

    MOV R0, NO_ENERGY   ; obtem-se o estado relativo
    MOV [GAME_STATE], R0    ; atualiza-se o estado de jogo relativo na memoria
    MOV R0, END_GAME    ; obtemos o comando para acabar o jogo
    MOV [tecla_carregada], R0   ; forca-se o terminar o jogo

    POP R0
    RET

; *****************************************************
;   change_no_energy:
;       - Funcao responsavel esperar que o jogo comece
;         denovo  
; ***************************************************** 

waits_for_refuel:   ; espero que o jogo comece denovo
    PUSH R0
    PUSH R1

    MOV R1, START_GAME  ; guardamos o comando para comecar o jogo
    waits_aux:
        MOV R0, [tecla_carregada]   ; esperamos input do utilizador
        CMP R0, R1  ; verificamos se a tecla carregada é para comecar o jogo
        JNZ waits_aux   ; se a tecla carregada for diferente do comando para comecar
                        ; nâo acontece nada e repete-se o ciclo
        MOV R1, ENERGIA_NAVE    ; caso contrario, guardamos a energia inicial da nave
        MOV R0, DISPLAY ; guardamos o endereco com as informacoes dos displays
        MOV [R0], R1    ; atualiza o valor da energia na informacoes dos displays
                        ; ( ao inicializar o jogo denovo a energia é resetada nos proprios displays
                        ; logo não e preciso atualzia-la nos displays )
    
    POP R1
    POP R0
    RET

; **********************************************************************
; Processo
;
; desenha_nave - Processo responsavel pelo desenho da nave e pelas respetivas
;                animacoes do painel de instrumentos
;
; **********************************************************************

PROCESS SP_inicial_nave

desenha_nave:
    MOV R4, ECRA_NAVE  ; guardamos o ecra onde sera desenhado o asteroide
    MOV R0, REFERENCIA_NAVE ; obtemos o endereco com o ponto de referencia da nave
    loop_painel:
        CALL confirma_estado    ; confirmamos se o jogo esta a decorrer
        MOV [SELECIONA_ECRA], R4    ; selecionamos o ecra
        MOV R6, ANIMACOES_NAVE  ; obtemos o endereco com os respetivos formatos da nave
        MOV R5, N_ANIMACOES_NAVE    ; obtemos o numero de animacoes da nave
        SHL R5, 1   ; Iremos trabalhar com tabelas de WORDS de 1 coluna
        painel_instrumentos:
            MOV R3, [R6 + R5]   ; obtemos o formata do respetivo frame
            MOV [SELECIONA_ECRA], R4    ; selecionamos o ecra
            CALL desenha_objeto ; desenhamos o frame
            MOV R2, [eventos_int + 6]   ; esperamos a interrupcao respetivo para o proximo frame
            CALL verifica_pausa ; verificamos se se pausou o jogo entretanto

            CALL verifica_fim   ; verificamos se o jogo acabou
            CMP R8, TRUE
            JZ apaga_nave   ; caso tenha acabado apagamos a nave

            SUB R5, 2   ; caso contrario, reduzimos o numero de frames a desenhar
            CMP R5, 0   ; verificamos se já se desenhou todos os frames
            JGE painel_instrumentos ; caso não se tenha desenhado repete-se o ciclo
            JMP loop_painel ; caso contrario voltamos a inicializar as animacoes

    apaga_nave: ; chamada caso o jogo termine
        MOV [SELECIONA_ECRA], R4    ; selecionamos o ecra
        MOV R0, REFERENCIA_NAVE ; obtemos o endereco para o ponto de referencia da nave
        MOV R3, DEF_NAVE    ; obtemos um formato de nave ( generico )
        CALL apaga_objeto   ; apagamos a nave
        JMP loop_painel     ; voltamos a esperar que o jogo comece
    

; **************************************************************************
;   testa_limites
;       - Funcao responsavel por verificar se um asteroide
;       - está no ecrã
;       Argumentos: R0 - Enderenco para o ponto de referencia do asteroide
;                   R3 - Endereco com as informacoes do formato do asteroide
;       OUTPUT: R8 -> True passou dos limites, False se está dentro dos limites
;                     do ecrâ
; **************************************************************************	

testa_limites:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3

    MOV R8, FALSE   ; inicializamos o resultado como FALSE
    teste_limite_inferior:
        ADD R3, 2   ; Obtemos o endereco para a altura do asteroide
        MOV R1, [R0]    ; Guardamos a linha do ponto de referencia do asteroide
        MOV R2, [R3]    ; Guardamos a altura de asteroide
        SUB R1, R2      ; Obtemos a linha mais acima onde o asteroide é desenhado
        MOV R2, MAX_LINHA   ; Guardamos a linha maximo
        CMP R1, R2  ; verificamos se a linha está dentro dos limites
        JGT reseta  ; caso nâo esteja iremos resetar o asteroide
    testa_limite_direito:		; vê se o boneco chegou ao limite direito
        ADD R0, 2   ; Obtemos o endereco para a coluna do ponto de referencia do asteoide
        MOV R1, [R0]    ; Guardamos a coluna do asteroide
        MOV	R2, MAX_COLUNA  ; Guardamos a coluna maxima
        CMP R1, R2  ; comparamos a coluna atual com a maxima coluna
        JGT	reseta	; caso a coluna atual seja maior o asteroide não
                    ; é desenhado no ecra e reseta-se
    testa_limite_esquerdo:		; vê se o boneco chegou ao limite esquerdo
        SUB R3, 2   ; Obtemos o endereco com a largura do asteroide
        MOV R2, [R3]    ; Guardamos a largura do asteroide
        ADD R1, R2  ; Obtemos a coluna maximo onde o asteroide é desenhado
        MOV	R2, MIN_COLUNA  ; guardamos a coluna minima
        CMP R1, R2  ; verificamos se a coluna esta dentro dos limites
        JLE	reseta ; caso nâo esteja iremos resetar o asteroide
        JMP sai_testa_limites   ; caso se passo a todos os teste acaba-se a verificacao
    reseta:
        MOV R8, TRUE    ; informa-se que o asteoroide tem de ser resetado
    sai_testa_limites:	
        POP R3
        POP	R2
        POP	R1
        POP R0
        RET

; *****************************************************
;   testa_colisao / testa_colisao_aux / testa_colisao_nave:
;       - Funcoes responsaveis por testar a colisao do asteroide 
;         com as sondas ou com a nave
;       - Argumentos: R0 - Endereco com o ponto de referencia atual
;                          do asteroide
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
        MOV R9, LINHA_SONDA_FRONTAL ; Movemos a a linha que representa a sonda frontal
                                    ; Na tabela das sondas
        JMP testa_e_sai     ; chamamos a funcao auxiliar
    colide_sonda_direita:   ; so pode colidir com a sonda da direita
        MOV R4, REFERENCIA_SONDAS   ; obtemos as referencias das sondas
        MOV R6, LINHA_SONDA_DIREITA ; obtemos a linha da tabela da sonda direita
        SHL R6, 2 ; Multiplicamos por 4 porque cada tabela tem 2 colunas ( 2 WORDS - 4 Bytes )
        ADD R4, R6  ; Obtemos a referencia da sonda da direita
        MOV R9, LINHA_SONDA_DIREITA ; Movemos a a linha que representa a sonda direita
                                    ; Na tabela das sondas
        JMP testa_e_sai ; chamamos a funcao auxiliar
    colide_sonda_esquerda:    ; so pode colidir com a sonda da esquerda
        MOV R4, REFERENCIA_SONDAS   ; obtemos as referencias da sonda esquerda
        MOV R6, LINHA_SONDA_ESQUERDA ; obtemos a linha da tabela da sonda esquerda
        SHL R6, 2 ; Multiplicamos por 4 porque cada tabela tem 2 colunas ( 2 WORDS - 4 Bytes )
        ADD R4, R6  ; Obtemos a referencia da sonda da esquerda
        MOV R9, LINHA_SONDA_ESQUERDA ; Movemos a a linha que representa a sonda esquerda
                                    ; Na tabela das sondas
    testa_e_sai:
        CALL testa_colisao_aux  ; chamamos a funcao auxiliar
        POP R9
        POP R6
        POP R4
        POP R2
        POP R1
        POP R0
        RET

testa_colisao_aux:
    PUSH R0
    PUSH R3 ; Endereco com as informacoes do formato do asteroide
    PUSH R4 ; ponto de referencia da sonda que o asteroide pode colidir
    PUSH R6
    PUSH R7

    MOV R8, FALSE   ; inicializamos o resultado como FALSE
    testa_linhas:   
        MOV R0, [R4]    ; obtemos a linha da sonda que o asteroide pode colidir
        CMP R0, R1      ; comparamos a linha da sonda com a linha do ponto de referencia do asteroide
        JGT fim_teste_aux   ; caso a sonda esteja abaixo do asteroide ainda nâo colidiu e acaba-se o teste
        ADD R3, 2   ; Obtemos o endereco para a altura do asteroide
        MOV R6, [R3]    ; Guardamos a altura do asteroide
        SUB R1, R6  ; Subtraimos à linha do ponto referencia ( obtemos a primeira linha onde o asteroide e desenhado )
        CMP R0, R1  ; Comparamos com a linha da sonda
        JLT fim_teste_aux   ; caso a sonda se encontra acima do asteroide nâo colide e acaba o teste
    testa_colunas:  
        ADD R4, 2   ; obtemos o endereco para a coluna da sonda que o asteroide pode colidir
        MOV R0, [R4]    ; guardamos a respetiva coluna 
        CMP R0, R2  ; comparamos com a coluna do ponto de referencia do asteroide
        JLT fim_teste_aux   ; caso a sonda se encontre a esquerda do asteroide nao colide
        SUB R3, 2   ; obtem-se o endereco com a largura do asteroide
        MOV R6, [R3]    ; guarda-se a largura do asteroide
        ADD R2, R6  ; adiciona-se a coluna do asteroide a largura ( obtemos a coluna maxima onde o asteroide é desenhado )
        CMP R0, R2  ; comparamos com a sonda
        JGT fim_teste_aux   ; caso a sonda se encontra-se a direita do asteroide nâo colide
        MOV R8, TRUE    ; caso contrario colide
        CALL testa_colisao_nave ; testamos se a colisao foi com a nave
                                ; ( Isto da-se porque o asteroide colide
                                ; com a nave na posicao onde as sondas sao
                                ; lancadas )
        MOV R0, MOVIMENTOS_SONDA    ; obtemos os enderecos com os movimentos das sondas
        SHL R9, 1       ; iremos trabalhar com tabelas de 1 coluna ( 1 WORD )
        ADD R0, R9      ; obtemos o endereco responsavel pelos movimentos da respetiva sonda
        MOV R3, 1       ; guardamos o "ultimo movimento"
        MOV [R0], R3     ; reseta os movimentos da sonda ( 1 porque o ultimo movimento e o resetar da sonda )
        SHL R9, 1       ; iremos trabalhar com tabelas de 2 colunas ( 2 WORDS )
        ; os proximos passos sao para que a sonda apenas colide com 1 asteroide de cada vez
        MOV R7, posicoes_iniciais_sondas    ; obtemos o endereco com as posicoes iniciais de cada sonda
        ADD R7, R9  ; obtemos a posicao inicial da respetiva sonda
        MOV R0, REFERENCIA_SONDAS   ; obtemos o endereco para as posicoes genericas de cada sonda
        ADD R0, R9  ; obtemos o endereco para o ponto de referencia atual da sonda
        MOV R3, DEF_SONDA   ; obtemos as informacoes sobre o formato generico de uma sonda
        MOV R4, ECRA_NAVE   ; selecionamos o ecra onde será desenhado a sonda
        MOV [SELECIONA_ECRA], R4
        CALL apaga_objeto   ; apagamos a sonda com a colisao ( reduz o delay da explosao )
        CALL reinicia_posicao   ; reiniciamos a posicao da sonda
    fim_teste_aux:
        POP R7
        POP R6
        POP R4
        POP R3
        POP R0
        RET

testa_colisao_nave:
    ; ( Isto da-se porque o asteroide colide
    ; com a nave na posicao onde as sondas sao
    ; lancadas )
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R9

    SHL R9, 2   ; Multiplicamos por 4 porque iremoas trabalhar com tabelas de 2 colunas
    MOV R1, posicoes_iniciais_sondas    ; obtemos o endreco para as posicoes iniciais das sondas
    ADD R1, R9  ; obtemos a posicao inicial das respetiva sonda
    MOV R2, [R1]    ; obtemos a linha da posicao inicial da sonda
    MOV R3, [R4]    ; obtemos a linha do ponto de referencia atual da sonda
    CMP R2, R3      ; verifcamos se a sonda ainda não foi lancada
    JZ call_loss    ; caso não tenha sido lancado, entao o asteroide colidiu
                    ; com a sonda presa a nave e chama-se a perda do jogo
    JNZ end_test    ; caso contrario não colidiu e acaba-se o teste
    call_loss:
        CALL change_state_collision ; muda-se o estado para "PERDEU POR COLISAO"
    end_test:
        POP R9
        POP R3
        POP R2
        POP R1
        RET

; *****************************************************
;   change_state_collision:
;       - Funcao responsavel por mudar o estado de jogo
;       para PERDEU POR COLISAO
; ***************************************************** 

change_state_collision:
    PUSH R0

    MOV R0, LOSS_COLLISION  ; guarda-se o estado de jogo quando se perde por colisao
    MOV [GAME_STATE], R0    ; atualiza-se o estado de jogo na memoria
    MOV R0, END_GAME        ; guarda-se o comando para terminar o jogo
    MOV [tecla_carregada], R0   ; forca-se o terminar o jogo

    POP R0
    RET

; **********************************************************************
; ROT_INT_0 - 	Rotina de atendimento da interrupção 0
;			Faz simplesmente uma escrita no LOCK que o processo asteroides lê.
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
;			Faz simplesmente uma escrita no LOCK que o processo sondas lê.
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
;			Faz simplesmente uma escrita no LOCK que o processo energia_nave lê.
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
;			Faz simplesmente uma escrita no LOCK que o processo desenha_nave lê.
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
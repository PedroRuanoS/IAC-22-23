; *********************************************************************************
; * IST-UL
; * Modulo:    lab7-processos-muitos-bonecos-displays-teclado.asm
; * Descrição: Este programa ilustra a utilização de várias instâncias de um
; *			processo cooperativo (evolução do lab7-processos-quatro-bonecos-displays-teclado.asm),
; *			com vários bonecos que se movimentam de forma independente no ecrã.
; *			O número de bonecos pode ser definido entre 1 e o número de linhas do ecrã.
; *			O movimento dos bonecos é temporizado por quatro interrupções
; *			e os displays sobem ou descem pelo meio do teclado.
; *			Há 6 processos:
; *				- Programa principal, que trata dos displays
; *				- Teclado, que deteta uma tecla na 4ª linha do teclado
; *				- Um número variável de instâncias do processo boneco, cada um tratando do movimento
; *				  de um dos vários bonecos, sempre que a interrupção respetiva ocorre.
; *				  Cada boneco reage à interrupção determinada pelo resto da divisão do número
; *				  da instância por 4 (ou seja, 0 a 3)
; *				  As várias instâncias têm o mesmo código, variando apenas os dados
; *				  (a definição dos vários bonecos é a mesma, mas poderiam ser diferentes
; *				  com uma tabela com os endereços das várias tabelas de definição de cada
; *				  tipo de boneco diferente)
; *
; *********************************************************************************

; *********************************************************************************
; * Constantes
; *********************************************************************************
COMANDOS				EQU	6000H			; endereço de base dos comandos do MediaCenter

DEFINE_LINHA    		EQU COMANDOS + 0AH		; endereço do comando para definir a linha
DEFINE_COLUNA   		EQU COMANDOS + 0CH		; endereço do comando para definir a coluna
DEFINE_PIXEL    		EQU COMANDOS + 12H		; endereço do comando para escrever um pixel
APAGA_AVISO     		EQU COMANDOS + 40H		; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRÃ	 		EQU COMANDOS + 02H		; endereço do comando para apagar todos os pixels já desenhados
SELECIONA_CENARIO_FUNDO  EQU COMANDOS + 42H		; endereço do comando para selecionar uma imagem de fundo

DISPLAYS			EQU  0A000H	; endereço do periférico que liga aos displays
TEC_LIN			EQU  0C000H	; endereço das linhas do teclado (periférico POUT-2)
TEC_COL			EQU  0E000H	; endereço das colunas do teclado (periférico PIN)
LINHA_TECLADO		EQU 	8		; linha a testar (4ª linha, 1000b)
MASCARA			EQU	0FH		; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
TECLA_C			EQU 	1		; tecla na primeira coluna do teclado (tecla C)
TECLA_D			EQU 	2		; tecla na segunda coluna do teclado (tecla D)

N_LINHAS			EQU  32		; número de linhas do ecrã

COLUNA			EQU  30        ; coluna inicial dos bonecos (a meio do ecrã)
MIN_COLUNA		EQU  0		; número da coluna mais à esquerda que o objeto pode ocupar
MAX_COLUNA		EQU  63        ; número da coluna mais à direita que o objeto pode ocupar

N_BONECOS			EQU  32		; número de bonecos (de 1 até N_LINHAS)

LARGURA			EQU	5		; largura do boneco
COR_PIXEL			EQU	0FF00H	; cor do pixel: vermelho em ARGB (opaco e vermelho no máximo, verde e azul a 0)

TAMANHO_PILHA		EQU  40H		; tamanho de cada pilha, em words

; *********************************************************************************
; * Dados 
; *********************************************************************************
	PLACE       1000H

; Reserva do espaço para as pilhas dos processos
	STACK TAMANHO_PILHA		; espaço reservado para a pilha do processo "programa principal"
SP_inicial_prog_princ:		; este é o endereço com que o SP deste processo deve ser inicializado
							
	STACK TAMANHO_PILHA		; espaço reservado para a pilha do processo "teclado"
SP_inicial_teclado:			; este é o endereço com que o SP deste processo deve ser inicializado
							
	STACK TAMANHO_PILHA * N_BONECOS	; espaço reservado para as pilhas de todos os processos "boneco"
SP_inicial_boneco:					; este é o endereço incial do SP com que o processo "boneco" deve ser declarado no PROCESS,
								; mas cada instância deve depois reinicializar o SP (cada uma com o seu bloco de TAMANHO_PILHA palavras)

DEF_BONECO:				; tabela que define o boneco (cor, largura, pixels)
	WORD		LARGURA
	WORD		COR_PIXEL, 0, COR_PIXEL, 0, COR_PIXEL		; # # #   as cores podem ser diferentes de pixel para pixel
     
; Tabela das rotinas de interrupção
tab:
	WORD rot_int_0			; rotina de atendimento da interrupção 0
	WORD rot_int_1			; rotina de atendimento da interrupção 1
	WORD rot_int_2			; rotina de atendimento da interrupção 2
	WORD rot_int_3			; rotina de atendimento da interrupção 3

evento_int_bonecos:			; LOCKs para cada rotina de interrupção comunicar ao processo
						; boneco respetivo que a interrupção ocorreu
	LOCK 0				; LOCK para a rotina de interrupção 0
	LOCK 0				; LOCK para a rotina de interrupção 1
	LOCK 0				; LOCK para a rotina de interrupção 2
	LOCK 0				; LOCK para a rotina de interrupção 3
							
tecla_carregada:
	LOCK 0				; LOCK para o teclado comunicar aos restantes processos que tecla detetou
							
                              

; *********************************************************************************
; * Código
; *********************************************************************************
PLACE   0                     ; o código tem de começar em 0000H
inicio:
	MOV  SP, SP_inicial_prog_princ		; inicializa SP do programa principal
                            
	MOV  BTE, tab			; inicializa BTE (registo de Base da Tabela de Exceções)

     MOV  [APAGA_AVISO], R1	; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
     MOV  [APAGA_ECRÃ], R1	; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
	MOV	R1, 0			; cenário de fundo número 0
     MOV  [SELECIONA_CENARIO_FUNDO], R1	; seleciona o cenário de fundo
     
	EI0					; permite interrupções 0
	EI1					; permite interrupções 1
	EI2					; permite interrupções 2
	EI3					; permite interrupções 3
	EI					; permite interrupções (geral)
						; a partir daqui, qualquer interrupção que ocorra usa
						; a pilha do processo que estiver a correr nessa altura
	
; cria processos. O CALL não invoca a rotina, apenas cria um processo executável

	CALL	teclado			; cria o processo teclado

	MOV	R11, N_BONECOS		; número de bonecos a usar (até N_LINHAS)
loop_bonecos:
	SUB	R11, 1			; próximo boneco
	CALL	boneco			; cria uma nova instância do processo boneco (o valor de R11 distingue-as)
						; Cada processo fica com uma cópia independente dos registos
	CMP  R11, 0			; já criou as instâncias todas?
     JNZ	loop_bonecos		; se não, continua

; o resto do programa principal é também um processo (neste caso, trata dos displays)

	MOV  R2, 0			; valor do contador, cujo valor vai ser mostrado nos displays
	MOV  R0, DISPLAYS        ; endereço do periférico que liga aos displays
atualiza_display:	
	MOVB [R0], R2            ; mostra o valor do contador nos displays
obtem_tecla:	
	MOV	R1, [tecla_carregada]	; bloqueia neste LOCK até uma tecla ser carregada
	CMP	R1, TECLA_C		; é a coluna da tecla C?
	JNZ	testa_D
	ADD  R2, 1               ; aumenta o contador
	JMP	atualiza_display
testa_D:	
	CMP	R1, TECLA_D		; é a coluna da tecla D?
	JNZ	obtem_tecla		; se não, ignora a tecla e espera por outra
	SUB  R2, 1               ; diminui o contador
	JMP	atualiza_display	; processo do programa principal nunca termina


; **********************************************************************
; Processo
;
; TECLADO - Processo que deteta quando se carrega numa tecla na 4ª linha
;		  do teclado e escreve o valor da coluna num LOCK.
;
; **********************************************************************

PROCESS SP_inicial_teclado	; indicação de que a rotina que se segue é um processo,
						; com indicação do valor para inicializar o SP
teclado:					; processo que implementa o comportamento do teclado
	MOV  R2, TEC_LIN		; endereço do periférico das linhas
	MOV  R3, TEC_COL		; endereço do periférico das colunas
	MOV  R5, MASCARA		; para isolar os 4 bits de menor peso, ao ler as colunas do teclado

espera_tecla:				; neste ciclo espera-se até uma tecla ser premida

	YIELD				; este ciclo é potencialmente bloqueante, pelo que tem de
						; ter um ponto de fuga (aqui pode comutar para outro processo)

	MOV  R1, LINHA_TECLADO	; testar a linha 4 
	MOVB [R2], R1			; escrever no periférico de saída (linhas)
	MOVB R0, [R3]			; ler do periférico de entrada (colunas)
	AND  R0, R5			; elimina bits para além dos bits 0-3
	CMP  R0, 0			; há tecla premida?
	JZ   espera_tecla		; se nenhuma tecla premida, repete
						
	MOV	[tecla_carregada], R0	; informa quem estiver bloqueado neste LOCK que uma tecla foi carregada
							; (o valor escrito é o número da coluna da tecla no teclado)

ha_tecla:					; neste ciclo espera-se até NENHUMA tecla estar premida

	YIELD				; este ciclo é potencialmente bloqueante, pelo que tem de
						; ter um ponto de fuga (aqui pode comutar para outro processo)

     MOV  R1, LINHA_TECLADO	; testar a linha 4  (R1 tinha sido alterado)
     MOVB [R2], R1			; escrever no periférico de saída (linhas)
     MOVB R0, [R3]			; ler do periférico de entrada (colunas)
	AND  R0, R5			; elimina bits para além dos bits 0-3
     CMP  R0, 0			; há tecla premida?
     JNZ  ha_tecla			; se ainda houver uma tecla premida, espera até não haver

	JMP	espera_tecla		; esta "rotina" nunca retorna porque nunca termina
						; Se se quisesse terminar o processo, era deixar o processo chegar a um RET


; **********************************************************************
; Processo
;
; BONECO - Processo que desenha um boneco e o move horizontalmente, com
;		 temporização marcada por uma interrupção.
;		 Este processo está preparado para ter várias instâncias (vários
;		 processos serem criados com o mesmo código), com o argumento (R11)
;		 a indicar o número de cada instância. Esse número é usado para
;		 indexar tabelas com informação para cada uma das instâncias,
;		 nomeadamente o valor inicial do SP (que tem de ser único para cada instaância)
;		 e o LOCK que lê à espera que a interrupção respetiva ocorra
;
; Argumentos:   R11 - número da instância do processo (cada instância fica
;				  com uma cópia independente dos registos, com os valores
;				  que os registos tinham na altura da criação do processo.
;				  O valor de R11 deve ser mantido ao longo de toda a vida do processo
;
; **********************************************************************

PROCESS SP_inicial_boneco	; indicação de que a rotina que se segue é um processo,
						; com indicação do valor para inicializar o SP
						; NOTA - Como cada processo tem de ter uma pilha única,
						;	    mal comece a executar tem de ajustar
						; 	    o SP com o valor correto, obtido de forma
						;	    simples usando o R11 (número da instância).
						;	    Cada instância tem de ter a sua própria pilha
						
boneco:					; processo que implementa o comportamento do boneco
	MOV	R1, TAMANHO_PILHA	; tamanho em palavras da pilha de cada processo
	MUL	R1, R11			; TAMANHO_PILHA vezes o nº da instância do "boneco"
	SUB	SP, R1		     ; inicializa SP deste "boneco" (antes de subtrair já tinha sido inicializado com SP_inicial_boneco)
						; A instância 0 fica na mesma, e as seguintes vão andando para trás,
						; até esgotar todo o espaço de pilha reservado para os processos "boneco"
	
	; calcula o espaçamento em linhas de boneco para boneco
	MOV	R9, N_LINHAS		; número de linhas do ecrã
	MOV	R0, N_BONECOS		; número de bonecos no ecrã (entre 1 e N_LINHAS)
	DIV	R9, R0			; Divisão inteira de N_LINHAS por N_BONECOS
	MOV	R1, R11
	MUL	R1, R9			; linha em que cada boneco deve estar
						; NOTA - Cada processo tem a sua cópia própria do R1
						;	    Este algoritmo é usado para obter a linha inicial,
						;	    mas a partir daí o R1 de cada processo "boneco" mantém a linha respetiva
							
	MOV  R2, COLUNA		; coluna em que cada boneco está
						; NOTA - Cada processo tem a sua cópia própria do R2
						; 	    Por isso, o R2 é usado para manter a coluna, de forma independente
						;	    para cada instância (embora todas comecem na mesma coluna)

	MOV	R7, 1			; sentido de movimento inicial para a direita, por omissão
	BIT	R11, 0			; testa o bit de menor peso do número de instância deste processo
	JZ	continua_boneco	; se for 0, a instância é par e R7 está certo (instâncias pares começam para a direita)
	MOV	R7, -1			; se for 1, a instância é ímpar e corrige R7 (instâncias ímpares começam para a esquerda)
						; NOTA - Cada processo tem a sua cópia própria do R7
						;	    Este algoritmo é usado para obter o sentido inicial,
						;	    mas a partir daí o R7 de cada processo "boneco" mantém o sentido respetivo
	
continua_boneco:
	MOV	R4, DEF_BONECO		; endereço da tabela que define o boneco (igual para todas as instâncias)

ciclo_boneco:
	CALL	desenha_boneco		; desenha o boneco a partir da tabela, na sua posição atual

	MOV  R10, R11			; cópia do nº de instância do processo
	MOV	R0, 4
	MOD	R10, R0			; resto da divisão do nº de instância por 4 (0 a 3)
	SHL  R10, 1			; multiplica por 2 porque as tabelas são de WORDS

	MOV  R9, evento_int_bonecos
	MOV  R3, [R9+R10]		; lê o LOCK desta instância (bloqueia até a rotina de interrupção
						; respetiva escrever neste LOCK)
						; Quando bloqueia, passa o controlo para outro processo
						; Como não há valor a transmitir, o registo pode ser um qualquer

	CALL	apaga_boneco		; apaga o boneco na sua posição corrente
	
	MOV	R6, [R4]			; obtém a largura do boneco
	CALL	testa_limites		; vê se chegou aos limites do ecrã e nesse caso inverte o sentido
	ADD	R2, R7			; para desenhar objeto na coluna seguinte (direita ou esquerda)
	JMP	ciclo_boneco		; esta "rotina" nunca retorna porque nunca termina
						; Se se quisesse terminar o processo, era deixar o processo chegar a um RET


; **********************************************************************
; DESENHA_BONECO - Desenha um boneco na linha e coluna indicadas
;			    com a forma e cor definidas na tabela indicada.
; Argumentos:   R1 - linha
;               R2 - coluna
;               R4 - tabela que define o boneco
;
; **********************************************************************
desenha_boneco:
	PUSH	R2
	PUSH	R3
	PUSH	R4
	PUSH	R5
	MOV	R5, [R4]			; obtém a largura do boneco
	ADD	R4, 2			; endereço da cor do 1º pixel (2 porque a largura é uma word)
desenha_pixels:       		; desenha os pixels do boneco a partir da tabela
	MOV	R3, [R4]			; obtém a cor do próximo pixel do boneco
	CALL	escreve_pixel		; escreve cada pixel do boneco
	ADD	R4, 2			; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
     ADD  R2, 1               ; próxima coluna
     SUB  R5, 1			; menos uma coluna para tratar
     JNZ  desenha_pixels      ; continua até percorrer toda a largura do objeto
	POP	R5
	POP	R4
	POP	R3
	POP	R2
	RET

; **********************************************************************
; APAGA_BONECO - Apaga um boneco na linha e coluna indicadas
;			  com a forma definida na tabela indicada.
; Argumentos:   R1 - linha
;               R2 - coluna
;               R4 - tabela que define o boneco
;
; **********************************************************************
apaga_boneco:
	PUSH	R2
	PUSH	R3
	PUSH	R4
	PUSH	R5
	MOV	R5, [R4]			; obtém a largura do boneco
	ADD	R4, 2			; endereço da cor do 1º pixel (2 porque a largura é uma word)
apaga_pixels:       		; desenha os pixels do boneco a partir da tabela
	MOV	R3, 0			; cor para apagar o próximo pixel do boneco
	CALL	escreve_pixel		; escreve cada pixel do boneco
	ADD	R4, 2			; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
     ADD  R2, 1               ; próxima coluna
     SUB  R5, 1			; menos uma coluna para tratar
     JNZ  apaga_pixels      ; continua até percorrer toda a largura do objeto
	POP	R5
	POP	R4
	POP	R3
	POP	R2
	RET


; **********************************************************************
; ESCREVE_PIXEL - Escreve um pixel na linha e coluna indicadas.
; Argumentos:   R1 - linha
;               R2 - coluna
;               R3 - cor do pixel (em formato ARGB de 16 bits)
;
; **********************************************************************
escreve_pixel:
	MOV  [DEFINE_LINHA], R1		; seleciona a linha
	MOV  [DEFINE_COLUNA], R2		; seleciona a coluna
	MOV  [DEFINE_PIXEL], R3		; altera a cor do pixel na linha e coluna já selecionadas
	RET


; **********************************************************************
; TESTA_LIMITES - Testa se o boneco chegou aos limites do ecrã e nesse caso
;			   inverte o sentido de movimento
; Argumentos:	R2 - coluna em que o objeto está
;			R6 - largura do boneco
;			R7 - sentido de movimento do boneco (valor a somar à coluna
;				em cada movimento: +1 para a direita, -1 para a esquerda)
;
; Retorna: 	R7 - novo sentido de movimento (pode ser o mesmo)	
; **********************************************************************
testa_limites:
	PUSH	R5
	PUSH	R6
testa_limite_esquerdo:		; vê se o boneco chegou ao limite esquerdo
	MOV	R5, MIN_COLUNA
	CMP	R2, R5
	JLE	inverte_para_direita
testa_limite_direito:		; vê se o boneco chegou ao limite direito
	ADD	R6, R2			; posição a seguir ao extremo direito do boneco
	MOV	R5, MAX_COLUNA
	CMP	R6, R5
	JGT	inverte_para_esquerda
	JMP	sai_testa_limites	; entre limites. Mantém o valor do R7

inverte_para_direita:
	MOV	R7, 1			; passa a deslocar-se para a direita
	JMP	sai_testa_limites
inverte_para_esquerda:
	MOV	R7, -1			; passa a deslocar-se para a esquerda
sai_testa_limites:	
	POP	R6
	POP	R5
	RET

; **********************************************************************
; ROT_INT_0 - 	Rotina de atendimento da interrupção 0
;			Faz simplesmente uma escrita no LOCK que o processo boneco lê.
;			Como basta indicar que a interrupção ocorreu (não há mais
;			informação a transmitir), basta a escrita em si, pelo que
;			o registo usado, bem como o seu valor, é irrelevante
; **********************************************************************
rot_int_0:
	PUSH	R1
	MOV  R1, evento_int_bonecos
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
	MOV  R1, evento_int_bonecos
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
	MOV  R1, evento_int_bonecos
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
	MOV  R1, evento_int_bonecos
	MOV	[R1+6], R0	; desbloqueia processo boneco (qualquer registo serve)
					; O valor a somar ao R1 (base da tabela dos LOCKs) é
					; o dobro do número da interrupção, pois a tabela é de WORDs
	POP	R1
	RFE



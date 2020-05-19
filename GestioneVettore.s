#####################################################################
# GRUPPO: Timofte Robert Octavian - VR429581						#
#		  Feola Emanuele - VR437205									#
#		  Carra Mattia - VR429609									#
# DESCRIZIONE FILE: programma completo con relative funzioni usate	#
#####################################################################
.section .bss
    input_num: 		.long 0

.section .data
    length:         .long 10   	#dimensione del vettore
    max_index:      .long 0         #indice massimo del vettore   
    vector: 		.fill 10,4,0    #il primo numero va modificato in base alla dimensione del vettore desiderata
    dim_error_msg:  .string "Dimensione impostata per il vettore errata! (1 <= dim <= 255)\n"
    start_msg: 		.string "Inserimento dei %d interi che compongono il vettore...\n"
    insert_msg: 	.string "Inserire l'intero in posizione %d: "
    input_format: 	.string "%d"
	menu1: 			.string "\nOPERAZIONI DISPONIBILI\n"
    menu2: 			.string "----------------------\n"
    menu3: 			.string "1) stampa a video del vettore inserito\n"
    menu4: 			.string "2) stampa a video del vettore inserito in ordine inverso\n"
    menu5: 			.string "3) stampa il numero di valori pari e dispari inseriti\n"
    menu6: 			.string "4) stampa la posizione di un valore inserito dall'utente\n"
    menu7: 			.string "5) stampa il massimo valore inserito\n"
    menu8: 			.string "6) stampa la posizione del massimo valore inserito\n"
    menu9: 			.string "7) stampa il minimo valore inserito\n"
    menu10: 		.string "8) stampa la posizione del minimo valore inserito\n"
    menu11: 		.string "9) stampa il valore inserito con maggior frequenza\n"
    menu12: 		.string "10) stampa la media intera dei valori inseriti\n"
    option_msg: 	.string "\nInserire valore operazione (0 uscita, -1 ristampa menu'): "
   	exit_msg: 		.string "\nUscita dall'applicazione...\n"
    default_msg: 	.string "\nOpzione non supportata dall'applicazione!\n"
	std_msg: 		.string "\nValori inseriti:\n"
	std_msg_inv: 	.string "\nValori inseriti: (ordine di inserimento invertito)\n"
	value_msg: 		.string "Valore %d: %d\n"
	even_msg: 		.string "\nNumero di valori pari inseriti: %d\n"
	odd_msg: 		.string "Numero di valori dispari inseriti: %d\n"
	search_msg: 	.string "\nInserisci l'intero da cercare: "
	found_msg: 		.string "Posizione del valore %d: %d\n"
	not_found_msg: 	.string "Valore %d non trovato\n"
	max_value_msg: 	.string "\nMassimo valore inserito: %d\n"
    max_pos_msg: 	.string "\nPosizione del massimo valore inserito: %d\n"
    min_value_msg: 	.string "\nMinimo valore inserito: %d\n"
    min_pos_msg: 	.string "\nPosizione del minimo valore inserito: %d\n"
    max_freq_msg: 	.string "\nValore inserito con maggior frequenza: %d\n"
    mean_msg: 		.string "\nMedia valori: %d\n"

.section .text
    .global main

main:
    cmpl $0, length
    jle dim_error
	cmpl $255, length
	jg dim_error

    call getMaxIndex
    movl %ebx, max_index
    xorl %ebx, %ebx

	#stampo il messaggio di inizio programma
    pushl length
    pushl $start_msg
    call printf 
    addl $8, %esp

	#imposto i valori per scorrere il vettore per inserire numeri
    movl max_index ,%ebx
    movl $0, %esi

#in questa parte di codice chiedo in input i numeri e li salvo nel vettore
insert:
	movl %esi, %eax
	addl $4, %eax
	movb $4, %dl
	divb %dl
	movb %al, %cl

    pushl %ecx
    pushl $insert_msg
    call printf
    addl $8, %esp

    pushl $input_num
    pushl $input_format
    call scanf
    addl $8, %esp

    xorl %eax, %eax
    movl (input_num), %eax
    movl %eax, vector(%esi)
    addl $4, %esi 
    cmpl %esi, %ebx
    jnl insert

	#stampo le operazioni effettuabili sul vettore
    call printOptions

	#chiamo la funzione che gestisce la scelta dell'opzione
	call chooseOption

exit:
    xorl %eax, %eax
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80

dim_error:
    pushl $dim_error_msg
    call printf
    addl $4, %esp
    jmp exit
#########################################################################
# funzione che calcola e restituisce l'indice massimo del vettore    	#
#########################################################################
.type getMaxIndex, @function

getMaxIndex:
    xorl %eax, %eax
    xorl %ebx, %ebx
    xorl %ecx, %ecx
    xorl %edx, %edx

    movl $4, %ecx
    movl length, %eax
    mull %ecx
    
    movl %eax, %ebx
    subl $4, %ebx

    xorl %eax, %eax
    xorl %ecx, %ecx
    xorl %edx, %edx

    ret
#########################################################################
# funzione che stampa il menu delle operazioni effettuabili sul vettore #
#########################################################################
.type printOptions, @function

printOptions:
    pushl $menu1
    call printf
    addl $4, %esp
    pushl $menu2
    call printf
    addl $4, %esp
    pushl $menu3
    call printf
    addl $4, %esp
    pushl $menu4
    call printf
    addl $4, %esp
    pushl $menu5
    call printf
    addl $4, %esp
    pushl $menu6
    call printf
    addl $4, %esp
    pushl $menu7
    call printf
    addl $4, %esp
    pushl $menu8
    call printf
    addl $4, %esp
    pushl $menu9
    call printf
    addl $4, %esp
    pushl $menu10
    call printf
    addl $4, %esp
    pushl $menu11
    call printf
    addl $4, %esp
    pushl $menu12
    call printf
    addl $4, %esp

    ret
#########################################################################
# funzione che gestisce la scelta dell'opzione							#
#########################################################################
.type chooseOption, @function

chooseOption:
    pushl $option_msg
    call printf 
    addl $4, %esp

    pushl $input_num
    pushl $input_format
    call scanf
    addl $8, %esp

    movl (input_num), %eax

	cmpl $0, %eax
	je opt0
	cmpl $-1, %eax
	je optm1
    cmpl $1, %eax
    je opt1
	cmpl $2, %eax
	je opt2
	cmpl $3, %eax
	je opt3
	cmpl $4, %eax
	je opt4
	cmpl $5, %eax
	je opt5
    cmpl $6, %eax
    je opt6
    cmpl $7, %eax
    je opt7
    cmpl $8, %eax
    je opt8
    cmpl $9, %eax
    je opt9
    cmpl $10, %eax
    je opt10

	jne optStd

opt0:
    pushl $exit_msg
    call printf
    addl $4, %esp

    ret

optm1:
    call printOptions
	jmp chooseOption

opt1:
    call printVector
    jmp chooseOption

opt2:
	call printInverseVector
	jmp chooseOption

opt3:
	call printEvenOddNumber
	jmp chooseOption

opt4:
	call findValue
	jmp chooseOption

opt5:
	call getMaxValue

	pushl %eax
	pushl $max_value_msg
	call printf
	addl $8, %esp

	jmp chooseOption

opt6:
    call printMaxValuePos
    jmp chooseOption

opt7:
    call getMinValue

	pushl %eax
	pushl $min_value_msg
	call printf
	addl $8, %esp

    jmp chooseOption

opt8:
    call printMinValuePos
    jmp chooseOption

opt9:
    call printMaxFreqValue
    jmp chooseOption

opt10:
    call printMean
    jmp chooseOption

optStd:
    pushl $default_msg
    call printf
    addl $4, %esp
    call printOptions
	jmp chooseOption
#########################################################################
# funzione che stampa il vettore									 	#
#########################################################################
.type printVector, @function

printVector:
	xorl %eax, %eax
	xorl %ebx, %ebx
	xorl %ecx, %ecx
	xorl %edx, %edx
	xorl %esi, %esi

	pushl $std_msg
	call printf
	addl $4, %esp

	movl max_index, %ebx	
    movl $0, %esi

printLoop:
	movl %esi, %eax
	addl $4, %eax
	movb $4, %dl
	divb %dl
	movb %al, %cl 

	pushl vector(%esi)
    pushl %ecx
    pushl $value_msg
    call printf
    addl $12, %esp

    addl $4, %esi   
    cmpl %esi, %ebx
    jnl printLoop

	ret
#########################################################################
# funzione che stampa il vettore in ordine di inserimento inverso	 	#
#########################################################################
.type printInverseVector, @function

printInverseVector:
	xorl %eax, %eax
	xorl %ebx, %ebx
	xorl %ecx, %ecx
	xorl %edx, %edx
	xorl %esi, %esi

	pushl $std_msg_inv
	call printf
	addl $4, %esp

    movl $0, %ebx
    movl max_index, %esi

inversePrintLoop:
	movl %esi, %eax
	addl $4, %eax
	movb $4, %dl
	divb %dl
	movb %al, %cl 

	pushl vector(%esi)
    pushl %ecx
    pushl $value_msg
    call printf
    addl $12, %esp

    subl $4, %esi   
    cmpl %esi, %ebx
    jng inversePrintLoop

	ret
#########################################################################
# funzione che stampa il numero di valori pari e dispari			 	#
#########################################################################
.type printEvenOddNumber, @function

printEvenOddNumber:
	xorl %eax, %eax
	xorl %ebx, %ebx
	xorl %ecx, %ecx
	xorl %edx, %edx
	xorl %esi, %esi

	movl $0, %esi

	movb $0, %cl	#contatore numeri pari

#verifico se il valore corrente del vettore è pari o dispari
calculate:
	xorl %eax, %eax
	xorl %edx, %edx
	movl vector(%esi), %eax
	movl $2, %ebx
	divl %ebx
		
	cmpl $0, %edx
	je evenPlus
	jne goAhead

#se pari incremento il relativo contatore
evenPlus:
	incb %cl
	jmp goAhead

#scorro il vettore e alla fine stampo il numero di elementi pari e dispari
goAhead:
	addl $4, %esi
	cmpl max_index, %esi
	jng calculate
	
	xorl %ebx, %ebx
	movb %cl, %bl	

	pushl %ecx
	pushl $even_msg
	call printf
	addl $8, %esp

	#per calcolare il numero di elementi dispari faccio 10 - n elementi pari
	xorl %eax, %eax
	movb length, %al
	subb %bl, %al

	pushl %eax
	pushl $odd_msg
	call printf
	addl $8, %esp

	ret
##########################################################################
# funzione che trova un valore scelto e stampa la sua posizione			 #
##########################################################################
.type findValue, @function

findValue:
	xorl %eax, %eax
	xorl %ebx, %ebx
	xorl %ecx, %ecx
	xorl %edx, %edx
	xorl %esi, %esi

	pushl $search_msg
	call printf
	addl $4, %esp

	pushl $input_num
	pushl $input_format
	call scanf
	addl $8, %esp

	movl (input_num), %ebx

#verifico se il valore corrente dell'vettore e' quello giusto
#in caso contrario continuo a scorrere l'array	
find:
	movl vector(%esi), %eax
	cmpl %ebx, %eax
	je found

	addl $4, %esi
	cmpl max_index, %esi
	jng find
	jg notFound

#una volta trovato il valore giusto stampo la sua posizione	
found:
	xorl %edx, %edx
	xorl %eax, %eax
	movl %esi, %eax
	addl $4, %eax
	movb $4, %dl
	divb %dl

	xorl %ecx, %ecx
	movb %al, %cl

	pushl %ecx
	pushl %ebx
	pushl $found_msg
	call printf
	addl $12, %esp

	ret

#se il valore non e' stato trovato, stampo un messaggio che informa l'utente
notFound:
	pushl %ebx
	pushl $not_found_msg
	call printf
	addl $8, %esp

	ret
##########################################################################
# funzione che restituisce il valore massimo presente nel vettore		 #
##########################################################################
.type getMaxValue, @function

getMaxValue:
	xorl %eax, %eax
	xorl %ebx, %ebx
	xorl %esi, %esi

	movl max_index, %ebx
	movl vector(%esi), %eax		#imposto come valore massimo il primo elemento del vettore

#controllo se il valore corrente e' maggiore del massimo stabilito
findMaxValue:
	cmpl vector(%esi), %eax
	jg keepMaxLoopGoing
	movl vector(%esi), %eax

#scorro l'array, alla fine restituisco nel registro eax il massimo valore trovato
keepMaxLoopGoing:
	addl $4, %esi
	cmpl %esi, %ebx
	jnl findMaxValue

	xorl %ebx, %ebx
	xorl %esi, %esi

	ret
##########################################################################
# funzione che stampa la posizione del valore massimo del vettore		 #
##########################################################################
.type printMaxValuePos, @function

printMaxValuePos:	
	call getMaxValue

	movl max_index, %ebx

#cerco la posizione del valore massimo
getMaxValuePos:
    cmpl vector(%esi), %eax
    je printMaxPosMsg
    addl $4, %esi
    cmpl %esi, %ebx
    jnl getMaxValuePos

#una volta trovata, stampo la posizione del valore massimo
printMaxPosMsg:
    addl $4, %esi
    xorl %eax, %eax
    movl %esi, %eax    
    xorl %ebx, %ebx
    movb $4, %bl
    divb %bl

    xorl %ecx, %ecx
    movb %al, %cl
	
	pushl %ecx
	pushl $max_pos_msg
	call printf
	addl $8, %esp		

	ret
##########################################################################
# funzione che restituisce il valore minimo presente nel vettore		 #
##########################################################################
.type getMinValue, @function

getMinValue:
	xorl %eax, %eax
	xorl %ebx, %ebx
	xorl %esi, %esi

	movl max_index, %ebx
	movl vector(%esi), %eax		#imposto come valore minimo il primo elemento del vettore

#controllo se il valore corrente e' minore del massimo stabilito
findMinValue:
	cmpl vector(%esi), %eax
	jl keepMinLoopGoing
	movl vector(%esi), %eax

#scorro l'array, alla fine restituisco nel registro eax il minimo valore trovato
keepMinLoopGoing:
	addl $4, %esi
	cmpl %esi, %ebx
	jnl findMinValue

	xorl %ebx, %ebx
	xorl %esi, %esi

	ret
##########################################################################
# funzione che stampa la posizione del valore minimo del vettore		 #
##########################################################################
.type printMinValuePos, @function

printMinValuePos:
	call getMinValue

	movl max_index, %ebx

#cerco la posizione del valore minimo
getMinValuePos:
    cmpl vector(%esi), %eax
    je printMinPosMsg
    addl $4, %esi
    cmpl %esi, %ebx
    jnl getMinValuePos

#una volta trovata, stampo la posizione del valore minimo
printMinPosMsg:
    addl $4, %esi
    xorl %eax, %eax
    movl %esi, %eax    
    xorl %ebx, %ebx
    movb $4, %bl
    divb %bl

    xorl %ecx, %ecx
    movb %al, %cl
	
	pushl %ecx
	pushl $min_pos_msg
	call printf
	addl $8, %esp		

	ret
##########################################################################
# funzione che stampa il valore che compare piu' frequentemente			 #
##########################################################################
.type printMaxFreqValue, @function

printMaxFreqValue:
	xorl %eax, %eax
	xorl %ebx, %ebx
	xorl %ecx, %ecx     #valFreq (variabile file c)
	xorl %edx, %edx     #imposto indice ciclo interno
	xorl %esi, %esi     #imposto indice ciclo esterno
	
	movb $-1, %bl	#maxFreq (variabile file c)
	movb $0, %bh	#freq (variabile file c)

#imposto il valore per il quale devo contare la frequenza
setValue:
	movl vector(%esi), %eax

#effettuo il confronto
compare:
	cmpl vector(%edx), %eax
	je freqPP
	jne intPP

#incremento il contatore della frequenza
freqPP:
	incb %bh

#faccio scorrere il ciclo interno
intPP:
	addl $4, %edx
	cmpl max_index, %edx
	jng compare
	jg checkFreq

#controllo se la frequenza del valore appena controllata e' maggiore di quella massima stabilita
checkFreq:
	cmpb %bl, %bh
	jg updateValues
	jng extPP

#aggiorno i valori delle frequenze
updateValues:
	xorb %bl, %bl
	movb %bh, %bl
	xorl %ecx, %ecx
	movl vector(%esi), %ecx

#faccio scorrere il ciclo esterno
extPP:
	xorb %bh, %bh
	xorl %edx, %edx
	addl $4, %esi
	cmpl max_index, %esi
	jng setValue
	jg done

#stampo il valore che compare piu' frequentemente
done:
    pushl %ecx
    pushl $max_freq_msg
    call printf
    addl $8, %esp 

	ret
##########################################################################
# funzione che stampa la media dei valori del vettore					 #
##########################################################################
.type printMean @function

printMean:
	xorl %eax, %eax
	xorl %ebx, %ebx
	xorl %ecx, %ecx
	xorl %edx, %edx
	xorl %esi, %esi

    movl max_index, %ebx
    movl $0, %esi

#sommo i valori del vettore e poi divido il risultato per 10, poi stampo la media
sum:
    addl vector(%esi), %eax
    addl $4, %esi
    cmpl %esi, %ebx
    jnl sum

	cmpl $0, %eax
	jl negSum
	jnl posSum

negSum:
	xorl %ecx, %ecx
	movl $-1, %ecx
	mull %ecx

	xorl %edx, %edx
	xorl %ecx, %ecx
    movl length, %ecx
	div %ecx

	xorl %edx, %edx
	xorl %ecx, %ecx
	movl $-1, %ecx
	mull %ecx

	pushl %eax
    pushl $mean_msg
    call printf
    addl $8, %esp    

	ret

posSum:
    movl length, %ecx
    div %ecx

    pushl %eax
    pushl $mean_msg
    call printf
    addl $8, %esp  

	ret

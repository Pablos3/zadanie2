/*
 * zadanie2.asm
 *
 *  Created: 2014-11-05 10:37:19
 *   Author: Pawe³ Syka³a
 */ 

;Wykonanie dodawania liczb p1 i p2 dla dowolnej dlugosci tych liczb
.DSEG
.ORG 0x01FF ;zaczynamy od tego segmentu pamieci
.EQU LEN=2 ;zmienne beda mialy taka sama dlugosc 
p1: .BYTE LEN  ;zmienna p1
p2: .BYTE LEN  ;zmienna p2
.CSEG ;w tym momencie program zaczyna swoja prace(wykonywanie)
LDI XL,LOW(p1) ;wczytywanie p1 do rejestru X
LDI XH,HIGH(p1);wczytywanie p1 do rejestru X
LDI YL,LOW(p2) ;wczytywanie p2 do rejestru Y
LDI YH,HIGH(p2);wczytywanie p2 do rejestru Y
LDI ZL,LOW(LEN) ;wczytywanie dlugosci do rejestru
LDI ZH,HIGH(LEN);wczytywanie dlugosci do rejestru
CLC ; flaga carry zostaje wyczyszczona czyli dostaje wartosc 0
LDI R20,low(RAMEND)
LDI R21,high(RAMEND) ; stos zostaje zainicjowany na koncu pamieci
OUT SPL,R20  
OUT SPH,R21 ;przekazujemy wskaznik do rejetru w którym znajduje sie stos

CALL WLOZ_DOSTOSU ; po tej instrucji cal  wkladamy na stos adresy rejestrow tutaj wykonuje sie to w petli,petla ktora konczy wykonanie programu

KONIEC:
RJMP KONIEC 
WLOZ_DOSTOSU:
	PUSH R16 ; zapisanie stanu rejestru R16 na stos wcelu uniknienia utraty danych
	PUSH R17 ; zapisanie stanu rejestru R17 na stos wcelu uniknienia utraty danych
	PUSH R18 ; zapisanie stanu rejestru R18 na stos wcelu uniknienia utraty danych
	PUSH R19 ; zapisanie stanu rejestru R19 na stos wcelu uniknienia utraty danych 
 	LDI R18,0 ;zerujemy rejestr R18
	LDI R19,0 ;zerujemy rejestr R19
LOOP:    
	CPSE ZH,R18 ;sprawdzamy wartosc ZH czy przypadkiem nie jest zerem bo jezeli jest to patrz nizej
	RJMP LOOP2;jak wartosc ZH rozna od zera to  wykonujemy petle
	CPSE ZL,R18 ;sprawdzamy wartosc ZL czy przypadkiem nie jest zerem bo jezeli jest to patrz nizej
	RJMP LOOP2 ;jak nie to powrot do petli
	RJMP Funkcja ;zakonczenie programu w przypadku obydwu 0
LOOP2:
	CPI R19,0 ;sprawdza czy zapamitana wartosc carry to 0
	BRNE CWST ;przejdz do CWST jezeli carry jest zerem
	CLC ;wyczyszczenie flagi carry do wartosci 0
	RJMP LOOP3
	CWST:
	SEC ;bit carry zostaje aktywowany
LOOP3:
	LD R16,X+ ;wczytanie X do rejestru R16 i inkrementacja X
	LD R17,Y
	ADC R17,R16
	BRCC CARZ ;sprawdza flage carry czy jest aktywna jezeli nie jest aktywna to przechodzi do CARZ
	LDI R19,1 ;wpisanie wartosci do rejestru R19
	RJMP CARD petla CARD
	CARZ:
	LDI R19,0 ;wpisanie wartosci do rejestru R19
	CARD: 
	ST Y+,R17 ;Wpisanie rejestru R17 do zmiennej Y i inkrementacja 
	SBIW Z,1 ;Z zostaje zdekrementowany
	RJMP LOOP 
Funkcja:
	;Licznik przy wartosci 0 aktywuje funkcje 
	POP R16 ; zabiera wartosc z rejestru R16 ktora zostala wczesniej zapisana
	POP R17 ; zabiera wartosc z rejestru R17 ktora zostala wczesniej zapisana
	POP R18 ; zabiera wartosc z rejestru R18 ktora zostala wczesniej zapisana
	POP R19 ; zabiera wartosc z rejestru R19 ktora zostala wczesniej zapisana
	RET ; Subroutine Return czyli powrot podprogramu
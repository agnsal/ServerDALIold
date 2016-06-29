
:-use_module(library(random)),
  use_module(library(lists)),
  use_module(library(system)),
  use_module(library('linda/client')),
  use_module(library(fdbg)).

user.

% apri in lettura il file, Stream è la variabile dove metto lo stream e le opzioni sono niente
utente:-open('../interpreter/server.txt',read,Stream,[]),
              read(Stream,I),
              close(Stream),linda_client(I),
			  out(agente_attivo(user,I)),
			  procedure_message(I).

%%%%%%%%%%%
%% L’agente DALI e’ continuamente attivo ed in attesa di messaggi ed attraverso una apposita procedura tiene 
%% continuamente sotto controllo il suo ambiente. Un evento, una volta catturato dall’agente, viene associato 
%% ad un timestamp perche’ mantenga l’unicita’. Il messaggio, una volta ricevuto, viene automaticamente 
%% rimosso.
%%%%%%%%%%%

procedure_message(I):-print('Insert name of addressee'),nl,read(D),
                  
                   print('Insert From'),nl,read(From),
                   print('Insert message'),nl,read(M),
                   go(M),clause(result_format(F),_),
                   out(message(I,D,I,From,italian,[],F)),nl,  
                   assert(ind(I)),
                   print('New message'),nl,procedure_message(I).



go(T):-variables(T,_,[]). %%innesco sul predicato variables. T è il MESSAGGIO %%

%TRASFORMA DA VAR A NAMING VAR
%% METTE GLI fd_var davanti alle variabili che compaiono nel messaggio %%

%%message('tir-486':3010,nessuno,'tir-486':3010,davide,italian,[],cavallo(fdvar_1,fdvar_2,fdvar_3,cakkio)) 


%% mette alla variabile X il fdvar davanti ma a che serve?
variables(X,[X|L0],L):-var(X),fdbg_assign_name(X,N),
                       X=N,!,L=L0.
%functor usata in questo modo mi restituisce l'arità del functore T'
variables(T,L0,L):-nonvar(T),
                   functor(T,_,A),
                   variables(0,A,T,L0,L).

variables(A,A,T,L0,L):-retractall(result_format(_)),assert(result_format(T)),!,L=L0.
variables(A0,A,T,L0,L):-
          A0<A,
          A1 is A0+1,
          arg(A1,T,X),
          variables(X,L0,L1),
          variables(A1,A,T,L1,L).

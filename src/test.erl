%%%-------------------------------------------------------------------
%%% @author QiLi
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. jan 2017 13:32
%%%-------------------------------------------------------------------
-module(test).
-author("QiLi").

-compile(export_all).
%% API

double(N) ->
   N*2.

ftoc(F) ->
  (F - 32) / 1.8.

recta(L,W) ->
  L * W.

squara(L)->
  W=L,
  recta(L,W).

circlea(R) ->
  R*R*3.15.

product1(M,N) ->
  if
    M == 0 -> 0 ;
    true -> N + product1(M-1,N)
  end.

product2(M,N) ->
  case M of
    0 -> 0;
    _ -> N + product2(M-1,N)
  end.

product3(0,_) ->
  0;
product3(M,N) ->
  N + product3(M-1,N).

exp(_,0) ->
  1;
exp(X,Y)->
  product1(X,exp(X,Y-1)).

expf(X,1) ->
  X;
expf(X,Y) ->
  if
    Y rem 2 ==0 ->
      A= expE(X,Y div 2),
      A*A;
    true -> A=expE(X,(Y - 1) div 2),
            A*A*X
  end.

expE(_,0) ->
  1;
expE(X,Y) ->
  X*expE(X,Y-1).


nth(N,L) ->
  [H|T]=L,
  if
    N == 0 -> H;
    true ->
nth(N-1,T)
  end.

number(L) ->
  [_ | T] = L,
  if
    T ==[] -> 1;
    true ->1+number(T)
  end.

sum(L) ->
  [H|T]=L,
  if
    T ==[] -> H;
    true ->H+sum(T)
  end.


duplicate(L) ->
  [H|T]=L,
  if
    T==[] -> [H,H];
    true ->lists:append([H,H],duplicate(T))
  end.

unique(L) ->
  S = sets:from_list(L),
  lists:sort(sets:to_list(S)).

reverse(L) ->
  [H|T]=L,
  if
    T==[] ->[H] ;
    true -> lists:append(reverse(T),[H])
  end.

pack(L)->
  Y =unique(L),
pack(L,Y).
pack(L,Y) ->
  [YH|YT]=Y,
  A=[X|| X<-L,X==YH],
  if
    YT==[] -> [A]  ;
    true -> lists:append(pack(L,YT),[A])
  end.

insert(Element,[])-> [Element|[]];
insert(Element,List) ->
A=[X|| X<-List,X<Element],
B=[Y || Y<- List,Y >Element],
  C=[Element|B],
  fix(Element,A,C).

fix(_,[],C)-> C;
fix(Element,A,C) ->
  [H|T]=A,
  if
    T==[] -> [H|C];
    true ->
      [H|fix(Element,T,C)]
  end.

isort(List) ->
  Sorted = [],
  isort(List,Sorted).


isort([Hl|Tl],Sorted) ->
  if
    Tl==[] -> insert(Hl,Sorted);
    true -> insert(Hl,isort(Tl,Sorted))
  end.

lt(C1,C2)->
  if
    C1<C2 -> false ;
    true -> true
  end.

msort(L) ->
  {L1,L2}=msplit(L),
  merge(L1,L2).

merge([], S2) -> S2;
merge(S1, []) ->S1 ;
merge([C1|S1],[C2|S2])->
  case lt(C1, C2) of
    true ->
      [C1 | merge(S1, [C2|S2])];
    false ->
    [C2 | merge([C1|S1], S2)]
end.



msplit(Deck) ->
  msplit(Deck, [], []).
msplit([], D1, D2) ->
  {D1, D2};
msplit([H|T],D1,D2) ->
  msplit(T,D2,[H|D1]).


%%%-------------------------------------------------------------------
%%% @author QiLi
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. jan 2017 14:32
%%%-------------------------------------------------------------------
-module(huffman).
-author("QiLi").

%% API
-compile(export_all).

sample() ->
  "the quick brown fox jumps over the lazy dog this is a sample text that we will use when we build up a table we will only handle lower case letters and no punctuation symbols the frequency will of course not represent english but it is probably not that far off".

text() ->
  "this is something that we should encode".
%%test() ->
%%  Sample = sample(),
%%  Tree = tree(Sample),
%%  Encode = encode_table(Tree),
%%  Decode = decode_table(Tree),
%%  Text = text(),
%%  Seq = encode(Text, Encode),
%%  Text = decode(Seq, Decode).

%%tree(Sample) ->
%%  Freq = freq(Sample),
%%  huffman(Freq).
number(L) ->
  [_|T]=L,
  if
    T ==[] -> 1;
    true ->1+number(T)
  end.

tree(Sample,S) ->
  FreqT=freq(Sample),
  Omax=number(FreqT),
  if
    S=="N" ->N = 1;
    true -> N=S
  end,
  build(FreqT,N,Omax).

  build(FreqT,N,Omax)->
  [L1,L2|T]=FreqT,
    Val =element(2,L1)+element(2,L2),
    if
      N== Omax-> FreqT;
      true -> L=lists:keysort(2,[{{{element(1,L1),[0]},{element(1,L2),[1]}},Val}|T]),
        case number(L) of
          N -> L;
          _Else -> build(L,N,Omax)
        end
    end.






freq(Sample)->
  FreqM=#{},
    A = maps:to_list(fix(Sample,FreqM)),
   lists:keysort(2,A).

  fix(Sample,FreqM)->
  [H|T]=Sample,
  Key =H,
  if
    T==[] -> mapadd(Key,FreqM);
    true -> mapadd(Key,fix(T,FreqM))
  end.


  mapadd(Key,FreqM)->
  case maps:get(Key, FreqM, "NE") of
      "NE"->
        Val =1,
        FreqM#{Key => Val};
    _Else ->
      Val=maps:get(Key,FreqM),
      FreqM#{Key := Val+1}
end.



test(L) ->
FreqM = #{},
  FreqM#{L => 1}.


%%encode_table(_Tree) ->
%%[H|T]=_Tree,
%%  Tree=element(1,H),
%%  encode(Tree,{element(1,Tree),[0]},{element(2,Tree),[1]}).

%%  encode(Tree,Left,Right)->
%%    Left={element(1,Tree),[[0]| },
%%  Right={element(2,Tree),[[1]| }


decode() ->
  Table=decode_table(),
 decode(base(),Table, Table).


decode([], _, _) -> [];
decode([H|T], {node, Char, Long, Short},Root) ->
  case H of
    $. -> decode(T, Short, Root);
    $- ->decode(T,Long, Root);
    _Else -> [Char| decode(T, Root, Root)]
  end.


%%% The codes that you should decode:

base() ->
".- .-.. .-.. ..-- -.-- --- ..- .-. ..-- -... .- ... . ..-- .- .-. . ..-- -... . .-.. --- -. --. ..-- - --- ..-- ..- ... ".


rolled() ->
  ".... - - .--. ... ---... .----- .----- .-- .-- .-- .-.-.- -.-- --- ..- - ..- -... . .-.-.- -.-. --- -- .----- .-- .- - -.-. .... ..--.. ...- .----. -.. .--.-- ..... .---- .-- ....- .-- ----. .--.-- ..... --... --. .--.-- ..... ---.. -.-. .--.-- ..... .---- ".


%%% The decoding tree.

decode_table() ->
  {node,na,
    {node,116,
      {node,109,
        {node,111,
          {node,na,{node,48,nil,nil},{node,57,nil,nil}},
          {node,na,nil,{node,56,nil,{node,58,nil,nil}}}},
        {node,103,
          {node,113,nil,nil},
          {node,122,
            {node,na,{node,44,nil,nil},nil},
            {node,55,nil,nil}}}},
      {node,110,
        {node,107,{node,121,nil,nil},{node,99,nil,nil}},
        {node,100,
          {node,120,nil,nil},
          {node,98,nil,{node,54,{node,45,nil,nil},nil}}}}},
    {node,101,
      {node,97,
        {node,119,
          {node,106,
            {node,49,{node,47,nil,nil},{node,61,nil,nil}},
            nil},
          {node,112,
            {node,na,{node,37,nil,nil},{node,64,nil,nil}},
            nil}},
        {node,114,
          {node,na,nil,{node,na,{node,46,nil,nil},nil}},
          {node,108,nil,nil}}},
      {node,105,
        {node,117,
          {node,32,
            {node,50,nil,nil},
            {node,na,nil,{node,63,nil,nil}}},
          {node,102,nil,nil}},
        {node,115,
          {node,118,{node,51,nil,nil},nil},
          {node,104,{node,52,nil,nil},{node,53,nil,nil}}}}}}.


%%% The codes in an ordered list.

codes() ->
  [{32,"..--"},
    {37,".--.--"},
    {44,"--..--"},
    {45,"-....-"},
    {46,".-.-.-"},
    {47,".-----"},
    {48,"-----"},
    {49,".----"},
    {50,"..---"},
    {51,"...--"},
    {52,"....-"},
    {53,"....."},
    {54,"-...."},
    {55,"--..."},
    {56,"---.."},
    {57,"----."},
    {58,"---..."},
    {61,".----."},
    {63,"..--.."},
    {64,".--.-."},
    {97,".-"},
    {98,"-..."},
    {99,"-.-."},
    {100,"-.."},
    {101,"."},
    {102,"..-."},
    {103,"--."},
    {104,"...."},
    {105,".."},
    {106,".---"},
    {107,"-.-"},
    {108,".-.."},
    {109,"--"},
    {110,"-."},
    {111,"---"},
    {112,".--."},
    {113,"--.-"},
    {114,".-."},
    {115,"..."},
    {116,"-"},
    {117,"..-"},
    {118,"...-"},
    {119,".--"},
    {120,"-..-"},
    {121,"-.--"},
    {122,"--.."}].





%%decode_table(_Tree) -> na.
%%encode(_Text, _Table) -> na.
%%decode(_Seq, _Table) -> na.


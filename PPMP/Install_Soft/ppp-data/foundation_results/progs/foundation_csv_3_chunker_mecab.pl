:- encoding(utf8).
:- dynamic used_morph_number/1.
:- dynamic rule/7.
:- multifile rule/7.
:- dynamic rule/9.
:- multifile rule/9.
%:- load_files(['F:/SVN/PumpkinPyParser/data_csv_results/mecab_pl/foundation_csv_3_cabocha.pl']).
:- load_files(['G:/SVN/Install_Soft/ppp-data/foundation_results/mecab_pl/foundation_csv_3_mecab.pl']).

% facts
pos_class(taigen, ['名詞', _]).

% 1. Head
catch_class(['名詞', '形容動詞語幹'], '体用言').
catch_class(['名詞', _], '体言').

catch_class(['動詞', _], '用言').
catch_class(['形容詞', _], '用言').

catch_class(['連体詞', _], '').
catch_class(['副詞', _], '').
catch_class(['接続詞', _], '').
catch_class(['感動詞', _], '').

catch_class(['接頭詞', '名詞接続'], '体言').
catch_class(['接頭詞', '数接続'], '体言').

% 2. Tail
throw_class(['助詞', 'か'], '連用').
throw_class(['助詞', 'が'], '連用').
throw_class(['助詞', 'かも'], '連用').
throw_class(['助詞', 'から'], '連用').
throw_class(['助詞', 'くらい'], '連用').
throw_class(['助詞', 'ぐらい'], '連用').
throw_class(['助詞', 'けど'], '連用').
throw_class(['助詞', 'けれど'], '連用').
throw_class(['助詞', 'けれども'], '連用').
throw_class(['助詞', 'さ'], '連用').
throw_class(['助詞', 'さえ'], '連用').
throw_class(['助詞', 'し'], '連用').
throw_class(['助詞', 'しか'], '連用').
throw_class(['助詞', 'ずつ'], '連用').
throw_class(['助詞', 'たり'], '連用').
throw_class(['助詞', 'だの'], '連用').
throw_class(['助詞', 'だけ'], '連用').
throw_class(['助詞', 'って'], '連用').
throw_class(['助詞', 'っと'], '連用').
throw_class(['助詞', 'て'], '連用').
throw_class(['助詞', 'で'], '連用').
throw_class(['助詞', 'でも'], '連用').
throw_class(['助詞', 'と'], '連用').
throw_class(['助詞', 'という'], '連用').
throw_class(['助詞', 'といった'], '連用').
throw_class(['助詞', 'とか'], '連用').
throw_class(['助詞', 'として'], '連用').
throw_class(['助詞', 'とともに'], '連用').
throw_class(['助詞', 'ながら'], '連用').
throw_class(['助詞', 'など'], '連用').
throw_class(['助詞', 'なり'], '連用').
throw_class(['助詞', 'に'], '連用').
throw_class(['助詞', 'において'], '連用').
throw_class(['助詞', 'に従って'], '連用').
throw_class(['助詞', 'について'], '連用').
throw_class(['助詞', 'に対して'], '連用').
throw_class(['助詞', 'につれて'], '連用').
throw_class(['助詞', 'によって'], '連用').
throw_class(['助詞', 'による'], '連用').
throw_class(['助詞', 'ね'], '連用').
throw_class(['助詞', 'ので'], '連用').
throw_class(['助詞', 'のに'], '連用').
throw_class(['助詞', 'のみ'], '連用').
throw_class(['助詞', 'は'], '連用').
throw_class(['助詞', 'ば'], '連用').
throw_class(['助詞', 'ばかり'], '連用').
throw_class(['助詞', 'へ'], '連用').
throw_class(['助詞', 'ほど'], '連用').
throw_class(['助詞', '程'], '連用').
throw_class(['助詞', 'まで'], '連用').
throw_class(['助詞', '迄'], '連用').
throw_class(['助詞', 'も'], '連用').
throw_class(['助詞', 'や'], '連用').
throw_class(['助詞', 'より'], '連用').
throw_class(['助詞', 'を'], '連用').
throw_class(['助詞', 'を通して'], '連用').
throw_class(['助詞', 'を通じて'], '連用').
throw_class(['助詞', 'んで'], '連用').

throw_class(['助詞', 'な'], '連体').
throw_class(['助詞', 'の'], '連体').

throw_class(['助動詞', '基本形'], '連体').
throw_class(['助動詞', _], '連用').

throw_class(['形容詞', '基本形'], '連体').
throw_class(['形容詞', _], '連用').

throw_class(['名詞', _], '連用').

throw_class(['動詞', '基本形'], '連体').
throw_class(['動詞', _], '連用').

throw_class(['連体詞', _], '連体').
throw_class(['副詞', _], '連用').
throw_class(['接続詞', _], '連用').
throw_class(['感動詞', _], '連用').

chunk :-
        TaigenHeadClassList = [['名詞', _]],
        %RenyoTailClassList = ['て', 'も'],
        findall(_,
                (       rule(m, _, _, _, Max_N, _, _),
                        flag(count, _, Max_N)
                ),
                _
        ),
        flag(count, Max_N, Max_N),
        format('Max_N = ~w~n', [Max_N]),

        retractall(rule(b, _, _, _, _, _, _, _, _)),
        retractall(used_morph_number(_)),
        % チャンク
        findall(_,
                (
                        between(0, Max_N, N),
                        not(used_morph_number(N)),
                        rule(m, X, Y, Z, N, _, D),
                        
                        chunk(X, Y, Z, N),
                        true
                ),
                _
        ),

        % rule(m, 3, 3, 0, 16, ['安い', '形容詞', '自立', '*', '*', '形容詞・アウオ段', '基本形', '安い', 'ヤスイ', 'ヤスイ'], 'foundation').

        % 記録する
        %OFile = 'F:/SVN/PumpkinPyParser/data_csv_results/mecab_pl/test.pl',
        OFile = 'G:/SVN/Install_Soft/ppp-data/foundation_results/mecab_pl/foundation_csv_3_mecab_synthesis.pl',
        open(OFile, write, OStream, [encoding(utf8)]),          % sjis(cp932)ではエラーが出る。
        format(OStream, ':- encoding(utf8).~n', []),
        format(OStream, ':- dynamic rule/9.~n', []),
        format(OStream, ':- multifile rule/9.~n', []),
        format(OStream, '% rule(b, 列, 行, コメント, 通し番号, [ここから, ここまで], [受け, 投げ, 複合語, 文節], [[受け品詞, 受け語], [投げ品詞, 投げ品詞]], データセット)).~n', []),
        findall(_,
                (       between(0, Max_N, N),
                        rule(b, X, Y, Z, N, Pos, Func, KU_List, D),
                        format(OStream, 'rule(b, ~w, ~w, ~q, ~w, ~q, ~q, ~q, ~q).~n', [X, Y, Z, N, Pos, Func, KU_List, D])
                ),
                _
        ),
        close(OStream),

        % 未説明のものを選んで記録する。
        %OFile2 = 'F:/SVN/PumpkinPyParser/data_csv_results/mecab_pl/test_rest.pl',
        OFile2 = 'G:/SVN/Install_Soft/ppp-data/foundation_results/mecab_pl/foundation_csv_3_mecab_synthesis_rest.pl',
        open(OFile2, write, OStream2, [encoding(utf8)]),                % sjis(cp932)ではエラーが出る。

        format(OStream2, ':- encoding(utf8).~n', []),
        format(OStream2, ':- dynamic rule/7.~n', []),
        format(OStream2, ':- multifile rule/7.~n', []),

        findall(_,
                (
                        between(0, Max_N, N),
                        rule(m, X, Y, Z, N, List, D),
                        (       used_morph_number(N)
                        ->      true
                        ;       format(OStream2, 'rule(m, ~w, ~w, ~q, ~w, ~q, ~w).~n', [X, Y, Z, N, List, D])
                        )
                ),
                _
        ),
        close(OStream2),
        
        % 係り受けの生成と保存
        find_kakari2uke,
        save_dep,
        true.

compound_ok(PrevHeadClass, PrevStemType, HeadClass, StemType):-
    PrevHeadClass = '接頭詞',
    member(HeadClass, ['名詞', '動詞']),
    true.

compound_ok(PrevHeadClass, PrevStemType, HeadClass, StemType):-
    PrevHeadClass = '名詞',
    not(PrevStemType = '副詞可能'),
    member(HeadClass, ['名詞']),
    true.

% (0) -(助詞)+
complete_bunsetsu(X, Y, N, N_Last, Comment, StemTypeList, CascadeComment, WordList, ResultWordList) :-
    N1 is N + 1,
    (   rule(m, X, Y, _, N1, [Joshi1, Particle, StemType, _ | _], D)
    ->  Comment = [PrevHeadClass | _],
        StemTypeList = [PrevStemType | _],
        (   %member(Particle, ['名詞', '動詞']), member(PrevHeadClass, ['名詞', '接頭詞'])
            compound_ok(PrevHeadClass, PrevStemType, Particle, StemType)
        ->  complete_bunsetsu(X, Y, N1, N_Last, ['名詞' | Comment], [StemType | StemTypeList], CascadeComment, [Joshi1 | WordList], ResultWordList)
        ;
            (   member(Particle, ['助詞', '助動詞'])
                % rule(m, _, _, _, N1, [Joshi1, '助詞', _, _ | _], D)
            ->
                %N2 is N1 + 1,
                complete_bunsetsu(X, Y, N1, N_Last, [Joshi1 | Comment], [StemType | StemTypeList], CascadeComment, WordList, ResultWordList)
            ;   (   member(Particle, ['形容詞', '動詞']),
                    member(StemType, ['非自立', '接尾'])
                    % 付け + やすい, いる + ので
                ->
                    complete_bunsetsu(X, Y, N1, N_Last, [Joshi1 | Comment], [StemType | StemTypeList], CascadeComment, WordList, ResultWordList)
                ;
                    reverse(Comment, CascadeComment),
                    reverse(WordList, ResultWordList),
                    N_Last is N,
                    true
                )
            )
        )
    ;   reverse(Comment, CascadeComment),
        reverse(WordList, ResultWordList),
        N_Last is N,
        true
    ),
    !.

% (1) 文節-
chunk(X, Y, Z, N):-
    % 1. Head
    rule(m, X, Y, _, N, [HeadWord, HeadClass, StemType, _, _, _, InflType, HeadLemma | _], D),
    N1 is N + 1,
    
    (    rule(m, X, Y, _, N1, [HeadWord1, HeadClass1, StemType1, _, _, _, _, HeadLemma1 | _], D)
    ->  (   InflType = '連用形',
            HeadLemma1 = 'て'
        ->  % 歩いて
            HeadType = '用言'
        ;   (   InflType = '連用形',
                member(HeadClass1, ['助詞'])
            ->  % 歩きで
                HeadType = '体言'
            ;   (   catch_class([HeadClass, StemType], HeadType)        % HeadType is fixed here
                ->  true
                ;   HeadType = 'zzzz1'
                )
            )
        )
    ;   (   catch_class([HeadClass, StemType], HeadType)        % HeadType is fixed here
        ->  true
        ;   HeadType = 'zzzz2'
        )
    ),

    (   HeadClass = '名詞'
    ->  Title = '(1) 体言'
    ;   (   StemType = '自立'
        ->  Title = '(2) 用言'
        ;   (   member(HeadClass, ['連体詞', '副詞', '感動詞', '接続詞'])
            ->  concat_atom(['(2) ', HeadClass], Title)
            ;   (   member(HeadClass, ['接頭詞']),
                    member(StemType, ['名詞接続', '数接続'])
                ->  concat_atom(['(3) ', '接辞'], Title)
                ;   fail
                )
            )
        )
    ),

    complete_bunsetsu(X, Y, N, N_Last, [HeadClass], [StemType], CascadeComment, [HeadWord], ResultWordList),
    concat_atom([Title | CascadeComment], '-', CascadeCommentStr),
    concat_atom(ResultWordList, ResultWordStr),
    length(ResultWordList, ResultWordStrLen),

    % rule(m, 3, 76, 0, 622, ['っぽい', '形容詞', '接尾', '*', '*', '形容詞・アウオ段', '基本形', 'っぽい', 'ッポイ', 'ッポイ'], 'foundation').

    % 2. Tail
    rule(m, X, Y, _, N_Last, [TailParticle, TailClass, _, _, _, _, Param7, TailLemma | _], D),
    !,
    (   member(TailClass, ['助動詞', '動詞', '形容詞'])
    ->  SecondParam = Param7
    ;   SecondParam = TailParticle
    ),

    (   throw_class([TailClass, SecondParam], TailType)    % TailType is fixed here
    ->  true
    ;   TailType = 'zzz'
    ),

    % 3. Assertiom
/*
    (   HeadLemma = '*'
    ->  HeadLemma1 = HeadWord
    ;   HeadLemma1 = HeadLemma
    ),
*/
    findall(HeadWordx,
        (   between(N, N_Last, Nx),
            rule(m, _, _, _, Nx, [HeadWordx | _], D),
            assert(used_morph_number(Nx))
        ),
        HeadWordxList
    ),
    findall([HeadClassx, HeadLemmax1],
        (   between(N, N_Last, Nx),
            rule(m, _, _, _, Nx, [HeadWordx, HeadClassx, _, _, _, _, _, HeadLemmax | _], D),
            (   HeadLemma = '*'
            ->  HeadLemmax1 = HeadWordx
            ;   HeadLemmax1 = HeadLemmax
            )
        ),
        HeadClass_HeadLemma_List
    ),
    concat_atom(HeadWordxList, HeadWordxStr),

    % rule(m, _, _, _, N, [HeadWord, _, _, _, _, _, _, _ | _], D)
/*
    (   member(HeadClass, ['名詞', '接頭詞'])
    ->  (   ResultWordStr = HeadWord
        ->  Compound = ''
        ;   Compound = ResultWordStr
        )
    ;   Compound = ''
    ),
*/
    (   member(HeadClass, ['名詞', '接頭詞'])
    ->  (   ResultWordStrLen > 1
        ->  Compound = [ResultWordStrLen, ResultWordStr]
        ;   Compound = [0, '']
        )
    ;   Compound = [0, '']
    ),

    % 場合により、HeadLemma1 or HeadWord
    assert(rule(b, X, Y, CascadeCommentStr, N, [N, N_Last], [HeadType, TailType, Compound, HeadWordxStr], HeadClass_HeadLemma_List, D)),
    true.

chunk(X, Y, Z, N):-
    % 1. 孤立
    rule(m, X, Y, _, N, [HeadWord, HeadClass, StemType, _, _, _, Infl, HeadLemma | _], D),
    (   HeadClass = '記号'
    ->  %assert(rule(b, X, Y, '(4) 記号', N, [[N, N], [[StemType, HeadClass], [HeadClass, HeadWord], [HeadClass, HeadWord]]], D)),
        assert(rule(b, X, Y, '(4) 記号', N, [N, N], [StemType, HeadWord], [], D)),
        assert(used_morph_number(N)),
        !
    ;
        (   member(HeadClass, ['連体詞', '副詞', '接続詞', '感動詞', '名詞', '動詞']),
            concat_atom(['(3) ', HeadClass], CascadeCommentStr),
            (   HeadClass ='連体詞'
            ->  HeadType = '',
                TailType = '連体'
            ;   (   member(HeadClass, ['副詞', '接続詞', '感動詞'])
                ->  HeadType = '',
                    TailType = '連用'
                ;   HeadType = 'zzz1',
                    TailType = 'zzz2'
                )
            ),
/*
            (   Infl = '基本形'
            ->  TailType = '連体'
            ;   TailType = '連用'
            ),
*/
            assert(rule(b, X, Y, CascadeCommentStr, N, [N, N], [HeadType, TailType], [[HeadClass, HeadLemma], [HeadClass, HeadWord]], D)),
            assert(used_morph_number(N)),
            !
        )
    ).

find_kakari2uke:-
    retractall(rule(dep, _, _, _, _)),
    %ColNo = 3,
    % RowNo = 4,
    % Seq = b,
    retractall(rule(dep, _, _, _, _)),
    findall(_,
        (    %between(4, 6, RowNo),
            rule(b, ColNo, RowNo, Comment, Seq, _, UkeKakari, UkeKakari2, _),
            UkeKakari = [_, _, [Num, Compound00] |_],
            UkeKakari2 = [[_, Compound01] |_],
            %format('++0++ Compound00 = ~w~n', [Compound00]),
            %format('++1++ Compound01 = ~w~n', [Compound01]),
            %format('++2++ UkeKakari = ~w~n', [UkeKakari]),
            select_word(Num, Compound00, Compound01, Compound0),
            %format('Seq = ~w, UkeKakari = ~w, UkeKakari2 = ~w, Compound0 = ~w~n',
            %    [Seq, UkeKakari, UkeKakari2, Compound0]),
            % SeqList = [17,19,20,21,22,24,25,27,28,29]
            find_uke([ColNo, RowNo, Comment, Seq, UkeKakari], [Type, Seq1, Compound1]),
            %format('~w: ~w(~w) -> ~w(~w)~n', [Type, Seq, Compound0, Seq1, Compound1]),
            assert(rule(dep, Type, [ColNo, RowNo], [Seq, Compound0], [Seq1, Compound1])),
            true
        ),
        _
    ),
    % listing(rule(dep, _, _, _, _)),
    true.

select_word(Num1, Compound10, Compound11, Compound1):-
    %format('++x++ Num1 = ~w, Compound10 = ~w, Compound11 = ~w, Compound1 = ~w~n', [Num1, Compound10, Compound11, Compound1]),
    (   Num1 = 0
    ->  Compound1 = Compound11
    ;   Compound1 = Compound10
    ).

find_uke([ColNo, RowNo, Comment, Seq, [_, '連用' |_]], ['連用', Seq1, Compound1]):-
    %format('111~n'),
    member(Uke1, ['用言', '体用言']),
    rule(b, ColNo, RowNo, Comment1, Seq1, _, [Uke1, _, [Num1, Compound10] |_], [[_, Compound11] |_], _),
    Seq1 > Seq,
    select_word(Num1, Compound10, Compound11, Compound1),
    %format('222 Seq1 = ~w, Uke1 = ~w, Num1 = ~w, Compound11 = ~w~n', [Seq1, Uke1, Num1, Coumpound11]),
    !.

find_uke([ColNo, RowNo, Comment, Seq, [_, '連体' |_]], ['連体', Seq1, Compound1]):-
    %format('333~n'),
    member(Uke1, ['体言', '体用言']),
    rule(b, ColNo, RowNo, Comment1, Seq1, _, [Uke1, _, [Num1, Compound10] |_], [[_, Compound11] |_], _),
    Seq1 > Seq,
    select_word(Num1, Compound10, Compound11, Compound1),
    %format('444 Seq1 = ~w, Uke1 = ~w, Num1 = ~w, Compound11 = ~w~n', [Seq1, Uke1, Num1, Coumpound11]),
    !.

save_dep:-
    % tell('F:/SVN/PumpkinPyParser/data_csv/foundation2_results/mecab_pl/foundation_csv_3_dependencies.pl'),
    % tell('G:/SVN/Install_Soft/ppp-data/foundation_results/mecab_pl/foundation_csv_3_dependencies.pl'),
    % format('% rule(dep, Type, [ColNo, RowNo], [Seq, Compound0], [Seq1, Compound1])~n'),
    % listing(rule(dep, _, _, _, _)),
    % told.
    OFile3 = 'G:/SVN/Install_Soft/ppp-data/foundation_results/mecab_pl/foundation_csv_3_dependencies.pl',
    open(OFile3, write, OStream3, [encoding(utf8)]),          % sjis(cp932)ではエラーが出る。
    format(OStream3, ':- encoding(utf8).~n', []),
    format(OStream3, ':- dynamic rule/9.~n', []),
    format(OStream3, ':- multifile rule/9.~n', []),
    format(OStream3, '% rule(b, 列, 行, コメント, 通し番号, [ここから, ここまで], [受け, 投げ, 複合語, 文節], [[受け品詞, 受け語], [投げ品詞, 投げ品詞]], データセット)).~n', []),
    findall(_,
            (       % between(0, Max_N, N),
                    rule(dep, Modtype, [ColNo, RowNo], [MorphNo1, Pitcher], [MorphNo2, Catcher]),
                    % rule(dep, 連用, [3, 1], [1, ぶん], [3, ある]).
                    format(OStream3, 'rule(dep, ~w, [~w, ~w], [~w, ~w], [~w, ~w]).~n', [Modtype, ColNo, RowNo, MorphNo1, Pitcher, MorphNo2, Catcher])
            ),
            _
    ),
    close(OStream3),
    true.
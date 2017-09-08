:- encoding(utf8).
:- dynamic rule/5.
:- multifile rule/5.
:- dynamic rule/7.
:- multifile rule/7.

% self.ui.lineEdit_results_dir.text() + 'progs/morph_seq.pl'
:- load_files(['G:/SVN/Install_Soft/ppp-data/foundation_results/progs/morph_seq.pl']).

% self.ui.lineEdit_results_dir.text() + 'mecab_pl/' + basename_csv_col + '_mecab.pl'
:- load_files(['G:/SVN/Install_Soft/ppp-data/foundation_results/mecab_pl/foundation_csv_3_mecab.pl']).

% F:\SVN\PumpkinPyParser\progs
% 
% 糊付けするレンマ列を記述する。品詞は、最後のレンマの品詞とする。
% 設定ファイルの置き場所: progs/templete/morph_seq.pl
% :- dynamic rule/2.
% :- multifile rule/2.
% rule(concat, ['じ', 'ぶん']).
% rule(concat, ['粉', 'っぽい']).
% rule(concat, ['合う', 'てる']).

% swi-prolog list except last element
% Prolog: Delete last list element
% http://stackoverflow.com/questions/33724526/prolog-delete-last-list-element
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% remove_last(IN_LIST, OUT_LIST).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1. No last element to remove, fail - cut stops alternatives
remove_last([], []) :- !, fail.

% 2. Only one element in list - return empty list - cut stops alternatives
remove_last([_], []) :- !.

% 3. If the rules above did not match, preserve the head of the
% list in the result list and recurse...
remove_last([X | T], [X | T2]) :-
    remove_last(T, T2).


glue_morphs :-
	catch(glue_morphs1, E, (print_message(error, E), fail)), halt.
	% morph_chunk,
	% halt.

glue_morphs :-
	halt(1).


glue_morphs1:-
	retractall(rule(part, _, _, _, _)),
	retractall(rule(glued, _, _, _, _, _, _)),
	retractall(rule(m1, _, _, _, _, _, _)),
	
	% 1. 連結したいレンマ列を見つけて、抽出する。
	findall([Result, SurfConcat, LemmaConcat, X8Concat, X9Concat],
		(	rule(concat, LemmaSeq),
			find_seq([ColNo, RowNo, SentenceNo, MorphNo], LemmaSeq, Result, SurfList, LemmaList, X8List, X9List),
			remove_last(SurfList, SurfListExceptLast),
			last(LemmaList, LemmaLast),
			atomic_list_concat(SurfList, '', SurfConcat),
			%atomic_list_concat(LemmaList, '', LemmaConcat),
			atomic_list_concat(SurfListExceptLast, '', SurfConcatExceptLast),
			atomic_list_concat([SurfConcatExceptLast, LemmaLast], '', LemmaConcat),
			atomic_list_concat(X8List, '', X8Concat),
			atomic_list_concat(X9List, '', X9Concat),
			%format('Result = ~w, SurfConcat = ~w, LemmaConcat = ~w, X8List = ~w, X9List = ~w~n', [Result, SurfConcat, LemmaConcat, X8Concat, X9Concat]),
			true
		),
		ResultSurfConcatLemmaConcatX8ConcatX9ConcatList
	),
	
	% 2. 述語で登録する。
	% chunking result
	% rule(part, ColNo, RowNo, SentenceNo, MorphNo, ...)は、rule(m, ColNo, RowNo, SentenceNo, MorphNo, ...)を消し込む。
	% rule(glued, ColNo, RowNo, SentenceNo, MorphNo, ...)は、rule(m, ColNo, RowNo, SentenceNo, MorphNo, ...)を置き換える。
	findall(_,
		(	member([Result, SurfConcat, LemmaConcat, X8Concat, X9Concat], ResultSurfConcatLemmaConcatX8ConcatX9ConcatList),
			length(Result, Len),
			findall(_,
				(	between(1, Len, N),
					nth1(N, Result, IdList),
					IdList = [ColNo, RowNo, SentenceNo, MorphNo],
					assert(rule(part, ColNo, RowNo, SentenceNo, MorphNo)),
					(	N = Len
					->	rule(m, ColNo, RowNo, SentenceNo, MorphNo, [_Surf, X1, X2, X3, X4, X5, X6, _Lemma, _X8, _X9], Df),
						assert(rule(glued, ColNo, RowNo, SentenceNo, MorphNo, [SurfConcat, X1, X2, X3, X4, X5, X6, LemmaConcat, X8Concat, X9Concat], Df))
					;	true
					)
				),
				_
			)
		),
		_
	),
	%listing(rule(part, _, _, _, _)),
	%listing(rule(glued, _, _, _, _, _, _)),
	
	% 3. rule(m, ...)をrule(m1, ...)として登録する。その際、rule(part, ...)を引いて、rule(glued, ...)を足す。
	findall(_,
		(	rule(m, Y1, Y2, Y3, Y4, Y5List, Df),
			(	rule(part, Y1, Y2, Y3, Y4)
			->	true
			;	assert(rule(m1, Y1, Y2, Y3, Y4, Y5List, Df))
			),
			(	rule(glued, Y1, Y2, Y3, Y4, Z5List, Df)
			->	assert(rule(m1, Y1, Y2, Y3, Y4, Z5List, Df))
			;	true
			)
		),
		_
	),
	

	%tell('F:/SVN/PumpkinPyParser/data_csv/nihongo_results/mecab_pl/nihongo_foundation_csv_3_mecab_glued.pl'),
	open('G:/SVN/Install_Soft/ppp-data/foundation_results/mecab_pl/foundation_csv_3_mecab_glued.pl', write, OStream, [encoding(utf8)]),
	format(OStream, ':- encoding(utf8).~n', []),
	format(OStream, ':- dynamic rule/7.~n', []),
	format(OStream, ':- multifile rule/7.~n', []),

	findall(_,
    	(	rule(m1, Y1, Y2, Y3, Y4, Z5List, Df),
    		(	Z5List = [Z1, Z2, Z3, Z4, Z5, Z6, Z7, Z8, Z9, Z10]
    		->	format(OStream, 'rule(m, ~q, ~q, ~q, ~q, [\'~w\', \'~w\', \'~w\', \'~w\', \'~w\', \'~w\', \'~w\', \'~w\', \'~w\', \'~w\'], \'~w\').~n', [Y1, Y2, Y3, Y4, Z1, Z2, Z3, Z4, Z5, Z6, Z7, Z8, Z9, Z10, Df])
    		;	(	Z5List = [Z1, Z2, Z3, Z4, Z5, Z6, Z7, Z8]
    			->	format(OStream, 'rule(m, ~q, ~q, ~q, ~q, [\'~w\', \'~w\', \'~w\', \'~w\', \'~w\', \'~w\', \'~w\', \'~w\'], \'~w\').~n', [Y1, Y2, Y3, Y4, Z1, Z2, Z3, Z4, Z5, Z6, Z7, Z8, Df])
    			)
    		)
    		/*
	    	(	rule(m1, Y1, Y2, Y3, Y4, [Z1, Z2, Z3, Z4, Z5, Z6, Z7, Z8, Z9, Z10], Df)
	    	->	%format(OStream, 'rule(m, ~q, ~q, ~q, ~q, [~q, ~q, ~q, ~q, ~q, ~q, ~q, ~q, ~q, ~q], , ~q).~n', [Y1, Y2, Y3, Y4, Z1, Z2, Z3, Z4, Z5, Z6, Z7, Z8, Z9, Z10, Df])
	    		format(OStream, 'rule(m, ~q, ~q, ~q, ~q, [\'~w\', \'~w\', \'~w\', \'~w\', \'~w\', \'~w\', \'~w\', \'~w\', \'~w\', \'~w\'], \'~w\').~n', [Y1, Y2, Y3, Y4, Z1, Z2, Z3, Z4, Z5, Z6, Z7, Z8, Z9, Z10, Df])
	    	;	(	rule(m1, Y1, Y2, Y3, Y4, [Z1, Z2, Z3, Z4, Z5, Z6, Z7, Z8], Df)
	    		->	format(OStream, 'rule(m, ~q, ~q, ~q, ~q, [\'~w\', \'~w\', \'~w\', \'~w\', \'~w\', \'~w\', \'~w\', \'~w\'], \'~w\').~n', [Y1, Y2, Y3, Y4, Z1, Z2, Z3, Z4, Z5, Z6, Z7, Z8, Df])
	    		;	true
	    		)
	    	),
	    	*/
	    ),
    	_
    ),
    % listing(rule(m1, _, _, _, _, _, _)),
    close(OStream),

	true.


find_seq([_ColNo, _RowNo, _SentenceNo, _MorphNo], [], [], [], [], [], []):-
	true.

find_seq([ColNo, RowNo, SentenceNo, MorphNo], [Lemma | LemmaSeq], Result, SurfList, LemmaList, X8List, X9List):-
	rule(m, ColNo, RowNo, SentenceNo, MorphNo, [Surf, _, _, _, _, _, _, Lemma, X8, X9], _),
	%format('SentenceNo = ~w, MorphNo = ~w, Surf = ~w, Lemma = ~w~n', [SentenceNo, MorphNo, Surf, Lemma]),
	MorphNo1 is MorphNo + 1,
	find_seq([ColNo, RowNo, SentenceNo, MorphNo1], LemmaSeq, Result1, SurfList1, LemmaList1, X8List1, X9List1),
	Result = [[ColNo, RowNo, SentenceNo, MorphNo] | Result1],
	SurfList = [Surf | SurfList1],
	LemmaList = [Lemma | LemmaList1],
	X8List = [X8 | X8List1],
	X9List = [X9 | X9List1],
	true.
	
/*
add_seq(IdListSeq):-
	length(IdListSeq, Len),
	nth(Len, IdListSeq, LastElement),
	findall([],
		(	member([ColNo, RowNo, SentenceNo, MorphNo, [Surf, Lemma]], IdListSeq),
*/

% rule(m, 3, 1, 0, 0, ['じ', '助動詞', '*', '*', '*', '不変化型', '基本形', 'じ', 'ジ', 'ジ'], 'nihongo_foundation').
% rule(m, 3, 1, 0, 1, ['ぶん', '名詞', '一般', '*', '*', '*', '*', 'ぶん', 'ブン', 'ブン'], 'nihongo_foundation').



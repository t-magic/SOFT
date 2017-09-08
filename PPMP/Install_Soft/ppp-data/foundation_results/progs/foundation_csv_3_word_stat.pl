:- encoding(utf8).

% F:\SVN\PumpkinPyParser\progs\templates
% count_words.pl
% F:\SVN\PumpkinPyParser\data_csv\nihongo_results\mecab_pl\
% nihongo_foundation_csv_3_mecab_synthesis.pl
%:- load_files(['F:/SVN/PumpkinPyParser/data_csv/nihongo_results/mecab_pl/nihongo_foundation_csv_3_mecab_synthesis.pl']).
:- load_files(['G:/SVN/Install_Soft/ppp-data/foundation_results/mecab_pl/foundation_csv_3_mecab_synthesis.pl']).

word_stat :-
	% tell('F:/SVN/PumpkinPyParser/data_csv/nihongo_results/mecab_pl/word_stat_utf8.csv'),
	open('G:/SVN/Install_Soft/ppp-data/foundation_results/mecab_pl/foundation_csv_3_word_stat_utf8.csv', write, OStream, [encoding(utf8)]),
	findall(_,
		(	rule(b, ColNo, RowNo, Comment, SeqNo, [From, To], [Catcher, Pitcher,[ZeroOrInt, Compoundx], Wx], [[Posx,Wordx] | _], Df),
			(	ZeroOrInt = 0
			->	Pos = Posx,
				Word = Wordx
			;	Pos = '複合語',
				Word = Compoundx
			),
			format(OStream, '~w, ~w, ~w, ~w, ~w, ~w~n', [Word, Pos, ColNo, RowNo, Comment, SeqNo])
		),
		_
	),
	close(OStream),
	true.


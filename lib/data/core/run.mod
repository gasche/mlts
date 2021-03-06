module run.
% This is the harness for testing and examples.

accumulate spy, control, lists.
accumulate eval.
accumulate typing.
accumulate utils.
accumulate progs_gen.
accumulate json.


run_tests J4 :- prog Name Prog,
       	    Size is size Name,
	    if (Size > 4) (
       	    Deb is substring Name 0 4,
	    if (Deb = "test") (
       	    eval Prog V,
            term_to_string Prog SProg,
            term_to_string V SV,
	    json_new J,
	    json_add_string "value" SV J J2,
	    json_add_string "prog" SProg J2 J3,
	    json_add_string "name" Name J3 J4
	    ) (fail)
	    ) (fail)
	    .


run_all Json :-
	json_new J,
	alli (run_tests) List,
	json_array_from_json_list List Jarray,
	json_add_val "output" Jarray J J',
	string_of_json J' Json.
	

charge:-open('C:/dali_agents/cuspis/user_profiles/profile_1.txt',read,Stream,[]),
                                   repeat,
                                   read(Stream,T),if(T=end_of_file,true,
                                         assert(T)),
                                    T==end_of_file,!,
                            close(Stream),write('profile charged'),nl.
							
go:-clause(interest(R),_),
    clause(job(K),_),
	clause(age(K1),_),
	clause(cultural_assets_level(L),_),
	assert((job(K):-get_interest(R))),
    assert((age(K1):-get_interest(R))),
	assert((cultural_assets_level(L):-get_interest(R))).
	
	
create_clause(X,Y,Z):-discriminate_type_of_rule(X,Y,Z).

discriminate_type_of_rule(X,Y,Z):-Z=h, create_horn_clause(X,Y).
discriminate_type_of_rule(X,Y,Z):-Z=e, create_external_clause(X,Y).
discriminate_type_of_rule(X,Y,Z):-Z=i, create_internal_clause(X,Y).

create_horn_clause(X,Y):-append
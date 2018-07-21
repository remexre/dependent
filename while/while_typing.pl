:- [while_predicates].

whileType(bool).
whileType(int).
whileType(list(T)) :- whileType(T).

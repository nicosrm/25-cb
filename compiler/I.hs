-- Menge an AST
data Exp
    = Literal Integer
    | Plus Exp Exp
    | Times Exp Exp
    | Let Name Exp Exp -- Name für Variable, Zuweisung, Ausdruck
    | Ref Name
    deriving Show

type Name = String

ex1 :: Exp
ex1 = Times (Plus (Literal 1) (Literal 2)) (Literal 3)

ex2 :: Exp
ex2 = Let
    "x"
    (Plus (Literal 3)  (Literal 4))
    (Times (Ref "x") (Ref "x"))

ex3 :: Exp
ex3 = Let "x" (Literal 2)
    $ Let "y" (Literal 3)
    $ Ref "x"

type Env = (Name -> Integer)

extend :: Name -> Integer -> Env -> Env
extend n v env = \ m -> if m == n then v else env m

-- Interpreter: AST -> Wert
value :: Env -> Exp -> Integer
value env x = case x of
    Literal i -> i
    Plus l r -> value env l + value env r
    Times l r -> value env l * value env r
    Ref n -> env n
    Let n x b -> 
        value (extend n (value env x) env) b

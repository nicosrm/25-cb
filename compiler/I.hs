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

-- Interpreter: AST -> Wert
value :: Exp -> Integer
value x = case x of
    Literal i -> i
    Plus l r -> value l + value r
    Times l r -> value l * value r

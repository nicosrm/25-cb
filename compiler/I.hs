-- Menge an AST
data Exp
    = Literal Integer
    | Plus Exp Exp
    | Times Exp Exp

-- Interpreter: AST -> Wert
value :: Exp -> Integer
value x = case x of
    Literal i -> i
    Plus l r -> value l + value r
    Times l r -> value l * value r

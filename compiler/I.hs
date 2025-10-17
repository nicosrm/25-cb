import Prelude hiding (lookup)
import qualified Data.Map as M

-- Menge an AST
data Exp
    = Literal Integer
    | Plus Exp Exp
    | Times Exp Exp
    | Eq Exp Exp
    | Let Name Exp Exp -- Name für Variable, Zuweisung, Ausdruck
    | Ref Name
    | If Exp Exp Exp   -- if not Zero
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

ex4 :: Exp
ex4 = If (Literal 0) (Literal 1) (Literal 2) -- 2

ex5 :: Exp
ex5 = Let "x" (Literal 42)
    $ If (Ref "x") (Literal 1) (Literal 2) -- 1

ex6 :: Exp
ex6 = Let "x" (Eq (Literal 1) (Literal 42))
    $ If (Ref "x") (Literal 1) (Literal 2) -- 2

ex7 :: Exp
ex7 = Ref "y"

-- value (extend "y" 42 env0) $ Ref "y" -- 42
-- value (extend "y" 42 env0) $ Ref "x" -- undefined

ex8 :: Exp
ex8 = Let "x" (Ref "x") (Ref "x")
-- x erst im dritten Argument sichtbar

ex9 :: Exp
ex9 = Let "x" (Ref "y")
    $ Let "y" (Literal 0) (Ref "x")

ex10 :: Exp
ex10 = Let "x" (Literal 0)
    $ Let "y" (Ref "y") (Ref "y")

-- type Env = (Name -> Integer)
type Env = M.Map Name Integer

-- leere Umgebung
env0 = M.empty

extend :: Name -> Integer -> Env -> Env
-- extend n v env = \ m -> if m == n then v else env m
extend = M.insert

lookup :: Env -> Name -> Integer
lookup env n = case M.lookup n env of
    Nothing -> error $ "lookup (" <> show env <> "): undefined variable " <> n
    Just i -> i

-- Interpreter: AST -> Wert
value :: Env -> Exp -> Integer
value env x = case x of
    Literal i -> i
    Plus l r -> value env l + value env r
    Times l r -> value env l * value env r
    Eq l r -> if value env l == value env r
        then 1
        else 0
    Ref n -> lookup env n
    Let n x b -> 
        value (extend n (value env x) env) b
    If c t f -> if (value env c) /= 0 
        then value env t
        else value env f

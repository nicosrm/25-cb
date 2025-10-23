import Prelude hiding (lookup, LT, GT)
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
    | ExpTrue
    | ExpFalse
    | LT Exp Exp
    | LE Exp Exp
    | GT Exp Exp
    | GE Exp Exp
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

ex11 :: Exp
ex11 = If ExpTrue (Literal 1) (Literal 2)

-- type Env = (Name -> Integer)
type Env = M.Map Name Val

-- leere Umgebung
env0 = M.empty

extend :: Name -> Val -> Env -> Env
-- extend n v env = \ m -> if m == n then v else env m
extend = M.insert

lookup :: Env -> Name -> Val
lookup env n = case M.lookup n env of
    Nothing -> error $ "lookup (" <> show env <> "): undefined variable " <> n
    Just i -> i

data Val = ValInt Integer
         | ValBool Bool
         deriving Show

-- continuation (k)
-- Polymorphie?
with_int  :: Val -> (Integer  -> Val) -> Val
with_int v k = case v of
    ValInt i -> k i
    _ -> error "expected ValInt"

with_bool  :: Val -> (Bool  -> Val) -> Val
with_bool v k = case v of
    ValBool b -> k b
    _ -> error "expected ValBool"

-- Interpreter: AST -> Wert
value :: Env -> Exp -> Val
value env x = case x of
    Literal i -> ValInt i

    -- Plus l r -> value env l + value env r
    Plus l r ->
        -- case value env l of
        -- ValInt a -> case value env r of
        --     ValInt b -> ValInt $ a + b
        -- geht zwar, aber nicht schön ==> Continuation
        with_int (value env l) $ \ a ->
        with_int (value env r) $ \ b ->
        ValInt $ a + b

    -- Times l r -> value env l * value env r
    Times l r ->
        with_int (value env l) $ \ a ->
        with_int (value env r) $ \ b ->
        ValInt $ a * b


    -- Eq l r -> if value env l == value env r
    --     then 1
    --     else 0
    Eq l r -> case (value env l) of
        ValInt i -> with_int (value env r) $ \ j ->
            ValBool $ i == j
        ValBool b -> with_bool (value env r) $ \ c ->
            ValBool $ b == c

    Ref n -> lookup env n
    Let n x b -> 
        value (extend n (value env x) env) b

    -- If c t f -> if (value env c) /= 0 
    --     then value env t
    --     else value env f
    If c t f -> case (value env c) of
        ValInt i -> if i /= 0
            then value env t
            else value env f
        ValBool b -> if b
            then value env t
            else value env f

    ExpTrue -> ValBool True
    ExpFalse -> ValBool False

    LT l r -> case (value env l) of
        ValInt a -> with_int (value env r) $ \ b ->
            ValBool $ a < b
        ValBool a -> with_bool (value env r) $ \ b ->
            ValBool $ a < b

    LE l r -> case (value env l) of
        ValInt a -> with_int (value env r) $ \ b ->
            ValBool $ a <= b
        ValBool a -> with_bool (value env r) $ \ b ->
            ValBool $ a <= b
    
    GT l r -> case (value env l) of
        ValInt a -> with_int (value env r) $ \ b ->
            ValBool $ a > b
        ValBool a -> with_bool (value env r) $ \ b ->
            ValBool $ a > b

    GE l r -> case (value env l) of
        ValInt a -> with_int (value env r) $ \ b ->
            ValBool $ a >= b
        ValBool a -> with_bool (value env r) $ \ b ->
            ValBool $ a >= b

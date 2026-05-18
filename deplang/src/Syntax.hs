module Syntax where

type Index = Int
type Level = Int

data Term
        = Var Index

        | Univ Level
        | Pi Term Term
        | Lam Term Term

        | App Term Term
        deriving (Show, Eq)

-- shift d c term: d - на сколько сдвигаем, c - текущая отсечка (уровень вложенности)
shift :: Int -> Int -> Term -> Term
shift d cutoff (Var index) =
  if index >= cutoff
  then Var (index + d)
  else Var index
shift d cutoff (Lam ty body) = Lam (shift d cutoff ty) (shift d (cutoff + 1) body)
shift d cutoff (Pi  dom cod) = Pi (shift d cutoff dom) (shift d (cutoff + 1) cod)
shift d cutoff (App fun arg) = App (shift d cutoff fun) (shift d cutoff arg)
shift _ _ (Univ i) = Univ i

-- subst t t': подставляет term t вместо переменной с индексом 0 в term t'
-- n - что вставляем
-- m - куда
subst :: Term -> Term -> Term
subst = substAt 0

substAt :: Int -> Term -> Term -> Term
substAt cutoff n (Var i) =
        case compare i cutoff of
          EQ -> shift cutoff 0 n
          GT -> Var (i - 1)
          LT -> Var i
substAt cutoff term (Lam ty body) = Lam (substAt cutoff term ty) (substAt (cutoff + 1) term body)
substAt cutoff term (Pi dom cod) = Pi (substAt cutoff term dom) (substAt (cutoff + 1) term cod)
substAt cutoff term (App fun arg) = App (substAt cutoff term fun) (substAt cutoff fun arg)
substAt _ _ (Univ i) = Univ i

-- prittyPrint
allNames :: [String]
allNames = basic ++ [ n ++ show i | i <- [1..] ,  n <- basic  ]
        where basic = ["x", "y", "z", "v", "u", "w"]

pickFreshName :: [String] -> String
pickFreshName used = head [n | n <-allNames, n `notElem` used ]

prittyPrint :: [String] -> Term -> String
prittyPrint ctx (Var i)
        | i >= 0 && length ctx > i = ctx !! i
        | otherwise = "free_" ++ show (i - length ctx)

prittyPrint ctx (Lam typeArg body) =
  let fresh = pickFreshName ctx
      tyStr = prittyPrint ctx typeArg
      bodyStr = prittyPrint (fresh : ctx) body
  in "λ(" ++ fresh ++ " : " ++ tyStr ++ "). " ++ bodyStr
prittyPrint ctx (Pi dom cod) =
  let fresh = pickFreshName ctx
      domStr = prittyPrint ctx dom
      codStr = prittyPrint (fresh : ctx) cod
  in "П(" ++ fresh ++ " : " ++ domStr ++ "). " ++ codStr

prittyPrint ctx (App fun arg) =
  let funStr = bracketApp fun (prittyPrint ctx fun)
      argStr = bracketArg arg (prittyPrint ctx arg)
  in funStr ++ " " ++ argStr

prittyPrint _ (Univ level) = "Type" ++ show level


bracketApp :: Term -> String -> String
bracketApp (Lam _ _) s = "(" ++ s ++ ")"
bracketApp (Pi _ _) s = "(" ++ s ++ ")"
bracketApp _ s       = s

bracketArg :: Term -> String -> String
bracketArg (App _ _) s = "(" ++ s ++ ")"
bracketArg (Lam _ _) s   = "(" ++ s ++ ")"
bracketArg (Pi _ _) s  = "(" ++ s ++ ")"
bracketArg _ s         = s



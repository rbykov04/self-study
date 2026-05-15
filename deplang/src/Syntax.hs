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

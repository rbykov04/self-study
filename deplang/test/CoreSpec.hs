module CoreSpec where

import Test.Hspec
import Syntax

idTerm :: Term
idTerm = Lam (Univ 0) (Lam (Var 0) (Var 0))

-- Её тип: (A : Type0) -> (x : A) -> A
idType :: Term
idType = Pi (Univ 0) (Pi (Var 0) (Var 1))

spec :: Spec
spec = describe "prittyPrint" $ do
  it "6 имя" $ allNames !! 6 `shouldBe` "x1"
  it "7 имя" $ allNames !! 7 `shouldBe` "y1"
  it "возьмем свободное имя" $ pickFreshName ["x"] `shouldBe` "y"
  it "возьмем свободное имя: зашли на круг" $ pickFreshName ["x", "y", "z", "v", "u", "w"] `shouldBe` "x1"
  it "свободная переменная" $ prittyPrint [] (Var 0) `shouldBe` "free_0"
  it "странная Lam" $ prittyPrint [] (Lam (Var 0) (Var 0)) `shouldBe` "λ(x : free_0). x"
  it "Type0" $ prittyPrint [] (Univ 0) `shouldBe` "Type0"
  it "тело id для зав типов" $ prittyPrint [] idTerm `shouldBe` "λ(x : Type0). λ(y : x). y"
  it "тип id для зав типов" $ prittyPrint [] idType `shouldBe` "П(x : Type0). П(y : x). x"
  it "странная аппликация" $ prittyPrint ["Bool"] (App (Var 0) (Var 0)) `shouldBe` "Bool Bool"

module CoreSpec where

import Test.Hspec
import Syntax

idTerm :: Term
idTerm = Lam (Univ 0) (Lam (Var 0) (Var 0))

-- Её тип: (A : Type0) -> (x : A) -> A
idType :: Term
idType = Pi (Univ 0) (Pi (Var 0) (Var 1))

spec :: Spec
spec = do
  describe "prittyPrint" $ do
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

  describe "Сдвиг индексов (shift)" $ do
      it "не меняет переменные ниже отсечки" $ do
        -- В теле Lam индекс 0 связан. Сдвиг с отсечкой 1 не должен его трогать.
        -- Lam (Univ 0) (Var 0) -> внутри Lam отсечка становится 1. Var 0 < 1, не меняется.
        shift 1 1 (Lam (Univ 0) (Var 0)) `shouldBe` Lam (Univ 0) (Var 0)
      it "сдвигает свободные переменные выше или равные отсечке" $ do
        -- Индекс 1 внутри тела Lam свободен. При отсечке 0 он должен стать 2.
        shift 1 0 (Lam (Univ 0) (Var 1)) `shouldBe` Lam (Univ 0) (Var 2)
      it "НЕ увеличивает отсечку внутри аннотации типа лямбды" $ do
        -- Переменная в типе аргумента находится снаружи связывателя.
        -- Если стартовая отсечка 0, то Var 0 в типе должен сдвинуться, так как он свободен.
        shift 1 0 (Lam (Var 0) (Var 0)) `shouldBe`  ( Lam (Var 1) (Var 0))

  describe "Подстановка (subst)" $ do
    it "заменяет целевую переменную Var 0" $ do
      subst (Univ 0) (Var 0) `shouldBe` Univ 0

    it "уменьшает индекс свободных переменных на 1" $ do
      subst (Univ 0) (Var 1) `shouldBe` Var 0

    it "правильно обрабатывает вложенность в Lam" $ do
      -- Подставляем (Var 0) в выражение (Lam (Univ 0) (Var 1))
      -- Внутри тела Lam целевой индекс смещается на +1 и становится равным 1.
      -- Подставляемый терм (Var 0) сдвигается на +1 внутри Lam и становится (Var 1).
      -- Итог: Var 1 в теле заменяется на Var 1.
      subst (Var 0) (Lam (Univ 0) (Var 1)) `shouldBe` Lam (Univ 0) (Var 1)

    it "комплексный тест: (\\x: A. x y) z -> z y" $ do
      -- В индексах Де Брёйна:
      -- Выражение: Lam (Univ 0) (App (Var 0) (Var 1)) -- (\x. x y)
      -- Аргумент: Var 2 -- z
      -- Ожидаем после подстановки аргумента в тело: App (Var 2) (Var 0)
      let body = App (Var 0) (Var 1)
      let arg  = Var 2
      subst arg body `shouldBe` App (Var 2) (Var 0)

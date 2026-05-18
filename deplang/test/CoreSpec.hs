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
  describe "substAt для App" $ do

    it "корректно распределяет подстановку в обе ветви (fun и arg)" $ do
      -- Тело: (0 0), подставляем Var 5 вместо 0
      let body     = App (Var 0) (Var 0)
      let replacement = Var 5
      let expected = App (Var 5) (Var 5)

      substAt 0 replacement body `shouldBe` expected

    it "правильно обрабатывает комбинацию свободных и заменяемых переменных внутри App" $ do
      -- Тело: (0 2), подставляем Var 5 вместо 0.
      -- Индекс 2 (свободная переменная) должен уменьшиться на 1.
      let body     = App (Var 0) (Var 2)
      let replacement = Var 5
      let expected = App (Var 5) (Var 1)

      substAt 0 replacement body `shouldBe` expected

  describe "substAt — коррекция индексов свободных переменных (ветка GT)" $ do

    it "уменьшает индекс свободной переменной на 1, если он строго больше cutoff" $ do
      -- cutoff = 0. Переменная Var 1 является свободной.
      -- Так как 1 > 0 (GT), индекс должен стать (1 - 1) = 0.
      let body        = Var 1
      let replacement = Var 99 -- Не важен, так как подстановки по индексу 1 нет
      let expected    = Var 0

      substAt 0 replacement body `shouldBe` expected

    it "корректно сдвигает индексы свободных переменных внутри App" $ do
      -- Семантика: (λx. y z) [подстановка вместо x] -> y' z'
      -- В индексах: (λ. 1 2) -> в теле App (Var 1) (Var 2)
      -- Обе переменные свободные для cutoff = 0. Должны стать 0 и 1.
      let body        = App (Var 1) (Var 2)
      let replacement = Var 99
      let expected    = App (Var 0) (Var 1)

      substAt 0 replacement body `shouldBe` expected

    it "не изменяет связанные (зависимые) переменные (ветка LT)" $ do
      -- Если cutoff = 1 (например, мы уже зашли внутрь одной лямбды),
      -- то Var 0 — это связанная переменная внутренней лямбды. Ее индекс трогать нельзя.
      -- Сравниваем: i = 0, cutoff = 1. 0 < 1 (LT) -> остается Var 0.
      let body        = Var 0
      let replacement = Var 99
      let expected    = Var 0

      substAt 1 replacement body `shouldBe` expected


    -- ==========================================
    -- 1. ТЕСТЫ ДЛЯ LAM (АБСТРАКЦИЯ)
    -- ==========================================
    describe "Случай Lam type body" $ do

      it "НЕ увеличивает cutoff для типа аргумента, но увеличивает для тела" $ do
        -- Пример: λ(у : Var 1). Var 2
        -- Для типа (Var 1): cutoff еще 0. Индекс 1 > 0 (GT) -> станет Var 0.
        -- Для тела (Var 2): cutoff стал 1. Индекс 2 > 1 (GT) -> станет Var 1.
        -- Исходный: Lam (Var 1) (Var 2)
        -- Ожидаемый: Lam (Var 0) (Var 1)
        let body        = Lam (Var 1) (Var 2)
        let replacement = Var 99
        let expected    = Lam (Var 0) (Var 1)

        substAt 0 replacement body `shouldBe` expected

      it "правильно определяет связанную переменную в теле Lam (ветка LT)" $ do
        -- Пример: λ(у : Univ 0). Var 0  (здесь Var 0 привязан к этой лямбде)
        -- Внутри тела cutoff = 1. Проверяем Var 0: 0 < 1 (LT) -> индекс НЕ меняется.
        let body        = Lam (Univ 0) (Var 0)
        let replacement = Var 99
        let expected    = Lam (Univ 0) (Var 0)

        substAt 0 replacement body `shouldBe` expected


    -- ==========================================
    -- 2. ТЕСТЫ ДЛЯ PI (DEPENDENT PRODUCT)
    -- ==========================================
    describe "Случай Pi argType resType" $ do

      it "корректно сдвигает свободные переменные (GT) в типе результата" $ do
        -- Пример: Π(x : Var 1). Var 2
        -- Как и в Lam, в типе аргумента (Var 1) cutoff = 0 -> превратится в Var 0.
        -- В типе результата (Var 2) переменная x связывается, cutoff = 1. 2 > 1 (GT) -> Var 1.
        let body        = Pi (Var 1) (Var 2)
        let replacement = Var 99
        let expected    = Pi (Var 0) (Var 1)

        substAt 0 replacement body `shouldBe` expected

      it "корректно обрабатывает зависимый тип (когда тип результата использует аргумент)" $ do
        -- Пример: Π(x : Univ 0). Var 0  (например, полиморфное тождество П(T:Type). T -> T)
        -- В типе результата Var 0 ссылается на сам аргумент x.
        -- cutoff = 1, индекс 0 < 1 (LT) -> не должен измениться.
        let body        = Pi (Univ 0) (Var 0)
        let replacement = Var 99
        let expected    = Pi (Univ 0) (Var 0)

        substAt 0 replacement body `shouldBe` expected


    -- ==========================================
    -- 3. СЛОЖНЫЙ КОМБИНИРОВАННЫЙ КЕЙС
    -- ==========================================
    it "корректно обрабатывает каскад из Pi и Lam (вложенное связывание)" $ do
      -- Контекст: мы имеем свободную переменную Var 3 на уровне cutoff = 0.
      -- Выражение: Π(A : Univ 0). λ(x : Var 4). Var 5
      -- Шаг 1 (Вход в Pi): тип аргумента Univ 0 (без изменений).
      -- Шаг 2 (Вход в тип результата Pi): cutoff становится 1.
      -- Шаг 3 (Вход в Lam): тип аргумента Var 4. cutoff все еще 1! 4 > 1 (GT) -> Var 3.
      -- Шаг 4 (Вход в тело Lam): cutoff становится 2. Переменная Var 5: 5 > 2 (GT) -> Var 4.
      -- Итог: Pi (Univ 0) (Lam (Var 3) (Var 4))
      let body        = Pi (Univ 0) (Lam (Var 4) (Var 5))
      let replacement = Var 99
      let expected    = Pi (Univ 0) (Lam (Var 3) (Var 4))

      substAt 0 replacement body `shouldBe` expected

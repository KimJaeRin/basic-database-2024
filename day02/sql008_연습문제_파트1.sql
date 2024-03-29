-- 연습문제 PART 1
-- 1. 도서번호가 1인 도서 검색
SELECT *
  FROM book
 WHERE bookid = 1;

-- 2. 가격이 2만원 이상인 도서 검색.
SELECT *
  FROM book
 WHERE price >= 20000;

 -- 3. 박지성의 총 구매액 검색.
SELECT *
  FROM customer;      -- 박지성의 custid는 1번

SELECT SUM(saleprice)   AS [박지성의 총 구매액]
  FROM orders
 WHERE custid = 1

 
SELECT COUNT(*)   AS [박지성의 구매 도서 수]
  FROM orders
 WHERE custid = 1


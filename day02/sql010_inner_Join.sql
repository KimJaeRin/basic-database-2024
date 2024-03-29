-- 두 개 이상의 테이블 SQL 쿼리 작성.
-- Customer, Orders 테이블을 동시에 조회(조건 없이)

SELECT *
  FROM Customer, orders;

-- Customer, Orders 테이블을 동시에 조회(둘의 custid가 일치하는 조건에서)
-- RDB에서 가자아아아ㅏ앙 중요한 쿼리문1 = Join 
SELECT *
  FROM Customer, orders
 WHERE customer.custid = orders.custid
 ORDER BY customer.custid ASC;


SELECT  customer.[name]
	  , orders.saleprice
  FROM customer, orders
 WHERE customer.custid = orders.custid

-- 고객별로 주문한 모든 도서의 총 판매액을 구하고, 고객별로 정렬.
-- 각 테이블의 별명으로 줄여서 쓰는게 일반적 (ex. FROM customer AS C와 같이 바꿈)
--  Join, 내부 조인, Inner join

SELECT  customer.[name]
	  , SUM(orders.saleprice) AS [판매액]
  FROM customer, orders
 WHERE customer.custid = orders.custid
 GROUP BY customer.[name]
 ORDER BY customer.[name]


 -- 세 개의 테이블 조인

 SELECT * -- 컬럼별로 나눠적기 생략
   FROM customer AS c, orders AS o, book AS b
  WHERE c.custid = o.custid
    AND o.bookid = b.bookid

-- 실제 표준 sql innerJoin (더 복잡)

SELECT *
  FROM customer AS c
 INNER JOIN orders AS o
	ON c.custid = o.custid
 INNER JOIN book AS b
	ON o.bookid = b.bookid

-- 가격이 20,000원 이상인 도서를 주문한 고객의 이름과 도서명 조회
SELECT c.[name]
     , b.bookname
	 , o.saleprice
	 , b.price
  FROM customer AS c, orders AS o, book AS b
 WHERE c.custid = o.custid
   AND o.bookid = b.bookid    -- 여기까진 Join을 위한 조건
   AND b.price >= 20000;      -- 그 외 필터링을 위한 조건

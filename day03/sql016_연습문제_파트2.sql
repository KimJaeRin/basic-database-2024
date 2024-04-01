-- 1. 주문하지 않은 고객의 이름(서브쿼리 사용)

SELECT [name] AS '주문하지 않은 고객 이름'
  FROM Customer
 WHERE custid NOT IN (SELECT DISTINCT custid
                        FROM orders)

-- 2. 주문 금액의 총액과 주문의 평균금액

SELECT  SUM(o.saleprice) AS '주문금액 총액', AVG(o.saleprice) AS '주문금액평균'
  FROM Orders o


-- 3. 고객의 이름과 고객별 구매액
SELECT c.name AS ' 이름 '
     , SUM(o.saleprice) AS '구매액'
  FROM Book AS b, Orders AS o, Customer AS c
 WHERE b.bookid = o.bookid
   AND o.custid = c.custid
 GROUP BY c.name


-- 4.고객의 이름과 고객이 구매한 도서 목록
SELECT DISTINCT c.name AS ' 이름 ',
                b.bookname AS '구매한 도서 목록'
  FROM Book AS b, Orders AS o, Customer AS c
 WHERE b.bookid = o.bookid
   AND o.custid = c.custid
   
   -- 5.도서의 가격(Book 테이블)과 판매가격(Orders 테이블)의 차이가 가장 많은 주문
SELECT TOP 1 b.bookname, b.price AS '정가'
      , o.saleprice AS '판매가'
      , (b.price - o.saleprice) AS '정가와 판매가의 차이' 
  FROM Book AS b, Orders AS o, Customer AS c
 WHERE b.bookid = o.bookid
   AND o.custid = c.custid
ORDER BY (b.price - o.saleprice) DESC
  
-- 6.도서 판매액 평균보다 자신의 구매액 평균이 더 높은 고객의 이름
SELECT b.AVG AS '구매액 평균'
     , c.[name]
  FROM (SELECT AVG(o1.saleprice) AS avg
             , o1.custid
          FROM Orders AS o1
         GROUP BY o1.custid) AS b, Customer AS c
 WHERE b.custid = c.custid
   AND b.avg >= (SELECT AVG(saleprice)
                   FROM Orders)


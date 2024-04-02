-- NULL에 대한 고찰
-- MyBook 테이블에서 시작
SELECT bookid
     , price + 100
  FROM MyBook;

-- 합계, 전체의 COUNT는 문제 x, 평균에서의 price COUNT는 NULL값이 빠짐. 
SELECT SUM(price), AVG(price), COUNT(*), COUNT(price)
  FROM MyBook;

SELECT (10000 + 20000 + 0) / 3;

-- bookid가 없는 데이터로 통계를 낼때는 NULL이 나와야 함.
SELECT SUM(price), AVG(price), COUNT(*), COUNT(price)
  FROM MyBook
 WHERE bookid >= 4;

-- NULL 비교(!)
-- NULL은 일반 비교 연산자로 비교가 안되기 때문에, IS NULL 이나 IS NOT NULL을 사용.
SELECT * 
  FROM MyBook
 WHERE price IS NULL;

-- IS NULL() 함수
-- 사전 작업 (Customer 테이블)
SELECT *
  FROM Customer
 WHERE phone IS NULL;

UPDATE Customer
   SET phone = NULL
 WHERE custid = 2;

-- NULL인
SELECT custid
     , [name]
     , [address]
     , ISNULL(phone, '연락처 없음') AS phone
  FROM Customer;











-- 연습문제 PART 2
-- 1. 마당서점 도서의 총 갯수
 SELECT COUNT(*) AS [도서의 총 갯수]
 FROM book


-- 2. 마당서점에 도서를 출고하는 출판사의 총 개수

 SELECT COUNT(DISTINCT publisher) AS [출판사의 총 개수]
  FROM book;

 -- 3. 모든 고객의 이름 주소.
 SELECT [name] , [address]
   FROM customer
 

-- 4. 2023년 7월 4일 ~ 7월 7일 사이에 주문 받은 도서의 주문 번호
SELECT orderid
  FROM orders
  WHERE  orderdate = '2023-07-04'
     OR orderdate = '2023-07-05'
	 OR orderdate ='2023-07-06'
	 OR orderdate ='2023-07-07'            --BETWEEN AND 도 가능.


-- 5. 2023년 7월 4일 ~ 7월 7일 사이에 주문 받은 도서를 제외한 도서의 주문번호

SELECT orderid
  FROM orders
  WHERE NOT orderdate = '2023-07-04'
     AND NOT orderdate = '2023-07-05'
	 AND NOT orderdate ='2023-07-06'
	 AND NOT orderdate ='2023-07-07'




-- 6. 성이 '김'씨인 고객의 이름과 주소
SELECT [name] , [address]
  FROM customer
 WHERE [name] LIKE '김%'
  



-- 7. 성이 '김'씨이고 이름이 '아;로 끝나는 고객의 이름과 주소
SELECT [name] , [address]
  FROM customer
 WHERE [name] LIKE '김%아'
		
  




  

  
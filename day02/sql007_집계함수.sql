-- 집계함수, GROUP BY
-- 고객이 주문한 도서의 총 판매액
SELECT SUM(saleprice) AS [총 매출] -- AS = 열 이름 지정 키워드
  FROM orders;

-- 김연아 고객이 주문한 도서의 총 판매액 
SELECT *
  FROM Customer;
-- 김연아는 custid가 2번

SELECT SUM(saleprice) AS '김연아 고객 총 판매액'
  FROM Orders
 WHERE custid = 2;

 -- COUNT()는 *을 사용가능 BUT 나머지 집계함수는 열(column) 하나만 지정해서 사용할 것.
 SELECT COUNT(*)  -- 잘 쓰지않음
   FROM orders;

SELECT COUNT(saleprice) AS 주문개수
     , SUM(saleprice) AS [총 판매액]
	 , AVG(saleprice) AS [판매액 평균]
	 , MIN(saleprice) AS [주문도서 최소금액]
	 , MAX(saleprice) AS [주문도서 최대금액]
  FROM orders;

-- 출판사 수
SELECT COUNT(DISTINCT publisher)
  FROM book;


-- GROUP BY : 필요조건으로 그룹핑을 해서 결과(통계)를 내기위함.
-- GROUP BY절에 들어있는 컬럼 외에는 SELECT문에 절대(!) 쓸 수 없음.
-- 단, saleprice는 집계함수 안에 들어있으므로 예외.
SELECT custid, SUM(saleprice) AS '판매액' 
  FROM orders
 GROUP BY custid;

-- HAVING - WHERE절은 일반 필터링 조건이지만(그래서 함수 사용 불가), HAVING은 통계, 집합함수의 필터링 조건.
-- 가격이 8,000원 이상인 도서를 구매한 고객에 대하여 고객별(!) 주문 도서 총 수량
-- 단, 두 권 이상 구매한 경우만... 
SELECT custid, COUNT(*) AS [구매 수]
  FROM orders
 WHERE saleprice >= 8000
 GROUP BY custid
 HAVING COUNT(*) >= 2  -- [구매 수] 라는 별명으로 필터링 사용 불가

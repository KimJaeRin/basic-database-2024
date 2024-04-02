-- 내장함수

-- 함수의 결과값은 (열 이름 없음) 이름지정 필요

SELECT ABS(-5), ABS(5);

SELECT CEILING(4.0) AS '올림', FLOOR(4.4) AS '내림', ROUND(4.4, 0) AS '반올림', POWER(2, 10) AS 'N 승';

-- 고객별 평균주문 금액
SELECT custid
     , SUM(saleprice) AS '고객별 총 주문금액'
     , AVG(saleprice) AS '고객별 평균 주문금액'
     , COUNT(*) AS '고객별 주문 수'
     , SUM(saleprice) / COUNT(*) AS '고객별 평균 주문금액'
  FROM Orders
 GROUP BY custid;

-- 문자열함수

-- 책제목에 야구를 농구로 바꿔서 출력
-- FORMAT(VAL, '포맷값')

SELECT bookid
     , REPLACE (bookname, '야구', '농구') AS 'bookname'
     , publisher
     , FORMAT(price, '#,#') AS price
  FROM Book

SELECT bookname AS '제목'
     , LEN(bookname) AS '제목별 길이'
  FROM Book
 WHERE publisher = '굿스포츠';

-- 영문자 단어, 코드 변환시 유용하게 많이 사용
SELECT LOWER('HELLO'), UPPER('hello');

-- TRIM : 공백제거
SELECT '|' + LTRIM('     HELLO     ') + '|'
     , '|' + RTRIM('     HELLO     ') + '|'
     , '|' + TRIM('     HELLO     ') + '|'

-- LEFT(), RIGHT(), SUBSTRING()
SELECT LEFT('HELLO WORLD', 5)
     , RIGHT('HELLO WORLD', 6)
     , SUBSTRING('HELLO WORLD', 7, 5);

-- CHARINDEX() : 문자 찾기
SELECT CHARINDEX('sql','Microsoft SQL Server 2022' );

-- SUBSTRING() 연계
SELECT SUBSTRING('Microsoft SQL Server 2022', 
               CHARINDEX('sql','Microsoft SQL Server 2022' ),
               LEN('sql'));

-- SUBSTRING, DB는 INDEX 1부터 시작함
SELECT SUBSTRING([name], 1, 1) AS '성씨'
     , COUNT(*) AS '성씨별 인원수'
  FROM Customer
 GROUP BY SUBSTRING([name], 1, 1)

 -- 날짜 및 시간 함수
 SELECT GETDATE()

 SELECT DAY(GETDATE()) AS '일'
 SELECT MONTH(GETDATE()) AS '월'
 SELECT YEAR(GETDATE()) AS '년'

 SELECT FORMAT(GETDATE(), 'yyyy-MM-dd')
 SELECT FORMAT(GETDATE(), 'HH:mm:ss')
 
 -- 주문 테이블에서 주문 10일 후에 각 주문을 확정 짓는다, 확정일자 출력
 -- dd(날짜), mm(달), yy(년), qq(분기), wk(주)
 SELECT orderid
      , orderdate
      , saleprice
      , orderdate AS '주문일자'
      , DATEADD(dd, 10, orderdate) AS '주문 확정일자'
      , DATEADD(mm, 1, orderdate) AS '통계 일자'
   FROM Orders

-- TOP n : 함수 X, 내장된 키워드
SELECT TOP 3 orderid, custid, saleprice
  FROM Orders
 ORDER BY saleprice DESC;


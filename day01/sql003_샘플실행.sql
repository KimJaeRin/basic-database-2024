-- 책 중에서 '축구의 역사'라는 도서의 출판사와 가격을 알고 싶어.
-- dbo는 DataBase Owner(지금은 패스)

SELECT publisher, price 
  FROM Book
 WHERE bookname = '축구의 역사';

 /*
 - SQL에서는 equal연산자제 == 사용하지않음, 무조건 =
 - SQL에서는 문자열에 " 사용하지않음, 무조건 '
 - SQL에서는 대소문자 구분없음. 하지만, 키워드는 대문자로 사용할 것.
 - SQL에서는 ;이 필수가 아님, 하지만, 중요한 사항에서는 사용할 것.
 */

 -- 김연아 고객의 전화번호를 찾으시오.
 
 -- 1 STEP
 SELECT *  -- * 을 ALL이라고 부름.
   FROM Customer;

 -- 2 STEP
 SELECT *
   FROM Customer
  WHERE [name] = '김연아'   -- 대괄호 = 키워드가 아니라는 뜻

 -- 3 STEP
 SELECT phone
   FROM Customer
  WHERE [name] = '김연아'   -- 대괄호 = 키워드가 아니라는 뜻

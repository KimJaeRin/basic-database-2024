-- OUTER JOIN(외부 조인)
-- LEFT OUTER JOIN vs RIGHT OUTER JOIN


SELECT *
  FROM TableA A
  LEFT OUTER JOIN TableB B
    On A.key = B.key;

-- 이 둘은 같은 의미의 쿼리
SELECT *
  FROM TableB B
 RIGHT OUTER JOIN TableA A
    On A.key = B.key;
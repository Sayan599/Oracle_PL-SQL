--  PLSQL DML Concept

Always commit at the end. Never do partial commit.
This can lead to data inconsistency.

Eg:-
BEGIN
      INSERT INTO orders 
      VALUES (101, SYSDATE);
      
      INSERT INTO order_items 
      VALUES (101, 'ITEM1', 2);

      COMMIT;

EXCEPTION
      WHEN OTHERS THEN
        ROLLBACK;
        RAISE;

END;



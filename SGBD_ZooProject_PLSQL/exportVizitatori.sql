 set serveroutput on;

CREATE OR REPLACE PROCEDURE get_lista_vizitatori_totala
IS

  idx_linie1 integer := 3;
  idx_linie2 integer := 3;
  idx_linie3 integer := 3;
  idx_linie4 integer := 3;
  idx_linie5 integer := 3;
  idx_linie6 integer := 3;
  idx_linie7 integer := 3;

   CURSOR ticket_number_values IS
      SELECT ticket_number FROM view_child_visitors order by visit_date asc;
      
   CURSOR ticket_type_values IS
      SELECT ticket_type FROM view_child_visitors order by visit_date asc;
      
   CURSOR ticket_price_values IS
      SELECT ticket_price FROM view_child_visitors order by visit_date asc;
      
   CURSOR visitor_name_values IS
      SELECT visitor_name FROM view_child_visitors order by visit_date asc;
      
   CURSOR visitor_age_values IS
      SELECT visitor_age FROM view_child_visitors order by visit_date asc;
      
   CURSOR guide_name_values IS
      SELECT guide_name FROM view_child_visitors order by visit_date asc;
      
   CURSOR visit_date_values IS
      SELECT visit_date FROM view_child_visitors order by visit_date asc;
    
  BEGIN
  
    as_xlsx.clear_workbook;
    as_xlsx.new_sheet;
    as_xlsx.setUseXf( false );
  
   as_xlsx.cell(1, 1, 'Numarul biletului');
   as_xlsx.cell(2, 1, 'Tipul biletului');
   as_xlsx.cell(3, 1, 'Pretul biletului');
   as_xlsx.cell(4, 1, 'Nume vizitator');
   as_xlsx.cell(5, 1, 'Varsta vizitator');
   as_xlsx.cell(6, 1, 'Nume ghid');
   as_xlsx.cell(7, 1, 'Data vizitei');
   
   FOR v_linie1 IN ticket_number_values 
   
    LOOP

       as_xlsx.cell(1, idx_linie1, v_linie1.ticket_number);
       idx_linie1 := idx_linie1 + 1;
       
    END LOOP;
    
    FOR v_linie2 IN ticket_type_values 
   
    LOOP

       as_xlsx.cell(2, idx_linie2, v_linie2.ticket_type);
       idx_linie2 := idx_linie2 + 1;
       
    END LOOP;
    
    FOR v_linie3 IN ticket_price_values 
   
    LOOP

       as_xlsx.cell(3, idx_linie3, v_linie3.ticket_price);
       idx_linie3 := idx_linie3 + 1;
       
    END LOOP;
    
    FOR v_linie4 IN visitor_name_values 
   
    LOOP

       as_xlsx.cell(4, idx_linie4, v_linie4.visitor_name);
       idx_linie4 := idx_linie4 + 1;
       
    END LOOP;
    
    FOR v_linie5 IN visitor_age_values 
   
    LOOP

       as_xlsx.cell(5, idx_linie5, v_linie5.visitor_age);
       idx_linie5 := idx_linie5 + 1;
       
    END LOOP;
    
    FOR v_linie6 IN guide_name_values 
   
    LOOP

       as_xlsx.cell(6, idx_linie6, v_linie6.guide_name);
       idx_linie6 := idx_linie6 + 1;
       
    END LOOP;
    
    FOR v_linie7 IN visit_date_values 
   
    LOOP

       as_xlsx.cell(7, idx_linie7, to_date(v_linie7.visit_date));
       idx_linie7 := idx_linie7 + 1;
       
    END LOOP;        
  
  as_xlsx.save( 'MY_DIR', 'Vizitatori2.xlsx' );
END;
/
begin
get_lista_vizitatori_totala();
end;
/
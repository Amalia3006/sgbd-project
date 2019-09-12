set serveroutput on;

CREATE OR REPLACE PROCEDURE get_lista_ghizi
  IS

  idx_linie1 integer := 3;
  idx_linie2 integer := 3;
  idx_linie3 integer := 3;
  idx_linie4 integer := 3;
  idx_linie5 integer := 3;


   CURSOR guide_id_values IS
      SELECT guide_id FROM view_guides order by guide_id asc;
      
   CURSOR guide_name_values IS
      SELECT firstname FROM view_guides order by guide_id asc;
      
    CURSOR guide_lastname_values IS
      SELECT lastname FROM view_guides order by guide_id asc;   
      
   CURSOR hire_date_values IS
      SELECT hire_date FROM guides join employees on guides.employee_id=employees.employee_id order by guide_id asc;
      
   CURSOR salary_values IS
      SELECT salary FROM view_guides order by guide_id asc;
      
    
  BEGIN
  
  as_xlsx.clear_workbook;
  as_xlsx.new_sheet;
  as_xlsx.setUseXf( false );
    
   as_xlsx.cell(1, 1, 'ID Ghid');
   as_xlsx.cell(2, 1, 'Nume');
   as_xlsx.cell(3, 1, 'Prenume');
   as_xlsx.cell(4, 1, 'Data angajarii');
   as_xlsx.cell(5, 1, 'Salariu');
   
   FOR v_linie1 IN guide_id_values 
   
    LOOP

       as_xlsx.cell(1, idx_linie1, v_linie1.guide_id);
       idx_linie1 := idx_linie1 + 1;
       
    END LOOP;
    
    FOR v_linie2 IN guide_name_values 
   
    LOOP

       as_xlsx.cell(2, idx_linie2, v_linie2.firstname);
       idx_linie2 := idx_linie2 + 1;
       
    END LOOP;
    
    FOR v_linie3 IN guide_lastname_values 
   
    LOOP

       as_xlsx.cell(3, idx_linie3, v_linie3.lastname);
       idx_linie3 := idx_linie3 + 1;
       
    END LOOP;   
    
    FOR v_linie4 IN hire_date_values 
   
    LOOP

       as_xlsx.cell(4, idx_linie4, v_linie4.hire_date);
       idx_linie4 := idx_linie4 + 1;
       
    END LOOP;

    FOR v_linie5 IN salary_values 
   
    LOOP

       as_xlsx.cell(5, idx_linie5, floor(v_linie5.salary));
       idx_linie5 := idx_linie5 + 1;
       
    END LOOP;
    
  as_xlsx.save( 'MY_DIR', 'Ghizi_lista2.xlsx' );
END;
/

begin
get_lista_ghizi();
end;
/

set serveroutput on;

CREATE OR REPLACE PROCEDURE get_guides_program_on_a_day
(data_dorita in date)
IS

  idx_linie1 integer := 3; ---ghid_id
  idx_linie2 integer := 3; ---ghid nume SI PRENUME
  idx_linie3 integer := 3; ---nr de visitatori dintr-o anumita zi

   CURSOR guide_id_values IS
      SELECT distinct guide_id as id_ghid
      FROM guides gui join visitors v on v.guide_assigned_id = gui.guide_id and visit_date=data_dorita order by gui.guide_id asc;
      
   CURSOR guide_name_values IS
      SELECT nume_ghid FROM (SELECT distinct first_name||' '||last_name as nume_ghid, gui.guide_id 
      FROM guides gui join visitors v on gui.guide_id = v.guide_assigned_id and visit_date=data_dorita 
      join employees emp on gui.employee_id = emp.employee_id 
      join persons pers on emp.employee_identity=pers.person_id order by gui.guide_id asc);
      
    CURSOR count_visitors_values  is
    SELECT count(ticket_number) as counter 
    FROM visitors v join guides gui on v.guide_assigned_id=gui.guide_id and visit_date=data_dorita
    group by gui.guide_id order by gui.guide_id asc;
          
  BEGIN
  as_xlsx.clear_workbook;
  as_xlsx.new_sheet;
  as_xlsx.setUseXf( false );
  
   as_xlsx.cell(1, 1, 'ID Ghid');
   as_xlsx.cell(2, 1, 'Nume si Prenume');
   as_xlsx.cell(3, 1, 'Numarul de vizitatori');
   
   FOR v_linie1 IN guide_id_values 
   
    LOOP

       as_xlsx.cell(1, idx_linie1, v_linie1.id_ghid);
       idx_linie1 := idx_linie1 + 1;
       
    END LOOP;
    
    
       
   FOR v_linie2 IN guide_name_values 
   
    LOOP

       as_xlsx.cell(2, idx_linie2, v_linie2.nume_ghid);
       idx_linie2 := idx_linie2 + 1;
       
    END LOOP;
    
    
    FOR v_linie3 IN count_visitors_values 
   
    LOOP

       as_xlsx.cell(3, idx_linie3, v_linie3.counter);
       idx_linie3 := idx_linie3 + 1;
       
    END LOOP;
    
  as_xlsx.save( 'MY_DIR', 'Ghizi_lista_ZI.xlsx' );
  END;
   /
begin
get_guides_program_on_a_day('18-04-2019');
end;
/
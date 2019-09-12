------------------------------------------------------------------
--Trigger care la inserarea unui nou visitator verifica daca ghidul pe care dorim sa il asignam este disponibil la acea data
--(nu trebuie sa aiba mai mult de 10vizitatori/zi).
--Daca nu e disponibil. Recomand primul ghid disponibil gasit si il asignez pt vizitator.
---------------------------------------------------------------------

set serveroutput on;


create or replace trigger check_if_guide_available
  before insert on visitors 
  for each row
    declare vizitatoriAsignati number;
    vizitatori number;
    idx number;
    id_ghid number;
begin
  select count(*) into vizitatoriAsignati from visitors where guide_assigned_id = :new.guide_assigned_id and visit_date = :new.visit_date;
  if(vizitatoriAsignati > 9) then
       DBMS_OUTPUT.PUT_LINE('Acest ghid nu este disponibil ');
      
  for idx in 1..1000
    loop
      select count(*) into vizitatori from visitors where guide_assigned_id = idx and visit_date = :new.visit_date;
        ---DBMS_OUTPUT.PUT_LINE(vizitatori);
        if(vizitatori <= 9) then 
          id_ghid := idx;
          exit;
        end if;
       end loop;
    DBMS_OUTPUT.PUT_LINE(id_ghid); 
    if(id_ghid=1000 and vizitatori>9) then 
        DBMS_OUTPUT.PUT_LINE('niciun ghid nu e disponibil la aceasta data');
    else
        DBMS_OUTPUT.PUT_LINE('Ghidul cu id-ul: ' || id_ghid || ' este disponibil');
        insert into visitors(ticket_details_id,visitor_id,visit_date,guide_assigned_id)
        values (:new.ticket_details_id,:new.visitor_id,:new.visit_date, id_ghid);
        DBMS_OUTPUT.PUT_LINE('Am asignat ghidul cu id-ul: ' || id_ghid);

    end if; 
      
  end if;
end;
/
-----------------------------------------------------------------------------------
select * from guides;
select * from persons;
select * from visitors;
select count(*) from visitors where guide_assigned_id=5 and visit_date=sysdate;
------------------------------------------------------------------------------------
insert into visitors(ticket_details_id,visitor_id,visit_date,guide_assigned_id) values (1,47998,'08-04-2019',1);

select * from visitors where visitor_id=47998;
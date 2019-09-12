set serveroutput on;

insert into visitors(ticket_details_id,visitor_id,visit_date,guide_assigned_id) values (3,47999,'7-04-2019',1);

create or replace trigger check_date_recommend_another
  before insert on visitors
  for each row
    
    declare
      vizitatoriZiuaData number;
      vizitatoriNr number;
      idx number;
      id_ghid visitors.guide_assigned_id%type;
      luna number;
      ziua number;
      ziNoua number;
      ziNouachar varchar(255);
      data_recomandata varchar2(255);
      
    begin
    
      select count(*) into vizitatoriZiuaData from visitors
        where visit_date=:new.visit_date;
       DBMS_OUTPUT.PUT_LINE('nr de vizitatori in data dorita este: '||vizitatoriZiuaData);
      
      if(vizitatoriZiuaData<1500) then
        DBMS_OUTPUT.PUT_LINE('data e valabila');
      
      else
      
      luna:= to_number(to_char(:new.visit_date,'MM'));
      DBMS_OUTPUT.PUT_LINE('luna din data dorita este:'||luna); 
      
      ziua:= to_number(to_char(:new.visit_date,'DD'));
      DBMS_OUTPUT.PUT_LINE('ziua din data dorita este:'||ziua);
      
      for idx in ziua..30
      loop

      select count(*) into vizitatoriNr from visitors
      where to_number(to_char(visit_date,'MM'))=luna
        and to_number(to_char(visit_date,'DD'))=idx;
        
      if(vizitatoriNr<1500) then
                    DBMS_OUTPUT.PUT_LINE('nr= '||vizitatoriNr);
                    
      select distinct to_char(visit_date,'DD') into ziNouachar from visitors  
      where 
      to_number(to_char(visit_date,'MM'))=luna
      and
       to_number(to_char(visit_date,'DD'))=idx;
       
       ziNoua:=to_number(ziNouachar);
      
      DBMS_OUTPUT.PUT_LINE('cea mai apropiata data dispnibila este: ' || ziNoua||'-'||luna||'-2019');       
        exit;
        end if;

      end loop;
           
     end if;
        
    end;
    
        
set serveroutput on;
--gen dam ca argument o aumita luna si imi zice cati vizitatori au fost in luna aceea si
--cum e statistica faata de luna trecuta geeen cu cat la suta mai multi/mai putini 

create or replace procedure statistici_vizitatori (luna in number)
is
luna_data number;
luna_trecuta number;
procent_comparatie number;
procent_curent number;
procent_trecut number;
numar_vizitatori number;
nr_viz_luna_trecuta number;

begin  

select count(*) into numar_vizitatori from visitors where to_number(to_char(visit_date,'MM'))=luna; --numarul total din luna data
select count(*) into nr_viz_luna_trecuta from visitors where to_number(to_char(visit_date,'MM'))=(luna-1); --numar total din luna trecuta



DBMS_OUTPUT.PUT_LINE('luna asta:'||numar_vizitatori||' luna trecuta:'||nr_viz_luna_trecuta);

procent_curent:= (numar_vizitatori*100)/45000;
procent_trecut:= (nr_viz_luna_trecuta*100)/45000;
procent_comparatie:=procent_curent-procent_trecut;


if(procent_comparatie<0) then
  procent_comparatie:= substr(round(procent_comparatie,2),2);
  DBMS_OUTPUT.PUT_LINE('Luna aceasta au fost: '|| numar_vizitatori||' fata de luna trecuta sunt cu '||procent_comparatie||'% mai putini');
  
  else if (procent_comparatie>0) then
  procent_comparatie:= round(procent_comparatie,2);
  DBMS_OUTPUT.PUT_LINE('Luna aceasta au fost: '|| numar_vizitatori||' fata de luna trecuta sunt cu '||procent_comparatie||'% mai multi');
  
  else 
      procent_comparatie:= round(procent_comparatie,2);
    DBMS_OUTPUT.PUT_LINE('Luna aceasta au fost: '|| numar_vizitatori||' in numar egal cu cei de luna trecuta');
    end if;
  end if;
  
end;
/

begin
statistici_vizitatori(2);
end;
/
//Copyright 2017 Andrey S. Ionisyan (anserion@gmail.com)
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.

//учебный шаблон перевода интерпретации графа из списков смежности (входящие ребра)
//в матрицу смежности, матрицу инцидентности, список ребер, список смежности (исходящие ребра).

program graph_trans_ls_in;
const
   max_p=100;
   max_q=100;

var i,j,k,p,q,p_start,p_end:integer;
   graph_adj: array [1..max_p,1..max_p] of integer; //матрица смежности
   graph_inc: array [1..max_p,1..max_q] of integer; //матрица инцидентности
   graph_edg: array [1..max_q,1..2] of integer; //список ребер
   graph_lst_out: array [1..max_p,1..max_q] of integer; //списки смежности (исходящих ребер)
   graph_lst_in: array [1..max_p,1..max_q] of integer; //списки смежности (входящих ребер)
begin
   //ввод исходных данных (список ребер)
   writeln('translate graph from adjacency list (incoming) to other');
   //определяем количество вершин графа
   write('number of vertexes: '); readln(p);

   //инициализация списков смежности (входящие ребра)
   for i:=1 to p do
      for j:=1 to max_q do
         graph_lst_in[i,j]:=0;

   //автоматическая генерация списков смежности
   for i:=1 to p do
   begin
      k:=random(p);
      for j:=1 to k do
         graph_lst_in[i,j]:=random(p)+1;
   end;
{   
   //ввод списков смежности вручную
   for i:=1 to p do
   begin
      k:=0;
      writeln('vertex ',i);
      repeat
         k:=k+1;
         write(i,': edge to vertex (0 - next end-point vertex): ');
         readln(graph_lst_in[i,k]);
      until (graph_lst_in[i,k]=0)or(k=q);
   end;
   writeln('===========================================');
 }  

   //определение числа ребер
   q:=0;
   for i:=1 to p do
   begin
      k:=1;
      while (graph_lst_in[i,k]<>0)and(k<max_q) do
      begin
         q:=q+1;
         k:=k+1;
      end;
   end;

   //печать списков смежности (входящие ребра)
   writeln('Adjacency list (incoming)');
   for i:=1 to p do
   begin
      write(i,': ');
      j:=1;
      while (graph_lst_in[i,j]<>0)and(j<=q) do
      begin
         write(graph_lst_in[i,j]:3);
         j:=j+1;
      end;
      writeln;
   end;

   //инициализация матрицы смежности
   for i:=1 to p do
      for j:=1 to p do
         graph_adj[i,j]:=0;

   //перевод списков смежности в матрицу смежности
   for i:=1 to p do
   begin
      k:=1;
      while (graph_lst_in[i,k]<>0)and(k<=q) do
      begin
         graph_adj[graph_lst_in[i,k],i]:=1;
         k:=k+1;
      end;
   end;
      
   //печать матрицы смежности
   writeln('Adjacency matrix: ',p,'x',p,' vertexes');
   write('     '); for i:=1 to p do write(i:3); writeln;
   for i:=1 to p do
   begin
      write(i:3,': ');
      for j:=1 to p do write(graph_adj[i,j]:3);
      writeln;
   end;

   //инициализация матрицы инцидентности
   for i:=1 to p do
      for j:=1 to q do
         graph_inc[i,j]:=0;
      
   //перевод списков смежности в матрицу инцидентности
   j:=0;
   for i:=1 to p do
   begin
      k:=1;
      while (graph_lst_in[i,k]<>0)and(k<=q) do
      begin
         j:=j+1;
         graph_inc[graph_lst_in[i,k],j]:=1;
         graph_inc[i,j]:=-1;
         k:=k+1; 
      end;
   end;
   
   //печать матрицы инцидентности
   writeln('Incidence matrix: ',p,' vertexes, ',q, ' edges');
   write('     '); for i:=1 to q do write(i:3); writeln;
   for i:=1 to p do
   begin
      write(i:3,': ');
      for j:=1 to q do write(graph_inc[i,j]:3);
      writeln;
   end;
 
    //инициализация списка ребер
   for i:=1 to q do
   begin
      graph_edg[i,1]:=0;
      graph_edg[i,2]:=0;
   end;

   //перевод списков смежности в список ребер
   j:=0;
   for i:=1 to p do
   begin
      k:=1;
      while (graph_lst_in[i,k]<>0)and(k<=q) do
      begin
         j:=j+1;
         graph_edg[j,1]:=graph_lst_in[i,k];
         graph_edg[j,2]:=i;
         k:=k+1;
      end;
   end;
   
   //печать списка ребер      
   writeln('Edge list (',q,' edges)');
   for i:=1 to q do writeln(i,': (', graph_edg[i,1],',',graph_edg[i,2],')');
  
   //инициализация списков смежности (исходящие ребра)
   for i:=1 to p do
      for j:=1 to q do
         graph_lst_out[i,j]:=0;
   
   //перевод списков смежности (входящие ребра) в списки смежности (исходящие ребра)
   for p_start:=1 to p do
   begin
      j:=1;
      for p_end:=1 to p do
      begin
         k:=1;
         while (graph_lst_in[p_end,k]<>0)and(k<=q) do
         begin
            if graph_lst_in[p_end,k]=p_start then
            begin
               graph_lst_out[p_start,j]:=p_end;
               j:=j+1;
            end;
            k:=k+1;
         end;
      end;      
   end;
   
   //печать списков смежности (исходящие ребра)
   writeln('Adjacency list (outcoming)');
   for i:=1 to p do
   begin
      write(i,': ');
      j:=1;
      while (graph_lst_out[i,j]<>0)and(j<q) do
      begin
         write(graph_lst_out[i,j]:3);
         j:=j+1;
      end;
      writeln;
   end;
      
end.
